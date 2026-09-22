## Problemset Title >
## [ PROJ ] < Problem Set 10 >
## [ FILE ] < lastname_firstname_problemset10.R >
## [ AUTH ] < Your Name / GitHub Handle >
## [ INIT ] < Date You Started the File >

  # 24 points

## Overview ----
  # In this problem set, you will be working with multiple datasets and will practice joining them
  # to conduct meaningful analyses. First, we will conduct preliminary investigations of the
  # dataframes we are working with. Then, we will carry out some data manipulations prior to joining
  # (merging) our dataframes. Next, we will practice joining dataframes and diagnosing problems with
  # our joins (merges). Lastly, we will perform exploratory data analyses to investigate the
  # characteristics (e.g., school, community) associated with receiving or not receiving a visit from
  # the university.
 
  # The datasets you will be working with are:
 
  # `pubhs_events`
  # Contains data on the off-campus recruiting events to public high schools by a sample of public
  # research universities
  # Each observation is a visit by the university to the high school. The variable `num_events`
  # counts the number of visits that the high school received from that university.
 
  # `zip_data`
  # Contains Census data from the American Community Survey
  # https://www.census.gov/programs-surveys/acs/about.html on characteristics of each zip code
  # Each observation is a zip code
 
  # `ccd_data`
  # Contains data on characteristics of U.S. public schools from the Common Core of Data (CCD)
  # https://nces.ed.gov/ccd/aboutccd.asp
  # Each observation is a public school. The variable `ncessch` uniquely identifies each school.

  # Load the `tidyverse` and `labelled` libraries in the code chunk below.

rm(list=ls())
library(tidyverse)
library(labelled)

# Load the 3 dataframes from the URL:
# https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruiting_datasets.RData
# Hint: Use `load()` and `url()`

load(url("https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruiting_datasets.RData"))


## Explore the data ----

  # Conduct some preliminary investigations of the 3 data frames to become acquainted with them.
  # E.g., Use `attributes()` to check the labels of a variable, print some observations, check values
  # and labels for a variable etc. Note: In completing subsequent steps of the problem set, you may find it
  # helpful to conduct additional investigations of the data
  # You can use this space for such explorations. Further down we will ask questions about the shape of
  # the data that you learned from these investigations.

# Investigations for ccd_data
# Location state
ccd_data %>% count(lstate) %>% var_label()
unique(ccd_data$lstate)

# School type
attributes(ccd_data$sch_type)

# Updated status
attributes(ccd_data$updated_status)

# Virtual School Status
ccd_data %>% select(virtual) %>% var_label()
ccd_data %>% count(virtual) %>% as_factor()

# Grade 12 Offered
ccd_data %>% select(g12offered) %>% var_label()
ccd_data %>% count(g12offered) %>% as_factor()

# Grade 12 students
ccd_data %>% select(g12) %>% var_label()
ccd_data %>% count(g12) %>% as_factor()

# Investigations for pubhs_events
names(pubhs_events)

# University name
attributes(pubhs_events$univ_name)
pubhs_events %>% count(univ_name) %>% as_factor()

# High school ID
attributes(pubhs_events$school_id)
pubhs_events %>% count(school_id) %>% as_factor()
nrow(pubhs_events)

# Number of events
attributes(pubhs_events$num_events)
pubhs_events %>% count(num_events) %>% as_factor()

# Investigations for zip_data
names(zip_data)
glimpse(zip_data)

# State
zip_data %>% count(state_code) %>% var_label()
unique(zip_data$state_code)

  # Q1.1 ----
  # 1 point each

  # Q1a
  # Which data sets have a variable for NCESS school id? Assign your answer
  # to a new object named `q1_a`. Make sure to assign the dataset names exaxtly as they appear 
  # in your R environment

q1_a <- 

  # Q1b
  # Which data sets have a ZIP code variable? Assign your answer
  # to a new object named `q1_b`. Make sure to assign the dataset names exactly as they are named 
  # in your R environment

q1_b <- 

  # Q1c
  # For this question we are asking for a numeric vector with 5 elements:
  # How many individual universities are we working with in `pubhs_events`? 
  # How many high schools are in the `pubhs_events` data frame? 
  # How many high schools are in `ccd_data`?
  # How many state codes are in `zip_data`?
  # How many state codes are in `ccd_data`?
  # Assign each of these numbers as a vector to a new object named `q1_c`. 

q1_c <- 

  # Q1d 
  # What high school in `pubhs_events` had the most events? How many events
  # did it have? Please assign the `school_id` number and the number of visits
  # to an object named `q1_d`. Don't worry about the actual school name. 
  #   Hint: group by school id and use summarize to sum the number of events. 

q1_d <- 

  # Q1e 
  # What university in `pubhs_events` attended to the most events? How many events
  # was that? Please assign the `univ_id` number and the number of visits
  # to an object named `q1_e`. Don't worry about the actual university name. 

q1_e <- 

  # Q1.2 ----
  # 3 points
  # Identify the primary key for each data set. In other words, which variable(s) uniquely identify
  # the observations in each data set? Refer back to problem set 9, Q2.2, Q2.3, and Q2.7, and the
  # Tidy Data lecture, section 2.3, for how we might expect you to check for unique identifiers.
  #   Hint: One of the data sets' key is a combination of two variables.

  # Assign the variable names for each primary key in the list object we created for you below:

# populate this list object with key variables
q1_2 <- list(
  ccd_dta_key = c(""),
  pubhs_events_key = c(""),
  zip_data_key = c("")
)

## Question 2: Define universe of public high schools ----

  # Q2.1 ----
  # 4 points
  # Create a new object based on `ccd_data` called `ccd_hs` that only contains observations for high
  # schools that meet all of the following (admittedly arbitrary) criteria:
 
  # - Located in the 50 U.S. states or District of Columbia (`lstate`) [Hint: `lstate` values that are 
  #   not a U.S. territory: "AS", "AE", "AP", "PR", "GU", "VI"]
  # - Is a regular school or vocational school (`sch_type`) [Hint: use the attributes function to
  #   check the value labels]
  # - Updated status is open, new, or reopened (`updated_status`)
  # - Is not a virtual school (`virtual`)
  # - Grade 12 is offered (`g12offered`)
  # - Enrolls at least 10 students in the 12th grade (`g12`)

ccd_hs <- 

  # Q2.2 ----
  # 2 points
  # Now join the `ccd_hs` dataframe with `zip_data` so that each public high school (ie. row) in
  # `ccd_hs` is matched with its corresponding zip code level data. 
  # Think about what kind of join you want to perform. Remember that we want to keep all of the
  # public high schools in `ccd_hs` and add zip code level data from `zip_data` if available. 
  # Assign the resulting data to a new object named `ccd_hs_zip`.
  #   Hint: remember to use the argument `by = c("left_var", "right_var")` to match key variables 
  #   across sets when their names don't match.

ccd_hs_zip <- 

  # Q2.3 ----
  # 1 point
  # Perform an anti join to investigate which high schools did not match with any zip code data.
  # Assign the resulting data to an object named `anti_ccd_hs_zip`. Take a look at the `lzip` 
  # variable in `anti_ccd_hs_zip`. What do you notice about the zip codes that were not matched?

anti_ccd_hs_zip <- 

  # Q2.4 ----
  # 1 point
  # Based on your observations in the previous step, fix the `lzip` variable in the `ccd_hs` data frame.
  # Make sure to assign your fix back into `ccd_hs`.
  #   Hint: You can use `str_pad()` to help add back missing characters.

ccd_hs <- 

  # Q2.5 ----
  # 2 point
  # Copy your `left_join` and `anti_join` code from Q2.2 and Q2.3 into the space below
  # but assign the code to objects named `ccd_hs_zip_2` and `anti_ccd_hs_zip_2`, respectively.
  # Run them again. You should notice that `anti_ccd_hs_zip_2` will have much fewer mismatches.
  # `ccd_hs_zip_2` on the other hand, will have the same number of rows, but if you look closely there will 
  # be more zip code data assigned to more schools per row.

ccd_hs_zip_2 <- 

anti_ccd_hs_zip_2 <- 

## Question 3: Create analysis dataset for one university ----

  # Q3.1 ----
  # 1 point
  # Looking at `pubhs_events`, choose 1 university that you want to conduct analysis on. 
  # Please assign your chosen university's `univ_id` value to an object named `q3_1_uni`, 
  # like this: `q3_1_uni <- 000000`. We need this info to help grade your answers.

q3_1_uni <- 

  # Now filter `pubhs_events` for only events by the university you chose and save the resulting 
  # dataframe in an object called `events_uni`

events_uni <- 

  # Q3.2 ----
  # 1 point
  # Your `events_uni` data frame should contain one row for each public high school that your
  # university of choice visited. Confirm that `school_id` alone can now uniquely identify all
  # observations in `events_uni` similar to how you checked in Q1.2. 
  # Note: No need to assign an answer, graders can corroborate 1 obs per group with `event_uni`.

# school_id is primary key for events_uni
events_uni %>%
  group_by(school_id) %>%
  summarise(n_per_group = n()) %>%
  ungroup() %>%
  count(n_per_group)

table(table(events_uni$school_id))
 
  # Q3.3 ----
  # 1 points
  # Now join `events_uni` (public HS that your university of choice visited) with `ccd_hs_zip` 
  # (universe of all public HS that fit our previously defined criteria) and assign it
  # to an object named `ccd_hs_zip_events`. Either left join and right join can work.

  # We want `ccd_hs_zip_events` to contain _all_ public high schools from `ccd_hs_zip`, and 
  # each row is merged with a row in `events_uni` if that high school was visited that university.
  # If the high school was not visited, the new columns will be empty.

ccd_hs_zip_events <- 

  # Q3.4 ----
  # 2 points
  # Perform a semi join and an anti join to find out which rows in `ccd_hs_zip` have a match in
  # `events_uni` and which did not. Save the objects as `semi_ccd_hs_zip_events` and
  # `anti_ccd_hs_zip_events`. 

semi_ccd_hs_zip_events <- 

anti_ccd_hs_zip_events <- 

  # Q3.5 ----
  # Which type of join from Q3.4 creates a data frame for high schools that did _NOT_ receive 
  # any visits from the university you chose? Assign your answer to an object named `q3_5`.

q3_5 <- 

  # Q3.6 ----
  # 2 points
  # Go back to the `ccd_hs_zip_events` dataframe you created in step 3, and add a new column to
  # the dataframe called `num_visits` that identifies the number of visits each high school received
  # from your university of choice. The value should be `0` if the high school did not receive a
  # visit, and the same value as `num_events` if it did receive a visit. 

ccd_hs_zip_events <- 

  # Now use `count()` to get the frequency table for the values of `num_visits` and assign this
  # table to an object named `q3_6`.

q3_6 <- 

  # Q3.7 ----
  # 2 points
  # Based on the variable `num_visits` you just created, create a 0/1 variable `got_visit` to
  # `ccd_hs_zip_events` that equals `1` if the high school got at least one visit from your
  # university of choice and equals `0` if the high school did not receive any visits. 

ccd_hs_zip_events <- 

  #Use `count()` to get the frequency table for the values of `got_visit` and assign this
  # table to an object named `q3_7`.

q3_7 <- 

## Question 4: Conduct analysis comparing visited and nonvisited high schools ----

  # 3 points
  # Perform exploratory data analysis on variables you find interesting, with the general focus
  # of identifying characteristics associated with getting visit(s) versus not getting visit(s).

  # [EXAMPLE] One analysis you can conduct is compare the high school race composition between
  # visited and nonvisited schools.

# Write your analysis code here


## Question 5: Bonus (up to 10% extra credit) ----
  # Create a graph using data that you used in this problem set. Make sure to title and label the
  # plot appropriately and customize it how you'd like. Add a color palette from `Rcolorbrewer` or
  # curate your own color palette. Then, write some text describing your findings or observations.

## Create a GitHub issue ----
  # 2 points
  # Go to the class repository https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues and create a new issue.
  # Refer to rclass1 student issues readme https://github.com/anyone-can-cook/rclass1_student_issues_f26/blob/main/README.md 
  # for instructions on how to post questions or reflections.
  # You are also required to respond to at least one issue posted by another student.
  
  # Create an object named `issue` below and assign it the URL to your new issue, as a character string.
  # Make sure the URL is in quotes.
  
  issue <- 
  
  # Create an object named `reply` below and assign it the URL to your response to another issue, as a character string. 
  # Make sure the URL is in quotes.
  
  reply <- 
  
## Submit problem set on Canvas ----
  # Use this naming convention "lastname_firstname_ps#" for your R script (e.g. jaquette_ozan_problemset10.R).
