## Problemset Title ----
## [ PROJ ] < Problem set 3 SOLUTIONS >
## [ FILE ] < problemset3_solutions.R >
## [ AUTH ] < Teaching team >

## Notes for the teaching team ----
  # - Where there is more than one correct way to answer, the options are separated by `# or`.
  #   Every option is runnable and produces the same object, so this whole script can be
  #   sourced and run against the test script.
  # - Expected row counts / values are given in comments so you can check student work quickly.
  #   They match the expected values in problemset3_tests_revised.R.

## Question 1: Load and inspect `df_event` dataset ----
  # Q1.1 ----

library(tidyverse)
load(url("https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_event_somevars.RData"))

  # `url()` creates a connection to the web address, and `load()` reads the .RData file through
  # that connection. `load()` does not need to be assigned to anything: it puts the object
  # `df_event` straight into the environment, under the name it was saved with.
  # Check: dim(df_event) is 18680 rows x 32 columns

  # Q1.2 ----

q1_2a <- names(df_event)              # all 32 column names
q1_2b <- typeof(df_event$event_state) # "character"
q1_2c <- str(df_event$med_inc)        # prints: num [1:18680] 71714 ...
q1_2d <- table(df_event$event_type)   # 2yr college, 4yr college, other, private hs, public hs

  # Note: `names()` takes the whole dataframe, while the other three take one column (df$column).
  # `str()` only prints to the console and returns NULL, so `q1_2c` will show as NULL. That is
  # expected, and the test checks for NULL.
  # The table in q1_2d shows the exact spelling of the event types needed later:
  #   "2yr college"  "4yr college"  "other"  "private hs"  "public hs"


## Question 2: Filtering/isolating observations ----

  # Q2.1a ----

q2_1a <- filter(df_event, univ_id == 166629)

  # 908 rows. `univ_id` is numeric, so no quotes. Remember `==` (test for equality),
  # not `=` (which is for assigning/naming arguments).

  # Q2.1b ----

q2_1b <- filter(q2_1a, event_state != instst)

  # 626 rows. `!=` means "not equal to." Out-of-state means the state of the event is
  # different from the state of the university. You can compare two columns to each other
  # row by row, just like comparing a column to a single value.
  # (For reference, in-state, `event_state == instst`, would give 282 rows.)

  # Q2.1c ----

q2_1c <- filter(q2_1b, event_type == "public hs")

  # 406 rows. `event_type` is character, so the value goes in quotes and must match the
  # spelling and case exactly ("public hs", not "Public HS" or "public").

  # Q2.1d ----

q2_1d <- filter(q2_1c, med_inc >= 100000)

  # 264 rows. Numbers are written without commas or dollar signs.
  # Note: `filter()` drops rows where the condition is NA, so events with missing `med_inc`
  # are dropped automatically.

  # Q2.1e ----

# tidyverse filter() function without pipes
q2_1e <- filter(df_event, univ_id == 166629, event_state != instst, event_type == "public hs", med_inc >= 100000)
# or
q2_1e <- filter(df_event, univ_id == 166629 & event_state != instst & event_type == "public hs" & med_inc >= 100000)

  # 264 rows, same as q2_1d. Inside `filter()`, separating conditions with a comma is the same
  # as joining them with `&`: a row is kept only if ALL conditions are TRUE.

  # Q2.2 ----

# tidyverse filter() function with pipes
q2_2 <- df_event %>%
  filter(univ_id == 166629, event_state != instst, event_type == "public hs", med_inc >= 100000)
# or
q2_2 <- df_event %>%
  filter(univ_id == 166629) %>%
  filter(event_state != instst) %>%
  filter(event_type == "public hs") %>%
  filter(med_inc >= 100000)

  # 264 rows, identical to q2_1e. The pipe `%>%` passes the object on its left in as the
  # first argument of the function on its right, so `df_event %>% filter(...)` is the same as
  # `filter(df_event, ...)`. The second version shows the step-by-step logic of Q2.1 in one chain.
  # Common mistake: ending the chain with `nrow()`. The question asks for the dataframe.

  # Q2.3a ----

q2_3a <- filter(df_event, univ_id == 218663 | univ_id == 100751)
# or
q2_3a <- filter(df_event, univ_id %in% c(218663, 100751))

  # 5725 rows. `|` means OR: keep the row if either condition is TRUE.
  # `%in%` checks whether each value is in a list of values, which is shorter when there are
  # many values to check.
  # Common mistake: `filter(df_event, univ_id == 218663, univ_id == 100751)` gives 0 rows,
  # because the comma means AND and no single row can have two different univ_ids.

  # Q2.3b ----

q2_3b <- filter(q2_3a, event_state == instst, event_type == "2yr college")
# or
q2_3b <- filter(q2_3a, event_state == instst & event_type == "2yr college")

  # 68 rows. In-state means the event state equals the university's state.

  # Q2.3c ----

# tidyverse filter() function without pipes
q2_3c <- filter(q2_3a, (event_state == instst & event_type == "2yr college") | pop_total > 10000)
# or (same result without parentheses, because & is evaluated before |)
q2_3c <- filter(q2_3a, event_state == instst & event_type == "2yr college" | pop_total > 10000)

  # 5171 rows. R evaluates `&` before `|` (like multiplication before addition), so both
  # versions mean "(in-state AND 2-year college) OR population over 10,000." The parentheses
  # are not required but make the intent clear.
  # Common mistake: using a comma for the AND part, e.g.
  #   filter(q2_3a, event_state == instst, event_type == "2yr college" | pop_total > 10000)
  # The comma splits it into two separate conditions that BOTH must be TRUE, which is a
  # different filter.
  # Grading note: the original solution used `pop_total < 10000`, which gives 543 rows.
  # The test script accepts 5171 or 543 this term.

  # Q2.4 ----

# tidyverse filter() function with pipes
q2_4 <- q2_3a %>%
  filter((event_state == instst & event_type == "2yr college") | pop_total > 10000)
# or (starting from the full dataset)
q2_4 <- df_event %>%
  filter(univ_id %in% c(218663, 100751)) %>%
  filter((event_state == instst & event_type == "2yr college") | pop_total > 10000)

  # 5171 rows, identical to q2_3c.
  # Note: the university filter and the OR filter must stay in separate steps (or be joined
  # with `&`/a comma). Putting `univ_id %in% c(...)` inside the OR part would also keep
  # other universities' events in large zip codes.


## Question 3: Sorting observations ----
  # Q3 ----

# tidyverse using arrange()
q3 <- arrange(df_event, univ_id, event_date, event_state, desc(pct_white_zip), desc(med_inc))
# or
q3 <- df_event %>%
  arrange(univ_id, event_date, event_state, desc(pct_white_zip), desc(med_inc))

  # 18680 rows x 32 columns (same as df_event, just reordered).
  # `arrange()` sorts ascending by default; `desc()` sorts descending. The order of the
  # variables matters: R sorts by `univ_id` first, then uses `event_date` to break ties within
  # each university, then `event_state`, and so on.
  # Common mistake: separate arrange() calls, e.g. arrange(arrange(df, med_inc), univ_id).
  # Each new arrange() re-sorts the whole dataframe, so the variables would end up prioritized
  # in the wrong order.
  # Check: first row is univ_id 100751, pid 2667, school_id "X1328481"


## Question 4: Selecting variables ----
  # Q4.1 ----

# tidyverse select() without pipes
q4_1 <- select(df_event, univ_id, event_date, event_type, zip, med_inc)
# or
q4_1 <- select(df_event, c(univ_id, event_date, event_type, zip, med_inc))

  # 18680 rows x 5 columns. `select()` picks columns (variables); `filter()` picks rows
  # (observations). Column names inside select() don't need quotes.

  # Q4.2 ----

q4_2 <- names(q4_1)

  # "univ_id" "event_date" "event_type" "zip" "med_inc"

  # Q4.3 ----

q4_3 <- df_event %>% select(univ_id, event_date, event_type, zip, med_inc)

  # Identical to q4_1.

  # Q4.4 ----

q4_4 <- names(q4_3)

  # Same five names as q4_2.


## Question 5: Additional practice with `df_school_all` dataframe ----
  # Q5.1 ----

load(url("https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_school_allvars.RData"))

  # Check: dim(df_school_all) is 21301 rows x 55 columns

  # Q5.2 ----

q5_2 <- table(df_school_all$school_type)

  # private: 3822   public: 17479
  # Note the values are lowercase "public" and "private". Students need this for Q5.7/5.8.

  # Q5.3 ----

q5_3 <- select(arrange(df_school_all, desc(total_visits)),
               name, state_code, city, school_type, total_visits, med_inc,
               pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian)
# or (select first, then arrange)
q5_3 <- arrange(select(df_school_all, name, state_code, city, school_type, total_visits, med_inc,
                       pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian),
                desc(total_visits))

  # 21301 rows x 11 columns. Without pipes, one function is nested inside the other: R runs
  # the inner function first, and its result becomes the first argument of the outer function.
  # Either order works here because `total_visits` is one of the selected columns. If it were
  # not selected, you would have to arrange first.
  # Check: first row is "EPISCOPAL HIGH SCHOOL" with 26 visits

  # Q5.4 ----

q5_4 <- head(q5_3, n = 10)
# or
q5_4 <- head(q5_3, 10)

  # 10 rows x 11 columns. `head()` returns 6 rows by default, so `n = 10` is needed.
  # Check: row 10 is "TRINITY CHRISTIAN ACADEMY"

  # Q5.5 ----

q5_5 <- df_school_all %>%
  arrange(desc(total_visits)) %>%
  select(name, state_code, city, school_type, total_visits, med_inc,
         pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian)

  # Identical to q5_3. With pipes the steps read top to bottom in the order they happen,
  # which is easier to follow than nested functions.

  # Q5.6 ----

q5_6 <- head(q5_5, n = 10)
# or
q5_6 <- q5_5 %>% head(n = 10)

  # Identical to q5_4.

  # Q5.7 ----

q5_7 <- df_school_all %>%
  filter(state_code == "CA", school_type == "public") %>%
  arrange(desc(total_visits)) %>%
  select(name, state_code, city, school_type, total_visits, med_inc,
         pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian) %>%
  head(n = 10)
# or (without pipes)
q5_7 <- head(select(arrange(filter(df_school_all, state_code == "CA", school_type == "public"),
                            desc(total_visits)),
                    name, state_code, city, school_type, total_visits, med_inc,
                    pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian),
             n = 10)

  # 10 rows x 11 columns. Order matters for `head()`: it must come last, after filtering and
  # sorting, or you would get the first 10 rows of the wrong set of schools.
  # Check: row 1 "Corona del Mar High", row 6 "Calabasas High"

  # Q5.8 ----

q5_8 <- df_school_all %>%
  filter(state_code == "CA", school_type == "private") %>%
  arrange(desc(total_visits)) %>%
  select(name, state_code, city, school_type, total_visits, med_inc,
         pct_white, pct_black, pct_hispanic, pct_asian, pct_amerindian) %>%
  head(n = 10)

  # 10 rows x 11 columns. Same as Q5.7 with "private" instead of "public".
  # Check: row 1 "SANTA MARGARITA CATHOLIC HIGH SCHOOL", row 6 "CHAMINADE COLLEGE PREPARATORY HIGH SCHOOL"


## Create a GitHub issue ----
  # Example format only. Each student's URLs will be different.
  # Issue links end in /issues/<number>; comment links add #issuecomment-<number>.

issue <- "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/1"

reply <- "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/2#issuecomment-1234567890"
