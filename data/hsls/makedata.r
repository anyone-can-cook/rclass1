################################################################################
##
## PROJ: College choice update
## FILE: makedata.r
## AUTH: Benjamin Skinner
## INIT: 11 November 2015
##
################################################################################

## clear memory
rm(list = ls())
gc()

## libraries
libs <- c('dplyr', 'foreign', 'geosphere', 'readr', 'tidyr')
lapply(libs, require, character.only = TRUE)

## dirs
elsddir <- 'C:/Data/ELS/ELS 02-12/Stata/'
elsgdir <- 'C:/Data/ELS/ELS Geocodes/'
ddir <- '../data/'
tdir <- '../tables/csv/'

checkmiss <- function(x) {
    out <- sapply(x, FUN = function(z) {mean(is.na(z))})
    return(out)
}

`%+%` <- function(a,b) paste(a, b, sep = '')
negtoNA <- function(x) ifelse(as.numeric(x) < 0, NA, x)
NAtozero <- function(x) ifelse(as.numeric(is.na(x)), 0, x)

## =============================================================================
## READ IN ELS:2002 DATA
## =============================================================================

## ---------------------------
## geography
## ---------------------------

geo <- read_fwf(elsgdir %+% 'Geocodes.dat',
                col_position = fwf_widths(c(6,5,2,3,6,4,2,1,1,1),
                                          col_names = c('stu_id','bygzipcd',
                                                       'bygstate','bygcnty',
                                                       'bygtract','bygblock',
                                                       'bygprizm','bygsrce',
                                                       'bygmatch',
                                                       'bygpstat'))) %>%
    ## get block group (first digit)
    mutate(blkgrp = as.integer(substr(bygblock, 1, 1))) %>%
    ## subset columns
    select(stu_id,
           state = bygstate,
           county = bygcnty,
           tract = bygtract,
           blkgrp = blkgrp) %>%
    ## join with census blockgroup data
    left_join(read_csv(ddir %+% 'blkgrp_pop_centroid_withname.txt'),
              by = c('state', 'county', 'tract', 'blkgrp')) %>%
    ## don't need population
    select(-pop) %>%
    ## join with census tract data
    left_join(read_csv(ddir %+% 'tract_pop.txt',
                       col_names = c('state','county','tract','pop',
                                     'trclat','trclon')),
              by = c('state', 'county', 'tract')) %>%
    ## still don't need population data
    select(-pop) %>%
    ## join with county data
    left_join(read_csv(ddir %+% 'county_cen.txt'),
              by = c('state', 'county')) %>%
    ## for lon/lat, move blkgrp -> tract -> county as necessary due to missing
    mutate(lon = ifelse(!is.na(cntrlonc), cntrlonc,
                 ifelse(!is.na(trclon), trclon, pclon00)),
           lat = ifelse(!is.na(cntrlatc), cntrlatc,
                 ifelse(!is.na(trclat), trclat, pclat00)),
           ## note the level of match in case need later
           geomatch = ifelse(!is.na(cntrlatc), 'block',
                      ifelse(!is.na(trclat), 'tract', 'county'))) %>%
    ## subset columns
    select(stu_id, state, county, lon, lat, geomatch) %>%
    ## drop the very few (~2) who don't have location; can't use them
    na.omit() %>%
    ## sort by student id
    arrange(stu_id)

## keep track of matching; save to disk
write.csv(geo %>% select(stu_id, geomatch),
          file = ddir %+% 'geomatch.csv',
          row.names = FALSE,
          quote = FALSE)

## ---------------------------
## student
## ---------------------------

els <- read.dta(elsddir %+% 'byf3stu.dta') %>%
    ## lower names
    setNames(tolower(names(.))) %>%
    ## subset columns
    select(stu_id, bysex, byrace, byincome, f3hscpdr, f3ps1start, f3hs2ps1,
           txeesatc, bypared) %>%
    ## to table dataframe
    tbl_df() %>%
    ## convert negative values (missing in ELS) to NA
    mutate_each(funs(negtoNA(.))) %>%
    ## create variables
    mutate(female = ifelse(bysex == 2, 1, 0),
           amerind = ifelse(byrace == 1, 1, 0),
           asianpi = ifelse(byrace == 2, 1, 0),
           black = ifelse(byrace == 3, 1, 0),
           hispanic = ifelse(byrace %in% c(4:5), 1, 0),
           multrace = ifelse(byrace == 6, 1, 0),
           white = ifelse(byrace == 7, 1, 0),
           sat = txeesatc,
           satpct = (sat - min(sat, na.rm = TRUE)) /
               (max(sat, na.rm = TRUE) - min(sat, na.rm = TRUE)),
           ## satpct in 10s
           satpct = satpct * 10) %>%
    ## drop if missing gender or race
    filter(!is.na(bysex), !is.na(byrace)) %>%
    ## subset columns
    select(-c(bysex, byrace, txeesatc))

## ---------------------------
## postsecondary
## ---------------------------

ps <- read.dta(elsddir %+% 'f3inst.dta') %>%
    ## lower names
    setNames(tolower(names(.))) %>%
    ## subset columns
    select(stu_id, f3iiped, f3istdate) %>%
    ## convert to table dataframe
    tbl_df() %>%
    ## convert negative values (missing in ELS) to NA
    mutate_each(funs(negtoNA(.))) %>%
    ## join with date completed high school
    left_join(els %>% select(stu_id, f3hscpdr), by = 'stu_id') %>%
    ## drop if didn't go to college or college date is before HS grad
    filter(!is.na(f3istdate),
           f3istdate > f3hscpdr) %>%
    ## group by student
    group_by(stu_id) %>%
    ## sort by college enrollment date
    arrange(f3istdate) %>%
    ## keep only first value (first college post HS)
    filter(row_number() == 1) %>%
    ungroup() %>%
    ## subset columns
    select(stu_id, f3iiped, f3istdate)

## ---------------------------
## MERGE/SUBSET
## ---------------------------

els <- els %>%
    left_join(ps, by = 'stu_id') %>%
    left_join(geo, by = 'stu_id') %>%
    ## drop if not in lower 48 states
    filter(!(as.numeric(state) %in% c(2,15)),
           ## for whom we have an SAT score
           !is.na(satpct),
           ## for whom we have state code
           !is.na(state)) %>%
    ## drop if duplicate student id (not any now, but will keep for check)
    distinct(stu_id) %>%
    ## enroll within 2 years of HS graduation
    mutate(enroll2yr = ifelse(!is.na(f3hs2ps1)
                              & !is.na(f3iiped)
                              & f3hs2ps1 < 25,
                              1,
                              0)) %>%
    ## arrange by student id
    arrange(stu_id)

## vector of high SAT student ids
hisat <- els %>%
    filter(sat >= 1100) %>%
    select(stu_id)

## vector of low income student ids (< 25K)
lowinc <- els %>%
    filter(byincome < 8) %>%
    select(stu_id)

## =============================================================================
## MAKE INSTITUTIONAL DATA
## =============================================================================

## ---------------------------
## HD file
## ---------------------------

hd <- read_csv(ddir %+% 'hd2004.csv') %>%
    ## subset columns
    select(unitid, sector, stfips = fips, fte) %>%
    ## drop below two-year and special administrative schools
    filter(!(sector %in% c(7:9,99,0))) %>%
    ## create indicators for public, priv. non-profit, priv. for-profit, 2yr
    mutate(public = as.integer(sector %in% c(1,4)),
           privnp = as.integer(sector %in% c(2,5)),
           privfp = as.integer(sector %in% c(3,6)),
           twoyr = as.integer(sector %in% c(4:6))) %>%
    ## drop sector
    select(-sector) %>%
    ## drop institutions not in lower 48
    filter(!(stfips %in% c(2,15,60,64,66,68,69,70,72,78)))

## ---------------------------
## IC file
## ---------------------------

## convert ACT to SAT; conversion data frames
act <- seq(1,36,1)
sat <- c(rep(200, 10),530,590,640,690,740,790,830,870,910,950,990,1030,1070,
         1110,1150,1190,1220,1260,1300,1340,1380,1420,1460,1510,1560,1600)

conv25 <- data.frame('actcm25' = act, 'satconv25' = sat)
conv75 <- data.frame('actcm75' = act, 'satconv75' = sat)

ic <- read_csv(ddir %+% 'ic2004.csv') %>%
    ## subset columns to unitid and test variables
    select(unitid, matches('^(sat|act).*(25|75)$')) %>%
    ## get composite SAT scores
    mutate(satc25 = satvr25 + satmt25,
           satc75 = satvr25 + satmt75) %>%
    ## join with concordance dataframes
    left_join(conv25, by = 'actcm25') %>%
    left_join(conv75, by = 'actcm75') %>%
    ## if school reports ACT, plug in concordance SAT value
    mutate(satc25 = ifelse(is.na(satc25), satconv25, satc25),
           satc75 = ifelse(is.na(satc75), satconv75, satc75),
           sat = ifelse(!is.na(satc25) & !is.na(satc75), (satc25+satc75)/2, NA),
           ## round to nearest 10s b/c that's how SAT is scored
           sat = round(sat, -1)) %>%
    ## subset columns
    select(unitid, sat)

## ---------------------------
## INSTRUCTIONAL FACULTY
## ---------------------------

fac <- read_csv(ddir %+% 'sal2004_a.csv') %>%
    ## filter long file into "All faculty total"
    filter(arank == 7) %>%
    ## subset in unitid and number of full-time faculty
    select(unitid, ftfac = empcntt) %>%
    ## group by school
    group_by(unitid) %>%
    ## sum across sub categories to get actual total
    summarise(ftfac = sum(ftfac, na.rm = TRUE)) %>%
    ungroup()

## ---------------------------
## FACULTY (tenure track)
## ---------------------------

ttfac <- read_csv(ddir %+% 'eap2004.csv') %>%
    ## filter to all faculty (1101) and those not on tenure tract
    filter(eaprectp == 1101 | eaprectp == 1104) %>%
    ## subset columns
    select(unitid, eaprectp, eaptot) %>%
    ## change values to prepare for long to wide transformation
    mutate(eaprectp = ifelse(eaprectp == 1101, 'total', 'nttf')) %>%
    ## spread long to wide
    spread(eaprectp, eaptot) %>%
    ## ttracpct = 1 - nttracpct; in 10s
    mutate(ttfacpct = (1 - (nttf / total)) * 10) %>%
    ## subset columns
    select(unitid, ttfacpct)

## ---------------------------
## COST
## ---------------------------

cost <- read_csv(ddir %+% 'ic2004_ay.csv') %>%
    ## subset columns
    select(unitid, instuition = chg2ay3, outtuition = chg3ay3) %>%
    ## join with data on grants
    left_join(read_csv(ddir %+% 'sfa0203.csv'), by = 'unitid') %>%
    ## subset to tuition, federal, and state grants
    select(unitid, instuition, outtuition, fgrnt_a, sgrnt_a) %>%
    ## assume no grant information means 0 reduction
    mutate(fgrnt_a = NAtozero(fgrnt_a),
           sgrnt_a = NAtozero(sgrnt_a),
           ## get average instate and out of state costs
           ## instate = instate tuition - federal grants - state grants
           ## outstate = outstate tuition - federal grants
           instcost = instuition - fgrnt_a - sgrnt_a,
           outscost = outtuition - fgrnt_a,
           ## if less than zero (due to averaging), then set at 0
           instcost = ifelse(instcost < 0, 0, instcost / 1000), # 1000s
           outscost = ifelse(outscost < 0, 0, outscost / 1000), # 1000s
           ## get quadratics and cubics
           instcost_sq = instcost^2,
           outscost_sq = outscost^2) %>%
    ## subset columns
    select(unitid, instcost, instcost_sq, outscost, outscost_sq)

## ---------------------------
## BARRONS
## ---------------------------

bar <- read_csv(ddir %+% 'barrons2004.csv') %>%
    ## lower names
    setNames(tolower(names(.))) %>%
    ## use information from 2004 year
    select(unitid = unitid_04, barcomp = barrons04)

## ---------------------------
## DELTA COST (EXPENDITURES)
## ---------------------------

dc <- read_csv(ddir %+% 'delta_public_00_12.csv') %>%
    ## filter to 2004 academic year
    filter(academicyear == 2004) %>%
    ## subset columns
    select(unitid, instruction01)

## =============================================================================
## MERGE INSTITUTION FILES
## =============================================================================

inst <- hd %>%
    ## join all institution sub-data sets
    left_join(ic, by = 'unitid') %>%
    left_join(cost, by = 'unitid') %>%
    left_join(fac, by = 'unitid') %>%
    left_join(ttfac, by = 'unitid') %>%
    left_join(dc, by = 'unitid') %>%
    left_join(bar, by = 'unitid') %>%
    ## drop those with missing costs
    filter(!is.na(instcost),
           ## drop if missing full-time equivalent enrollment
           !is.na(fte),
           ## drop if missing % of tenured/tenure-track faculty
           !is.na(ttfacpct),
           ## drop if missing full-time faculty
           !is.na(ftfac)) %>%
    ## only one college observation
    distinct(unitid) %>%
    ## create new vars
    mutate(sfr = fte / ftfac,                    # student faculty ratio
           instfte = instruction01 / fte / 1000) # 1000s

## =============================================================================
## IMPUTES
## =============================================================================

## ---------------------------
## EXPENDITURES
## ---------------------------

## get conditional mean prediction
fit <- lm(log(instfte) ~  fte + ftfac + privnp + privfp + twoyr + as.factor(stfips) +
              instcost + outscost + instcost_sq + outscost_sq, data = inst)

## get regression error
fit_err <- summary(fit)$sigma

## set seed for replicability
set.seed(4592)

## Buck's method (1960) conditional mean imputation
inst <- inst %>%
    ## get predictions
    mutate(instftepred = predict(fit, newdata = inst),
           ## add noise
           instftepred = instftepred + rnorm(nrow(inst), 0, fit_err),
           ## exponetiate: exp(log(x)) == x
           instftepred = exp(instftepred),
           ## replace if missing
           instfte = ifelse(is.na(instfte), instftepred, instfte)) %>%
    select(-instftepred)

## ---------------------------
## SAT SCORES + NEW VARS
## ---------------------------

inst <- inst %>%
    ## plug in 700 for missing two-years per Long (2004) footnote 12
    mutate(sat = ifelse(is.na(sat) & twoyr == 1, 700, sat),
           barcomp = ifelse(is.na(barcomp), 6, barcomp),
           sat = ifelse(is.na(sat) & barcomp == 7, 700, sat), # special so == twoyr
           sat = ifelse(is.na(sat) & barcomp == 6, 700, sat), # not competitive so == twoyr
           sat = ifelse(is.na(sat) & barcomp == 5, 800, sat), # floor((< 500) * 2)
           sat = ifelse(is.na(sat) & barcomp == 4, 1070, sat),# floor((500 to 572) * 2)
           sat = ifelse(is.na(sat) & barcomp == 3, 1190, sat),# floor((573 to 619) * 2)
           sat = ifelse(is.na(sat) & barcomp == 2, 1270, sat),# floor((620 to 654) * 2)
           sat = ifelse(is.na(sat) & barcomp == 1, 1460, sat),# floor((655 to 800) * 2)
           sat = round(sat, -1),
           ## SAT percentile per 10 points
           satpct = (sat - min(sat)) / (max(sat) - min(sat)) * 10,
           ## convert FTE to 1000s; FTE enrollment squared
           fte = fte / 1000,
           fte_sq = fte^2,
           ## expenditures / FTE squared
           instfte_sq = instfte^2)

## save to disk for descriptives
write.csv(inst %>%
          select(public,
                 privnp,
                 privfp,
                 twoyr,
                 sat,
                 sfr,
                 instcost,
                 outscost,
                 fte,
                 ttfacpct,
                 instfte),
          file = tdir %+% 'institutions.csv', row.names = FALSE)

## drop variables
inst <- inst %>%
    select(-c(barcomp, instruction01, ftfac, ftfac, sat, public, privnp, privfp))

## =============================================================================
## CREATE DISTANCE MATRIX: FIPS TO COLLEGES
## =============================================================================

## get college fips
col <- read_csv(ddir %+% 'colfips2004.csv') %>%
    ## filter out those not in inst data to save computation time
    filter(unitid %in% inst$unitid) %>%
    ## make sure in order
    arrange(unitid)

## get vectors of names
unitid <- col %>% .[['unitid']]
studid <- els %>% .[['stu_id']]

## matrices of lon/lat
colmat <- col %>% select(lon, lat) %>% data.matrix(.)
stumat <- els %>% select(lon, lat) %>% data.matrix(.)

## compute distance
distmat <- distm(stumat, colmat)

## add row/column names
rownames(distmat) <- studid
colnames(distmat) <- unitid

## convert meters to miles
distmat <- distmat * 0.000621371

## make long
dist <- data.frame(distmat) %>%
    ## to table dataframe
    tbl_df() %>%
    ## add student id column (from rownames)
    mutate(stu_id = as.integer(row.names(distmat))) %>%
    ## from wide to long
    gather(unitid, dist, -stu_id) %>%
    ## drop X that's added
    mutate(unitid = as.integer(gsub('X(.*)', '\\1', unitid)),
           dist = dist / 100,           # distance in 100s of miles
           dist_sq = dist^2,
           dist_cb = dist^3) %>%
    ## arrange by student, then school ids
    arrange(stu_id, unitid)

## get college list
colleges <- unitid

## remove matrices/vectors to free up space
rm(list = c('distmat','stumat','colmat','unitid'))
gc()

## ---------------------------
## UNIQUE INSTITUTIONS
## ---------------------------

write.csv(dist %>%
          distinct(unitid) %>%
          select(unitid),
          file = tdir %+% 'collegeoptions.csv', row.names = FALSE)

## ---------------------------
## ADJUST ENROLL
## ---------------------------

els <- els %>%
    ## only enrollments in colleges with physical location
    mutate(enroll2yr = ifelse(enroll2yr == 1 & f3iiped %in% colleges,
                              enroll2yr,
                              0))

## ---------------------------
## SAVE STUDENT DATA
## ---------------------------

write.csv(els %>%
          select(stu_id,
                 female,
                 amerind,
                 asianpi,
                 black,
                 hispanic,
                 multrace,
                 white,
                 byincome,
                 bypared,
                 state,
                 county,
                 sat,
                 satpct,
                 enroll2yr),
          file = ddir %+% 'studentdat.csv',
          row.names = FALSE,
          quote = FALSE)

## =============================================================================
## CREATE CONDITIONAL LOGIT DATASET
## =============================================================================

## build in pieces b/c memory management
dist <- dist %>%
    ## join institutional data
    left_join(inst, by = 'unitid') %>%
    ## join student data
    left_join(els %>% select(stu_id,
                             homestate = state,
                             stusatpct = satpct,
                             f3iiped,
                             enroll2yr),
              by = 'stu_id')

## remove to free memory
rm(list = setdiff(ls(), c('dist', 'elsddir', 'ddir',
                          'elsatt', 'hisat', 'lowinc')))
gc()
dist <- dist %>%
    ## add new variables
    mutate(homestate = as.integer(homestate),
           satdiff = stusatpct - satpct,
           cost = ifelse(homestate == stfips, instcost, outscost),
           cost_sq = ifelse(homestate == stfips, instcost_sq, outscost_sq),
           attend = ifelse(f3iiped == unitid
                           & !is.na(f3iiped)
                           & enroll2yr == 1, 1, 0)) %>%
    ## subset to save memory
    select(stu_id,        # student id
           unitid,        # school choices
           cost,          # cost
           cost_sq,       # cost^2
           dist,          # dist
           dist_sq,       # dist^2
           dist_cb,       # dist^3
           instfte,       # instructional expend
           instfte_sq,    # instructional expend^2
           sfr,           # student faculty ratio
           ttfacpct,      # tenure/tenure tract faculty pct
           satdiff,       # sat difference
           twoyr,         # two-year dummy
           fte,           # FTE
           fte_sq,        # FTE^2
           enroll2yr,     # enroll within 2 years (0/1)
           attend)        # attend (0/1)

gc()
dist <- dist %>%
    ## add new variables
    mutate(sathi = ifelse(satdiff > 0, satdiff, 0),
           sathi_sq = sathi^2,
           satlo = ifelse(satdiff < 0, satdiff, 0),
           satlo_sq = satlo^2) %>%
    select(-satdiff)
gc()

## =============================================================================
## ADD INDICATORS
## =============================================================================

dist <- dist %>%
    mutate(hisat = ifelse(stu_id %in% hisat$stu_id, 1, 0),
           lowinc = ifelse(stu_id %in% lowinc$stu_id, 1, 0))
gc()

## =============================================================================
## READ IN APPLICATION DATA
## =============================================================================

## redo functions
`%+%` <- function(a,b) paste(a, b, sep = '')
negtoNA <- function(x) ifelse(as.numeric(x) < 0, NA, x)

appdf <- read.dta(elsddir %+% 'f2inst.dta') %>%
    ## lower names
    setNames(tolower(names(.))) %>%
    ## subset columns
    select(stu_id,
           unitid = f2iiped,
           apply = f2iapply,
           accept = f2iaccpt) %>%
    ## negative to NA
    mutate_each(funs(negtoNA(.))) %>%
    ## filter to applicable (hah!) rows
    filter(!is.na(apply), apply == 1, !is.na(accept)) %>%
    ## to table dataframe
    tbl_df()
gc()

dist <- dist %>%
    left_join(appdf, by = c('stu_id', 'unitid')) %>%
    ## replace artificial NA with 0
    mutate(apply = ifelse(is.na(apply), 0, apply),
           accept = ifelse(is.na(accept), 0, accept))
gc()

## =============================================================================
## SAVE DATA
## =============================================================================

## STATA format
write.dta(dist, file = ddir %+% 'choice.dta', version = 10)
gc()

## =============================================================================
## END FILE
################################################################################
