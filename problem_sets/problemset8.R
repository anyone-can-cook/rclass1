## Problemset Title ----
## [ PROJ ] < Problem set 8 >
## [ FILE ] < lastname_firstname_problemset8.R >
## [ AUTH ] < Your name / GitHub handle >
## [ INIT ] < Date you started the file >

# 23 points

## Overview:

  # In this problem set, you will be using the `stringr` package (part of tidyverse) to work
  # with strings, and the `lubridate` package for working with dates and times. We will ask you
  # to load Twitter data (now X) that is saved as an .RData file.
 
## Question 1: Working with strings ----

  # Load the following packages below: `tidyverse` and `lubridate`.

rm(list=ls())
library(tidyverse)
library(lubridate)

  # Recall from lecture that str_c() joins vectors element by element. An input with only
  # one element is recycled so it gets joined to every element of the longer vector(s).
  # In the example below, "@" has one element, so it is joined to all three handles.
 
str_c("@", c("ozanj", "joebruin", "josiebruin"), sep = "", collapse = ", ")
 
  # [1] "@ozanj, @joebruin, @josiebruin" 
 
  # Q1.1 ----
  # 1 point
  # Now try it yourself. Create the string "Roses are red, Violets are blue"
  # using str_c() and the following objects as input. 

vec_1 <- c("Roses", "Violets")
vec_2 <- c("red", "blue")
str_1 <- "are"


  # Once your code produces the text "Roses are red, Violets are blue", 
  # assign the working code in quotes to an object named `q1_1`. 
  # Your code will have double quotes inside it, so put single quotes around the whole thing.
  # Like this: q1_1 <- 'str_c( ... )'.

# Write your code here
q1_1 <- 

  # Q1.2 ----
  # 2 points
  # Pig Latin (https://en.wikipedia.org/wiki/Pig_Latin) is a language game in which the
  # first consonant of each word is moved to the end of the word, then "ay" is appended
  # to create a suffix. For example, the word "Wikipedia" would become "Ikipediaway".
 
  # Using str_c() and str_sub(), turn the given pig_latin vector into the string:
  # "igpay atinlay"

pig_latin <- c('pig', 'latin')

  # We encourage you to first sketch out what you want to do on some scratch paper.
  # First, think about what the final outcome will look like.
  # Then, think about how you can get there. Play around with the str_sub() function.

  # Hint: use str_sub() twice, once to get everything after the first letter and once
  # to get the first letter by itself. Then join the pieces with str_c().
  # Once your code is working, assign it in quotes to an object named `q1_2`. 
  # Like this: q1_2 <- 'str_c( ... )'.

# Write your code here
q1_2 <- 

  # Q1.3 ----
  # 1 point
  # Using str_c() and str_sub(), decode the given secret_message back into regular English.
  # Your output should be one string (three words separated by spaces).
 
secret_message <- c('ollowfay', 'ouryay', 'earthay')

  # Follow the same logic from above, but in reverse.
  # Sketch out what you want to do on some scratch paper. Break it down step by step.
  # Hint: the words are different lengths, so count from the end of each word. 
  # Negative values for `start` and `end` in str_sub() count backward from the end.
  # Once your code is working, assign it in quotes to an object named `q1_3`. 
  # Like this: q1_3 <- 'str_c( ... )'.

# Write your code here
q1_3 <- 

## Question 2: Working with Twitter data ----
  
  # You will be using Twitter data we fetched from the following Twitter (now X) handles
  # in 2020: UniNoticias, FoxNews, and CNN.
  # This data has been saved as an RData file below:
  # https://github.com/anyone-can-cook/rclass1/raw/master/data/twitter/twitter_news.RData
 
  # Q2.1 ----
  # 1 point
  # Load the data from the url above. Use the dim() function to report the dimensions of `news_df`  
  # (rows and columns), assigning it to an object named `q2_1`.

q2_1 <- 

  # Q2.2 ----
  # 1 point
  # Subset your dataframe `news_df` and create a new dataframe called `news_df2` keeping only
  # the following variables: user_id, status_id, created_at, screen_name, text, followers_count,
  # profile_expanded_url.

news_df2 <- 

  # Q2.3 ----
  # 1 point
  # Create a new column in news_df2 called `text_len` that contains the number of characters
  # in the variable `text`. Remember to assign your changes to the existing `news_df2` object.

news_df2 <- 

  # Q2.4 ----
  # 1 point
  # What is the class and type of this new column? Use the appropriate functions and 
  # assign the class and type to an object named `q2_4`. The answers should be 2 single words 
  # in the `q2_4` vector.

q2_4 <- 

  # Q2.5 ----
  # 1 point
  # Create an additional column in `news_df2` called `handle_followers` that stores the twitter
  # handle and the number of followers associated with that twitter handle in a string. 
  # The entries in the `handle_followers` column should look like this:
  # @[twitter_handle] has [number] followers.
  # For example: @CNN has 50562050 followers.
  # Remember to assign your changes back to the `news_df2` dataframe. 

news_df2 <- 

  # Q2.6 ----
  # 1 point
  # What is the class and type of this new column? Use the appropriate functions and 
  # assign the class and type to an object named `q2_6`. The answers should be 2 single words 
  # stored as characters in the `q2_6` vector.

q2_6 <- 

  # Q2.7 ----
  # 1 point
  # Lastly, create a column in `news_df2` called `short_web` that contains a short version of the
  # `profile_expanded_url` without the http://www. part of the url. For example, the entries in
  # that column should look something like: cnn.com.
  # Hint :) every url in this column starts with http://www. so you can count how many
  # characters that is and use str_sub() to keep everything after it.
  # Remember to assign your changes back to the `news_df2` dataframe. 

news_df2 <- 

## Question 3: Working with dates/times ----

  # Q3.1 ----
  # 1 point
  # Using the column `created_at`, create a new column in `news_df2` called `dt_chr` that is a
  # character version of `created_at`. Remember to assign changes back to `news_df2`.

news_df2 <- 
 
  # Q3.2 ----
  # 1 point
  # What is the class of the `created_at` and `dt_chr` columns? Use the appropriate function and 
  # assign the classes to an object named `q3_2`. The class of `created_at` should come first,
  # then the class of `dt_chr`. 
  # NOTE!!!!: `created_at` has more than one class, so `q3_2` will have more than 2 elements. That is okay.

q3_2 <- 

  # Q3.3 ----
  # 1 point
  # Create another column in `news_df2` called `dt_len` that stores the number of characters
  # in `dt_chr` and assign your changes back to `news_df2`.

news_df2 <- 

  # Q3.4 ----
  # 2 points
  # Next, create five additional columns in `news_df2` for each of the following date/time components:

  # a. Create a new column `date_chr` for date (e.g. 2020-11-05) using the column `dt_chr` and the
  #    str_sub() function.
  # b. Do the same for year `yr_chr` (e.g. 2020).
  # c. Do the same for month `mth_chr` (e.g. 11).
  # d. Do the same for day `day_chr` (e.g. 05).
  # e. Do the same for time `time_chr` (e.g. 18:14:59).
  # Remember to assign your changes back to `news_df2`.

news_df2 <- 

  # Q3.5 ----
  # 1 point
  # Using the column `time_chr` and the str_sub() function, create additional columns in 
  # `news_df2` for the following time components:
 
  # a. `hr_chr` for hour (e.g. 18).
  # b. `min_chr` for minutes (e.g. 14).
  # c. `sec_chr` for seconds (e.g. 59).
  # Remember to assign your changes back to `news_df2`.

news_df2 <- 

  # Q3.6 ----
  # 1 point
  # Now let's get some practice with the lubridate package.
 
  # a. Using the `year()` function from the lubridate package, create a new column in `news_df2`
  #    called `yr_num` that contains the year (e.g. 2020) extracted from `date_chr`.
  # b. Do the same for month `mth_num`.
  # c. Do the same for day `day_num`.
  # d. Create a numeric hour variable `hr_num`, but extract it from `created_at` instead of `date_chr`.
  # e. Do the same for minutes `min_num`.
  # f. Do the same for seconds `sec_num`.

  # Note: year(), month(), and day() work on `date_chr` even though it is a character column,
  # because it is written in year-month-day order.
  # Hint: the lubridate functions for minutes and seconds are minute() and second().
  # Remember to assign your changes back to `news_df2`.

news_df2 <- 

  # Q3.7 ----
  # 2 points
  # Using the new numeric columns (e.g. `day_num`, `mth_num`) you've created in the previous
  # step, reconstruct the `date` and `datetime` columns. Namely, add the following columns to
  # `news_df2`:
 
  # a. Use make_date() to create new column called `my_date` that contains the date (year, month,
  #    day).
  # b. Use make_datetime() to create new column called `my_datetime` that contains the datetime
  #    (year, month, day, hour, minutes, seconds).
  # Remember to assign your changes back to `news_df2`.
 
news_df2 <- 

  # Q3.8 ----
  # 1 point
  # What is the class of your `my_date` and `my_datetime` columns? Use the appropriate function and 
  # assign the classes to an object named `q3_8`. 
  # The class of `my_date` should be the first element assigned to `q3_8` and 
  # the class of `my_datetime` should come next.
  # Note: `my_datetime` has more than one class, so `q3_8` will have more than 2 elements. That is okay.

q3_8 <- 

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

## Submit problem set ----
  # Submit your R script on Canvas.
  # Use this naming convention "lastname_firstname_problemset#" for your R script (e.g. jaquette_ozan_problemset8.R).
