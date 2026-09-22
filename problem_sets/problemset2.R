## Problemset Title ----
## [ PROJ ] < Problem set 2 >
## [ FILE ] < lastname_firstname_problemset2.R >
## [ AUTH ] < Your name / GitHub handle >
## [ INIT ] < Date you started the file >

## Overview ----
  # In this problem set, you will practice investigating and subsetting objects using the Base R approach. 
  # We are asking you to practice working with different object types such as atomic vectors, lists, and data frames. 
  # Learning how to work with different object types will be very useful in the coming weeks and will help you 
  # understand the underlying structure of any data you are working with. While this problem set is fairly short, 
  # we want you to become familiar with these concepts -- which are fundamental to data management and working with R.

## Question 1: Investigating objects, Base R ----

  # Q1.1 ----
  # 1 point
  # load the data using the following URL: 
  # https://github.com/ozanj/rclass/raw/master/data/recruiting/recruit_school_allvars.RData
  # remember to use the url() function embedded inside the load() function.
  # this will create the object 'df_school_all' in your R global environment

rm(list = ls()) # remove all objects



  # Answer the following questions about the object `df_school_all` by running the appropriate R commands in the 
  # space below. Use the the appropriate R functions to investigate the object. 
  # You must also assign the output of the R command to a new object once you know your code works. 
  # We will always tell you what to name this object. This is necessary for our grading code to work!
  # The first question will be answered for you to show how it works.

  # What "type" of object is `df_school_all`?

typeof(df_school_all)
q1_x <- typeof(df_school_all) # assign your code
q1_x <- "list" # or assign the literal output from typeof()

  # Q1.2 ----
  # 1 points
  # What is the "length" of the object `df_school_all`? 
  # What does this specific value of length refer to in one word? 
  # Assign your two answers to objects named `q1_2a` and `g1_2b`, respectively. 
  # Make sure `q1_2b` is assigned as a string/text data type

q1_2a <- 
q1_2b <- 

  # Q1.3 ----
  # 1 point
  # How many "rows" are in the object `df_school_all`? 
  # What does each row represent, in one word? 
  # Assign your two answers to object named `q1_3a` and `q1_3b`, respectively.
	# Make sure `q1_3b` is assigned as a string/text data type

q1_3a <- 
q1_3b <- 

##
## In the space below, use the `str()` function to investigate the contents of `df_school_all` ----
##


  # based on the output of str() above, answer the following questions with a ONE WORD answer 
  # Assign your answer to an object named `q1_x` like this:

q1_x <- "answer"

  # Do not forget to assign your one word answer as a character object by using single or double quotation marks.

  # Q1.4 ----
  # 1 point
  # In one word, what does each element of the object `df_school_all` represent? 
  # Assign your answer to an object named `q1_4`.

q1_4 <- 

  # Q1.5 ----
  # 1 point
  # In one word, are the individual elements within `df_school_all` lists or vectors? 
  # Assign your answer to an object named `q1_5`.

q1_5 <- 

  # Q1.6 ----
  # 1 point
  # Are the individual elements within `df_school_all` named or un-named? 
  # Assign your answer to an object named `q1_6`.

q1_6 <- 

### These questions refer to the variable `school_type` within the object `df_school_all`. ----
  # For the first two questions, write the appropriate R function to investigate this variable,
  # Then assign that line of code to a named object again so we can grade your answer. 

  # Q1.7 ----
  # 1 point
  # What is the data "type" of `school_type`? 
  # Assign your answer to an object named `q1_7`.

q1_7 <- 
  
  # Q1.8 ----
  # 1 point
  #   What is the "length" of `school_type`? 
  # Assign your answer to an object named `q1_8`.

q1_8 <- 

  # Q1.9 ----
  # 1 point
  # In one word, what part of the data frame does this specific value of length() refer to?
  # Assign your answer as a character data type to an object named `q1_9`.

q1_9 <- 

  # Q1.10 ----
  # 3 points
  # Use the `table()` function to count `school_type` three different ways:
  # 1) no `useNA` argument
  # 2) `useNA = "ifany"`
  # 3) `useNA = "always"`



  # After writing and trying these three lines of code, assign each of the three lines
  # to a 'q1_x_x' object like this: 
  # q1_10_1 <- table(...)
  # q1_10_2 <- table(...) etc. ...

q1_10_1 <- 
q1_10_2 <- 
q1_10_3 <- 

  # Q1.11 ----
  # 1 point
  # In one word, what is the default value of the `useNA` argument? 
  # Assign your answer to an object named `q1_11`.

q1_11 <- 

  # Q1.12 ----
  # 1 point
  # How many columns appear in the table when you assign the value "ifany" to the `useNA` argument?
  # Assign your answer as a number, not a character, to an object named `q1_12`.

q1_12 <- 

  # Q1.13 ----
  # 1 point
  # How many columns appear in the table when you assign the value "always" to the `useNA` argument?
  # Assign your answer as a number, not a character, to an object named `q1_13`.

q1_13 <- 

## Question 2: Subsetting, Base R ----
  # In the code below, you will find 3 objects: a vector, a list, and the data frame `df_school_all`. 
  # Run the code. You will use these objects in the following questions.

  # Create a named numeric atomic vector
vec <- c(a = 2.4, b = 1.1, c = 3.4, d = 4, e = 6, f = 32, g = 21, h = 17, i = 10)
str(vec)

  # Create a list
list <- list(c(1:3), list("red", "orange"), list("LA", "NY", "DC")) 
str(list)

  # View the `df_school_all` data frame you loaded earlier
head(df_school_all, n = 5)
#str(df_school_all)



### In this question we will use the `[]` to subset the atomic vector `vec`: ----
  # For your answers, you should test your line of code in the space below the prompt
  # Once you know the right answer, you must assign the line of code to a q2_x object again
  # like this: q2_x <- vec[x,y] etc. ...

  # Q2.1 ----
  # 1 point
  # Return the 4th and 7th element of the vector `vec`. 
  # Assign your answer to an object named `q2_1`.


q2_1 <- 

  # Q2.2 ----
  # 1 point
  # Return everything but the last element of the vector `vec`. 
  # Assign your answer to an object named `q2_2`.

q2_2 <- 

  # Q2.3 ----
  # 1 point  
  # Return elements named "a", "d", and "g". 
  # Assign your answer to an object named `q2_3`.

q2_3 <- 

  # Q2.4 ----
  # 1 point
  # Return elements that are less than `12`. 
  # Assign your answer to an object named `q2_4`.

q2_4 <- 

### In these questions we will use the `[]` (single brackets) to subset a list/data frame: ----
  # For your answers, you should test your line of code in the space below the prompt
  # Once you know the right answer, you must assign the line of code to a q2_x object.

  # Q2.5 ----
  # 1 point
  # Return the 1st element of the list `list` using `[]`. 
  # Assign your answer to an object named `q2_5`.

q2_5 <-

  # Q2.6 ----
  # 1 point
  # What is the data type? 
  # Assign the answer as a character data type to an object named `q2_6`.

q2_6 <- 

  # Q2.7 ----
  # 1 point
	# Return the 2nd, 4th, and 6th elements of the data frame `df_school_all`. 
	# Assign your answer to an object named `q2_7`.

q2_7 <-

  # Q2.8 ----
  # 1 point
	# Return the first 100 rows/observations of the `state_code` column
	# Assign your answer to an object named `q2_8`.

q2_8 <- 

  # Q2.9 ----
  # 1 point
	# Return the first 3 rows (observations) of the variables `state_code` and `name`
  # The answer should be a 3x2 object.
	# Assign your answer to an object named `q2_9`.

q2_9 <- 


### In these questions we will use `[]`, `[[]]`, and `$` to subset a list/data frame: ----
  # Pay close attention to how we ask you to subset in each question

  # Q2.10 ----
  # 1 point
  # Return the 1st element of the list `list` using `[[]]`. 
  # Assign this code to an object named `q2_10`

q2_10 <- 

  # Q2.11 ----
  # 1 point
  # What is the data type of `list[[1]]? **ANSWER:** It is an integer vector
  # Assign this character answer to an object named `q2_11`

q2_11 <- 

  # Q2.12 ----
  # 1 point
  # What is the data type of the variable `total_students` using only `[]`?
  # Assign this character answer to an object named `q2_12`

q2_12 <- 

  # Q2.13 ----
  # 1 point
  # What is the data type of the variable `total_students` using `[[]]`?
  # Assign this character answer to an object named `q2_13`

q2_13 <- 

  # Q2.14 ----
  # 1 point
  # What is the data type of the variable `total_students` using `$`?
  # Assign this character answer to an object named `q2_14`

q2_14 <- 

  # Q2.15 ----
  # 1 point
  # Return elements 10-15 from `total_students` using `$` and `[]`.
  # Assign the answer to an object named `q2_15`

q2_15 <- 

## Question 3: Calculate the total average number of students receiving free lunch from `num_fr_lunch`. 

  # Q3.1 - q3.3 ----
  # 3 points
  # Using the `mean()` function, calculate the mean of `num_free_lunch` three times 
  # by subsetting with `[]`, `[[]]`, and `$`, respectively. 
  # remember to assign each of the lines of code to objects named `q3_1`, `q3_2`, and `q3_3`.

q3_1 <- 
q3_2 <- 
q3_3 <- 

  # Q3_4 ----
  # 1 point
  # Which of the three lines of code above is bugged?
  # Choose 1 for q3_1, 2 for q3_2, and 3 for q3_3.
  # Submit your answer as an object named q3_4 with your answer as a numeric value 1, 2, or 3.

q3_4 <- 

  # Q3_5 ----
  # 1 point
  # What data type was incompatible with the mean function and caused this bug in the code?
  # Assign your answer to an object named `q3_5` with your answer as a character type.

q3_5 <- 

  # Q3_6 ----
  # 1 point
  # What two types of vectors are actually compatible with the mean function?
  # Assign your answer to an object named `q3_5 `with your answer as a character vector:
  # E.g.: q3_5 <- c("type1","type2"). 
  # For our grading code to work, the two types should be entered in alphabetical order :)

q3_6 <- 

## Create a GitHub issue ----
  # 2 points
  # Go to the class repository https://github.com/anyone-can-cook/rclass1_student_issues_f26 and create a new issue.
  # Refer to rclass1 student issues readme https://github.com/anyone-can-cook/rclass1_student_issues_f26/blob/main/README.md
  # for instructions on how to post questions or reflections.
  # You are also required to respond to at least one issue posted by another student.

  # Create an object named `issue` below and assign it the URL to your new issue, as a character object.  
  # Make sure the URL is in quotes.

issue <- ""

  # Create an object named `reply` below and assign it the URL to your response to another issue, as a character object. 
  # Make sure the URL is in quotes.

reply <- ""

## Submit problem set ----
  # Use this naming convention "lastname_firstname_ps#" for your R script (e.g. jaquette_ozan_problemset2.R).
