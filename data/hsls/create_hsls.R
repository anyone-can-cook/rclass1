
######## LOAD LIBRARIES ##########
#options(max.print=999999)
options(tibble.print_min=10)
library(tidyverse)
library(labelled)
library(haven)
library(sjlabelled)
#################################

#second followup survey instrument:
  #https://nces.ed.gov/surveys/hsls09/pdf/HSLS09_Second_Follow-up_Student_Instrument.pdf [2016]
  #https://nces.ed.gov/surveys/hsls09/pdf/2013_Student_Parent_Questionnaire.pdf [2013]

getwd()

list.files("../../Dropbox/teaching-data/hsls/data/by_f2")

#load("../../Dropbox/teaching-data/hsls/data/by_f2/hsls_16_student_v1_0.RData")


#STUDENT LEVEL DATA

#OPEN DATA BY LOADING R DATASET
  #PROBLEM: variable attributes are not attached to the individual variables
load("../../Dropbox/teaching-data/hsls/data/by_f2/hsls_16_student_v1_0.RData")
#stur <- hsls_16_student_v1_0
#names(stur) <- tolower(names(stur))
#stur <- as_tibble(stur)
#stur %>% select(stu_id, sch_id, contains("univ"),s3classes,s3apprentice,s3work,s3military,s3family,s3hs,s3gedcourse,s3focus,s3clgft,s3workft,s3milbranch,s3clgid,s3clgcntrl,s3clglvl,s3clgsel,s3clgstate,s3proglevel,x4evrappclg,x4clgappnum,x4evratndclg,x4evr2ypub,x4atndclg16fb,x4choiceappid,x4choiceaccid,x4atndappinst,x4hs2psmos,x4psend,x4ps1,x4ps1start,x4ps1sector,x4ps1level,x4ps1ctrl,x4ps1select,x4refinst,x4refsector,x4reflevel,x4refctrl,x4refselect) %>% str()


#OPEN DATA BY READING IN STATA DATA FILE
  # VARIABLES HAVE TYPE =NUMERIC/DOUBLE AND HAVE ATTRIBUTES VARIABLE LABELS AND VALUE LABELS BUT CLASS=LABELLED NOT CLASS=FACTOR
hsls_stu <- read_dta(file="../../Dropbox/teaching-data/hsls/data/by_f2/hsls_16_student_v1_0.dta", encoding=NULL)

class(hsls_stu) # tibble

#hsls_stu <- get_labels(hsls_stu)

names(hsls_stu) <- tolower(names(hsls_stu))

names(hsls_stu$x2txmth)
#Create version of dataset that converts labelled variables (i.e., those w/ value labels) to factors
hsls_stu_f <- haven::as_factor(hsls_stu,only_labelled = TRUE)
glimpse(hsls_stu)
#s4birthsex,s4male,s4female,s4male,s4transmtf,s4transftm,s4othgender,s4dkgender,s4orientation)

#comparing the data frame w/ class=labelled to the one w/ class=factor
hsls_stu %>% select(stu_id, sch_id, contains("univ"),s3classes,s3apprentice,s3work,s3military,s3family) %>% str()
hsls_stu_f %>% select(stu_id, sch_id, contains("univ"),s3classes,s3apprentice,s3work,s3military,s3family) %>% str()

#comparing frequency table class=labelled vs. class=factor
hsls_stu_f %>% select(s3classes) %>% count(s3classes)

attributes(hsls_stu$s3classes)
hsls_stu %>% select(s3classes) %>% count(s3classes)
hsls_stu %>% select(s3classes) %>% count(s3classes) %>% haven::as_factor()

#from haven package
hsls_stu %>% select(s3classes) %>% count(s3classes) %>% haven::as_factor()
hsls_stu %>% select(s3classes) %>% count(s3classes) %>% haven::as_factor.labelled()

#from labelled package
hsls_stu %>% select(s3classes) %>% count(s3classes) %>% labelled::labelled()

#stuff from sjlabelled package
hsls_stu %>% select(s3classes) %>% count(s3classes) %>% sjlabelled::as_factor() 
hsls_stu %>% select(s3classes) %>% count(s3classes) %>% sjlabelled::as_label() 
hsls_stu %>% select(s3classes) %>% count(s3classes) %>% sjlabelled::as_labelled() 



hsls_stu %>% select(s3classes) %>% filter(s3classes==3) %>% count(s3classes)

  #PROBLEM: HAVEN'T FIGURED OUT HOW TO SHOW FREQUENCY TABLE FOR CLASS=LABELLED AND SHOW THE VALUES+THE VALUE LABELS


hsls_stu_small <- hsls_stu %>% select(stu_id, sch_id, contains("univ"),s3classes,s3apprentice,s3work,s3military,s3family,
  s3hs,s3gedcourse,s3focus,s3clgft,s3workft,s3milbranch,s3clgid,s3clgcntrl,s3clglvl,s3clgsel,s3clgstate,s3proglevel,
  x3sqstat,x2sex,x2race,x2paredu,x2txmtscor,
  x4evrappclg,x4clgappnum,x4evratndclg,x4evr2ypub,x4atndclg16fb,x4choiceappid,x4choiceaccid,x4atndappinst,x4hs2psmos,x4psend,
  x4ps1,x4ps1start,x4ps1sector,x4ps1level,x4ps1ctrl,x4ps1select,x4refinst,x4refsector,x4reflevel,x4refctrl,x4refselect,
  x4x2ses,x4x2sesq5,x4sqstat)

#make data uppercase and export to Stata
  names(hsls_stu_small) <- toupper(names(hsls_stu_small))
  
  names(hsls_stu_small)
  
  
  
  #Error: Stata only supports labelled integers.
  str(hsls_stu_small$X2TXMTSCOR,hsls_stu_small$X4X2SES)
  hsls_stu_small$X2TXMTSCOR<- zap_labels(hsls_stu_small$X2TXMTSCOR)
  hsls_stu_small$X4X2SES <- zap_labels(hsls_stu_small$X4X2SES)
  str(hsls_stu_small$X2TXMTSCOR,hsls_stu_small$X4X2SES)
  
  #write_dta(hsls_stu_small, "../../Dropbox/teaching-data/hsls/data/by_f2/hsls_stu_small.dta", version=14)
  write_dta(hsls_stu_small, "data/hsls/hsls_stu_small.dta", version=14)

getwd()
stu_small %>% count(x3univ1)

stu_small %>% count(x3sqstat)
stu_small %>% count(x3sqstat) %>% haven::as_factor()

#s3classes
stu_small %>% count(s3classes)
stu_small %>% count(s3classes) %>% haven::as_factor()
stu_small %>% group_by(x3sqstat) %>% count(s3classes) %>% haven::as_factor()

#characteristics of postsecondary institution student is currently enrolled in [level]
stu_small %>% count(s3clglvl)
stu_small %>% count(s3clglvl) %>% haven::as_factor()

#task for students: create a measure of level of postsecondary institution attended with these categories
  #1=no-PSE; 2= 2yr or less-than 2-yr; 3=4yr
  #start by looking at questionnaire and identifying skip-patterns
  #they must figure out how to code all of the values of input variables correctly
    #what blatter did wrong: counted item-legitimate skip [not enrolled in classes] as missing

  #do two-way tabulations between s3clglvl and it's input variables:
    #x3sqstat
      stu_small %>% count(s3clglvl)
      stu_small %>% group_by(x3sqstat) %>%  count(s3clglvl)
    #s3classes
      stu_small %>% count(s3clglvl) %>% haven::as_factor()
      stu_small %>% group_by(s3classes) %>% count(s3clglvl) %>% haven::as_factor()
      stu_small %>% group_by(s3classes) %>% count(s3clglvl)

      
            
str(hsls_stu$x4reflevel)
typeof(hsls_stu$x4reflevel)
class(hsls_stu$x4reflevel)
head(hsls_stu$x4reflevel)
attributes(hsls_stu$x4reflevel)
attr(hsls_stu$x4reflevel,"label")
attr(hsls_stu$x4reflevel,"labels")
  #note that class "factor" has attributes called "levels" whereas class "labelled" has attributes called "labels"

hsls_stu %>% select(x4reflevel) %>% val_labels() # this is null after you convert from class="labelled" to class="factor"

hsls_stu %>% select(x4ps1sector) %>% count(x4ps1sector)
%>% as_factor()
str(hsls_stu$x4ps1sector)
#contains("s4pre"),s4hscred,s4hscredmo,s4hscredyr,s4lasthsyr,s4lasthsgrade,s4dropouths,s4dropouths_i,s4transferhs,s4transferhs_i,s4hspgmever,s4hspgm16fb,s4hsequexam,s4hsequexam_i,s4hseqexampass,s4hseqexampass_i,s4hsequexpect,s4anydualcred,s4everapply,s4whenapply,s4evratndclg,s4evratndclg_i,s4noenracad,s4noenrfam,s4noenrfin,s4noenrwrk,s4noenrnone,s4clgatndnum,s4clgftpt,s4transferclg,s4transferacad,s4transferfam,s4transferfin,s4transferwrk,s4transfernone,s4leftacad,s4leftfam,s4leftfin,s4leftwrk,s4leftnone,s4bachelor3yrs,s4eduexp,s4eduexppar) %>% str()

hsls_stu %>% select(stu_id, sch_id,) 






#SCHOOL DATA
hsls_sch <- read_dta(file="../../Dropbox/teaching-data/hsls/data/by_f2/HSLS_09_SCHOOL_v1_0.dta", encoding=NULL)
names(hsls_sch) <- tolower(names(hsls_sch))
hsls_sch <- as_factor(hsls_sch,only_labelled = TRUE)
str(hsls_sch)

rm(SCHOOL)
as.data.frame(load("../../Dropbox/teaching-data/hsls/data/by_f2/HSLS_09_SCHOOL_v1_0.rdata"))
class(SCHOOL)
schr <- as_tibble(SCHOOL)

str(hsls_sch)


#### alternative approaches to converting class=labelled to class=factors

We see that there are some labelled variables. If we only want to convert specific variables, we can use mutate_at from dplyr.

# Convert specific variables to factor
nlsw88 %>%
  mutate_at(
    vars('race'),
    funs(as_factor(.))
  ) %>%
  head()
Along Gregor's and aosmith's comments we can also convert all labelled variables using the mutate_if function, testing for the labelled class. This will save you a lot of extra typing.

# Convert all labelled variables to factor
nlsw88 %>%
  mutate_if(
    is.labelled,
    funs(as_factor(.))
  ) %>%
  head()

#OWN: I THINK THIS WORKS JUST AS WELL THOUGH:
hsls_stu <- as_factor(hsls_stu,only_labelled = TRUE)