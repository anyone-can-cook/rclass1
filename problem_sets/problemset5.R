## Problemset Title ----
## [ PROJ ] < Problem Set 5 >
## [ FILE ] < lastname_firstname_problemset5.R >
## [ AUTH ] < Your Name / GitHub handle >
## [ INIT ] < Date you started the file >

## 39 points

## Overview ----
  # In this problem set, we will be working with the student list data that University of Illinois-Chicago
  # purchased from College Board. Specifically, we will use the list from one specific order, where
  # UI-Chicago filtered for all prospects who identified as American Indian or Alaska Native and scored
  # within a specified test score/GPA range. Here https://anyone-can-cook.github.io/rclass1/data/prospect_list/uic_order_487927.pdf
  # is the order summary file containing the detailed search criteria.

  # To this student list data, we have also merged in Census data on zip-code characteristics and NCES data
  # on high school characteristics for each prospect. Thus, some variables in the data are prospect-level
  # variables, while others are measured at the zip-code level or school level. These include characteristics
  # for the zip code the prospect lives in and characteristics for the high school which the prospect
  # attends -- those variables do not vary across prospects within the same zip-code or school.

## Data
  # In this task, we are analyzing the characteristics of prospective students who identified as American
  # Indian or Alaska Native when they took the SAT test. We analyze the ethnicity categories and race
  # categories these students selected, where these students live, and their intended major. With respect to
  # course learning goals, these analyses will help you practice processing across observations. From a
  # substantive perspective, quantitative analyses seldom focus on students who identify as American Indian
  # or Alaska Native, so the UI-Chicago student list purchase offers an opportunity to learn a little more
  # about these students.

  # A note on terms for race and ethnicity categories: This problem set uses categories adopted by the U.S.
  # Census. For example, the problem set uses "American Indian or Alaska Native" rather than the terms
  # "Native American" or "Indigenous" and uses the term "Hispanic" rather than "Latinx."

## Question 1: Loading library and data ----
  # Load the `tidyverse` library.

rm(list=ls())
library(tidyverse)

  # Use `load()` and `url()` to load the `list_native_df` dataframe from
  # https://github.com/anyone-can-cook/rclass1/raw/master/data/prospect_list/list_native_df.RData.

load(url('https://github.com/anyone-can-cook/rclass1/raw/master/data/prospect_list/list_native_df.RData'))

  # Let's investigate the `list_native_df` dataframe. First, use `head()` and `glimpse()` to preview
  # the data.

list_native_df %>% head()
list_native_df %>% glimpse()

  # Q1.1 ----
  # 1 point
  # For each of the following ethnicity variables, use the `count()` function to count its unique values:

  # `stu_cuban`
  # `stu_mexican`
  # `stu_puerto_rican`
  # `stu_other_hispanic`
  # `stu_non_hispanic`
  # `stu_ethnicity_no_response`

  # In an object named `Q1_1` assign a numeric vector with the values for `Y` for each count of the 6 variables above. 
  # Like this: `q1_1 <- c(1,2,3,4,5,6)`
  #   Note: the order of each count in the vector does not matter.

q1_1 <- 

  # Q1.2 ----
  # 1 point
  # For each of the following race variables, use the `count()` function to count its unique values:
  # 1 point

  # `stu_american_indian`
  # `stu_asian`
  # `stu_black`
  # `stu_native_hawaiian`
  # `stu_white`
  # `stu_race_no_response`

  # In an object named `Q1_2` assign a numeric vector with the values for `Y` for each count of the 6 variables above. 
  # Like this: `q1_2 <- c(1,2,3,4,5,6)`
  #   Note: the order of each count in the vector does not matter.

list_native_df %>% count(stu_american_indian)
list_native_df %>% count(stu_asian)
list_native_df %>% count(stu_black)
list_native_df %>% count(stu_native_hawaiian)
list_native_df %>% count(stu_white)
list_native_df %>% count(stu_race_no_response)

q1_2 <- 

# 8 points

## Question 2: Recreating College Board's aggregate race/ethnicity variable ----
  # In the questionnaire that students fill out during the College Board exams, they are allowed to select
  # multiple ethnicity and race categories that they identify as. For example, a student who checks the box
  # for "Cuban" could also check the box for "Non-hispanic." Similarly, a student who checks the box for
  # "American Indian or Alaska Native" could also check the box for "Black." Here https://research.collegeboard.org/about-us/changes-to-race-ethnicity-reporting
  # are more details on how College Board defines their race and ethnicity data.

  # These College Board variables are based off of the U.S. Census variables, as defined here
  # https://www.census.gov/topics/population/race/about.html. The specific Census variables we use in our
  # dataset can be found here https://www.socialexplorer.com/data/ACS2019_5yr/metadata/?ds=ACS19_5yr&table=B03002.

  # College Board also reports the student's aggregate race/ethnicity per U.S. Department of Education
  # reporting guidelines, as defined here https://anyone-can-cook.github.io/rclass1/data/prospect_list/cb_race_ethnicity_fields.pdf
  # (see last page). This derived category allocates each student into 1 category. Below, we will recreate
  # this College Board variable (`race_cb`).

  # To do that, we will first create 0/1 indicators for each disaggregated race and ethnicity variable. For
  # example, we will create the 0/1 indicator variable `stu_hispanic_01`, whose value will be `1` if the
  # student identifies as hispanic and `0` otherwise. Then, these 0/1 indicators, along with a couple other
  # variables we create, will be used as input to recreate the `race_cb` variable.

  # Run the following code to create the new race/ethnicity categories. All code is provided for you.
  #   WARNING: Running this big chunk of code a second time will give you an `error in mutate()` warning.
  #   This is because the code creates new variables and deletes the source variables, so it cannot run a second time. 
  #   You can either leave it alone and ignore it, or re-load the original data to re-run it.

list_native_df <- list_native_df %>% mutate(
  stu_hispanic_01 = case_when(
    (stu_cuban == 'Y' | stu_mexican == 'Y' | stu_puerto_rican == 'Y' | stu_other_hispanic == 'Y') ~ 1,
    (stu_non_hispanic == 'Y' & is.na(stu_cuban) & is.na(stu_mexican) &
       is.na(stu_puerto_rican) & is.na(stu_other_hispanic)) ~ 0
  ),
  stu_cuban_01 = case_when(
    stu_cuban == 'Y' ~ 1,
    is.na(stu_cuban) & is.na(stu_ethnicity_no_response) ~ 0
  ),
  stu_mexican_01 = case_when(
    stu_mexican == 'Y' ~ 1,
    is.na(stu_mexican) & is.na(stu_ethnicity_no_response) ~ 0
  ),
  stu_puerto_rican_01 = case_when(
    stu_puerto_rican == 'Y' ~ 1,
    is.na(stu_puerto_rican) & is.na(stu_ethnicity_no_response) ~ 0
  ),
  stu_other_hispanic_01 = case_when(
    stu_other_hispanic == 'Y' ~ 1,
    is.na(stu_other_hispanic) & is.na(stu_ethnicity_no_response) ~ 0
  ),
  stu_american_indian_01 = case_when(
    stu_american_indian == 'Y' ~ 1,
    is.na(stu_american_indian) & is.na(stu_race_no_response) ~ 0
  ),
  stu_asian_01 = case_when(
    stu_asian == 'Y' ~ 1,
    is.na(stu_asian) & is.na(stu_race_no_response) ~ 0
  ),
  stu_black_01 = case_when(
    stu_black == 'Y' ~ 1,
    is.na(stu_black) & is.na(stu_race_no_response) ~ 0
  ),
  stu_native_hawaiian_01 = case_when(
    stu_native_hawaiian == 'Y' ~ 1,
    is.na(stu_native_hawaiian) & is.na(stu_race_no_response) ~ 0
  ),
  stu_white_01 = case_when(
    stu_white == 'Y' ~ 1,
    is.na(stu_white) & is.na(stu_race_no_response) ~ 0
  ),
  race_ct = rowSums(dplyr::across(c(stu_american_indian_01, stu_asian_01, stu_black_01,
                                    stu_native_hawaiian_01, stu_white_01)), na.rm = TRUE),
  multi_race_01 = if_else(race_ct >= 2, 1, 0, missing = NULL),
  race_cb = case_when(
    is.na(stu_hispanic_01) == 1 | (stu_hispanic_01 == 0 & stu_race_no_response == 'Y') ~ 'no_response',
    (stu_american_indian_01 == 1 & multi_race_01 == 0 & stu_hispanic_01 == 0) ~ 'ai_an',
    (stu_asian_01 == 1 & multi_race_01 == 0 & stu_hispanic_01 == 0) ~ 'asian',
    (stu_black_01 == 1 & multi_race_01 == 0 & stu_hispanic_01 == 0) ~ 'black',
    (stu_hispanic_01 == 1) ~ 'hispanic',
    (stu_native_hawaiian_01 == 1 & multi_race_01 == 0 & stu_hispanic_01 == 0) ~ 'nh_pi',
    (stu_white_01 == 1 & multi_race_01 == 0 & stu_hispanic_01 == 0) ~ 'white',
    (multi_race_01 == 1 & stu_hispanic_01 == 0) ~ 'multi_race'
  )
) %>%
  select(-stu_cuban, -stu_mexican, -stu_puerto_rican, -stu_other_hispanic, -stu_non_hispanic,
         -stu_american_indian, -stu_asian, -stu_black, -stu_native_hawaiian, -stu_white,
         -stu_ethnicity_no_response, -stu_race_no_response)

  # After adding the new variables, let's investigate the `list_native_df` dataframe again. Use `head()`
  # and `glimpse()` to preview the data.

list_native_df %>% head()
list_native_df %>% glimpse()

  # Q2.1 ----
  # 1 point
  # Now, let's take a look at the derived aggregate race/ethnicity variable `race_cb` we created. Create
  # a new object `race_cb_freq` that stores the count for each race/ethnicity category as follows:

  # Use `count()` to get the count for each `race_cb` category
  # Use `arrange()` to sort by the count in descending order

race_cb_freq <- 

  # Investigate the `race_cb_freq` object you created in the previous question by using the `typeof()`
  # and `str()` functions. Run your code below and answer the following questions:

typeof(race_cb_freq)
str(race_cb_freq)

  # Q2.2 ----
  # 1 point
  # What type of object is this, and how many elements does it have?
  # Assign your answers to an object named `q2_2` and give it a one word character answer in quotes to the first element, 
  # and a single numeric value to the second element. Like so: `q2_2 <- c("answer", 123)`

q2_2 <- 

  # Q2.3 ----
  # 1 point
  # Is this object a dataframe? 
  # How many observations does race_cb_freq have? 
  # What are the names of the variables? 
  # Assign your answer to an object named `q2_3` with four character elements like this:
  # `q2_3 <- c("answer", 123, "name1", "name2")`

q2_3 <- 

  # Q2.4 ----
  # 2 points
  # Now, using `race_cb_freq`, add a column for the percentage of students in each `race_cb` category.
  # Use `mutate()` to create a new variable that is the percent of students in each category. 
  # Name this new column `pct`, and remember to assign this new variable back to the `race_cb_freq` object.
  #   (Hint: Calculate the percent by dividing the count (`n`) by the sum of all counts, then multiply by 100)

race_cb_freq <- 

## Question 3: Summarizing across rows ----

  # Q3.1 ----
  # 3 points
  # Now, let's investigate the 0/1 indicator variables we created earlier for each race/ethnicity
  # variable. First, we'll take a look at `stu_hispanic_01`. 
  # Use `summarise()` on `list_native_df` to create three summary variables: 
  #   (Hint: Refer to the lecture to figure out which helper functions to use):

  # The total number of students (name this `n_obs`)
  # The total number of students where `stu_hispanic_01` is missing (name this `n_miss_hispanic`)
  # The percentage of students who identify as hispanic (name this `pct_hispanic`)
  # Assign the new summary table to an object named `q3_1`. 

q3_1 <- 

  # Q3.2 ----
  # 2 points
  # Next, use `summarise()` to calculate the percentage of students who identify as each of the following
  # category of race and ethnicity, and assign the result to an object named `race_ethnicity_pct`:

  # `stu_cuban_01`
  # `stu_mexican_01`
  # `stu_puerto_rican_01`
  # `stu_other_hispanic_01`
  # `stu_hispanic_01`
  # `stu_american_indian_01`
  # `stu_black_01`
  # `stu_native_hawaiian_01`
  # `stu_white_01`

  # Please name each new race and ethnicity percentage variable as `pct_ethnicity`; basically replacing the `stu`  
  # and removing the `_01` from the variable names above. I.e.: The percentage drawn from  
  # `stu_native_hawaiian_01` would be `pct_native_hawaiian`

  # How do these percentages differ from the aggregated `race_cb` variable in which each student can only be
  # in one group?
  # ANSWER:

race_ethnicity_pct <- 

  # Investigate the `race_ethnicity_pct` object you created in the previous question by using the
  # `typeof()` and `str()` functions. Run your code below and answer the following
  # questions:

race_ethnicity_pct %>% typeof()
race_ethnicity_pct %>% str()

  # Q3.3 ----
  # 1 point
  # What type of object is this, and how many elements does it have?
  # Assign your answer to an object named `q3_3` as a character vector with a single word and a single number.
  # Like this: `q3_3 <- c("answer", 12345)`

q3_3 <- 

  # Q3.4 ----
  # 2 points
  # Is this object a dataframe? If so, how many observations does it have, and what are the names of the
  # variables?
  # Assign your answer to an object named `q3_4` as a character vector with one word/number per item.
  # Like this: `q3_4 <- c("answer", 12345, "name1", "name2", ... )`

q3_4 <- 

## Question 4: Grouping and summarizing ----

  # Q4.1 ----
  # 3 points
  # Now using the `list_native_df`, use `group_by()` in conjunction with `summarise()` to
  # calculate summary results for each group. 
  # Assign the new dataframe to an object named `zip_cbsa_group`

  # First, group by core-based statistical area (`zip_cbsatitle`)
  # and calculate the following statistics for each CBSA:
  # The total number of students
  # The percentage of students who identify as each of the following race/ethnicity category:
  #   `stu_cuban_01`
  #   `stu_mexican_01`
  #   `stu_puerto_rican_01`
  #   `stu_other_hispanic_01`
  #   `stu_hispanic_01`
  #   `stu_american_indian_01`
  #   `stu_black_01`
  #   `stu_native_hawaiian_01`
  #   `stu_white_01`
  #   Remember to name your percentage variables as `pct_ethnicity`, the same as Q3.2.

  # Lastly, in the same line of code, sort by the number of students per CBSA in descending order. 
  # Note that a core-based statistical area by definition only includes urban areas. Observations where
  # `zip_cbsatitle` is `NA` indicates that the student does not live in a CBSA (i.e., rural location).

zip_cbsa_group <- 

  # Q4.2 ----
  # 3 points
  # Next, we will look at the students' zip-code level median household income (`zip_median_household_income`) by state. 
  # Assign the new dataframe to an object named `stu_state_group`.
  # Group by state (`stu_state`) and calculate the following statistics for each state:
  #   Note: We provide the name you need to give each new summary statistic in the list below

  # The total number of students (`n_student`)
  # The total number of students where `zip_median_household_income` is missing (`n_miss_inc`)
  # The average median household income of students (`ave_inc`)
  # The maximum median household income of students (`max_inc`)
  # The minimum median household income of students (`min_inc`)

  # Lastly, sort by the number of students per state in descending order. Ignore any warnings from R; 
  # the `stu_state_group` object should have been created in your environment despite the warnings.

stu_state_group <- 

  # Q4.3 ----
  # 1 point
  # In the next few questions, we'll take a look at the students' intended major choice. First, group by
  # major choice (`stu_major_1_group_text`) and summarize the number of students per major (`n_obs`). 
  # Sort by the number of students in descending order and assign the result to an object named `major_group_freq`.

major_group_freq <- 

  # Q4.4 ----
  # 1 point
  # Use `major_group_freq` to create a variable for the percentage of students in each
  # `stu_major_1_group_text` category. Name the new percentage variable `pct`
  # Assign this new dataframe to an object named `q4_4`.
  #   Hint: use the variable you created in the previous question for the
  #   number of students per major.

q4_4 <- 

  # Q4.5 ---- 
  # 1 point
  # Now, create the same table as the previous question that shows the count and percentage of students
  # for each major choice, but instead of using `group_by()` and `summarise()`, use `count()` to get the
  # counts from the original `list_native_df` dataframe. Make sure to sort by descending student count.
  # Assign the new table to an object named `q4_5`, and be sure to name your percentage variable `pct` 
  #   Hint: See Lecture Section 3.4 for usage of `count()`; the number of observations will automatically be named `n`.

q4_5 <- 

  # Q4.6 ----
  # 1 point
  # We can also group by multiple variables. In this question, using the `list_native_df` dataframe,
  # group by both state (`stu_state`) and the student's intended major (`stu_major_1_group_text`), then
  # summarize to get the number of students per state and major (name this `n_obs`). 
  # Sort ascending by state, then the number of students in descending order. 
  # Assign the result to an object named `major_by_state_freq`.

major_by_state_freq <- 

  # Looking at the `major_by_state_freq` dataframe from the previous question, answer the following
  # questions:

  # Q4.7 ----
  # 1 point
  # How many observations are there? Assign the numeric value to an object named `q4_7`

q4_7 <- 

  # Q4.8 ----
  # 1 point
  # What two variables does each row/observation represent?
  # Assign two single, unique, words as your answers (each one in quotation marks!) to an object named `q4_8`.
  # Like this: `q4_8 <- c("anwer1","answer2")`

q4_8 <- 

  # Q4.9 ----
  # 1 point
  # If we were to group/summarize only by state, how many observations would the resulting object have?
  # Assign the numeric value to an object named `q4_9`
  #   Hint: You will do this in the next question, so draw your answer from that object.

q4_9 <- 

  # Q4.10 ----
  # 1 point
  # Finally, we will look at the top 3 intended major choices by students from each state. Assign a 
  # new object named `top_3_majors` using `major_by_state_freq`. 
  # Group by state and create the following variables (we tell you what to name them):
    
  # The top choice major by students per state (`top_major`)
  # The second choice major by students per state (`second_major`)
  # The third choice major by students per state (`third_major`)

top_3_majors <- 

## Question 5: Bonus (1 point extra credit) ----
  # Perform an analysis of your choosing. Feel free to be creative!



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

## Submit problem set on Canvas ----.
  # Use this naming convention "lastname_firstname_ps#" for your R script (e.g. jaquette_ozan_problemset5.R).
