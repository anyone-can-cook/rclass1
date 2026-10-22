## Problemset Title ----
## [ PROJ ] < Problem set 3 SOLUTIONS >
## [ FILE ] < problemset3_solutions.R >
## [ AUTH ] < Teaching team >

## How to use this solutions script ----
# This script shows one or more correct ways to answer each question, plus notes on
# WHY the code works and the most common mistakes we saw.


## Question 1: Load and inspect `df_event` dataset ----
# Q1.1 ----

library(tidyverse)
load(url("https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_event_somevars.RData"))

# What this does:
#   `url()` opens a connection to the web address, and `load()` reads the .RData file
#   through that connection. `load()` puts `df_event` straight into your Environment under
#   the name it was saved with, so you don't need to assign it with `<-`.
#
# Check your work:
dim(df_event)   # 18680 rows, 32 columns

# Common mistake: forgetting `library(tidyverse)`, or putting it below the code that uses it.
# If you see strange errors from `filter()` or `%>%`, check that the tidyverse is loaded first!


# Q1.2 ----

q1_2a <- names(df_event)              # the 32 column names
q1_2b <- typeof(df_event$event_state) # "character"
q1_2c <- str(df_event$med_inc)        # prints: num [1:18680] ...
q1_2d <- table(df_event$event_type)   # counts for each event type

# Notes:
#   - `names()` works on the whole dataframe. Parts b-d ask about ONE column, so we use `$`
#     to pull that column out: df_event$column_name
#   - `str()` only prints to the console and doesn't return anything, so `q1_2c` shows up as
#     NULL in your Environment. That is expected.
#   - Helpful trick is to keep the `table()` output from q1_2d handy! It shows the exact spelling of each event
#     type, which you need for filtering in Question 2:
#       "2yr college"  "4yr college"  "other"  "private hs"  "public hs"
q1_2d


## Question 2: Filtering/isolating observations ----
# Reminder: `filter()` keeps ROWS (observations) where your condition is TRUE.
#
# Comparison operators you'll use here:
#   ==  equal to             !=  not equal to
#   >   greater than         >=  greater than or equal to
#   <   less than            <=  less than or equal to
#
# Combining conditions:
#   ,  or  &   AND: keep the row only if ALL conditions are TRUE
#   |          OR:  keep the row if AT LEAST ONE condition is TRUE
#   %in%       is the value one of these? e.g. univ_id %in% c(218663, 100751)

# Q2.1a ----

q2_1a <- filter(df_event, univ_id == 166629)

nrow(q2_1a)   # 908

# Notes:
#   - `univ_id` is numeric, so the value does not need quotes.
#   - Use `==` to TEST whether two things are equal. A single `=` is for naming arguments,
#     and `filter(df_event, univ_id = 166629)` gives an error.


# Q2.1b ----

q2_1b <- filter(q2_1a, event_state != instst)

nrow(q2_1b)   # 626

# Notes:
#   - Out-of-state means the event's state (`event_state`) is NOT the same as the
#     university's state (`instst`), so we use `!=`.
#   - For comparison, in-state events (`event_state == instst`) would give 282 rows.
#     626 + 282 = 908, which is all of q2_1a.


# Q2.1c ----

q2_1c <- filter(q2_1b, event_type == "public hs")

nrow(q2_1c)   # 406

# Notes:
#   - `event_type` is a character variable, so the value goes in quotes.
#   - The spelling and case must match the data exactly: "public hs" works, but
#     "Public HS", "public", or "public high school" give 0 rows. When you get 0 rows
#     unexpectedly, check the spelling with `table()`.


# Q2.1d ----

q2_1d <- filter(q2_1c, med_inc >= 100000)

nrow(q2_1d)   # 264

# Notes:
#   - Type numbers without commas or dollar signs: 100000, not 100,000 or $100,000.
#   - "$100,000 or higher" includes exactly $100,000, so we use `>=`, not `>`.
#   - Some events are missing `med_inc` (NA). `filter()` automatically drops rows where the
#     condition can't be evaluated, so those events are left out.


# Q2.1e ----

# Option A: conditions separated by commas
q2_1e <- filter(df_event, univ_id == 166629, event_state != instst,
                event_type == "public hs", med_inc >= 100000)

# Option B: conditions joined with &
q2_1e <- filter(df_event, univ_id == 166629 & event_state != instst &
                  event_type == "public hs" & med_inc >= 100000)

nrow(q2_1e)   # 264

# Notes:
#   - Inside `filter()`, a comma means the same thing as `&`: a row is kept only if ALL
#     the conditions are TRUE.
#   - This one line does what the four steps in Q2.1a-d did. Notice it starts from
#     `df_event`, not from `q2_1d`.
#   - Long lines can be broken after a comma, like shown above, for readability.


# Q2.2 ----

# Option A: one filter() with all four conditions
q2_2 <- df_event %>%
  filter(univ_id == 166629, event_state != instst,
         event_type == "public hs", med_inc >= 100000)

# Option B: one filter() per step, just like Q2.1a-d
q2_2 <- df_event %>%
  filter(univ_id == 166629) %>%
  filter(event_state != instst) %>%
  filter(event_type == "public hs") %>%
  filter(med_inc >= 100000)

nrow(q2_2)   # 264

# How the pipe works:
#   `%>%` takes whatever is on its LEFT and passes it in as the FIRST argument of the
#   function on its RIGHT. 
#   You can read `%>%` as "and then": take df_event, AND THEN filter it, AND THEN filter it...
#
# Common mistake: ending the command with `%>% nrow()`. That stores the NUMBER 264 in q2_2,
# but the question asks for the dataframe.


# Q2.3a ----

# Option A: the | (OR) operator
q2_3a <- filter(df_event, univ_id == 218663 | univ_id == 100751)

# Option B: the %in% operator
q2_3a <- filter(df_event, univ_id %in% c(218663, 100751))

nrow(q2_3a)   # 5725

# Notes:
#   - `|` means OR: keep the row if EITHER condition is TRUE.
#   - `%in%` asks "is this value one of the values in this list?" 
#
# Common mistake: `filter(df_event, univ_id == 218663, univ_id == 100751)` gives 0 rows.
# The comma means AND, so this asks for events where `univ_id` is 218663 AND 100751 at the
# same time. No single row can have two different university IDs!


# Q2.3b ----

# Option A: comma
q2_3b <- filter(q2_3a, event_state == instst, event_type == "2yr college")

# Option B: &
q2_3b <- filter(q2_3a, event_state == instst & event_type == "2yr college")

nrow(q2_3b)   # 68

# Notes:
#   - In-state means the event's state is the SAME as the university's state, so `==`.
#   - "2yr college" starts with a number and has no hyphen. Check `table()` for exact value.


# Q2.3c ----

q2_3c <- filter(q2_3a, (event_state == instst & event_type == "2yr college") | pop_total > 10000)

nrow(q2_3c)   # 5171

# This line commands R to:
#   Keep an event if EITHER
#     (it's in-state AND at a 2-year college)
#   OR
#     (the zip code has more than 10,000 people).
#
# About the parentheses:
#   R evaluates `&` before `|`, the same way math does multiplication before addition.
#   So the code works the same without the parentheses, but we recommend using them.
#
# Common mistake: using a comma for the AND part:
#   filter(q2_3a, event_state == instst, event_type == "2yr college" | pop_total > 10000)
# A comma splits this into two SEPARATE conditions that BOTH must be TRUE:
#   (1) in-state, AND (2) 2-year college OR big population.
#
# If you got 543 rows, you probably used `pop_total < 10000` instead of `> 10000`.
# The question asks for populations GREATER than 10,000, so 5171 is the correct answer.
# (Because of an error in an earlier version of our answer key, 543 was also accepted this term.)


# Q2.4 ----

# Option A: start from q2_3a
q2_4 <- q2_3a %>%
  filter((event_state == instst & event_type == "2yr college") | pop_total > 10000)

# Option B: start from df_event and do both steps in one command
q2_4 <- df_event %>%
  filter(univ_id %in% c(218663, 100751)) %>%
  filter((event_state == instst & event_type == "2yr college") | pop_total > 10000)

nrow(q2_4)   # 5171

# Common mistake (Option B): putting the university condition INSIDE the OR, like this:
#   filter(univ_id %in% c(218663, 100751) & event_state == instst &
#            event_type == "2yr college" | pop_total > 10000)


## Question 3: Sorting observations ----
# Q3 ----

# Option A: without pipes
q3 <- arrange(df_event, univ_id, event_date, event_state, desc(pct_white_zip), desc(med_inc))

# Option B: with pipes
q3 <- df_event %>%
  arrange(univ_id, event_date, event_state, desc(pct_white_zip), desc(med_inc))

dim(q3)    # 18680 rows, 32 columns: same as df_event, just in a different order
head(q3)   # preview the first 6 rows

# How `arrange()` works:
#   - It sorts ascending (smallest to largest, A to Z, earliest to latest) by default.
#   - Wrap a variable in `desc()` to sort it descending.
#   - The ORDER of the variables matters. R sorts by `univ_id` first. Then, within each
#     university, it sorts by `event_date`. Within each date, by `event_state`, and so on.
#     Later variables only break ties in earlier ones.
#   - Missing values (NA) are always placed at the end, even with `desc()`.
#
# Common mistake: using a separate arrange() for each variable, like this:
#   df_event %>% arrange(univ_id) %>% arrange(event_date)
# Each arrange() re-sorts the whole dataframe, so the LAST one becomes the main sort.
# This result is sorted by `event_date` first, not `univ_id`. Put all the variables in a
# single arrange() function, in order specified.


## Question 4: Selecting variables ----
# Q4.1 ----

q4_1 <- select(df_event, univ_id, event_date, event_type, zip, med_inc)

dim(q4_1)   # 18680 rows, 5 columns

# Notes:
#   - `select()` picks COLUMNS (variables). `filter()` picks ROWS (observations).
#     Here the number of rows stays the same and only the columns change.
#   - Column names inside `select()` don't need quotes.

# Q4.2 ----

q4_2 <- names(q4_1)
q4_2   # "univ_id" "event_date" "event_type" "zip" "med_inc"


# Q4.3 ----

q4_3 <- df_event %>%
  select(univ_id, event_date, event_type, zip, med_inc)

# Q4.4 ----

q4_4 <- names(q4_3)
q4_4   # same five names as q4_2


## Question 5: Additional practice with `df_school_all` dataframe ----
# Q5.1 ----

load(url("https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_school_allvars.RData"))

dim(df_school_all)   # 21301 rows, 55 columns


# Q5.2 ----

q5_2 <- table(df_school_all$school_type)
q5_2   # private: 3822   public: 17479

# Note: the values are lowercase "public" and "private". You'll need to use that exact spelling
# in Q5.7 and Q5.8.


# Q5.3 ----

# Option A: arrange first (inside), then select (outside)
q5_3 <- select(arrange(df_school_all, desc(total_visits)),
               name, state_code, city, school_type, total_visits, med_inc,
               pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian)

# Option B: select first (inside), then arrange (outside)
q5_3 <- arrange(select(df_school_all, name, state_code, city, school_type, total_visits,
                       med_inc, pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian),
                desc(total_visits))

dim(q5_3)   # 21301 rows, 11 columns

# How nesting functiuons within functions works:
#   Without pipes, you put one function inside another. R runs the INNER function first,
#   and its result becomes the first argument of the OUTER function. 
#
# Does the order matter here?
#   Not in this case, because `total_visits` is one of the columns we keep. But if you
#   selected first and left `total_visits` out, `arrange()` would have nothing to sort by
#   and you'd get an error. When in doubt, arrange (or filter) before you select.


# Q5.4 ----

q5_4 <- head(q5_3, n = 10)

q5_4   # the 10 most visited high schools

# Note: `head()` returns 6 rows by default. Use `n = 10` (or just `head(q5_3, 10)`)
# to get 10.


# Q5.5 ----

q5_5 <- df_school_all %>%
  arrange(desc(total_visits)) %>%
  select(name, state_code, city, school_type, total_visits, med_inc,
         pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian)

# Q5.6 ----

q5_6 <- q5_5 %>% head(n = 10)


# Q5.7 ----

# Option A: with pipes
q5_7 <- df_school_all %>%
  filter(state_code == "CA", school_type == "public") %>%
  arrange(desc(total_visits)) %>%
  select(name, state_code, city, school_type, total_visits, med_inc,
         pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian) %>%
  head(n = 10)

# Option B: without pipes (nested, read from the inside out)
q5_7 <- head(
  select(
    arrange(
      filter(df_school_all, state_code == "CA", school_type == "public"),
      desc(total_visits)),
    name, state_code, city, school_type, total_visits, med_inc,
    pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian),
  n = 10)

q5_7   # 10 rows, 11 columns

# Notes:
#   `head()` must come LAST. If you took the first 10 rows before filtering or sorting,
#   you'd get the first 10 rows of the wrong set of schools.


# Q5.8 ----

q5_8 <- df_school_all %>%
  filter(state_code == "CA", school_type == "private") %>%
  arrange(desc(total_visits)) %>%
  select(name, state_code, city, school_type, total_visits, med_inc,
         pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian) %>%
  head(n = 10)

q5_8   # 10 rows, 11 columns

# Something to think further about: compare the `med_inc` and racial composition columns in q5_7
# and q5_8. What patterns do you notice in which schools get the most visits?


## Create a GitHub issue ----

issue <- "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/1"

reply <- "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/2#issuecomment-1234567890"