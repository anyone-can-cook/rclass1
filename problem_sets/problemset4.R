## Problemset Title ----
## [ PROJ ] < Problem set 4 >
## [ FILE ] < lastname_firstname_problemset4.R >
## [ AUTH ] < Your name / GitHub handle >
## [ INIT ] < Date you started the file >

rm(list=ls()) # clears environment so script runs from a clean slate

## Overview ----
  # 26 points

  # In last week's problemset, you used `dplyr` functions such as `filter()`, 
  # `arrange()`, and `select()` and the pipe operator `%>%` to perform data manipulations. In this 
  # problemset, you'll practice creating variables using `mutate()` in combination with 
  # `if_else()`, `case_when()`, and `recode()`.

## Question 1: Data manipulation using pipes ----
  # Q1.1 ----
  # 1 point
  # First, load the `tidyverse` library. 
  # Second, use the `load()` and `url()` functions to download the `df_school_all` dataframe from this URL:
  # https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_school_allvars.RData



  # Notes on data: Each row in `df_school_all` represents a high school (includes both public and private)
  # There are columns (e.g., `visits_by_100751`) indicating the number of times a university visited that high school
  # The variable `total_visits` identifies the number of visits the high school received from 
  # all (16) public research universities in this data collection sample

  # Q1.2 ----
  # 1 point
  # Use the functions `arrange()`, `select()`, and `head()` to do the following:
  # !!!! Complete the tasks using 1 line of code by using pipes `%>%` !!!!
  # 1. Sort `df_school_all` descending by `med_inc`
  # 2. Select these variables, in this order: 
      # `name`, `state_code`, `city`, `school_type`, `total_visits`, `med_inc`, `pct_white`, 
      # `pct_black`, `pct_hispanic`, `pct_asian`, `pct_amerindian`
  # 3. Show the first 10 rows of the dataframe, which represents the schools that have students with the top 10 median income
  # 4. Assign this to a new object named `q1_2`

q1_2 <- 

  # Q1.3 ----
  # 1 point
  # Building upon the previous question, use the functions `arrange()`, `select()`, `filter()`, 
  # and `head()` to obtain observations on public high schools in New York with the top 10 
  # median income. Select the same variables, in the same order, as in Q1.2.
  # Assign this data to a new object named `q1_3`
  # HINT: Before filtering, check how the values are spelled, e.g.
  #   df_school_all %>% count(school_type)
  # HINT: `filter()` must come before `head()`. Otherwise you are filtering the national top 10.

q1_3 <- 

  # Q1.4 ----
  # 1 point
  # Now obtain the top 10 observations of private high schools in New York 
  # according to highest median income. Select the same variables, in the same order, as in Q1.2.
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
  # HINT: the general pattern is
  #   df %>% mutate(new_var = if_else(condition, 1, 0))
  # where `condition` is something that is TRUE or FALSE for each row (e.g., state_code == "XX").
  # Use 1 and 0 (not TRUE/FALSE) for your indicator values.

  # Q2.1 ----
  # 1 point
  # Create a 0/1 indicator called `ca_school` for whether the high school is in California. 
  # Start from `df_school_all` and assign the full dataframe (all original columns plus your new 
  # `ca_school` column) to a new object named `q2_1`.

q2_1 <- 
 
  # Q2.2 ----
  # 1 point
  # Generate a frequency table with `count()` for the `ca_school` variable you just created.
  # Assign this frequency table to a new object named `q2_2`

q2_2 <- 

  # Q2.3 ----
  # 1 point
  # Create a 0/1 indicator called `ca_pub_school` for whether the high school is 
  # a public school in California. 
  # Assign the full dataframe with your new column to a new object named `q2_3`.
  # HINT: both conditions go inside one `if_else()`, joined with `&`.

q2_3 <- 

  # Q2.4 ----
  # 1 point
  # Generate a frequency table with `count()` for the `ca_pub_school` variable you just created.
  # Assign this frequency table to a new object named `q2_4`

q2_4 <- 

## Question 3 ----
  # Complete the following steps to create an analysis variable using `mutate()` and `if_else()`:
  # Q3.1 ----
  # 1 point
  # First, use `select()` to select `name`, `pct_black`, `pct_hispanic`, `pct_amerindian` from 
  # `df_school_all`, and assign to a new object named `df_race`.

df_race <- 

  # Q3.2 ----
  # 3 points
  # Starting from `df_race`, use `filter()`, `is.na()`, and `count()` to investigate whether or not 
  # `pct_black`, `pct_hispanic`, `pct_amerindian` have missing values.
  # Assign each of these investigations to objects named `q3_2_a`, `q3_2_b`, and `q3_2_c`, respectively.
  # HINT: look at the second example at the start of Question 2 for the pattern.

q3_2_a <- 
q3_2_b <- 
q3_2_c <- 

  # Q3.3 ----
  # 1 point
  # How many of the three race and ethnicity variables from Q3.2 had missing values?
  # Assign your answer to an object named `q3_3` as a numeric value.

q3_3 <- 

  # Q3.4 ----
  # 1 point
  # Use `mutate()` to create a new variable `pct_bl_hisp_nat` in `df_race` that is the sum of 
  # `pct_black`, `pct_hispanic`, and `pct_amerindian`.
  # Reminder: You are creating the new variable inside the `df_race` dataframe, not a new object,
  # so assign your result back to `df_race`.

df_race <- 

  # Q3.5 ----
  # 1 point
  # Use `mutate()` to create a 0/1 indicator called `gt50pct_bl_hisp_nat` for whether more than 50% 
  # of students identify as Black, Latinx, or Native American combined (i.e., `pct_bl_hisp_nat`)
  # Reminder: You are creating the new variable inside the `df_race` dataframe, not a new object.
  # HINT: "more than 50%" means use `>`, not `>=`.

df_race <- 

  # Q3.6 ----
  # 1 point
  # Create frequency table using `count()` for the new analysis variable `gt50pct_bl_hisp_nat`.
  # Assign this table to a new object named `q3_6`.

q3_6 <- 

  # Q3.7 ----
  # 1 point
  # Based on your analyses, what percent of schools in the `df_school_all` data 
  # had a combined enrollment of Black, Latinx, and Native American students over 50%?
  # Assign your answer to an object named `q3_7` as a numeric value. 
  # Please do not use any decimals or a percentage sign, just a rounded number from 0 to 100.
  # HINT: you can type the number directly, or calculate it with code using the counts in `q3_6`
  # and `round()`.

q3_7 <- 

## Question 4 ----
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
  # 'South'     if state_code is not any of the above states (use `.default`)
  # Assign the new variable creation back into the `df_schools` data frame
  

  # We did the above for you :) so just run it.
    # NOTE: DC is not in any of the lists, so it is counted as South. That is expected.

df_schools <- df_schools %>% 
  mutate(region = case_when(
    state_code %in% c('CT','ME','MA','NH','RI','VT','NJ','NY','PA') ~ 'Northeast',
    state_code %in% c('IN','IL','MI','OH','WI','IA','KS','MN','MO','NE','ND','SD') ~ 'Midwest',
    state_code %in% c('AZ','CO','ID','NM','MT','UT','NV','WY','AK','CA','HI','OR','WA') ~ 'West',
    .default = 'South'
  ))

  # YOUR TURN: check the work above. Generate a frequency table of the new `region` variable 
  # using the `count()` function. Assign this frequency table to an object named `q4_2`.

q4_2 <- 

## Complete the following steps to recode variables using `mutate()` and `recode()`:
  # NOTE: If you look at the help page for `recode()`, you will see it is labeled "superseded."
  # That means newer alternatives exist, but `recode()` still works and is fine to use here.

  # Q4.3 ----
  # 2 points
  # In the `df_schools` dataframe, replace the values of the `region` variable:
  # Northeast -> NE
  # Midwest   -> MW
  # West      -> W
  # South     -> S
  # Remember to use assignment on `df_schools` to affect changes to the `region` variable.
  
  # HINT: in `recode()` the syntax is old_value = "new_value", e.g. recode(region, Northeast = "NE", ...)
  # This is the opposite order from `rename()`, which uses new_name = old_name.

df_schools <- 

  # Check your work by using the `count()` function on the updated `region` variable 
  # Assign this frequency table to an object named `q4_3`

q4_3 <- 

  # Q4.4 ----
  # 2 points
  # In the `df_schools` dataframe, create a new variable `state_name` whose value is:
  # 'California' if state_code is 'CA'
  # 'New York'   if state_code is 'NY'
  # One more state of your choice, e.g. 'Texas' if state_code is 'TX'
  #   (pick any state that appears in the data; all 50 states plus DC are included)
  # 'Other' for any other state (use `.default`)

  # You may use either `case_when()` or `recode()`; both accept a `.default` argument.
  # Do not change `state_code` itself. Create `state_name` as a new variable and assign the 
  # result back to `df_schools`.

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
  # HINT: To get a link to your specific comment, click the "..." menu at the top right of your
  # comment and choose "Copy link".

reply <- 

## Submit problem set on Canvas ----
  # Use this naming convention "lastname_firstname_problemset#" for your R script (e.g. jaquette_ozan_problemset4.R).