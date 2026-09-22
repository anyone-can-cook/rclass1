## Problemset Title ----
## [ PROJ ] < Problem set 4 >
## [ FILE ] < lastname_firstname_problemset4.R >
## [ AUTH ] < Your name / GitHub handle >
## [ INIT ] < Date you started the file >

## Overview ----
  # 21 points

  # In last week's problemset, you used `dplyr` functions such as `filter()`, 
  # `arrange()`, and `select()` and the pipe operator `%>%` to perform data manipulations. In this 
  # problemset, you'll also practice creating variables using `mutate()` in combination with 
  # `if_else()`, `case_when()`, and `recode()`.

## Question 1: Data manipulation using pipes ----
  # Q1.1 ----
  # 1 point
  # Load the `tidyverse` library. 
  # Use the `load()` and `url()` functions to download the `df_school_all` dataframe from:
  # https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/
  # recruit_school_allvars.RData
  # Each row in `df_school_all` represents a high school (includes both public and private)
  # There are columns (e.g., `visit_by_100751`) indicating the number of times a university 
  # visited that high school
  # The variable `total_visits` identifies the number of visits the high school received from 
  # all (16) public research universities in this data collection sample
rm(list=ls())



  # Q1.2 ----
  # 1 point
  # Use the functions `arrange()`, `select()`, and `head()` to do the following:
  # 1. Sort `df_school_all` descending by `med_inc`
  # 2. Select these variables: 
  # `name`, `state_code`, `city`, `school_type`, `total_visits`, `pct_white`, `pct_black`, `med_inc`, `pct_hispanic`, `pct_asian`, `pct_amerindian`
  # 3. Show the first 10 rows of the dataframe, which represents the schools that have students 
  # with the top 10 median income
  # Complete the tasks using 1 line of code by using pipes `%>%`
  # Assign this to a new object named `q1_2`

q1_2 <- 

  # Building upon the previous question, use the functions `arrange()`, `select()`, `filter()`, 
  # and `head()` to do the following (select same variables as above):

  # Q1.3 ----
  # 1 point
  # Obtain observations on _public_ high schools in New York with the top 10 median income. Select the same variables as before.
  # Assign this data to a new object named `q1_3`

q1_3 <- 

  # Q1.4 ----
  # 1 point
  # Now obtain the top 10 observations of _private_ high schools in New York 
  # according to highest median income. Select the same variables as before.
  # Assign this data to a new object named `q1_4`

q1_4 <- 

## Question 2: Variable creation using `tidyverse`'s `mutate()` ----
  # Often before creating new "analysis" variables, you may want to investigate the values of 
  # "input" variables. Here are some examples of checking variable values using `count()`:

df_school_all %>% count()
df_school_all %>% filter(is.na(med_inc)) %>% count()
df_school_all %>% count(school_type)

### The following questions will ask you to use `mutate()` with `if_else()` 
  # to create a 0/1 indicator and then use `count()` to generate frequency tables.

  # Q2.1 ----
  # 1 point
  # Create a 0/1 indicator called `ca_school` for whether the high school is in California. 
  # Assign this code to a new object named `q2_1`.

q2_1 <- 
 
  # Q2.2 ----
  # 1 point
  # Generate a frequency table with `count()` for the `ca_school` variable you just created.
  # Assign this code to a new object named `q2_2`

q2_2 <- 

  # Q2.3 ----
  # 1 point
  # Create a 0/1 indicator called `ca_pub_school` for whether the high school is 
  # a public school in California. 
  # Assign this to a new object named `q2_3`.

q2_3 <- 

  # Q2.4 ----
  # 1 point
  # Generate a frequency table with `count()` for the `ca_school` variable you just created.
  # Assign this to a new object named `q2_4`

q2_4 <- 

## Question 3 ----
  # Complete the following steps to create an analysis variable using `mutate()` and `if_else()`:
  # Q3.1 ----
  # 1 point
  # First, use `select()` to select `name`, `pct_black`, `pct_hispanic`, `pct_amerindian` from 
  # `df_school_all`, and assign to a new object named `df_race`.

df_race <- 

  # Q3.2 ----
  # 3 point
  # Use `filter()`, `is.na()`, and `count()` to investigate whether or not `pct_black`, 
  # `pct_hispanic`, `pct_amerindian` have missing values.
  # Assign each of these investigations to objects named `q3_2_a`, `q3_2_b`, and `q3_2_c`, respectively.

q3_2_a <- 
q3_2_b <- 
q3_2_c <- 

  # Q3.3 ----
  # 1 point
  # How many of the three race and ethnicity variables from Q2.5 had missing values?
  # Assign your answer to an object named `q3_3` as a numeric value.

q3_3 <- 

  # Q3.4 ----
  # 1 point
  # Use `mutate()` to create a new variable `pct_bl_hisp_nat` in `df_race` that is the sum of 
  # `pct_black`, `pct_hispanic`, and `pct_amerindian`.
  # Reminder: You are creating the new variable inside the `df_race` dataframe, not a new object.

df_race <- 

  # Q3.5 ----
  # 1 point
  # Use `mutate()` to create a 0/1 indicator called `gt50pct_bl_hisp_nat` for whether >50% of 
  # students identify as black, latinx, or native american 
  # Reminder: You are creating the new variable inside the `df_race` dataframe, not a new object.

df_race <- 

  # Q3.6 ----
  # 1 point
  # Create frequency table using `count()` for the new analysis variable `gt50pct_bl_hisp_nat`.
  # Assign this table to a new object named `q2_9`.

q3_6 <- 

  # Q3.7 ----
  # 1 point
  # Based on your analyses, what percent of schools in the `df_school_all` data 
  # had an enrollment of native, hispanic, and black students over 50%?
  # Assign your answer to an object named `q3_6` as a numeric value. 
  # Please do not use any decimals or a percentage sign, just a rounded number from 0 to 100.

q3_7 <- 

## Q4 ----
  # Complete the following steps to create an analysis variable using `mutate()` and `case_when()`:

  # Q4.1 ----
  # 1 point
  # First, use `select()` to select `name` and `state_code` from `df_school_all`. 
  # Assign to a new dataframe named `df_schools`.

df_schools <- 

  # Q4.2 ----
  # 2 points
  # Use `case_when()` to create a new variable in `df_schools` called `region`, with values:
  # 'Northeast' if state_code in c('CT','ME','MA','NH','RI','VT','NJ','NY','PA')
  # 'Midwest'   if state_code in c('IN','IL','MI','OH','WI','IA','KS','MN','MO',
  #                              'NE','ND','SD')
  # 'West'      if state_code in c('AZ','CO','ID','NM','MT','UT','NV','WY','AK',
  #                              'CA','HI','OR','WA')
  # 'South'     if state_code is not any of the above states (use TRUE for default)
  # Remember to assign the new variable creation back into the `df_schools` data frame

df_schools <- 

  # Check your work. Assign a contingency table of the the new `region` variable 
  # using the `count()` function. Assign this contingency table of df_schools$region to 
  # an object named `q4_2`.

q4_2 <- 

## Complete the following steps to recode variables using `mutate()` and `recode()`:

  # Q4.3 ----
  # 2 points
  # In the `df_schools` dataframe, replace the values of the `region` variable:
  # Northeast -> NE
  # Midwest   -> MW
  # West      -> W
  # South     -> S
  # Remember to use assignment on `df_schools` to affect changes to the `region` variable.

df_schools <- 

  # Check your work by using the `count()` function on the updated `region` variable 
  # Assign this contingency table to an object named `q4_3`

q4_3 <- 

  # Q4.4 ----
  # 2 points
  # In the `df_schools` dataframe, create a new variable `state_name` whose value is:
  # 'California' if state_code is 'CA'
  # 'New York'   if state_code is 'NY'
  # (Another state of your choice)
  # 'Other' for any other state (use `.default`)
  # Remember to use assignment when you recode the `state_code` variable.

df_schools <- 


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
  # Use this naming convention "lastname_firstname_ps#" for your R script (e.g. jaquette_ozan_problemset4.R).
