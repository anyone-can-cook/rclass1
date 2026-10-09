## Problemset Title ----
## [ PROJ ] < Problem set 3 >
## [ FILE ] < lastname_firstname_problemset3.R >
## [ AUTH ] < Your name / GitHub handle >
## [ INIT ] < Date you started this problem set >

## Overview ----
  # 34 points

  # The aim of this problem set is to give you practice completing data management tasks associated 
  # with filtering/isolating observations, sorting observations, and selecting variables. This can 
  # be done using the `filter()`, `arrange()`, and `select()` functions from the `dplyr` package, 
  # which is part of the `tidyverse`.
  # For the following questions, you'll be asked to complete the same task using `dplyr` functions 
  # in multiple ways, with and without pipes. We want you to understand that there are several ways 
  # to complete the same task, and we want you to practice completing it in different ways.

  # For the questions asking you to filter, we recommend that you write down the conditions the 
  # question asks for on a scratch piece of paper before you write the code. This will help you 
  # visualize the process before you write the code.

  # IMPORTANT: Your script is graded by running it from top to bottom. If any line produces an 
  # error, every question after that line can lose points. Before submitting, restart R 
  # (Session > Restart R) and run the whole script to make sure it finishes without errors.


## Question 1: Load and inspect `df_event` dataset ----
  # Q1.1 ----
  # 1 point
  # In the space below, complete the following:
  # 1. Load the `tidyverse` library using `library()`.
  # 2. Use the `load()` and `url()` functions to download the `df_event` dataframe from this url: 
  #    https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_event_somevars.RData
  #    Hint: `url()` goes inside `load()`, like this: load(url("paste_the_url_here"))
  #    After it runs, `df_event` should appear in your Environment pane (18,680 rows, 32 columns).
  # Each row in `df_event` represents a recruiting visit



  # Q1.2 ----
  # 2 points
  # Inspect the `df_event` dataframe in the space below:
  # a. Use `names()` to identify the column names in the dataframe
  # b. Use `typeof()` to show the data type of the `event_state` column
  # c. Use `str()` to show the structure of the `med_inc` column
  # d. Use `table()` to show the categorical values of the `event_type` column
      # Hint: Parts b-d ask about a single column. Use `$` to pull out a column from a
      # dataframe, e.g. df_event$column_name (df_event[["column_name"]] also works).

  # Assign each of the four lines of code above to its own object, named `q1_2a`, `q1_2b`, 
  # `q1_2c`, and `q1_2d` (matching letters a-d above). 
  #   Note: `str()` prints its output to the console and does not return anything, so `q1_2c` 
  #   will show up as NULL in your Environment. That is expected!

q1_2a <- 
q1_2b <- 
q1_2c <- 
q1_2d <- 

  
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
  # question you will do this in steps. Then you will put all the steps together into
  # one single `filter()` call. Later questions will ask you to perform multiple filters at once.
  #   Tip: After each step, check how many rows your new dataframe has using `nrow()` or the 
  #   Environment pane. Each step should have fewer (or equal) rows than the step before it.

  # Q2.1a ----
  # 1 point
  # Filter recruiting events in `df_event` by the University of Massachusetts-Amherst 
  # (`univ_id`: `166629`). Assign this data to a new object named `q2_1a`.
  #   Hint: `univ_id` is a numeric variable, so the value does not need quotes.

q2_1a <- 


  # Q2.1b ----
  # 1 point
  # Filter recruiting events from the `q2_1a` dataframe you just created to get 
  # any observations for events held at an OUT-OF-STATE high school (a high school in a 
  # different state than the university).
  #   Hint: Use the variables `event_state` (the state where the event was held) and 
  #   `instst` (the state where the university is located). An event is in-state when these 
  #   two variables are equal, and out-of-state when they are NOT equal. You can compare two 
  #   variables to each other directly, just like you compare a variable to a value.
  # Assign the new dataframe to a new object named `q2_1b`.

q2_1b <- 


  # Q2.1c ----
  # 1 point
  # Filter recruiting events from the previous dataframe `q2_1b` to get observations 
  # of any events at public high schools. Use the `event_type` variable for this. 
  #   Remember to inspect the `event_type` variable before filtering and make sure you are 
  #   using the right spelling, case, and data type (character variables require being in quotes!).
  #   Your `table()` output from Q1.2 shows exactly how each category is spelled.
  # Assign the data to a new object named `q2_1c`.

q2_1c <- 


  # Q2.1d ----
  # 1 point
  # Filter recruiting events from the `q2_1c` dataframe. Filter for observations 
  # where the median household income of the zip code (`med_inc`) is greater than or equal 
  # to $100,000.
  #   Hint: Type numbers without commas or dollar signs (e.g., 100000, not $100,000).
  # Assign this to a new object named `q2_1d`.

q2_1d <- 


  # Q2.1e ----
  # 1 point
  # Put all the previous steps together in a single `filter()` call without using %>% pipes.
  # Filter from `df_event` for all observations meeting the same criteria again:
  # 1. Visits from UMass-Amherst
  # 2. Out-of-state (in a different state than the institution)
  # 3. To public high schools
  # 4. Where median household income was $100,000 or higher.
  #   Hint: Notice how many observations/rows were left in df `q2_1d`. Your new dataframe
  #   should have the same number of rows.
  # Assign the data to a new object named `q2_1e`.

# tidyverse filter() function without pipes

q2_1e <- 

  # Q2.2 ----
  # 3 points
  # Do the exact same filtering as Q2.1e, but this time use `%>%` pipes. 
  # It should have the same number of rows as `q2_1e`.
  # Assign the resulting dataframe (not the row count) to an object named `q2_2`.

# tidyverse filter() function with pipes

q2_2 <- 

# The following question will be in multiple parts again, like question 2.1.
# The conditions can be confusing to address all at once, so you will filter for the
# conditions given in single steps before putting all the code together. 

  # Q2.3a ----
  # 1 point
  # Without using `%>%` pipes, filter for observations of recruiting events 
  # by the University of South Carolina-Columbia (`univ_id`: `218663`) 
  # OR by the University of Alabama (`univ_id`: `100751`).
  #   Hint: Separating conditions with a comma means AND, so writing 
  #   `univ_id == 218663, univ_id == 100751` asks for rows where `univ_id` is both values at 
  #   the same time, which is impossible, so you would get 0 rows. 
  #   Instead you need an OR condition, using either the `|` operator or the `%in%` operator.
  # Assign this to an object named `q2_3a`.

q2_3a <- 


  # Q2.3b ----
  # 1 point
  # Filter the `q2_3a` dataframe to get observations that meet BOTH of these conditions: 
  # 1. An in-state event (same state as the university). 
  # 2. At a 2-year college (check the `event_type` categories for the exact spelling). 
  #   Hint: Separating conditions with a comma creates an AND condition.
  #   You can also join two conditions together with the `&` symbol. Either works here.
  # Assign this to an object named `q2_3b`.

q2_3b <- 


  # Q2.3c ----
  # 1 point
  # Go back to `q2_3a`, which was visits by South Carolina and Alabama. Without using `%>%` pipes, 
  # filter `q2_3a` for observations that meet EITHER of these:
  #   - in-state AND 2-year college (the same two conditions as Q2.3b), 
  #   - OR the event's zip code has a population greater than 10,000 (`pop_total`).
  # In words: keep events where USCC and Alabama went to in-state 2-year colleges, _or_ 
  # where they went to locales with populations greater than 10,000 people.
  #   Note the order of precedence: `&` is evaluated before `|`, just like multiplication is 
  #   evaluated before addition. To make your intent clear, you may wrap the AND part in 
  #   parentheses: (condition1 & condition2) | condition3
  #   Important: Use `&` (not a comma) for the AND part here, because a comma would apply 
  #   to the whole OR statement.
  # Once you're sure your code is correct, assign it to an object named `q2_3c`.

# tidyverse filter() function without pipes

q2_3c <- 

  # Q2.4 ----
  # 3 points
  # Do the exact same filtering as Q2.3c (starting from `df_event` or from `q2_3a`), 
  # but this time use `%>%` pipes. It should have the same number of rows as `q2_3c`.
  # Assign it to an object named `q2_4`.

# tidyverse filter() function with pipes

q2_4 <- 

## Question 3: Sorting observations ----
  # Q3 ----
  # 3 points
  # Create a new dataframe named `q3` that contains the events in `df_event` sorted by:
  # 1. Ascending `univ_id`
  # 2. Ascending `event_date`
  # 3. Ascending `event_state`
  # 4. Descending `pct_white_zip`
  # 5. Descending `med_inc` 
  # all in that order, inside a single `arrange()` call. Use the tidyverse `arrange()` function.
  #   Hint: `arrange()` sorts ascending by default. Wrap a variable in `desc()` to sort descending.
  #   Do not use `select()` here; `q3` should keep all 32 columns.
  # You can preview the first 10 rows of the `q3` dataframe using `head()` if you wish to check your work. 

# tidyverse using arrange()

q3 <- 

## Question 4: Selecting variables ----
  # Q4.1 ----
  # 1 point
  # Create a new dataframe named `q4_1`. 
  # Use the tidyverse `select()` function without `%>%` pipes to select the following columns 
  # `univ_id`, `event_date`, `event_type`, `zip`, and `med_inc` from `df_event`, in that order. 

# tidyverse select() without pipes

q4_1 <- 

  # Q4.2 ----
  # 1 point
  # Use the `names()` function to show what columns (variables) are present
  # in `q4_1`. Assign this line of code to an object named `q4_2`.

q4_2 <- 


  # Q4.3 ----
  # 1 point
  # Do the exact same selection as Q4.1 but this time use `%>%` pipes. 
  # Assign this to an object named `q4_3`.

q4_3 <- 

  
  # Q4.4 ----
  # 1 point
  # Use the `names()` function to show what columns (variables) are present
  # in `q4_3`. Assign this code to an object named `q4_4`.

q4_4 <- 

## Question 5: Additional practice with `df_school_all` dataframe ----
  # Q5.1 ----
  # 1 point
  # Use the `load()` and `url()` functions to download the `df_school_all` dataframe from the url: 
  # https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_school_allvars.RData
  # Each row in `df_school_all` represents a high school (includes both public and private schools)
  # There are columns (e.g., `visits_by_100751`) indicating the number of times a university 
  # visited that high school
  # The variable `total_visits` identifies the number of visits the high school received from 
  # all (16) public research universities in this data collection sample.


  # Q5.2 ----
  # 1 point
  # Use `table()` to show the categorical values of the `school_type` variable.
  # Assign this code to an object named `q5_2`.

q5_2 <- 

  # Q5.3 ----
  # 1 point
  # Without using `%>%` pipes, use the tidyverse functions `arrange()` and `select()` to do the following:
  # 1. Sort `df_school_all` descending by `total_visits`
  # 2. Select the following variables, in this order: `name`, `state_code`, `city`, `school_type`, 
  #   `total_visits`, `med_inc`, `pct_white`, `pct_black`, `pct_hispanic`, `pct_asian`, `pct_amerindian`
  #   Hint: Without pipes, you can nest one function inside the other. The inner function runs 
  #   first, and its output becomes the first argument of the outer function: 
  #   outer_function(inner_function(df, ...), ...)
  # Assign this dataframe to a new object named `q5_3`.

q5_3 <- 

  # Q5.4 ----
  # 1 point
  # Get the first 10 rows of the `q5_3` dataframe using `head()`, which represents the top 10 
  # most visited schools by the 16 universities.
  #   Hint: `head()` shows 6 rows by default. Use the `n` argument to change that.
  # Assign this data to a new object named `q5_4`.

q5_4 <- 

  # Q5.5 ----
  # 1 point 
  # Do the same selecting and arranging as Q5.3, this time using `%>%` pipes.
  # Assign this dataframe to an object named `q5_5`, which should have the exact same 
  # dimensions as `q5_3`.

q5_5 <- 


  # Q5.6 ----
  # 1 point 
  # Get the top ten observations from `q5_5`, using `head()`.
  # Assign this dataframe to an object named `q5_6`.

q5_6 <- 

  # Q5.7 ----
  # 1 point
  # Starting from `df_school_all`, get the top 10 most visited _public_ high schools in California.
  # Use `filter()` to keep only public high schools in California, then sort and select the 
  # same way as Q5.3, and keep the first 10 rows. You may use pipes or not.
  #   Hint: Check the exact values of `school_type` from Q5.2. California's `state_code` is "CA".
  #   The result should have 10 rows and the same 11 columns as `q5_3`.
  # Assign this data to a new object named `q5_7`.

q5_7 <- 


  # Q5.8 ----
  # 1 point
  # Do the same as Q5.7, but this time get the top 10 most visited _private_ high schools 
  # in California.
  # Assign this data to a new object named `q5_8`.

q5_8 <- 


## Create a GitHub issue ----
  # 2 points
  # Go to the class repository https://github.com/anyone-can-cook/rclass1_student_issues_f26 and create a new issue.
  # Refer to rclass1 student issues readme https://github.com/anyone-can-cook/rclass1_student_issues_f26/blob/main/README.md
  # for instructions on how to post questions or reflections.
  # You are also required to respond to at least one issue posted by another student.
  
  # Replace the empty quotes below with the URL to your new issue, as a character object.  
  # Make sure the URL stays inside the quotes. Copy it from your browser's address bar, e.g.:
  # "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/12"

issue <- ""

  # Replace the empty quotes below with the URL to your response to another student's issue.
  # To get the link to your comment, click the "..." menu on your comment and choose "Copy link".
  # Make sure the URL stays inside the quotes.

reply <- ""

## Submit problem set ----
  # Use this naming convention "lastname_firstname_problemset#.R" for your R script 
  # (e.g. jaquette_ozan_problemset3.R).
