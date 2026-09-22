## Problemset Title >
## [ PROJ ] < Problem set 9 >
## [ FILE ] < lastname_firstname_problemset9.R >
## [ AUTH ] < Your name / GitHub handle >
## [ INIT ] < Date you started the file >

  # 17 points

## Overview ----
    
  # This problem set has three parts.
 
  # 1. We will ask you some definitional/conceptual questions about the concepts introduced in
  # lecture.

  # 2. Tidying untidy data: reshaping from long to wide.
  # E.g., dataset has one row for each combination of university ID and enrollment age group,
  # but you want a dataset with one row per university ID and one enrollment variable for each
  # age group.
  # For these questions we'll use fall enrollment data from the Integrated Postsecondary Data
  # System (IPEDS), specifically the fall enrollment sub-survey that focuses on enrollment by
  # age group.

  # 3. Tidying untidy data: reshaping from wide to long
  # For these questions we'll use data from the NCES Digest of Education Statistics that
  # contains data about the total number of teachers in each state.
 
  # Load libraries here
  # Note: _If you do not have the_ `pivot_wider()` _and_ `pivot_longer()` _functions, you may need
  # to update your_ `tidyr` _package using_ `install.packages('tidyr')`.

library(tidyverse)
library(haven)
library(labelled)

rm(list = ls()) # remove all objects

## Question 1: Conceptual questions ----

  # Q1.1 ----
  # 1 point

  # To which dimension of a dataframe does a "unit of analysis" [our term; not necessarily used outside this
  # class] belong? Assign a one word answer to an object named `q1_1`.

q1_1 <- 

  # Q1.2 ----
  # 3 points
  # The "three rules of tidy data" state three unique pairings; That each data _concept_ 
  # (variables, values, etc.) must have their own _structure_ of the 2-dimensional data frame 
  # (a row, a column, etc.). 
  # What are these three tidy data pairings?
  # Assign your answers to an object named `q1_2` as a data.frame with three columns,
  # where each column is one pairing, like this: c("concept", "structure").

q1_2 <- 

## Question 2: Questions about reshaping long to wide ----

  # __Description of the data__
 
  # For these questions, we'll be using data from the Fall Enrollment survey component of the
  # Integrated Postsecondary Education Data System (IPEDS)
 
  # Specifically, we'll be using data from the survey sub-component that focuses on enrollment by
  # age-group
  # The dataset we'll be using is from Fall 2016 (i.e., Fall of the 2016-17 academic year)
  # Here is a link to the data dictionary (an excel file) for the enrollment by age dataset:
  # https://nces.ed.gov/ipeds/datacenter/data/EF2016B_Dict.zip

  # In the dataset you load below:
  # 1. We've dropped a few of the variables from the raw enrollment by age data
  # 2. We've added a few variables from the "institutional characteristics" survey (e.g.,
  # institution name, state, sector) that should be pretty self explanatory if you examine the
  # variable labels and/or value labels
  # 3. The variable `unitid` is the ID variable for each college/university
  # 4. The dataset has one observation for each combination of the variables `unitid`-`efbage`-
  # `lstudy`
 
  # __Overview of the tasks__
 
  # Load the dataframe and assign it the name `age_f16_allvars_allobs`. [done for you]
  # Create a new dataframe called `agegroup1_obs` based on `age_f16_allvars_allobs`. [done for you]
  # `agegroup1_obs` will have fewer variables than `age_f16_allvars_allobs` and contains
  # only observations where age-group equals `1` (1 = All age categories total).

  # You will be reshaping `agegroup1_obs` from long to wide.

## Load data and create `agegroup1_obs`

  # Load IPEDS data that contains fall enrollment by age.
 
  # __NOTE: IN THIS SECTION, WE GIVE YOU THE ANSWERS; ALL YOU HAVE TO DO IS RUN THE CODE BELOW

# Read Stata data into R using read_dta() function from haven package
age_f16_allvars_allobs <- read_dta(
  file = "https://github.com/anyone-can-cook/rclass1/raw/master/data/ipeds/ef/age/ef_age_ic_fall_2016.dta",
  encoding = NULL
)

  # Rename a couple of variables (due to re-assignment, this code will throw an error if run a second time. This is okay.)
age_f16_allvars_allobs <- age_f16_allvars_allobs %>%
  rename(agegroup = efbage, levstudy = lstudy)

  # Variable names and variable labels
  # Familiarize yourself with these
names(age_f16_allvars_allobs)
age_f16_allvars_allobs %>% var_label()

  # Create new dataframe based on `age_f16_allvars_allobs`.
  # __NOTE: IN THIS QUESTION, WE GIVE YOU THE ANSWERS; ALL YOU HAVE TO DO IS RUN THE CODE BELOW

agegroup1_obs <- age_f16_allvars_allobs %>%
  select(fullname, unitid, agegroup, levstudy, efage09, stabbr, locale, sector) %>%
  filter(agegroup == 1) %>%
  select(-agegroup)

glimpse(agegroup1_obs)

## Reshaping `agegroup1_obs` from long to wide

  # Q2.1 ----
  # Run whatever investigations seem helpful for you to get to know the data (e.g., list
  # variable names, list variable labels, list variable values, tabulations). Then answer the 
  # questions below

names(agegroup1_obs)
str(agegroup1_obs)
agegroup1_obs %>% var_label()

#sort
agegroup1_obs <- agegroup1_obs %>% arrange(unitid, levstudy)

#print a few obs
agegroup1_obs %>% head(n=10) %>% as_factor

#frequency of level of study variable
agegroup1_obs %>% select(levstudy) %>% val_labels()
agegroup1_obs %>% count(levstudy) %>% as_factor

#frequency of sector variable
agegroup1_obs %>% select(sector) %>% val_labels()
agegroup1_obs %>% count(sector) %>% as_factor

#frequency of locale variable
agegroup1_obs %>% select(locale) %>% val_labels()
agegroup1_obs %>% count(locale) %>% as_factor %>% arrange(desc(n)) 

  # 1 point each
  # Q2.1a
  # What two variables represent the same thing but using different values in `agegroup1_obs`?
  # Assign your answer to a new object named `q2_1a` as two character elements:
  # `q2_1a <- c("var1","var2")`

q2_1a <- 

  # Q2.1b
  # What are the levels of student in the `agegroup1_obs` data?
  # Answer with the actual levels' labels by looking at the value labels (not the numeric values). 
  # Assign your answer to a new object named `q2_1b` like this:
  # `q2_1b <- c("lvl1","lvl2" ... )`. Answers must be assigned in order that the labels appear!

q2_1b <- 

  # Q2.1c
  # How many educational sectors are in the `agegroup1_obs` data?
  # How many _labels_ does the `sector` variable have? 
  # Assign the two answers as numbers to a new object named `q2_1c`:
  # `q2_1c <- c(123, 456)`

q2_1c <- 

  # Q2.1d
  # Which `locale` type is the most frequently observed locale in the `agegroup1_obs` data?
  # Make sure your answer matches the format of the value label (e.g.: "23. Suburb: Small")
  # Assign the answer to a new object named `q2_1d`. 
  # `q2_1d <- c("answer")`

q2_1d <- 

  # Q2.2 ----
  # 2 points
  # Confirm that there is one row per each combination of `unitid`-`levstudy`
  # by creating a summary table of the observations per grouped variables.
  # Use a combination of group_by(), summarise(), ungroup(), and count() to create the 
  # summary statistic, and name it `n_per_group`. Assign this to an object named
  # `q2_2`.
  #   Hint: See section 2.3, "Unit of Analysis", of the Tidy Data lecture for examples.

q2_2 <- 

  # Q2.3 ----
  # 1 point
  # Using the code from the previous question as a guide, confirm that the object
  # `agegroup1_obs` has more than one observation for each value of `unitid` by grouping by
  # just that variable.

q2_3 <- 

  # Q2.4 ----
  # 1 point each
  # Does the dataframe `agegroup1_obs` meet each of the three criteria for tidy
  # data? In an object named `q2_4a` assign a value "yes" or "no".

q2_4a <- 

  # Which variable in the `agegroup1_obs` data _should_ be the unique unit of analysis?
  # Assign your answer to an object named `q2_4b` as a character class value.

q2_4b <- 

  # Which variable adds multiple rows of observations, yet should _not_ be considered
  # the unit of analysis? Assign your answer to an object named `q2_4c` as a character class value.

q2_4c <- 

  # Q2.5 ----
  # 2 points
  # To make the `agegroup1_obs` data frame into tidy data, we need to widen the data frame. 
  # This requires using `names_from` and `values_from` in the pivot_wider() function.
  
  # `names_from` draws new column names from which variable's values?
  # `values_from` draws new column values from which variable?
  # Assign your answers (in order) to an object named `q2_5` as character class elements.

q2_5 <- 
 
  # Q2.6 ----
  # 2 points
  # Tidy the dataframe `agegroup1_obs` and assign this to a new object named
  # `agegroup1_obs_tidy`

agegroup1_obs %>% head(n=5)

agegroup1_obs_tidy <- 

agegroup1_obs_tidy %>% head(n=5)

  # Q2.7 ----
  # 1 point
  # Once more, confirm whether the new object `agegroup1_obs_tidy` contains one observation 
  # for each value of `unitid`. Assign the summarized object (refer back to q2.2 and q2.3)
  # to a new object named `q2_7`.

q2_7 <- 

  # Q2.8 ----
  # 3 points
  # Create a new object `agegroup1_obs_tidy_v2` from the object `agegroup1_obs` by performing
  # the following steps in one line of code with multiple pipes:
 
  # 1) Create a new variable called `level` that is a recoded character version of the 
  # `levstudy` variable. Check the value labels of `levstudy` with val_labels() to see 
  # what each numeric value represents. Then recode the corresponding numeric values 
  # into character values `all`, `ug`, and `grad`. These should become your new column names.

  # 2) Drop the original variable `levstudy`.
  # 3) Tidy the dataset (similar to Q2.6).

#attributes(agegroup1_obs$levstudy)
val_labels(agegroup1_obs$levstudy)
var_label(agegroup1_obs$levstudy)

agegroup1_obs_tidy_v2 <- 

  # Print the first few observations of `agegroup1_obs_tidy_v2`. Why is this dataframe
  # preferable over `agegroup1_obs_tidy`?
 
  # YOUR ANSWER HERE: 

agegroup1_obs_tidy_v2 %>% head(n=5)

## Question 3: Questions about reshaping wide to long ----

  # Here, we load a table from NCES Digest of Education Statistics that contains data about the
  # total number of teachers in each state for particular years.

load(url("https://github.com/anyone-can-cook/rclass1/raw/master/data/nces_digest/nces_digest_table_208_30.RData"))

  # Code below converts character variables for teacher totals to integers
table208_30[2:6] <- data.frame(lapply(table208_30[2:6], as.integer))

  # Q3.1 ----
  # 1 point each
  # The pivot_longer() function needs several parameters to obtain values and names 
  # pulled from multiple columns and their column names. With regard to that,
  # answer the following questions on how to pivot the `table208_30` data frame to longer:

  # What variable information is actually being stored in the column names of the 
  # `tot_fall_XXXX` variables? Assign your answer as a single word to an object 
  # named `q3_1a`.  

q3_1a <- 


  # What exact string/text in the column names is like a prefix to the year value? 
  # Assign your answer as a single string to an object named `q3_1b`.

q3_1b <- 

  # How many rows would there be _per state_ after creating a new `year` variable from the 
  # `tot_fall_xxxx` columns?
  # Assign your answer to an object named `q3_1c`.

q3_1c <- 

  # What people/professionals are represented by the numeric values in the `tot_fall_xxxx` columns?
  # Assign your answer as a single word to an object named `q3_1d`.

q3_1d <- 

  # Q3.2 ----
  # 2 points
  # Tidy the dataframe `table208_30` and create a new object `table208_30_tidy`.
  # Name the new variables as you see fit.
  #   Hint: Specify the column name pattern with `cols = starts_with(...)` to specify the columns
  #   and `names_prefix = ...` to specify the values hidden in the column names.

table208_30_tidy <- 

## Question 4: Bonus (up to 10% extra credit) ----

  # Create a graph using data that you used in this problem set. Make sure to title and label the
  # plot appropriately and customize it how you'd like. Add a color palette from `Rcolorbrewer` or
  # curate your own color palette. Then, write some text describing your findings or observations.
 
  # **Note:** The teaching team will not answer questions related to the bonus question. Instead,
  # feel free to ask your classmates on GitHub (make sure to include the "bonus" label in your
  # issue).

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
  # Use this naming convention "lastname_firstname_ps#" for your R script (e.g. jaquette_ozan_problemset9.R).
