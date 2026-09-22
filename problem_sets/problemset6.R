## Problemset Title ----
## [ PROJ ] < Problem Set 6 >
## [ FILE ] < lastname_firstname_problemset6.R >
## [ AUTH ] < Your name / GitHub handle >
## [ INIT ] < Date you started the file >

## Overview ----

  # In this problem set, we use data from the National Longitudinal Study of 1972 (NLS72) dataset -- a
  # nationally representative, longitudinal study of 12th graders in 1972. This dataset includes the
  # Postsecondary Education Transcript File of the NLS72, which contains information on transcripts from
  # NLS72 senior cohort members who reported attending a postsecondary institution after high school.

  # For this problem set, we will be creating the following GPA variables:

  # 1. An institution-level (i.e., transcript-level) GPA variable
  # 2. A term-level GPA variable

## General Instructions ----
  # Don't make changes to "input" variables; instead, create a new variable
  # You are responsible for deciding what data investigations to conduct (e.g., conditional statements,
  # frequency counts, etc.)

  # Whenever you create a new variable, run checks to make sure the variable was created correctly (e.g.,
  # counts, cross-tabulations, assertions)

  # As you work towards creating the GPA variable(s) you may make new "input" variables; drop these variables
  # when you no longer need them

  # This data set is messy. We want you to get experience manipulating unwieldy data into the shapes
  # and structures that will let you perform the analyses that you are interested in doing. At the same time, 
  # we tried to scaffold the steps and concepts while keeping the process as true to a real project as possible.

  # Lastly, we encourage you to leave comments in the code to help you organize your thoughts.

## Question 1: Data investigation ----

  # Load the tidyverse haven, and labelled packages
  # Load any other packages you want to use

library(tidyverse)
library(haven)
library(labelled)

  # Load the NLS72 data
  # Use read_dta() to read in the stata dataset using the url:
  # https://github.com/anyone-can-cook/rclass1/raw/master/data/nls72/nls72petscrs_v2.dta
  # Make sure to assign it to a new object `nls_crs`

rm(list=ls())
nls_crs <- read_dta(file="https://github.com/anyone-can-cook/rclass1/raw/master/data/nls72/nls72petscrs_v2.dta")


  # Below you will be asked a number of questions regarding the shapes and frequencies of variables
  # in the `nls_crs` data set. Become familiar with the data variable by variable; the questions below 
  # are intended to make you more familiar with how the variables relate, and for you to get more exercise 
  # subsetting and making data tables.

  # 1.1 ----
  # 1 point each

  # Investigate (e.g., typeof(), class(), and str()) the following course-level variables in the nls_crs
  # dataframe:
  #   `crsgrada`
  #   `crsgradb`
  #   `gradtype`
  #   `crsecred`
  # Answer the following questions in a character vector named `q1_1` in order.
  # What type of variable is `crsgrada`?
  # Does `crsgrada` contain letter or number grades?
  # What does the value "3" represent in the `gradtype` variable?

typeof(nls_crs$crsgrada)
class(nls_crs$crsgrada)
str(nls_crs$crsgrada)

typeof(nls_crs$crsgradb)
class(nls_crs$crsgradb)
str(nls_crs$crsgradb)

typeof(nls_crs$gradtype)
class(nls_crs$gradtype)
str(nls_crs$gradtype)

typeof(nls_crs$crsecred)
class(nls_crs$crsecred)
str(nls_crs$crsecred)

q1_1 <- 

  # 1.2 ----
  # Make a frequency table of `gradtype` using count(). How many values are missing?
  # How many are letter grades? And how many are numeric grades?
  # Assign your three answers in the order asked to a numeric vector named `q1_2`

nls_crs %>% count(gradtype)
q1_2 <- 

  # 1.3 ----
  # How many institution types are in the `itype` variable? Careful counting! 
  # Assign this number to an object named `q1_3`

nls_crs %>% select(itype) %>% val_labels()
q1_3 <- 

  # 1.4 ----
  # Answer these questions about `crsecred` in a numeric vector named `q1_4`, assign your answers in the order asked. 
  # How many courses offered exactly ZERO credits?
  # What was the highest number of credits given by any class (ignoring values of 999 or greater)
  # What was the most common/frequent value of credits?
  # How many credits are missing values?
  #   Note: A quirk in the data has missing values "999", while others are "999.999". 
  #   In your answer you should consider both of these values as missing.

nls_crs %>% filter(crsecred>900) %>% nrow()
nls_crs %>% count(crsecred) %>% arrange(desc(crsecred))
nls_crs %>% count(crsecred) %>% arrange(desc(n))

q1_4 <- 

  # 1.5 ----
  # Now investigate the `crsgradb` variable.
  # How many courses had missing grade values? 
  # Assign this number to an object named `q1_5`
  #   Note: A quirk in the data has missing values "999", while others are "999.999". 
  #   In your answer you should consider both of these values as missing.

nls_crs %>% filter(crsgradb>900) %>% nrow()
nls_crs %>% count(crsgradb) %>% arrange(desc(crsgradb))
q1_5 <- 

  # 1.6 ----
  # Make a frequency table of `crsgrada`. How many letter grades had missing (99) values? 
  # Assign this number to an object named `q1_6`

nls_crs %>% count(crsgrada)
q1_6 <- 

  # 1.7 ----
  # Filter for any values of `crsgradb` greater than 900 (i.e.: missing), then make a frequency table 
  # of counts for values of `crsgrada`. This table represents alphanumeric grade counts 
  # whose corresponding numeric values are missing. 
  # How many grades are missing (99) in `crsgrada` that were also missing in `crsgradb`?
  # Assign this number to an object named `q1_7`

nls_crs %>% filter(crsgradb>=900) %>% count(crsgrada) %>% print(n=40)
q1_7 <- 

  # 1.8 ----
  # Filter for any values of `crsgradb` greater than 900,
  # and values of `crsgrada` equal to 99, 
  # and values of `gradtype` that are _not_ missing.
  # Then pipe this to a frequency table where you count both `crsgrada` and `crsgradb` together.
  # How many missing values in `crsgrada` are also missing in `crsgradb`, and also
  # supposedly have a letter or numeric grade type assigned to them?
  # Assign this number to an object named `q1_8`

nls_crs %>% filter(gradtype %in% c(1,2), crsgrada=='99', crsgradb>900) %>% count(crsgrada,crsgradb)
q1_8 <- 


  # Question 2: Creating new grade variables ----

  # Q2.1 ----
  # 1 point

  # Create a new factor variable using the `crsgrada` variable, whose values represent letter course grades.
  # Assign the new variable back into to the `nls_crs` dataframe. Name the new variable `crsgrada_fac`. 

  # Use typeof(), class(), and attributes() to investigate the newly created `crsgrada_fac` variable
  # to confirm it is a factor variable.

nls_crs <- 

#Check the new variable created
typeof(nls_crs$crsgrada_fac)
class(nls_crs$crsgrada_fac)
attributes(nls_crs$crsgrada_fac)

  # Q2.2 ----
  # 2 points

  # Recode the `crsgrada_fac` variable into a new numeric factor variable called `numgrade_1` with 
  # numeric values based on the attribute levels from `crsgrada_fac.` 
  # Recode A+=4, A=4, A-=3.7, B+=3.3, B=3, B-=2.7, C+=2.3, C=2, C-=1.7, D+=1.3, D=1, D-=0.7, F=0, 
  # E=0, WF=0. All other letter grades should have missing values (use `.default=NA_real_.`)
  # Assign this new variable back into the `nls_crs` dataframe. 

nls_crs <- 

  # Q2.2a
  # 1 point
  # Make a frequency table for the new `numgrade_1` variable. How many missing values are left?
  # Assign your answer to an object named `q2_2a`

nls_crs %>% count(numgrade_1)
q2_2a <- 

  # Q2.3a ----
  # Let's take an even closer look at `crsgradb`. Above, we created a numeric grade variable from 
  # letter grades and its maximum value was 4 (an A and an A+). How many observations of `crsgradb` 
  # are greater than 4 (but not 900 or more)? Assign your answer to an object named `q2_3a`.
  #   Hint: You need to look at the number of rows after filtering.

nls_crs %>% filter(crsgradb>4&crsgradb<900) %>% nrow()
q2_3a <- 

  # Q2.3b ----
  # This number seems acceptably low. Create a new version of `crsgradb` called `numgrade_2` 
  # that enters NA for any values greater than 4, and uses the original values from `crsgrab` otherwise.
  # Assign this new variable back into `nls_crs`.

nls_crs <- 

nls_crs %>% count(numgrade_2)%>% arrange(desc(n))

  # Q2.4 ----
  # 1 point
  # `crsecred` is the variable for how many total credits were possible for each course. Its 
  # missing values are 999 and 999.999. Create a new variable `crsecred_2` that replaces these with NA.
  # Assign this new variable back into `nls_crs`. 

nls_crs <- 

nls_crs %>% count(crsecred_2)%>% arrange(desc(crsecred_2))

# Now variables `numgrade_1` and `numgrade_2` do not have any value discrepancies regarding
# missing-ness and non-standard grades. However, to calculate GPA, neither the credits variable 
# nor the grade variable can have missing values on the same row. 

  # Q2.5 ----
  # 2 points
  # Create a new merged `numgrade_3` variable that uses: 
  #   Values from `numgrade_1` when `gradtype==1` (letter) and `crsecred_2` is not missing.
  #   Values from `numgrade_2` when `gradtype==2` (numeric) and `crsecred_2` is not missing.
  # Assign it back to `nls_crs`.

# check how numgrade 1 and 2 look when you switch grade types.
nls_crs %>%
  select(gradtype, numgrade_1, numgrade_2) %>%
  filter(gradtype == 1) %>%
  head(n=20)

nls_crs %>%
  select(gradtype, numgrade_1, numgrade_2) %>%
  filter(gradtype == 2) %>%
  head(n=20)

# create numgrade_3 here
nls_crs <- 

  # Q2.6 ----
  # 1 point
  # Count the number of observations that have missing values in `numgrade_3` and no missing values
  # in `crsecred_2`. Assign that number of rows to an object named `q2_6`.

nls_crs %>% filter(!is.na(crsecred_2),is.na(numgrade_3)) %>% nrow()
q2_6 <- 

  # Q2.7 ----
  # Create `crsecred_3` from values of `crsecred_2`, but set any values to NA if a value for 
  # `numgrade_3` is missing. Remember to assign it to `nls_crs`.

nls_crs <- 

nls_crs %>% count(crsecred_3) %>% arrange(desc(crsecred_3))
nls_crs %>% filter(is.na(numgrade_3)) %>% count(crsecred_3)


  # Q2.8 ----
  # 1 point
  # Use set_variable_labels() to set variable labels for `numgrade_1`, `numgrade_2`, 
  # `numgrade_3`, and `crsecred_3`, so that readers will understand what these 
  # transformed variables represent.

nls_crs <- 

 
  # Q2.9 ----
  # 1 point
  # Sort and select your variables into a new clean dataframe named `nls_crs_v2` 
  # with the following requirements:
  #   Select variables: crsecip, crsename, id, transnum, termnum, crsecred_3, numgrade_3, gradtype, itype.
  #   Sort by ascending id, transnum, termnum, crsename (in that order)

nls_crs_v2 <- 

### Investigations (EXAMPLES PROVIDED FOR YOU):
  # Below are several example checks of the (cleaner) `nls_crs_v2` dataframe.
  # Run these at your own leisure to get a clearer picture of how this data was cleaned and what
  # your new variables look like. We are going to ask you to give us term-level and transcript-level
  # GPA values later on, so we included these as well.

nls_crs_v2 %>% select(transnum) %>% var_label()
nls_crs_v2 %>% count(transnum)

nls_crs_v2 %>%
  group_by(transnum) %>%
  summarise(count_transum = n()) %>%
  ungroup() %>%
  mutate(total_obs = sum(count_transum))

nls_crs_v2 %>% select(termnum) %>% var_label()
nls_crs_v2 %>% count(termnum)

nls_crs_v2 %>% select(crsecred_3) %>% var_label()
nls_crs_v2 %>% count(crsecred_3) %>% arrange(desc(n))
nls_crs_v2 %>%
  summarise(
    min = min(crsecred_3, na.rm=TRUE),
    max = max(crsecred_3, na.rm=TRUE)
  )

nls_crs_v2 %>% group_by(itype) %>%
  filter(crsecred_3>=100) %>%
  count(crsecred_3) 

nls_crs_v2 %>% select(numgrade_3) %>% var_label()
nls_crs_v2 %>% count(numgrade_3) %>% arrange(desc(n))
nls_crs_v2 %>%
  summarise(
    min = min(numgrade_3, na.rm=TRUE),
    max = max(numgrade_3, na.rm=TRUE)
  )

## Question 3: Calculate GPA ----
  # The formula for GPA is to multiply each observation of course credit by numerical grade 
  # (that is quality points). Then then divide the total summed quality points by the total 
  # summed credits available to a given unit of analysis (students, universities, terms ...). 
  # Therefore there are two steps to this with the data we have. First comes calculating quality 
  # points first. Then we have to aggregate the nls data by some unit of analysis and create sums of
  # both credits and quality points. 

  # Q3.1 ----
  # 2 points
  # Create a quality points variable below named `qualpts` and assign it to `nls_crs_v2`.

nls_crs_v2 <- 

# a multitude of checks to ensure data quality
nls_crs_v2 %>% count(qualpts)
nls_crs_v2 %>% select(id, transnum, numgrade_3, crsecred_3, qualpts)
nls_crs_v2 %>% filter(is.na(numgrade_3)) %>% count(qualpts)
nls_crs_v2 %>% group_by(numgrade_3, crsecred_3) %>% count(qualpts)
nls_crs_v2 %>%
  filter(numgrade_3==0 & qualpts!=0) %>%
  select(numgrade_3, crsecred_3, qualpts)
nls_crs_v2 %>%
  filter(crsecred_3==0 & qualpts!=0) %>%
  select(numgrade_3, crsecred_3, qualpts)

  # Q3.2 ----
  # 2 points
  # Create a student-institution-level GPA variable and save it in a new object named `nls_crs_trans`: 
  #   Group by `id` (students) and `transnum` (students' university transcripts). 
  #   Summarise the sum total credits and sum total quality points. 
  #   Name these `cred_trans` and `qualpts_trans`, respectively. 
  #   Then pipe these aggregated data to calculate GPA. Name the variable `gpa_trans`.
  # Note: Do not forget to drop missing values when using sum().

nls_crs_trans <- 

nls_crs_trans %>% filter(is.na(gpa_trans)&cred_trans!=0)
nls_crs_trans %>% arrange(desc(gpa_trans))

  # Q3.2a ----
  # 1 point

  # 2. Investigate gpa_trans to see if it looks reasonable.

nls_crs_trans %>% count(gpa_trans)
nls_crs_trans %>% filter(is.na(gpa_trans))
nls_crs_trans %>% filter(cred_trans==0 & qualpts_trans!=0)
nls_crs_trans %>% filter(cred_trans==0 & !is.na(gpa_trans))
nls_crs_trans %>% filter((qualpts_trans/cred_trans) != gpa_trans)
nls_crs_trans %>% count(gpa_trans) %>% filter(n>1)

  # Q3.3 ----
  # 2 points
  # Create term-level GPA variable and save as a new object named `nls_crs_term`. 
  # Similar to Q3.2, summarize credit and quality points totals across `id`, `transnum`, 
  # and `termnum`. Then calculate a new gpa variable named `gpa_term`.

nls_crs_term <- 

nls_crs_term %>% head()

  # Q3.3a
  # 1 point

  # 4. Investigate gpa_term to see if it looks reasonable.

nls_crs_term %>% count(gpa_term)
nls_crs_term %>% filter(is.na(gpa_term))
nls_crs_term %>% filter(cred_term==0 & qualpts_term!=0)
nls_crs_term %>% filter(cred_term==0 & !is.na(gpa_term))
nls_crs_term %>% filter((qualpts_term/cred_term) != gpa_term)
nls_crs_term %>% count(gpa_term) %>% filter(n>1)

## Create a GitHub issue ----
  # 2 points
  # Go to the class repository https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues and create a new issue.
  # Refer to rclass1 student issues readme https://github.com/anyone-can-cook/rclass1_student_issues_f26/blob/main/README.md 
  # for instructions on how to post questions or reflections.
  # You are also required to respond to at least one issue posted by another student.

  # Create an object named `issue` below and assign it the URL to your new issue, as a character object.  
  # Make sure the URL is in quotes.

issue <- 

  # Create an object named `reply` below and assign it the URL to your response to another issue, as a character object. 
  # Make sure the URL is in quotes.

reply <- 

## Submit problem set on Canvas ----
  # Use this naming convention "lastname_firstname_ps#" for your R script (e.g. jaquette_ozan_problemset6.R).
