## Problemset Title ----
## [ PROJ ] < Problem set 2 SOLUTIONS >
## [ FILE ] < problemset2_solutions.R >
## [ AUTH ] < Teaching team >

## Notes for the teaching team ----
  # - Where there is more than one correct way to answer, the options are separated by `# or`.
  #   Every option is runnable and produces an answer the test script accepts, so this whole
  #   script can be sourced and run against the test script.
  # - Expected values are given in comments so you can check student work quickly.

rm(list = ls()) # remove all objects from the Global Environment

## Question 1: Investigating objects, Base R ----

  # Q1.1 ----

load(url("https://github.com/ozanj/rclass/raw/master/data/recruiting/recruit_school_allvars.RData"))

  # `url()` creates a connection to the web address, and `load()` reads the .RData file through
  # it. `load()` does not need to be assigned to anything: it puts `df_school_all` straight into
  # the Global Environment. Check: dim(df_school_all) is 21301 rows x 55 columns

typeof(df_school_all)
q1_x <- typeof(df_school_all) # option 1 is to assign your code to the object
q1_x <- "list" # option 2 is to assign the literal output from typeof() to the object

  # A data frame is stored as a list, so typeof() returns "list" (class() would return
  # "data.frame"; for a tibble, "tbl_df" "tbl" "data.frame").

  # Q1.2 ----

q1_2a <- length(df_school_all)
# or
q1_2a <- 55

q1_2b <- "variables"
# or
q1_2b <- "columns"

  # 55. A data frame is a list where each element is one column, so length() counts columns.
  # The test also accepts "elements".

  # Q1.3 ----

q1_3a <- nrow(df_school_all)
# or
q1_3a <- 21301

q1_3b <- "observation"

  # 21301. Each row is one observation, here one high school.

  # Q1.4 ----

q1_4 <- "variable"

  # Each element of a data frame is one variable (column). Note: the test only accepts
  # "variable"; a student answering "column" is also conceptually right.

  # Q1.5 ----

q1_5 <- "vectors"

  # Each column is an atomic vector. str() shows this with labels like `chr` and `num`
  # for each column.

  # Q1.6 ----

q1_6 <- "named"

  # Every column has a name (state_code, school_type, ...), which is what str() lists
  # after each `$`.

  # Q1.7 ----

q1_7 <- typeof(df_school_all$school_type)
# or
q1_7 <- typeof(df_school_all[["school_type"]])

  # "character"

  # Q1.8 ----

q1_8 <- length(df_school_all$school_type)
# or
q1_8 <- length(df_school_all[["school_type"]])

  # 21301, the same as the number of rows, because each column has one value per row.

  # Q1.9 ----

q1_9 <- "observations"
# or
q1_9 <- "rows"

  # For a single vector, length() counts its elements; for a column of a data frame, each
  # element is one row/observation. Note: the test accepts "row" or "observation" but not
  # "elements", which is also technically correct.

  # Q1.10 ----

q1_10_1 <- table(df_school_all$school_type)
q1_10_2 <- table(df_school_all$school_type, useNA = "ifany")
q1_10_3 <- table(df_school_all$school_type, useNA = "always")

  # private 3822, public 17479 in all three.
  # "ifany" adds an NA column only if there are missing values. `school_type` has none,
  # so the table looks the same as the default.
  # "always" adds an NA column no matter what, so the third table shows NA = 0.

  # Q1.11 ----

q1_11 <- "no"

  # From ?table: useNA = c("no", "ifany", "always"). The first option listed is the default.

  # Q1.12 ----

q1_12 <- 2

  # private and public only, because there are no missing values.

  # Q1.13 ----

q1_13 <- 3

  # private, public, and NA (with a count of 0).


## Question 2: Subsetting, Base R ----

  # Create a named numeric atomic vector
vec <- c(a = 2.4, b = 1.1, c = 3.4, d = 4, e = 6, f = 32, g = 21, h = 17, i = 10)
str(vec)

  # Create a list
list <- list(c(1:3), list("red", "orange"), list("LA", "NY", "DC")) 
str(list)

  # View the `df_school_all` data frame you loaded earlier
head(df_school_all, n = 5)

  # Q2.1 ----

q2_1 <- vec[c(4, 7)]
# or
q2_1 <- vec[c("d", "g")]

  # d = 4, g = 21. `c()` is needed to give `[]` more than one position at a time.

  # Q2.2 ----

q2_2 <- vec[-9]
# or
q2_2 <- vec[-length(vec)]
# or
q2_2 <- vec[1:8]

  # a through h. A negative index removes that position. `-length(vec)` is the most general
  # because it works no matter how long the vector is.

  # Q2.3 ----

q2_3 <- vec[c("a", "d", "g")]

  # a = 2.4, d = 4, g = 21. Named vectors can be subset with a character vector of names.

  # Q2.4 ----

q2_4 <- vec[vec < 12]

  # a, b, c, d, e, i (2.4, 1.1, 3.4, 4, 6, 10).
  # `vec < 12` creates a logical vector (TRUE/FALSE for each element), and `[]` keeps the
  # elements that are TRUE.

  # Q2.5 ----

q2_5 <- list[1]

  # A list of length 1 containing the vector 1 2 3.

  # Q2.6 ----

q2_6 <- "list"
# or
q2_6 <- typeof(list[1])

  # Single brackets `[]` on a list always return a list (a smaller piece of the same container).

  # Q2.7 ----

q2_7 <- df_school_all[c(2, 4, 6)]
# or
q2_7 <- df_school_all[, c(2, 4, 6)]

  # The columns school_type, name, and city. With one index and no comma, `[]` treats the
  # data frame as a list and returns columns. With a comma, it is [rows, columns], and leaving
  # the rows blank means "all rows." Both return a data frame with 3 columns.

  # Q2.8 ----

q2_8 <- df_school_all[1:100, "state_code"]
# or
q2_8 <- df_school_all$state_code[1:100]
# or
q2_8 <- df_school_all[["state_code"]][1:100]

  # Rows go before the comma, columns after: df[rows, columns].
  # The `$` and `[[]]` options return a character vector of length 100. The first option returns
  # a 100 x 1 tibble if df_school_all is a tibble (a plain data.frame gives a vector instead).
  # The test accepts either.

  # Q2.9 ----

q2_9 <- df_school_all[1:3, c("state_code", "name")]

  # 3 x 2: AK "Bethel Regional High School", AK "Ayagina'ar Elitnaurvik",
  # AK "Kwigillingok School". Column order must be state_code then name to match the test.

  # Q2.10 ----

q2_10 <- list[[1]]

  # The vector 1 2 3 itself, not wrapped in a list.
  # The usual analogy: if `list` is a train, `list[1]` is the first train car, and
  # `list[[1]]` is what's inside the first car.

  # Q2.11 ----

q2_11 <- "integer"
# or
q2_11 <- typeof(list[[1]])

  # `1:3` creates integers, so the contents of the first element are an integer vector.

  # Q2.12 ----

q2_12 <- "list"
# or
q2_12 <- typeof(df_school_all["total_students"])

  # `[]` returns a data frame with one column, which is stored as a list.

  # Q2.13 ----

q2_13 <- "double"
# or
q2_13 <- typeof(df_school_all[["total_students"]])

  # `[[]]` pulls the column out as a vector, which is numeric (double).

  # Q2.14 ----

q2_14 <- "double"
# or
q2_14 <- typeof(df_school_all$total_students)

  # `$` works the same as `[[]]` with a name, so it also returns the double vector.

  # Q2.15 ----

q2_15 <- df_school_all$total_students[10:15]

  # 186 213 211 324 421 181. `$` extracts the vector first, then `[]` picks positions 10-15.


## Question 3: Calculate the total average number of students receiving free lunch from `num_fr_lunch`. 

  # Q3.1 - q3.3 ----

q3_1 <- mean(df_school_all["num_fr_lunch"], na.rm = TRUE)
q3_2 <- mean(df_school_all[["num_fr_lunch"]], na.rm = TRUE)
q3_3 <- mean(df_school_all$num_fr_lunch, na.rm = TRUE)

  # q3_1 returns NA with a warning ("argument is not numeric or logical: returning NA"),
  # because `[]` returns a one-column data frame (a list), and mean() can't average a list.
  # q3_2 and q3_3 both return about 322.79, because `[[]]` and `$` return the numeric vector.
  # `na.rm = TRUE` drops missing values before averaging; without it, the result would be NA.

  # Q3_4 ----

q3_4 <- 1

  # Q3_5 ----

q3_5 <- "list"

  # Q3_6 ----

q3_6 <- c("logical", "numeric")

  # From ?mean, x must be a numeric or logical vector. "numeric" covers both integer and
  # double. The test also accepts c("double", "integer", "logical").
  # Logical works because TRUE counts as 1 and FALSE as 0, so the mean of a logical vector
  # is the proportion of TRUEs.


## Create a GitHub issue ----
  # Example format only. Each student's URLs will be different.
  # The test requires the issue URL to end in /issues/<number> and the reply URL to end in
  # /issues/<number>#issuecomment-<number> (get this from "..." > "Copy link" on the comment).

issue <- "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/1"

reply <- "https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues/2#issuecomment-1234567890"
