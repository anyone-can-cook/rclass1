## Problem Set Title ----
## [ PROJ ] < Problem set 1 >
## [ FILE ] < lastname_firstname_problemset1.R >
## [ AUTH  ] < Your name / GitHub handle >
## [ INIT ] < Date you started the file >


## Overview ----

  # Welcome to Introduction to Programming and Data Management using R! 
  # This problem set is intended to give you some practice becoming familiar 
  # with using R. In this problem set, we ask you to create an R project, 
  # load and investigate an R data frame stored as a .csv file, apply some 
  # basic functions to atomic vectors, and create a GitHub issue.

# Question 1: Creating an R project & R script ----

  # Q1.1 Create an R project ----
  # 1 point
  # Create a folder where you want to save files associated with problem set 1. 
  # Make sure to name the folder "ps1".

  # For instance, the file directory/structure could be 
  # EDUC260a >> problem_sets >> problemset1.

  # 1 point
  # In RStudio, click on "File" >> "New Project" >> "Existing Directory" >> "Browse".
  # Browse to find and select your problem set 1 folder.
  # Click on "Create Project".
  # An R project file has the extension ".Rproj".
  # The name of the file should be "ps1.Rproj" (the name is based on the folder/directory name).

  # Warning: Creating a new R project can close any files currently open in R Studio
  # including this R script! Once you create the R project, you should re-open this `problemset1.R` file
  # inside the ps1 R project. You can check your current open project in the top right corner of RStudio 
  # (There should be a button with a pull-down menu that says "ps1")

  # Q1.2 Save this R script ----  
  # 1 point
  # If you have not already saved this file in the ps1 folder:
  # In RStudio, click on "File" >> "Save As ..." 
  # Make sure to save this R script in the ps1 folder you just created 
  # and put your name in the filename: "lastname_firstname_problemset1.R" (e.g. jaquette_ozan_problemset1.R)

## Confirm that Rproj and R script files were created

  # Q1.3 ----
  # 1 point each
  # Let's look at our files and working directory.
  # Run `getwd()` and then run `list.files()` below this comment. You should see a path to
  # the ps1 folder you created, and you should then see the .R script and the ps1.Rproj file.
  # (You might have other files saved here eventually. That's ok.)

getwd()
list.files()

  # Share your answer: Assign the outputs of the code above to two new objects named
  # `q1_3a` and `q1_3b`. Like this: q1_3a <- "/home/user/Documents/rclass/ps1" or q1_3a <- getwd().
  # Either copy-pasting or using the functions works as long as we get two strings in both objects.

q1_3a <- 
q1_3b <- 

## Question 2: Load .csv file and then investigate the data frame ----

  # Q2.1. ----
  # 1 point
  # This question asks you to load a dataset using the `read.csv()` function
  # and a link to the dataset. You can load the data two ways:
  # 1) You can download a .csv file into your "ps1" folder (using R code `download.file` 
  # or manually from a browser) and then use `read.csv()` to load from the file path.
  # 2) You can specify the URL inside the read.csv() function.
  
  # Remember to assign the csv data to an object named `df_recruiting`

#download.file("https://raw.githubusercontent.com/anyone-can-cook/rclass1/refs/heads/master/data/recruiting/recruit_ps1.csv", "recruit_ps1.csv")

df_recruiting <- 

#or
#df_recruiting <- read.csv("https://raw.githubusercontent.com/anyone-can-cook/rclass1/refs/heads/master/data/recruiting/recruit_ps1.csv")

  # Q2.2. ----
  # 1 point
  # How many rows and how many columns does `df_recruiting have`? 
  # Assign both row and column values to an object named `q2_2` as a numeric vector
  # like this: `q2_2 <- c(x, y)`. 
  #   Note: Answering questions with numeric and character vectors is a big part of these assignments!

q2_2 <- 

  # Q2.3. ----
  # 1 point
  # Use the `typeof()` function to investigate the type of data frame `df_recruiting`.
  # Assign the output (with code, or copy and paste, or write it out, so long as it is literal output)
  # to an object named `q2_3`.

q2_3 <- 

  # Q2.4. ----
  # 1 point
  # Apply the `length()` function to the data frame `df_recruiting`. Assign this output 
  # to an object named `q2_4` (Again, you may assign the code, or the output, so long as it is equal to the literal output).

q2_4 <- 

  # Q2.4a 
  # 1 point 
  # `df_recruiting` has the same number of rows and columns, and this number is equal to
  # the answer you got from Q2.4. Which of these data frame dimensions, columns or rows,
  # does `length()` actually measure? Assign your answer as a character value to 
  # an object named `q2_4a`. Don't forget to use quotes for word/character type answers!

q2_4a <- 

  # Q2.5. ----
  # 1 point
  # Use the `str()` function to investigate the structure of the data frame `df_recruiting`
  # and find the "class" of data structure that `df_recruiting` possesses. Corroborate with the
  # class() function. Now assign the data class (use the exact characters!) to an object named 
  # `q2_5` as character. 


q2_5 <- 

  # Q2.6. ----
  # 1 point
  # Use the `names` function to list the names of the elements (variables) within `df_recruiting`.
  # Assign these names to an object named `q2_6`. Again, you can assign with the code or type it out like `c("a","b"...)`
  # but it must match the output strings exactly.

q2_6 <- 

  # Q2.7. ----
  # 1 point total
  # Wrap the code from Q2.6 above, "names(data_frame_name)", inside the `typeof()` function. Then use the 
  # `length()` function, and finally the `str()` function to inspect the data frame's names values three different ways. 



  # Assign each of these three lines of code to three objects names `q2_7a`, `q2_7b`, and `q2_7c`.
  # Remember to assign them in the order they appear in the question!

q2_7a <- 
q2_7b <- 
q2_7c <- 


# Question 3: Applying basic functions to atomic vectors ----

  # Q3.1. ----
  # 1 point
  # Create an atomic vector object named `age` with the following values: 3, 6, 41, 43.

age <- 

  # Q3.2. ----
  # 1 point
  # Apply the `typeof()`, `length()`, and `str()` functions to the object `age`.
  # When you know the type length and structure, assign the three answers to
  # an object named `q3_2` using `c()` in this order:
  # The type of `age` as a character.
  # The length of `age` as a number.
  # The class of `age` as a character.

  # Note: str() abbreviates some class names in its output. When assigning your
  # answers, write out the full class name. For example, use "numeric" rather
  # than "num" and "character" rather than "chr".


q3_2 <- 

  # Q3.2a
  # 1 point
  # You stored the length of `age` as a number (without quotes) to `q3_2` in the question above. 
  # Now inspect it within the q3_2 object. What type/class is it inside of the `q3_2` object?
  # Assign your answer in one (unabbreviated) word to an object named `q3_2a`.

q3_2a <- 

  # Q3.3. ---
  # 1 point
  # Apply the `sum()` function to `age`. What is the sum? Assign it to an object named
  # `q3_3`.

q3_3 <- 

  # Q3.4. ---
  # 1 point
  # This question is in three parts. You will assign those answers, in order, 
  # as character elements in a vector as the final answer. 
  # Run the `?sum` command 
  # 1) What is the one and only "argument" in the sum() function? 
  # 2) What is the default value of this argument?
  # 3) Yes or no: would different values of this argument change the output of `sum(age)`? 
  # Assign your three answers to an object named `q3_4`.

q3_4 <- 

  # Q3.5. ----
  # 1 point
  # Create a new object `age2` with the following values: 3, 6, 41, 43, NA. 
  # Then calculate the sum of `age2` using the argument `na.rm = FALSE` 
  # and then calculate the sum using the argument `na.rm = TRUE`. 

age2 <- 

  
  # To an object named `q3_5` assign answers to the following as a character vector 
  # (i.e. wrap your answers in quotes) in the order of the questions:
  # Are the two outputs of `sum(age2)` different?
  # What was the sum of values when `na.rm = FALSE`?
  # Does `na.rm` drop NA values before operating, or ignore NA values while operating? (choose "drop", or "ignore")
 
q3_5 <- 

  # Q3.6. ----
  # 1 point
  # Create a vector `tf` using the following code: `tf <- c(TRUE,FALSE,TRUE,FALSE,TRUE)`. 
  # Then apply the  `typeof()`, `length()`, and `str()` functions to the object `tf`. 

tf <- 


  # Based on this output, what is the data type of `tf`? How many elements does it contain?
  # Assign both answers, in order and as characters, to an object named `q3_6`. 

q3_6 <-

  # Q3.7. ---- 
  # 1 point
  # Apply the `sum()` function to the `tf` object, using the option to remove `NA` 
  # values prior to calculation. 



  # What numeric value do mathematical calculations in R assign to `TRUE` values? 
  # What do they assign to `FALSE` values? 
  # Assign answers as a numeric vector to an object named `q3_7`. 
  
q3_7 <- 

  # Q3.8. ---- 
  # 1 point each
  # Run the ?mean command and read the help file. In an object named `q3_8a` 
  # assign a character vector with the three main argument names of the `mean()` function
  # in the order that they appear. 
  # (do not include the generalized `...` argument)

q3_8a <- 

  # Of the last two argument names for `mean()`, what are their respective
  # default argument values? Assign your answers as a character vector to an object named 
  # `q3_8b`.

q3_8b <- 

  # When using a function, R requires you to type the values you assign to each 
  # argument (unless you choose the default value). However, the argument names 
  # are almost always optional. Even though it takes a bit more time, I usually 
  # like typing in both argument names and  argument values because it encourages  
  # you to be more conscious about what values you are assigning to which argument, 
  # especially when a function is unfamiliar. 
  
  # Below, use the `mean()` function to calculate the mean of object `tf`. 
  # In your function call, include the argument names (e.g. `x = `) and the argument value 
  # for each corresponding argument name, even if it is the default. 



  # Then run the `mean` function again but without typing any argument names (e.g. `x = `), 
  # only argument values.



## Create a GitHub issue ----
  # 2 points
  # Go to the class repository https://github.com/anyone-can-cook/rclass1_student_issues_f26 and create a new issue.
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
  # Use this naming convention "lastname_firstname_ps#" for your R script (e.g. jaquette_ozan_problemset1.R).
