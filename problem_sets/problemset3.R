## Problemset Title ----
## [ PROJ ] < Problem set 3 >
## [ FILE ] < lastname_firstname_problemset3.R >
## [ AUTH ] < Your name / GitHub handle >
## [ INIT ] < 2025-01-27 >

## Overview ----
  # 30 points

  # The aim of this problem set is to give you practice completing data management tasks associated 
  # with filtering/isolating observations, sorting observations, and selecting variables. This can 
  # be done using the `filter()`, `arrange()`, and `select()` functions from the `tidyverse` package.

  # For the following questions, you'll be asked to complete the same task using `dplyr` functions 
  # in multiple ways, with and without pipes. We want you to understand that there are several ways 
  # to complete the same task, and we want you to practice completing it in different ways.

  # For the questions asking you to filter, we recommend that you write down the conditions the 
  # question asks for on a scratch piece of paper before you write the code. This will help you 
  # visualize the process before you write the code.

## Question 1: Load and inspect `df_event` dataset ----
  # 1 point
  # In the space below, complete the following:
  # Load the `tidyverse` library using the `load()` and `url()` functions to download the `df_event` 
  # dataframe from this url: https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_event_somevars.RData
  # Each row in `df_event` represents a recruiting visit



  # Q1.2 ----
  # 2 points
  # Inspect the `df_event` dataframe in the space below:
  # Use `names()` to identify the column names in the dataframe
  # Use `typeof()` to show the data type of the `event_state` column
  # Use `str()` to show the structure of the `med_inc` column
  # Use `table()` to show the categorical values of the `event_type` column



  # Please assign each of the four lines of code above to four new objects. 
  # Name each object `q1_2a`, `q1_2b`, etc. Like this:
  # q1_2x <- function(df$variable)


  
## Question 2: Filtering/isolating observations ----
  # Tidyverse functions can be done using multiple approaches with and without the "%>%" pipe 
  # operator. Below is an example of using each method to obtain the total number of recruiting 
  # visits to California from the `df_event` dataframe:

# tidyverse filter() function without pipes

nrow(filter(df_event, event_state == 'CA'))

# tidyverse filter() function using pipes

df_event %>%
  filter(event_state == 'CA') %>%
  nrow()
    
  # Your job is to create a filter that satisfies a few conditions at once. In the next 
  # question you will do this in three steps. Then you will put all the steps together into
  # one single line of code. Later questions will ask you to perform multiple filters at once.

  # Q2.1a ----
  # 1 point
  # Filter recruiting events in `df_event` by the University of Massachusetts-Amherst 
  # (`univ_id`: `166629`). Assign this data to a new object named `q2_1b`.



  # Q2.1b ----
  # 1 point
  # Filter recruiting events from the `q2_1a` dataframe you just created to get 
  # any observations for events held at an out-of-state high school. 
  #   Hint: You can use variables `event_state` (where the HS event was held) and 
  #   the variable `instst` (in what state is the university) to find in-state events.
  # Assign the new dataframe to a new object named `q2_1b`.



  # Q2.1c ----
  # 1 point
  # Filter recruiting events from the previous dataframe `q2_1b` to get observations 
  # of any events at public high schools. Use the `event_type` variable for this. 
  #   Remember to inspect the `event_type` variable before filtering and make sure you are 
  #   using the right spelling, case, and data type (character variables require being in quotes!).
  # Assign the data to a new object named `q2_1c`.



  # Q2.1d
  # 1 point
  # Filter recruiting events from the above q2_1c dataframe. FIlter for observations 
  # where average median household income is greater than or equal to $100,000 (`med_inc`).
  # Assign this to a new object named `q2_1d`.



  # Q2.1e ----
  # 1 point
  # Put all the previous steps together in one single line of code without using %>% pipes.
  # Filter from `df_event` for all observations meeting the same criteria again.
  # Assign the data to a new object named `q2_1e`
  # 1. Visits from UMass-Amherst
  # 2. In the same state as the institution
  # 3. To public high schools
  # 4. Where median income was $100,000 or higher.
  #   Hint: Notice how many observations/rows were left in df `q2_1d`. Your new dataframe
  #   should have the same number of rows.

# tidyverse filter() function without pipes


  # Q2.2 ----
  # 3 points
  # Do the exact same filtering and counting as Q2.1e
  # but this time use `%>%` pipes. It will have the same number of rows as `q2.1e`.
  # Assign this data to an object named `q2_2`.

# tidyverse filter() function with pipes


# The following question will be in multiple parts again, like question 2.1.
# The conditions can be confusing to address all at once, so you will filter for the
# conditions given in single steps before putting all the code together. 

  # Q2.3a ----
  # 1 point
  # Without using `%>%` pipes, filter for observations of recruiting events 
  # by the University of South Carolina-Columbia (`univ_id`: `218663`) 
  # or by the University of Alabama (`univ_id`: `100751`).
  #   Hint: If you filter for USCC first, then Alabama second by separating with a comma,
  #   your output will be 0, because Alabama and USCC did not do any events together. 
  #   Instead you need to filter using the `%in%` operator or the `|` operator.
  # Assign this to an object named `q2_3a`.



  # Q2.3b ----
  # 1 point
  # Use a single `and` condition to filter the data frame `q2_3a` to get observations for 
  # 1. An in-state event. 
  # 2. At a 2-year college event type. 
  #   Hint: Separating conditions with a comma performs an meets an `and` condition.
  #   However, you can also cluster two conditions together with an `&` symbol. 
  # Assign this to an object named `q2_3b`.



  # Q2.3c ----
  # 1 point
  # Go back to `q2_3a`, which was visits by South Carolina and Alabama. From this data
  # without using `%>%` pipes, filter `q2_3a` for observations for in-state and 2-year colleges, just like you did before,
  # but also add an OR condition for observations where a zip code had 
  # a population over 10,000 (`pop_total`). This means you will filter for observations where either
  # USCC and Alabama went to in-state 2-year colleges, _or_ they went to 
  # locales with populations greater than 10,000 people.
  #   Note the order of precedence: & is higher in priority than |
  # Once you're sure your code is correct, assign it to an object named `q2_3c`

# tidyverse filter() function without pipes


  # Q2.4 ----
  # 3 points
  # Do the exact same filtering as Q2.3c
  # but this time use `%>%` pipes. It will have the same number of rows as q2.3.
  # Assign it to an object named `q2_4`

# tidyverse filter() function with pipes


## Question 3: Sorting observations ----
  # Q3 ----
  # 3 points
  # Create a new dataframe named `q3` that contains the events in `df_events` sorted by:
  # 1. Ascending `univ_id`
  # 2. Ascending `event_date`
  # 3. Ascending `event_state`
  # 4. Descending `pct_white_zip`
  # 5. Descending `med_inc` 
  # all in that order. Use the tidyverse `arrange()` function.
  # You can preview the first 10 rows of the `q3` dataframe using `head()` if you wish to check your work. 

# tidyverse using arrange()


## Question 4: Selecting variables ----
  # Q4.1 ----
  # 1 point
  # Create a new dataframe named `q4`. 
  # Use the tidyverse `select()` function without `%>%` pipes to select the following columns 
  # `univ_id`, `event_date`, `event_type`, `zip`, and `med_inc` from `df_event`. 

# tidyverse select() without pipes


  # Q4.2 ----
  # 1 point
  # Use the `names()` function to show what columns (variables) are present
  # in the newly created dataframe. Assign this line of code to an object named `q4_2`



  # Q4.3 ----
  # 1 point
  # Do the exact same selection as Q4.1 but this time use `%>%` pipes. 
  # Assign this to an object named `q4_3`


  
  # Q4.4 ----
  # 1 point
  # Use the `names()` function to show what columns (variables) are present
  # in the previous dataframe `q4_3`. Assign this code to an object named `q4_4`


## Question 5: Additional practice with `df_school_all` dataframe ----
  # Q5.1 ----
  # 1 point
  # Use the `load()` and `url()` functions to download the `df_school_all` dataframe from the url: 
  # https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_school_allvars.RData
  # Each row in `df_school_all` represents a high school (includes both public and private schools)
  # There are columns (e.g., `visit_by_100751`) indicating the number of times a university 
  # visited that high school
  # The variable `total_visits` identifies the number of visits the high school received from 
  # all (16) public research universities in this data collection sample.


  # Q5.2 ----
  # 1 point
  # Use `table()` to show the categorical values of the `school_type` variable.
  # Assign this code to an object named `q5_2`


  # Q5.3
  # 1 point
  # Without using `%>% pipes, use the tidyverse functions `arrange()` and `select()` to do the following:
  # 1. Sort `df_school_all` descending by `total_visits`
  # 2. Select the following variables: `name`, `state_code`, `city`, `school_type`, `total_visits`, 
  #   `med_inc`, `pct_white`, `pct_black`, `pct_hispanic`, `pct_asian`, `pct_amerindian`
  # Assign this dataframe to a new object named `q5_3`.


  # Q5.4 ----
  # 1 point
  # Get the first 10 rows of the `q5_3` dataframe using `head()`, which represents the top 10 
  # most visited schools by the 16 universities.
  # Assign this data to a new object named `q5_4`.


  # Q5.5 ----
  # 1 point 
  # Do the same selecting and arranging as Q5.3, this time using `%>% pipes.
  # Assign this dataframe to an object named `q5_5`, which should have the exact same 
  # dimensions as `q5_3`.



  # Q5.6 ----
  # 1 point 
  # Get the top ten observations from Q5.5, using `head()`.
  # Assign this dataframe to an object named `q5_6`.


  # Q5.7 ----
  # 1 points
  # Select and arrange the same variables from `df_school_all` again, this time
  # get the top 10 most visited _public_ high schools in California
  # Assign this data to a new object named `q5_7`.



  # Q5.8 ----
  # 1 point
  # Select and arrange the same variables from `df_school_all` yet again, this time
  # get the top 10 most visited _private_ high schools in California.
  # Assign this data to a new object names `q5_8`.



## Create a GitHub issue ----
  # 2 points
  # Go to the class repository https://github.com/anyone-can-cook/rclass1_student_issues_f24/issues and create a new issue.
  # Refer to rclass1 student issues readme https://github.com/anyone-can-cook/rclass1_student_issues_f24/blob/main/README.md 
  # for instructions on how to post questions or reflections.
  # You are also required to respond to at least one issue posted by another student.
  
  # Create an object named `issue` below and assign it the URL to your new issue, as a character object.  
  # Make sure the URL is in quotes.

issue <- 

  # Create an object named `reply` below and assign it the URL to your response to another issue, as a character object. 
  # Make sure the URL is in quotes.

reply <- 

## Submit problem set ----
  # Use this naming convention "lastname_firstname_ps#" for your R script (e.g. jaquette_ozan_problemset3.R).
