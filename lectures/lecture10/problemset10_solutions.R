#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Grade (/20)

#-------------------------------------------------------------------------------------------------------------------------------------------------------

#=======================================================================================================================================================
#LOAD LIBRARIES
#options(max.print=999999)
library(tidyverse)
library(haven)
library(labelled)
#=======================================================================================================================================================

#=======================================================================================================================================================
#READ IN IC DIRECTORY DATA
#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Question 1 (/2)

#-------------------------------------------------------------------------------------------------------------------------------------------------------

getwd()

#Set working directory before downloading  
#setwd()
#Downloading file from the ipeds website
download.file("https://nces.ed.gov/ipeds/datacenter/data/HD2017.zip",
              destfile = "hd2017", mode = "wb")

#unzip zip file and keep original name
unzip(zipfile = "hd2017" , unzip = "unzip")

#Review documentation before reading in data 
hd <- read_csv("hd2017.csv") 


#Change names to lowercase  
names(hd) <- tolower(names(hd))

names(hd)  

#Subset dataframe to only a few columns  
hd <- hd %>%
  select(unitid, instnm, city, stabbr, zip, opeid, sector,
         iclevel, control, hbcu, tribal, c15basic)

#Label variable and value labels  

#Variable labels
hd <- hd %>%
  set_variable_labels(
    unitid = "Unique identification number of the institution",
    instnm = "Institution name",
    city = "City location of institution",
    stabbr = "State abbreviation",
    zip = "Zip code",
    opeid = "Office of Postsecondary Education (OPE) ID Number",
    sector = "Sector of institution",
    iclevel = "Level of institution",
    control = "Control of institution",
    hbcu = "Historically Black College or University",
    tribal = "Tribal college",
    c15basic = "Carnegie Classification 2015: Basic"
  )

hd %>%
  count(hbcu)

hd %>%
  count(tribal)

hd %>% 
  count(c15basic)

#Set value labels

hd <- hd %>%
  set_value_labels(sector = c("Administrative Unit" = 0, 
                              "Public, 4-year or above" = 1, 
                              "Private not-for-profit, 4-year or above" = 2,
                              "Private for-profit, 4-year or above" = 3, 
                              "Public, 2-year" = 4, 
                              "Private not-for-profit, 2-year" = 5, 
                              "Private for-profit, 2-year" = 6,
                              "Public, less-than 2-year" = 7, 
                              "Private not-for-profit, less-than 2-year" = 8,
                              "Private for-profit, less-than 2-year" = 9, 
                              "Sector unknown (not active)" = 99), 
                   iclevel = c("Four or more years" = 1, 
                               "At least 2 but less than 4 years" = 2, 
                               "Less than 2 years (below associate)" = 3,
                               "{Not available}" = -3),
                   control = c("Public" = 1, "Private not-for-profit" = 2, 
                               "Private for-profit" = 3, 
                               "{Not available}" = -3),
                   hbcu = c("Yes" = 1,
                            "No" = 2),
                   tribal = c("Yes" = 1,
                              "No" = 2),
                   c15basic = c("Associate's Colleges: High Transfer-High Traditional" = 1,
                                "Associate's Colleges: High Transfer-Mixed Traditional/Nontraditional" = 2,
                                "Associate's Colleges: High Transfer-High Nontraditional" = 3,
                                "Associate's Colleges: Mixed Transfer/Career & Technical-High Traditional" = 4,
                                "Associate's Colleges: Mixed Transfer/Career & Technical-Mixed Traditional/Nontraditional" = 5,
                                "Associate's Colleges: Mixed Transfer/Career & Technical-High Nontraditional" = 6,
                                "Associate's Colleges: High Career & Technical-High Traditional" = 7,
                                "Associate's Colleges: High Career & Technical-Mixed Traditional/Nontraditional" = 8,
                                "Associate's Colleges: High Career & Technical-High Nontraditional" = 9,
                                "Special Focus Two-Year: Health Professions" = 10,
                                "Special Focus Two-Year: Technical Professions" = 11,
                                "Special Focus Two-Year: Arts & Design" = 12,
                                "Special Focus Two-Year: Other Fields" = 13,
                                "Baccalaureate/Associate's Colleges: Associate's Dominant" = 14,
                                "Doctoral Universities: Highest Research Activity" = 15,
                                "Doctoral Universities: Higher Research Activity" = 16,
                                "Doctoral Universities: Moderate Research Activity" = 17,
                                "Master's Colleges & Universities: Larger Programs" = 18,
                                "Master's Colleges & Universities: Medium Programs" = 19,
                                "Master's Colleges & Universities: Small Programs" = 20,
                                "Baccalaureate Colleges: Arts & Sciences Focus" = 21,
                                "Baccalaureate Colleges: Diverse Fields" = 22,
                                "Baccalaureate/Associate's Colleges: Mixed Baccalaureate/Associate's" = 23,
                                "Special Focus Four-Year: Faith-Related Institutions" = 24,
                                "Special Focus Four-Year: Medical Schools & Centers" = 25,
                                "Special Focus Four-Year: Other Health Professions Schools" = 26,
                                "Special Focus Four-Year: Engineering Schools" = 27,
                                "Special Focus Four-Year: Other Technology-Related Schools" = 28,
                                "Special Focus Four-Year: Business & Management Schools" = 29,
                                "Special Focus Four-Year: Arts, Music & Design Schools" = 30,
                                "Special Focus Four-Year: Law Schools" = 31,
                                "Special Focus Four-Year: Other Special Focus Institutions" = 32,
                                "Tribal Colleges" = 33,
                                "Not applicable, not in Carnegie universe (not accredited or nondegree-granting)" = -2)
                   )

#Check a few vars
class(hd$sector)
typeof(hd$sector)

hd %>%
  count(sector) %>%
  as_factor()


class(hd$c15basic)
typeof(hd$c15basic)

hd %>%
  count(c15basic) %>%
  as_factor()


#View all variable labels
var_label(hd)

#View all value labels
val_labels(hd)


#Investigate data/tidy  
head(hd, n = 20)


hd %>%
  filter(c15basic == 8)

#investigate data structure
hd %>% # start with data frame object 
  group_by(unitid) %>% # group by unitid
  summarise(n_per_group=n()) %>% # create measure of number of obs per group
  ungroup %>% # ungroup (otherwise frequency table [next step] created) separately for each group (i.e., separate frequency table for each value of unitid)
  count(n_per_group) 

#=======================================================================================================================================================
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> YOUR CODE STARTS HERE. FOLLOW THE INSTRUCTIONS FROM PDF >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#=======================================================================================================================================================

#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Question 2 (/4.5)

#-------------------------------------------------------------------------------------------------------------------------------------------------------


########################### READ IN FLAGS DATA
download.file("https://nces.ed.gov/ipeds/datacenter/data/FLAGS2017.zip",
              destfile = "flags2017", mode = "wb")
#unzip zip file and keep original name
unzip(zipfile = "flags2017" , unzip = "unzip")

#Review documentation before reading in data 
flags <- read_csv("flags2017.csv") #No parsing errors

#Change names to lowercase  
names(flags) <- tolower(names(flags))

names(flags)  

#Subset dataframe to include unitid and stat_e12, read documentation
flags <- flags %>%
  select(unitid, contains("e12"))

names(flags)

#Label variable and value labels  

#Variable labels
flags <- flags %>%
  set_variable_labels(
    unitid = "Unique identification number of the institution",
    stat_e12 = "Response status of institution - 12-month enrollment",
    lock_e12 = "Status of 12-month enrollment component whe data collection closed",
    prch_e12 = "Parent/child indicator for 12-month enrollment",
    idx_e12 = "ID number of parent institution - 12-month enrollment",
    pce12_f = "Parent/child allocation factor - 12-month enrollment",
    imp_e12 = "Type of imputation method - 12 month enrollment"
  )


#Value labels

flags <- flags %>%
  set_value_labels(
    stat_e12 = c("Respondent" = 1,
                 "Non respondent, imputed" = 4,
                 "Nonrespondent hurricane-related problems, imputed" = 8,
                 "Nonrespondent not imputed" = 5,
                 "Not applicable" = -2,
                 "Not active" = -9),
    lock_e12 = c("No data submitted" = 0,
                 "Complete, final lock applied" = 8,
                 "Not applicable" = -2),
    imp_e12 = c("Nearest neighbor (NN)" = 2,
                "Not applicable" = -2))

class(flags$stat_e12)
typeof(flags$stat_e12)

flags %>%
  count(stat_e12)

flags %>%
  count(stat_e12) %>%
  as_factor()

flags %>%
  group_by(prch_e12, idx_e12, pce12_f) %>%
  count()

var_label(flags)
val_labels(flags)


#investigate data structure
flags %>% # start with data frame object 
  group_by(unitid) %>% # group by unitid
  summarise(n_per_group=n()) %>% # create measure of number of obs per group
  ungroup %>% # ungroup (otherwise frequency table [next step] created) separately for each group (i.e., separate frequency table for each value of unitid)
  count(n_per_group) 



#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Question 3 (/4)

#-------------------------------------------------------------------------------------------------------------------------------------------------------


#Inner join to keep all obs for stat_e12
hd_flags <- hd %>% 
  inner_join(flags, by = "unitid")


hd_flags %>%
  filter(is.na(stat_e12)) #No missing obs for stat_e12

anti_hd_flags <- hd %>% 
  anti_join(flags, by = "unitid") #all merged 

#print anti merge dataset; note, no observations don't merge
anti_hd_flags

rm(anti_hd_flags)

#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Question 4 (/5)

#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Downloading file from the ipeds website
download.file("https://nces.ed.gov/ipeds/datacenter/data/EFFY2017.zip",
              destfile = "effy2017", mode = "wb")
#unzip zip file and keep original name
unzip(zipfile = "effy2017" , unzip = "unzip")

#Review documentation before reading in data 
enroll <- read_csv("effy2017.csv") %>%
  select(-starts_with("X")) #No parsing errors


#Change variable names to lower-case
names(enroll) <- tolower(names(enroll))  
  
names(enroll)


#Subset dataframe, read documentation
enroll <- enroll %>% select(unitid, effylev, efytotlt)

enroll %>% head(n=10)

#Label variable and value labels  

#Variable labels
enroll <- enroll %>%
  set_variable_labels(
    unitid = "Unique identification number of the institution",
    effylev = "Level of student",
    efytotlt = "Grand total"
  )


#Value labels

enroll <- enroll %>%
  set_value_labels(
    effylev = c("All students total" = 1,
                "Undergraduate" = 2,
                "Graduate" = 4)
  )

#investigate data
class(enroll$effylev)
typeof(enroll$effylev)

enroll %>%
  count(effylev)

enroll %>%
  count(effylev) %>%
  as_factor()

var_label(enroll)
val_labels(enroll)



#Investigate structure
enroll %>% # start with data frame object 
  group_by(unitid,effylev) %>% # group by unitid
  summarise(n_per_group=n()) %>% # create measure of number of obs per group
  ungroup %>% # ungroup (otherwise frequency table [next step] created) separately for each group (i.e., separate frequency table for each value of unitid)
  count(n_per_group)

enroll %>%
  count(effylev)

#Tidy
enroll_v2 <- enroll %>% 
  mutate(level=recode(as.integer(effylev),
                      `1` = "all",
                      `2` = "ug",
                      `4` = "grad")
  ) %>% select(-effylev) %>% # drop variable effylev
  pivot_wider(names_from = level, values_from = efytotlt)

names(enroll_v2)
enroll_v2


#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Question 5 (/4.5)

#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Investigate structure
enroll_v2 %>% # start with data frame object 
  group_by(unitid) %>% # group by unitid
  summarise(n_per_group=n()) %>% # create measure of number of obs per group
  ungroup %>% # ungroup (otherwise frequency table [next step] created) separately for each group (i.e., separate frequency table for each value of unitid)
  count(n_per_group)


#Left join
hd_enroll <- hd_flags %>% 
  left_join(enroll_v2, by = "unitid")

hd_enroll %>% count(stat_e12) %>% as_factor()

anti_hd_enroll <- hd_flags %>% 
  anti_join(enroll_v2, by = "unitid")

anti_hd_enroll %>% count(stat_e12) %>% as_factor()


anti_hd_enroll %>% group_by(unitid) %>%
  summarise(by_school_id = n()) %>%
  ungroup() %>%
  count(by_school_id)




#Bonus question
#-------------------------------------------------------------------------------------------------------------------------------------------------------

#Bonus (/4)

#-------------------------------------------------------------------------------------------------------------------------------------------------------


## USAGE -----------------------------------------------------------------------
##
## (1) download relevant Stata data and label files from IPEDS (leave zipped)
##
##     - Stata data:    *_Data_Stata.zip
##     - Stata labels:  *_Stata.zip
##
## (2) change input/output directories below if desired
##
## (3) run
##
## NB: You can download zipped IPEDS files using < downloadipeds.r > script @
##     https://github.com/btskinner/downloadipeds
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## SET I/O DIRECTORIES (DEFAULT = everything in the current directory)
## -----------------------------------------------------------------------------

##  If directory structure like this EXAMPLE:
##
##  ./
##  |__/r_data
##  |
##  |__/stata_data
##  |    |-- ADM2014_Data_Stata.zip
##  |    |-- ADM2015_Data_Stata.zip
##  |
##  |__/stata_labels
##  |    |-- ADM2014_Stata.zip
##  |    |-- ADM2015_Stata.zip
##  |
##  |-- label_ipeds.r
##
##  Then:
##
##  labs_ddir <- file.path('.', 'stata_labels')
##  stata_ddir <- file.path('.', 'stata_data')
##  r_ddir <- file.path('.', 'r_data')
getwd()
labs_ddir <- file.path('~/Dropbox/r_class_problem_sets/lecture8/r_data/stata_labels')  # path to folder w/ zipped label files
stata_ddir <- file.path('~/Dropbox/r_class_problem_sets/lecture8/r_data/stata_data') # path to folder w/ zipped Stata data
r_ddir <- file.path('~/Dropbox/r_class_problem_sets/lecture8/r_data/r_files') # path to output folder for Rdata files

## -----------------------------------------------------------------------------
## WANT NOISIER OUTPUT? (DEFAULT = FALSE)
## -----------------------------------------------------------------------------

## allow readr::read_csv() messages?
noisy <- FALSE

## -----------------------------------------------------------------------------
## LIBRARIES & FUNCTIONS
## -----------------------------------------------------------------------------
## libraries
libs <- c('tidyverse','labelled')
lapply(libs, require, character.only = TRUE)

read_zip <- function(zipfile, type, noisy) {
  ## create a name for the dir where we'll unzip
  zipdir <- tempfile()
  ## create the dir using that name
  dir.create(zipdir)
  ## unzip the file into the dir
  unzip(zipfile, exdir = zipdir)
  ## get the files into the dir
  files <- list.files(zipdir, recursive = TRUE)
  ## chose rv file if more than two b/c IPEDS likes revisions
  if (length(files) > 1) {
    file <- grep('*_rv_*', tolower(files), value = TRUE)
    if (length(file) == 0) {
      file <- grep('*\\.csv', files, value = TRUE)
    }
  } else {
    file <- files[1]
  }
  ## get the full name of the file
  file <- file.path(zipdir, file)
  ## read the file
  if (type == 'csv') {
    if (noisy) {
      out <- read_csv(file)
    } else {
      out <- suppressMessages(suppressWarnings(read_csv(file,
                                                        progress = FALSE)))
    }
  } else {
    out <- readLines(file, encoding = 'latin1')
  }
  ## remove tmp
  unlink(zipdir, recursive = TRUE)
  ## return
  return(out)
}

read_labels <- function(zipfile) {
  ## read in label file
  labs <- read_zip(zipfile, 'do')
  ## get insheet line and add one to get next line
  line_no <- grep('insheet', labs) + 1
  ## drop header
  labs <- labs[line_no:length(labs)]
  ## drop first asterisk
  labs <- gsub('^\\*(.+)$', '\\1', labs)
  ## return
  return(labs)
}

assign_var_labels <- function(df, label_vec) {
  ## get variable label lines
  varlabs <- grep('^label variable', label_vec, value = TRUE)
  ## if no labels, exit
  if (length(varlabs) == 0) { return(df) }
  ## get variables that have labels
  vars <- unlist(lapply(varlabs, function(x) { strsplit(x, ' ')[[1]][[3]] }))
  ## get the labels belonging to those variables
  labs <- gsub('label variable .+"(.+)"', '\\1', varlabs)
  ## create list
  varlabs <- setNames(as.list(labs), vars)
  ## assign to variables
  var_label(df) <- varlabs
  ## return new data frame
  return(df)
}

assign_val_labels <- function(df, label_vec) {
  ## get value label lines
  vallabs <- grep('^label define', label_vec, value = TRUE)
  ## if no labels, exit
  if (length(vallabs) == 0) { return(df) }
  ## get unique defined labels
  labdefs <- unique(gsub('^label define (\\w+).+', '\\1', vallabs))
  ## get label value lines
  vars <- grep('^label values', label_vec, value = TRUE)
  ## make list of variable plus its value definition
  vardef <- setNames(as.list(gsub('^label values (\\w+).+', '\\1', vars)),
                     gsub('^label values \\w+ (\\w+)\\*?.*', '\\1', vars))
  ## make unique b/c of some double labels
  vardef <- vardef[!duplicated(vardef)]
  
  ## loop through each variable
  for (i in 1:length(labdefs)) {
    ## get label
    labdef <- labdefs[i]
    ## skip if missing
    if (!is.null(vardef[[labdef]])) {
      ## subset lines with this definition
      pattern <- paste0('\\b', labdef, '\\b')
      vallab <- grep(pattern, vallabs, value = TRUE)
      ## get values
      pattern <- paste0('label define ', labdef, ' +(-?\\w+).+')
      values <- gsub(pattern, '\\1', vallab)
      ## convert values to class of variable...hacky fix here
      suppressWarnings(class(values) <- class(df[[vardef[[labdef]]]]))
      ## get labels
      pattern <- paste0('label define ', labdef, ' .+"(.+)" ?(, ?add ?)?')
      labels <- gsub(pattern, '\\1', vallab)
      ## make list
      labels <- setNames(values, labels)
      ## label values
      df[[vardef[[labdef]]]] <- labelled(df[[vardef[[labdef]]]], labels)
    }
  }
  ## return dataframe
  return(df)
}

assign_imp_labels <- function(df, label_vec) {
  ## find line numbers surrounding imputation values
  line_no_start <- grep('imputation.*variable(s)?', label_vec) + 1
  ## if no imputation labels, exit
  if (length(line_no_start) == 0) { return(df) }
  line_no_stop <- grep('^tab\\b', label_vec)[[1]] - 1
  labs <- label_vec[line_no_start:line_no_stop]
  ## get variables starting with 'x'
  vars <- df %>% select(starts_with('x')) %>% names(.)
  ## make list of each impute value and label
  values <- gsub('(\\w\\b).+', '\\1', labs)
  labels <- gsub('\\w\\b (.+)', '\\1', labs)
  labels <- setNames(values, labels)
  ## loop through each imputed variable
  for (v in vars) {
    if (class(df[[v]]) == class(values)) {
      df[[v]] <- labelled(df[[v]], labels)
    }
  }
  ## return dataframe
  return(df)
}

## -----------------------------------------------------------------------------
## RUN BY LOOPING THROUGH FILES
## -----------------------------------------------------------------------------

## get list of zip files
stata_zip <- grep('*_Data_Stata\\.zip', list.files(stata_ddir), value = TRUE)
stata_lab <- grep('_Stata\\.zip', list.files(labs_ddir), value = TRUE)

## if stata_ddir and labs_ddir are the same, subset
if (identical(stata_ddir, labs_ddir)) {
  stata_lab <- stata_lab[!(stata_lab %in% stata_zip)]
}

## loop
for (i in 1:length(stata_zip)) {
  f <- stata_zip[i]
  ## message
  message(paste0('Working with: ', f))
  ## get basename
  fname <- gsub('(^.+)_Data_Stata.zip', '\\1', f)
  ## get label file
  lab_file <- grep(paste0('^', fname, '_Stata'), stata_lab, value = TRUE)
  ## skip if missing label file
  if (length(lab_file) == 0) {
    message(paste0('  NO LABEL FILE FOR: ', fname, ', skipping'))
    next
  }
  ## read in data
  df <- read_zip(file.path(stata_ddir, f), 'csv', noisy) %>%
    rename_all(tolower)
  ## get labels
  labs <- read_labels(file.path(labs_ddir, lab_file))
  ## assign variable labels
  df <- assign_var_labels(df, labs)
  ## assign value labels
  df <- assign_val_labels(df, labs)
  ## assign imputation labels
  df <- assign_imp_labels(df, labs)
  ## rename data frame to match file name
  assign(tolower(fname), df)
  ## save
  save(list = tolower(fname),
       file = file.path(r_ddir, paste0(fname, '.Rdata')))
  ## garbage collect every 10 loops...may help...idk
  if (i %% 10 == 0) { gc() }
}

## =============================================================================
## END SCRIPTstat
