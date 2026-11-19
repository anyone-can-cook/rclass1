## Problemset Title ----
## [ PROJ ] < Problem Set 6 SOLUTIONS >
## [ FILE ] < problemset6_solutions.R >

## About these solutions ----
  # For many questions there is more than one way to get the right answer.
  # When we show more than one option, they are separated by "# or". Any of them gets full credit.
  # We also note common mistakes we saw, so you can see where points were lost.
  # Everything in this script runs top to bottom. Some options use recode_values(),
  # which needs dplyr 1.2.0 or newer (check with packageVersion("dplyr")).

library(tidyverse)
library(haven)
library(labelled)

rm(list=ls())
nls_crs <- read_dta(file="https://github.com/anyone-can-cook/rclass1/raw/master/data/nls72/nls72petscrs_v2.dta")

## Question 1: Data investigation ----

  # 1.1 ----
typeof(nls_crs$crsgrada)  # "character"
str(nls_crs$crsgrada)     # values like "A", "B+", "W" -> letter grades
str(nls_crs$gradtype)     # labels: 1 = letter, 2 = numeric, 9 = missing

q1_1 <- c("character", "letter", "missing")

  # Note: crsgrada also has "99" values, but those are missing codes, not number grades.

  # 1.2 ----
nls_crs %>% count(gradtype)
  # 1 = letter: 459,348 | 2 = numeric: 10,517 | 9 = missing: 14,657

q1_2 <- c(14657, 459348, 10517)

  # Common mistake: putting the numbers in the order they appear in the table
  # (letter, numeric, missing) instead of the order asked (missing, letter, numeric).

  # 1.3 ----
nls_crs %>% select(itype) %>% val_labels()
  # The labels go 1, 2, 3, 4, 5, 6, 8 -- there is no 7! So there are 7 types, not 8.

q1_3 <- 7

  # or count the labels instead of reading the highest number
q1_3 <- length(val_labels(nls_crs$itype))

  # Common mistake: answering 8 because the last code is 8, or because count(itype) shows
  # 8 rows (one of those rows is NA, which is not an institution type).

  # 1.4 ----
nls_crs %>% filter(crsecred == 0) %>% nrow()                     # zero credits: 11,500
nls_crs %>% filter(crsecred < 999) %>% count(crsecred) %>%
  arrange(desc(crsecred))                                         # highest: 230
nls_crs %>% count(crsecred) %>% arrange(desc(n))                 # most common: 3
nls_crs %>% filter(crsecred > 900) %>% nrow()                    # missing: 18,819

q1_4 <- c(11500, 230, 3, 18819)

  # or for the missing count
nls_crs %>% filter(crsecred %in% c(999, 999.999)) %>% nrow()

  # Common mistake: only counting crsecred == 999 (497 rows) and missing the 999.999 rows.
  # Note: 999.999 prints as "1000." in count() output because R rounds when it prints.

  # 1.5 ----
nls_crs %>% filter(crsgradb > 900) %>% nrow()

q1_5 <- 99916

  # 1.6 ----
nls_crs %>% count(crsgrada)
  # "99" is the first row: 24,814

q1_6 <- 24814

  # or
nls_crs %>% filter(crsgrada == "99") %>% nrow()

  # Note: crsgrada is character, so the value is "99" in quotes.

  # 1.7 ----
nls_crs %>% filter(crsgradb > 900) %>% count(crsgrada) %>% print(n=40)

q1_7 <- 14014

  # 1.8 ----
nls_crs %>% filter(gradtype %in% c(1,2), crsgrada == '99', crsgradb > 900) %>% count(crsgrada, crsgradb)

q1_8 <- 84

  # or, "not missing" written as gradtype != 9
nls_crs %>% filter(gradtype != 9, crsgrada == '99', crsgradb > 900) %>% count(crsgrada, crsgradb)


## Question 2: Creating new grade variables ----

  # Q2.1 ----
nls_crs <- nls_crs %>% mutate(crsgrada_fac = factor(crsgrada))

  # or
nls_crs <- nls_crs %>% mutate(crsgrada_fac = as.factor(crsgrada))

  # or (haven's version)
nls_crs <- nls_crs %>% mutate(crsgrada_fac = as_factor(crsgrada))

typeof(nls_crs$crsgrada_fac)      # "integer" -- factors are stored as integers
class(nls_crs$crsgrada_fac)       # "factor"
attributes(nls_crs$crsgrada_fac)  # 25 levels, in alphabetical order

  # Q2.2 ----
  # Option 1: case_when()
nls_crs <- nls_crs %>%
  mutate(numgrade_1 = case_when(
    crsgrada_fac == "A+" ~ 4,
    crsgrada_fac == "A"  ~ 4,
    crsgrada_fac == "A-" ~ 3.7,
    crsgrada_fac == "B+" ~ 3.3,
    crsgrada_fac == "B"  ~ 3,
    crsgrada_fac == "B-" ~ 2.7,
    crsgrada_fac == "C+" ~ 2.3,
    crsgrada_fac == "C"  ~ 2,
    crsgrada_fac == "C-" ~ 1.7,
    crsgrada_fac == "D+" ~ 1.3,
    crsgrada_fac == "D"  ~ 1,
    crsgrada_fac == "D-" ~ 0.7,
    crsgrada_fac == "F"  ~ 0,
    crsgrada_fac == "E"  ~ 0,
    crsgrada_fac == "WF" ~ 0,
    .default = NA_real_
  ))

  # or, shorter, using %in% to group grades that get the same value
nls_crs <- nls_crs %>%
  mutate(numgrade_1 = case_when(
    crsgrada_fac %in% c("A+", "A")      ~ 4,
    crsgrada_fac == "A-"                ~ 3.7,
    crsgrada_fac == "B+"                ~ 3.3,
    crsgrada_fac == "B"                 ~ 3,
    crsgrada_fac == "B-"                ~ 2.7,
    crsgrada_fac == "C+"                ~ 2.3,
    crsgrada_fac == "C"                 ~ 2,
    crsgrada_fac == "C-"                ~ 1.7,
    crsgrada_fac == "D+"                ~ 1.3,
    crsgrada_fac == "D"                 ~ 1,
    crsgrada_fac == "D-"                ~ 0.7,
    crsgrada_fac %in% c("F", "E", "WF") ~ 0,
    .default = NA_real_
  ))

  # or Option 2: recode_values() (dplyr 1.2.0+)
  # Note: the syntax is "old" ~ new, and it's `default` with NO dot
nls_crs <- nls_crs %>%
  mutate(numgrade_1 = recode_values(crsgrada_fac,
    c("A+", "A")      ~ 4,
    "A-"              ~ 3.7,
    "B+"              ~ 3.3,
    "B"               ~ 3,
    "B-"              ~ 2.7,
    "C+"              ~ 2.3,
    "C"               ~ 2,
    "C-"              ~ 1.7,
    "D+"              ~ 1.3,
    "D"               ~ 1,
    "D-"              ~ 0.7,
    c("F", "E", "WF") ~ 0,
    default = NA_real_
  ))

  # Common mistakes:
  #   Forgetting E or WF (they are easy to miss at the end of the list)
  #   Using `.default` in recode_values() or `default` in case_when() -- one has a dot, one doesn't
  #   Putting the numbers in quotes ("4"), which makes the variable character instead of numeric

  # Q2.2a ----
nls_crs %>% count(numgrade_1)
  # NA row at the bottom: 94,598

q2_2a <- 94598

  # or
q2_2a <- sum(is.na(nls_crs$numgrade_1))

  # Q2.3a ----
nls_crs %>% filter(crsgradb > 4 & crsgradb < 900) %>% nrow()

q2_3a <- 127

  # Q2.3b ----
nls_crs <- nls_crs %>% mutate(numgrade_2 = if_else(crsgradb > 4, NA_real_, crsgradb))

  # or
nls_crs <- nls_crs %>% mutate(numgrade_2 = case_when(crsgradb <= 4 ~ crsgradb))

  # Note: "greater than 4" also catches the 999 and 999.999 missing codes, so they become NA too.

nls_crs %>% count(numgrade_2) %>% arrange(desc(n))

  # Q2.4 ----
nls_crs <- nls_crs %>% mutate(crsecred_2 = if_else(crsecred >= 999, NA_real_, crsecred))

  # or
nls_crs <- nls_crs %>% mutate(crsecred_2 = if_else(crsecred %in% c(999, 999.999), NA_real_, crsecred))

  # or
nls_crs <- nls_crs %>% mutate(crsecred_2 = case_when(crsecred < 999 ~ crsecred))

nls_crs %>% count(crsecred_2) %>% arrange(desc(crsecred_2))  # top value should now be 230
  # Common mistake: only replacing 999, so 999.999 is still there (shows as "1000." in count()).

  # Q2.5 ----
nls_crs <- nls_crs %>%
  mutate(numgrade_3 = case_when(
    gradtype == 1 & !is.na(crsecred_2) ~ numgrade_1,
    gradtype == 2 & !is.na(crsecred_2) ~ numgrade_2
  ))
  # Every row that doesn't match either condition (gradtype 9, or missing credits) becomes NA.

  # or, with nested if_else()
nls_crs <- nls_crs %>%
  mutate(numgrade_3 = if_else(gradtype == 1 & !is.na(crsecred_2), numgrade_1,
                              if_else(gradtype == 2 & !is.na(crsecred_2), numgrade_2, NA_real_)))

nls_crs %>% count(is.na(numgrade_3))  # 87,833 NA
  # Common mistake: leaving out the `!is.na(crsecred_2)` part, so rows with missing
  # credits still get a grade.

  # Q2.6 ----
nls_crs %>% filter(!is.na(crsecred_2), is.na(numgrade_3)) %>% nrow()

q2_6 <- 69014

  # Q2.7 ----
nls_crs <- nls_crs %>% mutate(crsecred_3 = if_else(is.na(numgrade_3), NA_real_, crsecred_2))

  # or
nls_crs <- nls_crs %>% mutate(crsecred_3 = case_when(!is.na(numgrade_3) ~ crsecred_2))

nls_crs %>% filter(is.na(numgrade_3)) %>% count(crsecred_3)  # should only show NA

  # Q2.8 ----
  # Any clear label is fine
nls_crs <- nls_crs %>%
  set_variable_labels(
    numgrade_1 = "Numeric grade recoded from letter grade (crsgrada)",
    numgrade_2 = "Numeric grade (crsgradb), values above 4 set to NA",
    numgrade_3 = "Numeric grade: numgrade_1 if letter, numgrade_2 if numeric, NA if credits missing",
    crsecred_3 = "Course credits, NA if numgrade_3 is missing"
  )

nls_crs %>% select(numgrade_1, numgrade_2, numgrade_3, crsecred_3) %>% var_label()
  # Note: run this AFTER you create all four variables. If you re-create a variable with
  # mutate() after labeling it, the label is lost.

  # Q2.9 ----
nls_crs_v2 <- nls_crs %>%
  select(crsecip, crsename, id, transnum, termnum, crsecred_3, numgrade_3, gradtype, itype) %>%
  arrange(id, transnum, termnum, crsename)

  # or arrange first, then select -- same result
nls_crs_v2 <- nls_crs %>%
  arrange(id, transnum, termnum, crsename) %>%
  select(crsecip, crsename, id, transnum, termnum, crsecred_3, numgrade_3, gradtype, itype)

dim(nls_crs_v2)  # 484,522 rows, 9 columns
  # Common mistake: listing the sort variables in a different order. arrange(crsename, id, ...)
  # sorts by course name first, which is a different dataframe.


## Question 3: Calculate GPA ----

  # Q3.1 ----
nls_crs_v2 <- nls_crs_v2 %>% mutate(qualpts = numgrade_3 * crsecred_3)

  # or (order doesn't matter when multiplying)
nls_crs_v2 <- nls_crs_v2 %>% mutate(qualpts = crsecred_3 * numgrade_3)

nls_crs_v2 %>% filter(is.na(numgrade_3)) %>% count(qualpts)  # all NA, as expected

  # Q3.2 ----
nls_crs_trans <- nls_crs_v2 %>%
  group_by(id, transnum) %>%
  summarise(
    cred_trans    = sum(crsecred_3, na.rm = TRUE),
    qualpts_trans = sum(qualpts, na.rm = TRUE)
  ) %>%
  mutate(gpa_trans = qualpts_trans / cred_trans)

  # or calculate GPA inside summarise(), and ungroup() at the end
nls_crs_trans <- nls_crs_v2 %>%
  group_by(id, transnum) %>%
  summarise(
    cred_trans    = sum(crsecred_3, na.rm = TRUE),
    qualpts_trans = sum(qualpts, na.rm = TRUE),
    gpa_trans     = qualpts_trans / cred_trans
  ) %>%
  ungroup()

nls_crs_trans %>% summary()  # GPA should be between 0 and 4

  # Note: some transcripts have 0 total credits, so GPA = 0/0, which R shows as NaN
  # ("not a number"). That's expected -- you can't calculate a GPA with no credits.
  # Common mistakes:
  #   Forgetting na.rm = TRUE -- then any transcript with one missing course gets an NA GPA
  #   Grouping by id only -- that gives one GPA per student, not per transcript

  # Q3.3 ----
nls_crs_term <- nls_crs_v2 %>%
  group_by(id, transnum, termnum) %>%
  summarise(
    cred_term    = sum(crsecred_3, na.rm = TRUE),
    qualpts_term = sum(qualpts, na.rm = TRUE)
  ) %>%
  mutate(gpa_term = qualpts_term / cred_term)

  # or
nls_crs_term <- nls_crs_v2 %>%
  group_by(id, transnum, termnum) %>%
  summarise(
    cred_term    = sum(crsecred_3, na.rm = TRUE),
    qualpts_term = sum(qualpts, na.rm = TRUE),
    gpa_term     = qualpts_term / cred_term
  ) %>%
  ungroup()

nls_crs_term %>% head()
  # Common mistake: leaving transnum out of group_by(). Term 1 at one school and term 1
  # at another school would get combined into one "term".

