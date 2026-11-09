## Problemset Title ----
## [ PROJ ] < Problem Set 5 >
## [ FILE ] < problemset5_solutions.R >
## [ AUTH ] < Teaching team >
## [ INIT ] < Solutions >

## 31 points (+1 bonus)

## About solutions ----
# Many questions can be answered more than one way. When there is more than one correct
# approach, the options are separated by `# or:`. Each option gives the same output.
# We also list the values you should see and the most common mistakes.

## Question 1: Loading library and data ----

rm(list=ls())
library(tidyverse)

load(url('https://github.com/anyone-can-cook/rclass1/raw/master/data/prospect_list/list_native_df.RData'))

list_native_df %>% head()
list_native_df %>% glimpse()

# Q1.1 ----
# Each of these variables has only two values: "Y" (the student checked the box) or NA.
# count() shows how many rows have each value. We want the `n` on the "Y" row.

list_native_df %>% count(stu_cuban)                  # Y = 182
list_native_df %>% count(stu_mexican)                # Y = 4160
list_native_df %>% count(stu_puerto_rican)           # Y = 593
list_native_df %>% count(stu_other_hispanic)         # Y = 2912
list_native_df %>% count(stu_non_hispanic)           # Y = 7248
list_native_df %>% count(stu_ethnicity_no_response)  # Y = 76

q1_1 <- c(182, 4160, 593, 2912, 7248, 76)

# Common mistakes:
# - Typing the NA counts instead of the Y counts.
# - Leaving out one of the six numbers. You need to include all six (but order doesn't matter).

# Q1.2 ----
# Same idea as Q1.1, now for the race variables.

list_native_df %>% count(stu_american_indian)   # Y = 14572
list_native_df %>% count(stu_asian)             # Y = 1120
list_native_df %>% count(stu_black)             # Y = 2202
list_native_df %>% count(stu_native_hawaiian)   # Y = 414
list_native_df %>% count(stu_white)             # Y = 7970
list_native_df %>% count(stu_race_no_response)  # Y = 23

q1_2 <- c(14572, 1120, 2202, 414, 7970, 23)

## Question 2: Recreating College Board's aggregate race/ethnicity variable ----
# This code was provided. Run it once. If you run it a second time you'll get an error,
# because the original variables were removed. Re-load the data to start over.

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

list_native_df %>% head()
list_native_df %>% glimpse()

# Q2.1 ----
# Expected: hispanic 6987, multi_race 5642, ai_an 1529, no_response 483, white 33,
# asian 3, black 2, nh_pi 1, NA 1 (9 rows)

race_cb_freq <- list_native_df %>% count(race_cb) %>% arrange(desc(n))

# or: count() can sort for you
race_cb_freq <- list_native_df %>% count(race_cb, sort = TRUE)

# or: a minus sign also sorts descending
race_cb_freq <- list_native_df %>% count(race_cb) %>% arrange(-n)

typeof(race_cb_freq)
str(race_cb_freq)

# Q2.2 ----
# typeof() says "list". A dataframe is stored as a list where each column is one element.
# race_cb_freq has 2 columns (race_cb and n), so it has 2 elements. length() confirms this.

length(race_cb_freq)

q2_2 <- c("list", 2)

# Common mistake: answering 9. That's the number of rows, not elements.

# Q2.3 ----
# typeof() tells you how R stores the object ("list"), while class() tells you what kind of
# object it is. class() includes "data.frame", so yes, it's a dataframe.

class(race_cb_freq)
is.data.frame(race_cb_freq)

q2_3 <- c("yes", 9, "race_cb", "n")

# or: TRUE also works
q2_3 <- c(TRUE, 9, "race_cb", "n")

# Common mistakes:
# - Answering "no" because typeof() said "list".
# - Listing the race_cb categories (hispanic, multi_race, ...) instead of the two
#   variable names, race_cb and n.

# Q2.4 ----
# Expected pct: hispanic 47.59, multi_race 38.43, ai_an 10.41, no_response 3.29, ...

race_cb_freq <- race_cb_freq %>% mutate(pct = n / sum(n) * 100)
# or:
race_cb_freq <- race_cb_freq %>% mutate(pct = 100 * n / sum(n))

# Common mistakes:
# - Q2.4 starts from race_cb_freq, so it only works if Q2.1 created race_cb_freq first.
#   If race_cb_freq doesn't exist, the script errors with "object 'race_cb_freq' not found".
# - Forgetting to assign back with `race_cb_freq <-`. The pct column may show in the console but it
#   isn't saved to the data. 
# - Leaving out * 100, which gives proportions (0.476) instead of percentages (47.6).

## Question 3: Summarizing across rows ----

# Q3.1 ----
# Because stu_hispanic_01 is 0/1, its mean is the share of 1s. For example, the mean of
# c(1, 0, 1, 1) is 0.75, so 75% are 1s. na.rm = TRUE leaves out students with a missing value.
# Expected: n_obs 14681, n_miss_hispanic 482, pct_hispanic 49.21

q3_1 <- list_native_df %>% 
  summarise(n_obs = n(),
            n_miss_hispanic = sum(is.na(stu_hispanic_01)),
            pct_hispanic = mean(stu_hispanic_01, na.rm = TRUE) * 100)

# or: divide the number of 1s by the number of non-missing values
q3_1 <- list_native_df %>% 
  summarise(n_obs = n(),
            n_miss_hispanic = sum(is.na(stu_hispanic_01)),
            pct_hispanic = sum(stu_hispanic_01, na.rm = TRUE) / sum(!is.na(stu_hispanic_01)) * 100)

# Common mistakes:
# - sum(stu_hispanic_01, na.rm = TRUE) / n() * 100 gives 47.59. This divides by ALL students,
#   including the 482 with a missing value, so the percentage comes out too low.
# - mean(stu_hispanic_01) * 100 without na.rm = TRUE gives NA.
# - sum(stu_hispanic_01 == NA) gives NA. Use is.na() to check for missing values.

# Q3.2 ----
# Expected: n 14681, pct_cuban 1.25, pct_mexican 28.48, pct_puerto_rican 4.06,
# pct_other_hispanic 19.94, pct_hispanic 49.21, pct_american_indian 99.41, pct_black 15.02,
# pct_native_hawaiian 2.82, pct_white 54.37

race_ethnicity_pct <- list_native_df %>% 
  summarise(n = n(),
            pct_cuban = mean(stu_cuban_01, na.rm = TRUE) * 100,
            pct_mexican = mean(stu_mexican_01, na.rm = TRUE) * 100,
            pct_puerto_rican = mean(stu_puerto_rican_01, na.rm = TRUE) * 100,
            pct_other_hispanic = mean(stu_other_hispanic_01, na.rm = TRUE) * 100,
            pct_hispanic = mean(stu_hispanic_01, na.rm = TRUE) * 100,
            pct_american_indian = mean(stu_american_indian_01, na.rm = TRUE) * 100,
            pct_black = mean(stu_black_01, na.rm = TRUE) * 100,
            pct_native_hawaiian = mean(stu_native_hawaiian_01, na.rm = TRUE) * 100,
            pct_white = mean(stu_white_01, na.rm = TRUE) * 100)

# or: across() applies the same function to many columns at once. across() keeps the
# original names (stu_cuban_01, ...), so use rename() afterward to change them.
race_ethnicity_pct <- list_native_df %>% 
  summarise(n = n(),
            across(c(stu_cuban_01, stu_mexican_01, stu_puerto_rican_01, stu_other_hispanic_01,
                     stu_hispanic_01, stu_american_indian_01, stu_black_01,
                     stu_native_hawaiian_01, stu_white_01),
                   ~ mean(.x, na.rm = TRUE) * 100)) %>% 
  rename(pct_cuban = stu_cuban_01,
         pct_mexican = stu_mexican_01,
         pct_puerto_rican = stu_puerto_rican_01,
         pct_other_hispanic = stu_other_hispanic_01,
         pct_hispanic = stu_hispanic_01,
         pct_american_indian = stu_american_indian_01,
         pct_black = stu_black_01,
         pct_native_hawaiian = stu_native_hawaiian_01,
         pct_white = stu_white_01)

# Extra (not covered in lecture): you can also rename inside across() with .names.
# sub() is find-and-replace. The inner sub() removes "stu_" and the outer one removes
# "_01", so stu_cuban_01 becomes pct_cuban.
race_ethnicity_pct <- list_native_df %>% 
  summarise(n = n(),
            across(c(stu_cuban_01, stu_mexican_01, stu_puerto_rican_01, stu_other_hispanic_01,
                     stu_hispanic_01, stu_american_indian_01, stu_black_01,
                     stu_native_hawaiian_01, stu_white_01),
                   ~ mean(.x, na.rm = TRUE) * 100,
                   .names = "pct_{sub('_01', '', sub('stu_', '', .col))}"))

# Notes:
# - Naming the count n_obs instead of n also works.
# - .names = "pct_{.col}" gives pct_stu_cuban_01, not pct_cuban.

# Common mistakes:
# - Leaving out one of the variables. Check that you have all 9 percentages.

race_ethnicity_pct %>% typeof()
race_ethnicity_pct %>% str()

# Q3.3 ----
# A list with 10 elements: n plus the 9 percentage columns. If your race_ethnicity_pct has
# a different number of columns, use length(race_ethnicity_pct) to check.

q3_3 <- c("list", 10)

# Q3.4 ----
# Yes, it's a dataframe, with 1 observation. summarise() without group_by() collapses the
# whole dataframe into one row.

q3_4 <- c("yes", 1, "n", "pct_cuban", "pct_mexican", "pct_puerto_rican", "pct_other_hispanic",
          "pct_hispanic", "pct_american_indian", "pct_black", "pct_native_hawaiian", "pct_white")

# or: let R type the names for you
q3_4 <- c("yes", 1, names(race_ethnicity_pct))

# Common mistakes:
# - Answering 10 observations. 10 is the number of elements (columns). Observations are
#   rows, and there is only 1.
# - Typos in the names, e.g. "pct_naive_hawaiian" or "pct,white". names(race_ethnicity_pct)
#   avoids this.

## Question 4: Grouping and summarizing ----

# Q4.1 ----
# This is the Q3.2 code with group_by() before summarise() and arrange() after it.
# Expected: 575 rows, 11 columns. Top 3: Houston (947), New York (936), Chicago (894)

zip_cbsa_group <- list_native_df %>% 
  group_by(zip_cbsatitle) %>% 
  summarise(n_obs = n(),
            pct_cuban = mean(stu_cuban_01, na.rm = TRUE) * 100,
            pct_mexican = mean(stu_mexican_01, na.rm = TRUE) * 100,
            pct_puerto_rican = mean(stu_puerto_rican_01, na.rm = TRUE) * 100,
            pct_other_hispanic = mean(stu_other_hispanic_01, na.rm = TRUE) * 100,
            pct_hispanic = mean(stu_hispanic_01, na.rm = TRUE) * 100,
            pct_american_indian = mean(stu_american_indian_01, na.rm = TRUE) * 100,
            pct_black = mean(stu_black_01, na.rm = TRUE) * 100,
            pct_native_hawaiian = mean(stu_native_hawaiian_01, na.rm = TRUE) * 100,
            pct_white = mean(stu_white_01, na.rm = TRUE) * 100) %>% 
  arrange(desc(n_obs))

# or: the across() + rename() version from Q3.2 also works here. Add group_by() before
# summarise() and arrange() at the end.

# Common mistakes:
# - Naming the count `n` instead of `n_obs`.
# - Sorting by a percentage instead of n_obs.

# Q4.2 ----
# Expected: 53 rows. TX is first with 2866 students, 27 missing income, and ave_inc 73714.21.
# The warnings and the NaN / Inf / -Inf values in a few rows (GU, VI, and the NA state) are
# expected: every student in those rows is missing income, so there's nothing to average.

stu_state_group <- list_native_df %>% 
  group_by(stu_state) %>% 
  summarise(n_student = n(),
            n_miss_inc = sum(is.na(zip_median_household_income)),
            ave_inc = mean(zip_median_household_income, na.rm = TRUE),
            max_inc = max(zip_median_household_income, na.rm = TRUE),
            min_inc = min(zip_median_household_income, na.rm = TRUE)) %>% 
  arrange(desc(n_student))

# Common mistake: leaving out na.rm = TRUE. Any state with even one missing income gets NA,
# including TX in the first row.

# Q4.3 ----
# Expected: 39 rows. Top 3: Health Professions 2223, Engineering 1823, Biological Science 1537

major_group_freq <- list_native_df %>% 
  group_by(stu_major_1_group_text) %>% 
  summarise(n_obs = n()) %>% 
  arrange(desc(n_obs))

# Q4.4 ----
# Same idea as Q2.4, using n_obs as the count.
# Expected pct: Health Professions 15.14, Engineering 12.42, Biological Science 10.47, ...

q4_4 <- major_group_freq %>% mutate(pct = n_obs / sum(n_obs) * 100)

# Q4.5 ----
# count() does group_by() + summarise(n = n()) in one step, so the count is named `n`.
# The pct values match Q4.4.

q4_5 <- list_native_df %>% 
  count(stu_major_1_group_text) %>% 
  arrange(desc(n)) %>% 
  mutate(pct = n / sum(n) * 100)

# or:
q4_5 <- list_native_df %>% 
  count(stu_major_1_group_text, sort = TRUE) %>% 
  mutate(pct = n / sum(n) * 100)

# Q4.6 ----
# arrange() can sort by more than one variable: first by state (A to Z), then by number of
# students within each state (highest first).
# Expected: 1006 rows, 3 columns. The first row is AK, Health Professions, 13.
# You may see a message about "regrouping output". That's normal: after summarise(), the
# result is still grouped by stu_state.

major_by_state_freq <- list_native_df %>% 
  group_by(stu_state, stu_major_1_group_text) %>% 
  summarise(n_obs = n()) %>% 
  arrange(stu_state, desc(n_obs))

# Common mistake: arrange(desc(n_obs)) alone sorts everything by count and mixes up the states.

# Q4.7 ----

q4_7 <- 1006

# or:
q4_7 <- nrow(major_by_state_freq)

# Q4.8 ----
# Each row is one state and major combination.

q4_8 <- c("state", "major")

# Q4.9 ----
# Grouping by state only gives one row per state (including NA): 53 rows.

q4_9 <- 53

# or: count the unique states
q4_9 <- n_distinct(major_by_state_freq$stu_state)

# or, after you finish Q4.10:
# q4_9 <- nrow(top_3_majors)

# Q4.10 ----
# This works because major_by_state_freq is already sorted by n_obs within each state, so
# the 1st row for each state is the top major, the 2nd row is the second, and so on.
# Expected: 53 rows. AK: Health Professions, Engineering, Biological Science

top_3_majors <- major_by_state_freq %>% 
  group_by(stu_state) %>% 
  summarise(top_major = first(stu_major_1_group_text),
            second_major = nth(stu_major_1_group_text, 2),
            third_major = nth(stu_major_1_group_text, 3))

# or: use [ ] to pick the 1st, 2nd, and 3rd values within each state
top_3_majors <- major_by_state_freq %>% 
  group_by(stu_state) %>% 
  summarise(top_major = stu_major_1_group_text[1],
            second_major = stu_major_1_group_text[2],
            third_major = stu_major_1_group_text[3])

# Notes:
# - States with fewer than 3 majors (like GU) get NA for the missing ones. That's expected.
# - If Q4.6 isn't sorted correctly, this question will also be wrong.

# You can check Q4.9:
nrow(top_3_majors)

## Question 5: Bonus (1 point extra credit) ----
# Any analysis using the `list_native_df` assigned to object `q5` gets credit!

## Create a GitHub issue ----
# Use the URLs to your own issue and reply, in quotes.

issue <- "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/1"
reply <- "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/2"

## Before you submit ----
# - Fill in or delete any line that ends in `<- ` with nothing after it. A blank `<- ` in the
#   file crashes the whole script.
# - Restart R (Session > Restart R) and run your script from the top. If it stops with an
#   error, fix that line before submitting.