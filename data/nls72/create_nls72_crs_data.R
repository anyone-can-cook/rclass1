

######## LOAD LIBRARIES ##########
#options(max.print=999999)
library(tidyverse)
library(haven)
library(labelled)
#################################

getwd()
list.files("../../Dropbox/teaching-data/nls/data/analysis/pets")

#Read Stata data
nls_crs <- read_dta(file="../../Dropbox/teaching-data/nls/data/analysis/pets/nls72petscrs_v2.dta", encoding=NULL)



#sort and order

nls_crs <- nls_crs %>% select(-cname) # drop variable cname, which we don't use
nls_crs <- nls_crs %>% arrange(id, transnum, termnum, crsename) # sort observations
nls_crs <- nls_crs %>% select(id, transnum, termnum, crsecred, gradtype, crsgradb, crsgrada, crsecip, crsename) # order variables

#Investigate data patterns
glimpse(nls_crs)
names(nls_crs)
head(nls_crs)
nls_crs %>% var_label() # view variable labels
#nls_crs %>% val_labels()

#Investigate variable transnum

nls_crs %>% select(transnum) %>% var_label() # view variable labels
nls_crs %>% count(transnum)
310800+131412+34926+6396+851+137==484522 ## asser sum of frequencies == number of rows

#Investigate variable termnum
nls_crs %>% select(termnum) %>% var_label() # view variable labels

nls_crs %>% count(termnum)
options(tibble.print_min=40)
nls_crs %>% count(termnum)
options(tibble.print_min=20)
nls_crs %>% count(termnum)

#Investigate course credits
glimpse(nls_crs)
nls_crs %>% select(crsecred) %>% var_label() # view variable labels


summary(nls_crs$crsecred)

nls_crs %>% count(crsecred)
options(tibble.print_min=Inf)
nls_crs %>% count(crsecred)
options(tibble.print_min=20)

#investigate high values of crsecred
nls_crs %>% filter(crsecred>=100) %>% count(crsecred) # frequency table of crsecred

nls_crs %>% filter(crsecred==999) # printing some observations for specific values of crsecred
nls_crs %>% filter(crsecred==1000) # printing some observations for specific values of crsecred
nls_crs %>% filter(crsecred>999) # printing some observations for specific values of crsecred

#Investigate gradtype
class(nls_crs$gradtype) # labelled
glimpse(nls_crs)
nls_crs %>% select(gradtype) %>% var_label() # view variable labels
nls_crs %>% select(gradtype) %>% val_labels() # view value labels on variable

nls_crs %>% count(gradtype)

#crsgrada, crsgradb
glimpse(nls_crs)
nls_crs %>% select(crsgrada,crsgradb) %>% var_label() # view variable labels
nls_crs %>% count(crsgrada)
nls_crs %>% count(crsgradb)

#Investigate gradtype, crsgrada, crsgradb
  nls_crs %>% filter(gradtype==1) # letter grade
  nls_crs %>% filter(gradtype==2) # numeric grade
  nls_crs %>% filter(gradtype==9) # missing
  
  #some tabulations for different values of gradtype
  nls_crs %>% filter(gradtype==1) %>% count(crsgrada) # letter grade
  nls_crs %>% filter(gradtype==1) %>% count(crsgradb) # letter grade
  
  nls_crs %>% filter(gradtype==2) %>% count(crsgrada) # numeric grade
  nls_crs %>% filter(gradtype==2) %>% count(crsgradb) # numeric grade
  
  nls_crs %>% filter(gradtype==9) %>% count(crsgrada) # missing
  nls_crs %>% filter(gradtype==9) %>% count(crsgradb) # missing
  

#STEPS IN CREATING INSTITUTION-LEVEL GPA VARIABLE

#Write a plan for how you will create an institution-level GPA variable  
  #The general definition of GPA is quality points (course credit multiplied by numerical grade value) divided by total credits. 
  
  #The first part of creating an institution-level GPA variable is to explore the input variables: 
    #id transnum gradtype crsecred crsgradb crsgrada. 
  
  #Next, we will generate missing values to deal with idiosyncracies in the value of "input" variables
    #so that calculations accross observations will be correct despite any one variable being missing.
  
  #Then, we will begin creating an institutional-level GPA by first generating a brand new numerical grade
    #value variable using crsegrada crsgradb and gradtype. This new variable will equal the numerical value
    #associated with crsgrada when gradtype==1 and it will equal crsegradb when gradtype==2 and crsegradb>4,
    #multipliying each observation's numerical grade value variable by crsecred will generate a course level
    #quality points variable.  
  
  #We will calculate institutional level quality points and total credits variables by summing across observations
    #within id and transnum. Finally, we will divide the institutional level quality points by insitutional total
    #credits to generate the institutional level GPA. 


#Create measure of course credits attempted that replaces 999 and 999.999 with missing

nls_crs %>% count(crsecred)

nls_crs %>% filter(crsecred==999) # printing some observations for specific values of crsecred
nls_crs %>% filter(crsecred==1000) # printing some observations for specific values of crsecred
nls_crs %>% filter(crsecred>=999) %>% count(crsecred) # printing some observations for specific values of crsecred

nls_crs <- nls_crs %>% 
  mutate(crsecredv2= ifelse(crsecred>=900, NA, crsecred))

#check that variables have been created correctly

  nls_crs %>% filter(crsecred==999) %>% select(crsecred,crsecredv2)
  nls_crs %>% filter(crsecred>999) %>% select(crsecred,crsecredv2)
  
  nls_crs %>% filter(crsecred>900) %>% count(crsecredv2) # one-way frequency table
  nls_crs %>% filter(crsecred>900) %>% group_by(crsecred) %>% count(crsecredv2) # two-way frequency table

#Create a second version of crsgradb [numeric grades where gradtype==2] that is missing if: [ENDED UP NOT USING THIS]
  #crsgradb is greater than 4
  #gradtype==1 [letter]
  #crsecredv2 is missing
  
  #investigate values of the numeric grade when gradtype==2 and course credit not missing
  
  typeof(nls_crs$crsgradb)
  class(nls_crs$crsgradb)
  
  options(tibble.print_min=300)
  nls_crs %>% filter(gradtype==2, (!is.na(crsecredv2))) %>% count(crsgradb)

  nls_crs <- nls_crs %>% mutate(crsgradbv2= ifelse(crsgradb<=4 & gradtype==2 & (!is.na(crsecredv2)), crsgradb, NA)) 
  #%>%   filter(gradtype==2)
  
  #check variables  
    nls_crs %>% filter(is.na(crsecredv2)) %>% count(crsgradbv2) # course credit is missing
    nls_crs %>% filter(gradtype %in% c(1,9)) %>% count(crsgradbv2) # course credit is missing
    nls_crs %>% filter(crsgradb>4) %>% count(crsgradbv2) # course credit is missing
    
    nls_crs %>% filter(crsgradb<=4, gradtype==2, (!is.na(crsecredv2))) %>% count(crsgradbv2) # tabulation of analysis variable
    nls_crs %>% filter(crsgradb<=4, gradtype==2, (!is.na(crsecredv2))) %>% group_by(crsgradb) %>% count(crsgradbv2) # tabulation of analysis variable
    nls_crs %>% filter(crsgradb<=4, gradtype==2, (!is.na(crsecredv2))) %>% mutate(assert=crsgradb==crsgradbv2) %>% count(assert)
  
#Create "numgrade" variable that has numeric grade associated with each class
  #check inputs
  nls_crs %>% count(gradtype)
  nls_crs %>% count(gradtype) %>% haven::as_factor()
  
  nls_crs %>% filter(gradtype==1) %>% count(crsgrada)

  #options(tibble.print_min=200)

  
  nls_crs <- nls_crs %>% 
    mutate(
      numgrade=case_when(
        crsgrada %in% c("A+","A") & gradtype==1 & (!is.na(crsecredv2)) ~ 4,
        crsgrada=="A-" & gradtype==1 & (!is.na(crsecredv2)) ~ 3.7,
        crsgrada=="B+" & gradtype==1 & (!is.na(crsecredv2)) ~ 3.3,
        crsgrada=="B" & gradtype==1 & (!is.na(crsecredv2)) ~ 3,
        crsgrada=="B-" & gradtype==1 & (!is.na(crsecredv2)) ~ 2.7,
        crsgrada=="C+" & gradtype==1 & (!is.na(crsecredv2)) ~ 2.3,
        crsgrada=="C" & gradtype==1 & (!is.na(crsecredv2)) ~ 2,
        crsgrada=="C-" & gradtype==1 & (!is.na(crsecredv2)) ~ 1.7,
        crsgrada=="D+" & gradtype==1 & (!is.na(crsecredv2)) ~ 1.3,
        crsgrada=="D" & gradtype==1 & (!is.na(crsecredv2)) ~ 1,
        crsgrada=="D-" & gradtype==1 & (!is.na(crsecredv2)) ~ 0.7,
        crsgrada %in% c("F","E","WF") & gradtype==1 & (!is.na(crsecredv2)) ~ 0,
        crsgradb<=4 & gradtype==2 & (!is.na(crsecredv2)) ~ crsgradb # use values of numeric var crsgradb
      )
    )
    #%>% filter(crsgrada %in% c("D+","D","D-")) %>% select(id,transnum,crsecred,crsecredv2,gradtype,crsgradb,crsgrada,numgrade)

  #check variable created correctly
  nls_crs %>% filter(is.na(crsecredv2)) %>% count(numgrade) # missing when crsecredv2==NA
  nls_crs %>% filter(gradtype==9) %>% count(numgrade) # missing when grade-type is not "letter"
  
  nls_crs %>% filter(gradtype==1, (!is.na(crsecredv2))) %>% count(numgrade) # when grade-type=letter and course credit is not missing
  nls_crs %>% filter(gradtype==1, (!is.na(crsecredv2))) %>% group_by(numgrade) %>% count(crsgrada) # when grade-type=letter and course credit is not missing
  410+8115+2625+10628+12824+4963+268+15094+1569==56496
  
  nls_crs %>% filter(gradtype==1, (!is.na(crsecredv2))) %>% group_by(crsgrada) %>% count(numgrade) # this is probably the better check
  
  #check against values of crsgradb
  nls_crs %>% filter(crsgradb>4, gradtype==2, !is.na(crsecredv2)) %>% group_by(crsgradb) %>% count(numgrade) # course credit is missing
  
#Create "quality points" variable, which equals credits attempted multiplied by numgrade
  
  nls_crs <- nls_crs %>% mutate(qualpts=numgrade*crsecredv2) 
  
  #nls_crs %>% mutate(qualpts=numgrade*crsecredv2) %>% select(id,transnum,crsecred,crsecredv2,gradtype,crsgradb,crsgrada,numgrade,qualpts)
  
  #checks
  
#Create measure of credits attempted that is missing if numgrade is missing
  nls_crs <- nls_crs %>% 
    mutate(
      crsecredv3=ifelse(is.na(numgrade),NA,crsecredv2)
    ) 
  #%>% select(numgrade,crsecredv2,crsecredv3)
  
#Create institution-level GPA variable  

    nls_crs_trans <- nls_crs %>% group_by(id,transnum) %>% 
      summarise(
        cred_trans=sum(crsecredv3, na.rm=TRUE), # sum total credits attempted where grade is known
        qualpts_trans=sum(qualpts, na.rm=TRUE) # sum total credits attempted where grade is known
      ) %>% 
      mutate(gpa_trans=qualpts_trans/cred_trans) 
    
    nls_crs_trans
    #options(tibble.print_min=400)
    
  #Create institution-level GPA w/out collapsing
    nls_crs %>% group_by(id,transnum) %>% 
      mutate(
        cred_trans=sum(crsecredv3, na.rm=TRUE), # sum total credits attempted where grade is known
        qualpts_trans=sum(qualpts, na.rm=TRUE), # sum total credits attempted where grade is known
        gpa_trans=qualpts_trans/cred_trans
    ) %>% select(id,transnum,crsecredv3,cred_trans,numgrade,qualpts,qualpts_trans,gpa_trans)

#Create term-level GPA variable
    nls_crs_term <- nls_crs %>% group_by(id,transnum,termnum) %>% 
      summarise(
        cred_term=sum(crsecredv3, na.rm=TRUE), # sum total credits attempted where grade is known
        qualpts_term=sum(qualpts, na.rm=TRUE) # sum total credits attempted where grade is known
      ) %>% 
      mutate(gpa_term=qualpts_term/cred_term) 
    
    nls_crs_term
    
    #Create term-level GPA w/out collapsing
    nls_crs %>% group_by(id,transnum,termnum) %>% 
      mutate(
        cred_term=sum(crsecredv3, na.rm=TRUE), # sum total credits attempted where grade is known
        qualpts_term=sum(qualpts, na.rm=TRUE), # sum total credits attempted where grade is known
        gpa_term=qualpts_term/cred_term
      ) %>% select(id,transnum,termnum,crsecredv3,cred_term,numgrade,qualpts,qualpts_term,gpa_term)
    
    