## Problemset Title ----
## [ PROJ ] < Problem set 4 SOLUTIONS >
## [ FILE ] < problemset4_solutions.R >
## [ AUTH ] < Teaching team >

## How to use this file ----
# Some questions can be answered more than one way. When that happens, the different
# options are separated by "# or". Any of them would get full credit.
# Under each answer you'll find the common mistakes seen while grading.

rm(list=ls())

## Question 1: Data manipulation using pipes ----
# Q1.1 ----
# You should end up with df_school_all: 21301 rows and 55 columns.

library(tidyverse)
load(url("https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_school_allvars.RData"))

dim(df_school_all)

# Common mistakes:
# - Loading the data from a file on your own computer, e.g. load("/Users/you/Downloads/...").
#   That file doesn't exist on anyone else's computer, so the script can't run there.
# - Running the load line only in the console. Every line your script needs has to be
#   IN the script, or it won't work when it's run from top to bottom.

# Q1.2 ----
# Sort by med_inc from highest to lowest, keep the 11 variables, then keep the first 10 rows.
# You should see "Los Altos High" in row 1.

q1_2 <- df_school_all %>% 
  arrange(desc(med_inc)) %>% 
  select(name, state_code, city, school_type, total_visits, med_inc, pct_white, 
         pct_black, pct_hispanic, pct_asian, pct_amerindian) %>% 
  head(10)

# or: select() first, then arrange() (the order of these two doesn't matter here)
q1_2 <- df_school_all %>% 
  select(name, state_code, city, school_type, total_visits, med_inc, pct_white, 
         pct_black, pct_hispanic, pct_asian, pct_amerindian) %>% 
  arrange(desc(med_inc)) %>% 
  head(10)

q1_2

# Common mistakes:
# - Writing the data again inside each function, e.g. arrange(.data = df_school_all, ...) or
#   head(x = df_school_all, n = 10). The pipe already passes the data along, so naming it
#   again makes R start over from the original, unsorted data.
# - Putting one function inside another, e.g. arrange(desc(med_inc), select(...)).
#   Each function is its own step, connected with %>%.

# Q1.3 ----
# Same as Q1.2, but only public schools in New York.
# The values in the data are lowercase. Check with: df_school_all %>% count(school_type)
# You should see "HORACE GREELEY HIGH SCHOOL" in row 2.

q1_3 <- df_school_all %>% 
  filter(state_code == "NY", school_type == "public") %>% 
  arrange(desc(med_inc)) %>% 
  select(name, state_code, city, school_type, total_visits, med_inc, pct_white, 
         pct_black, pct_hispanic, pct_asian, pct_amerindian) %>% 
  head(10)

# or: sort first, then filter, and use & instead of a comma inside filter()
q1_3 <- df_school_all %>% 
  arrange(desc(med_inc)) %>% 
  filter(state_code == "NY" & school_type == "public") %>% 
  select(name, state_code, city, school_type, total_visits, med_inc, pct_white, 
         pct_black, pct_hispanic, pct_asian, pct_amerindian) %>% 
  head(10)

q1_3

# Common mistakes:
# - Using head() before filter(). Then you're filtering the top 10 schools in the whole
#   country, and only 2 of those are in New York.
# - Writing "Public" or "NEW YORK". The values have to match the data exactly: "public", "NY".
# - Using | (OR) instead of a comma or &. That gives every NY school PLUS every public school.

# Q1.4 ----
# Same as Q1.3, but private schools.
# You should see "IONA PREPARATORY SCHOOL" in row 3.

q1_4 <- df_school_all %>% 
  filter(state_code == "NY", school_type == "private") %>% 
  arrange(desc(med_inc)) %>% 
  select(name, state_code, city, school_type, total_visits, med_inc, pct_white, 
         pct_black, pct_hispanic, pct_asian, pct_amerindian) %>% 
  head(10)

q1_4

## Question 2: Variable creation using `tidyverse`'s `mutate()` ----

df_school_all %>% count()
df_school_all %>% filter(is.na(med_inc)) %>% count()
df_school_all %>% count(school_type)

# Q2.1 ----
# if_else(condition, 1, 0) gives a 1 when the condition is TRUE and a 0 when it's FALSE.
# q2_1 is the whole dataframe with the new ca_school column added.
# 1770 schools should have ca_school = 1.

q2_1 <- df_school_all %>% mutate(ca_school = if_else(state_code == "CA", 1, 0))

# Common mistakes:
# - mutate(ca_school = state_code == "CA") without if_else(). That gives TRUE/FALSE
#   instead of 1/0.
# - Using = instead of == inside the condition. = assigns, == compares.

# Q2.2 ----
# You should get 2 rows: ca_school = 0 (19531 schools) and ca_school = 1 (1770 schools).

q2_2 <- q2_1 %>% count(ca_school)

q2_2

# Q2.3 ----
# Both things have to be true (in California AND public), so join them with &.
# 1404 schools should have ca_pub_school = 1.

q2_3 <- df_school_all %>% 
  mutate(ca_pub_school = if_else(state_code == "CA" & school_type == "public", 1, 0))

# or: build on q2_1 and reuse the ca_school variable you already made
q2_3 <- q2_1 %>% 
  mutate(ca_pub_school = if_else(ca_school == 1 & school_type == "public", 1, 0))

# Common mistake: using | (OR) instead of &. That counts every CA school plus every
# public school in the country.

# Q2.4 ----
# You should get 2 rows: ca_pub_school = 0 (19897 schools) and ca_pub_school = 1 (1404 schools).

q2_4 <- q2_3 %>% count(ca_pub_school)

q2_4

## Question 3 ----
# Q3.1 ----
# df_race should have 21301 rows and 4 columns.

df_race <- df_school_all %>% select(name, pct_black, pct_hispanic, pct_amerindian)

# Q3.2 ----
# filter(is.na(x)) keeps only the rows where x is missing, and count() counts them.
# Each one should give n = 0, which means there are no missing values.

q3_2_a <- df_race %>% filter(is.na(pct_black)) %>% count()
q3_2_b <- df_race %>% filter(is.na(pct_hispanic)) %>% count()
q3_2_c <- df_race %>% filter(is.na(pct_amerindian)) %>% count()

# or: start from df_school_all instead of df_race (same answer)
q3_2_a <- df_school_all %>% filter(is.na(pct_black)) %>% count()
q3_2_b <- df_school_all %>% filter(is.na(pct_hispanic)) %>% count()
q3_2_c <- df_school_all %>% filter(is.na(pct_amerindian)) %>% count()

q3_2_a; q3_2_b; q3_2_c

# Common mistakes:
# - Putting a variable inside count(), e.g. count(pct_black). Since no rows are left after
#   filter(), you get an empty table instead of n = 0. Use count() with nothing inside.
# - Using count(is.na(pct_black)) without filter(). That counts every row (n = 21301).

# Q3.3 ----
# None of the three variables had missing values, so the answer is 0.

q3_3 <- 0

# Common mistake: q3_3 <- "0". The quotes make it text, not an integer/double.

# Q3.4 ----
# Add the three columns together with +, and save the result back into df_race.
# The average of pct_bl_hisp_nat should be about 32.2.

df_race <- df_race %>% mutate(pct_bl_hisp_nat = pct_black + pct_hispanic + pct_amerindian)

mean(df_race$pct_bl_hisp_nat)

# Common mistake: using sum(pct_black, pct_hispanic, pct_amerindian) inside mutate().
# sum() adds up every value in all three columns into one big number, so every school
# gets the same value. Use + to add them school by school.

# Q3.5 ----
# "More than 50%" means > 50, not >= 50.
# 5600 schools should have gt50pct_bl_hisp_nat = 1.

df_race <- df_race %>% mutate(gt50pct_bl_hisp_nat = if_else(pct_bl_hisp_nat > 50, 1, 0))

# Common mistakes:
# - Leaving out if_else(), e.g. mutate(gt50pct_bl_hisp_nat = pct_bl_hisp_nat > 50, 1, 0).
#   Then the new variable is TRUE/FALSE, and mutate() also adds two extra columns: one full
#   of 1s and one full of 0s.
# - Using >= 50 instead of > 50. That gives 5614 instead of 5600.
# - Spelling the variable name differently from the instructions. Copy it exactly.

# Q3.6 ----
# You should get 2 rows: 0 (15701 schools) and 1 (5600 schools).

q3_6 <- df_race %>% count(gt50pct_bl_hisp_nat)

q3_6

# Q3.7 ----
# The question asks for the percent of ALL schools, so divide by the total number of schools:
# 5600 / 21301 = 0.263, which is 26%.

q3_7 <- 26

# or: calculate it from your table in Q3.6
q3_7 <- round(q3_6$n[2] / sum(q3_6$n) * 100)

q3_7

# Common mistakes:
# - Dividing by 15701 (the schools that are NOT over 50%) instead of the total.
#   5600 / 15701 gives 36%, which is the wrong answer.
# - Entering the count (5600) instead of the percent.
# - Entering 0.26. The question asks for a whole-number percent, so 26.

## Question 4 ----
# Q4.1 ----
# df_schools should have 21301 rows and 2 columns.

df_schools <- df_school_all %>% select(name, state_code)

# Q4.2 ----
# This case_when() code was given to you in the problem set. The part you wrote was q4_2.
# case_when() checks each line from top to bottom, and the first one that's TRUE decides
# the value. .default gives a value to everything that didn't match (DC ends up in South).
# You should see: Midwest 5809, Northeast 3931, South 7367, West 4194

df_schools <- df_schools %>% 
  mutate(region = case_when(
    state_code %in% c('CT','ME','MA','NH','RI','VT','NJ','NY','PA') ~ 'Northeast',
    state_code %in% c('IN','IL','MI','OH','WI','IA','KS','MN','MO','NE','ND','SD') ~ 'Midwest',
    state_code %in% c('AZ','CO','ID','NM','MT','UT','NV','WY','AK','CA','HI','OR','WA') ~ 'West',
    .default = 'South'
  ))

q4_2 <- df_schools %>% count(region)

q4_2

# Common mistake: saving the case_when() code into q4_2. q4_2 is only the frequency table,
# df_schools %>% count(region).

# Q4.3 ----
# recode_values() swaps old values for new ones, written as "old value" ~ "new value".
# Every region has its own line, so no default is needed here.
# You should see the same counts as Q4.2, with the new labels: MW, NE, S, W.

df_schools <- df_schools %>% 
  mutate(region = recode_values(region, "Northeast" ~ "NE", "Midwest" ~ "MW", 
                                "West" ~ "W", "South" ~ "S"))

q4_3 <- df_schools %>% count(region)

q4_3

# Common mistakes:
# - Adding %>% count(region) to the line that saves df_schools. That replaces your whole
#   dataframe with the small count table, so state_code is gone and Q4.4 can't work.
#   Save df_schools first, then make q4_3 on its own line.
# - Writing Northeast = "NE" (the style of the older recode() function). recode_values()
#   needs "Northeast" ~ "NE".
# - Getting 'could not find function "recode_values"'. recode_values() is new, so update
#   dplyr by running install.packages("dplyr") in the console, then restart R.

# Q4.4 ----
# Make a NEW variable, state_name. Don't change state_code.
# Any third state works, as long as it's in the data. Texas is used here.
# You should see: California 1770, New York 1491, Texas 1599, Other 16441

df_schools <- df_schools %>% 
  mutate(state_name = case_when(
    state_code == "CA" ~ "California",
    state_code == "NY" ~ "New York",
    state_code == "TX" ~ "Texas",
    .default = "Other"
  ))

# or: recode_values(). Note that its default is spelled WITHOUT a dot.
df_schools <- df_schools %>% 
  mutate(state_name = recode_values(state_code, 
                                    "CA" ~ "California", "NY" ~ "New York", "TX" ~ "Texas", 
                                    default = "Other"))

df_schools %>% count(state_name)

# Common mistakes:
# - Writing mutate(state_code = ...) instead of mutate(state_name = ...). That changes
#   state_code instead of making a new variable.
# - Mixing up .default and default. case_when() uses .default (with a dot);
#   recode_values() uses default (no dot).
# - Leaving out the default. Every other state then becomes NA instead of "Other".


## Create a GitHub issue ----
# Your answers should be the links to your own issue and to your reply on someone else's.
# The links below are just examples.

issue <- "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/1"

reply <- "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/2#issuecomment-1234567890"


## Before you submit (for next time) ----
# Two things that made scripts crash this week:
# - A blank line ending in <- (for example, if you skipped a question). R joins it to the
#   next line of code it finds, which can break other answers. If you skip a question,
#   put a # in front of its blank line.
# - An extra %>% at the end of a pipe. R then thinks the next line is part of the same pipe.
# Run your whole script from the top (with rm(list=ls()) first) before you submit.
# If it runs without errors for you, it will run for the autograder too.