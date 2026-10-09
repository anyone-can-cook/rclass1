library(tidyverse)

# Load dataset with one observation per high school
load(
  file = url(description = "https://github.com/ozanj/rclass/raw/master/data/recruiting/recruit_school_somevars.RData")
)

glimpse(df_school)

# Create regression variables
df_school_reg <- df_school %>%
  mutate(
    # Y: Any visits by Bama (numeric 0/1)
    bama_visits = if_else(visits_by_100751 > 0, 1, 0),
    
    # X1: Income deciles (factor)
    income_decile = factor(
      ntile(avgmedian_inc_2564, 10)
    ),
    
    # X2: Hispanic percentage deciles (factor)
    hispanic_decile = factor(
      ntile(pct_hispanic, 10)
    )
  )

# Inspect regression variables
df_school_reg %>%
  select(bama_visits, income_decile, hispanic_decile) %>%
  glimpse()


# SUMMARY STATISTICS --------------------------------------------

# Summary statistics: dependent variable
df_school_reg %>%
  summarise(
    n_schools = n(),
    n_visited = sum(bama_visits, na.rm = TRUE),
    pct_visited = mean(bama_visits, na.rm = TRUE) * 100
  )


# Percentage of schools visited by income decile
df_school_reg %>%
  group_by(income_decile) %>%
  summarise(
    n_schools = n(),
    pct_visited = mean(bama_visits, na.rm = TRUE) * 100
  )

# Percentage of schools visited by Hispanic percentage decile
df_school_reg %>%
  group_by(hispanic_decile) %>%
  summarise(
    n_schools = n(),
    pct_visited = mean(bama_visits, na.rm = TRUE) * 100
  )


# REGRESSION ----------------------------------------------------

# Linear probability model
mod1 <- lm(
  bama_visits ~ income_decile + hispanic_decile,
  data = df_school_reg
)

summary(mod1)

# Linear probability model, simpler
mod1 <- lm(
  bama_visits ~ income_decile,
  data = df_school_reg
)

summary(mod1)


# Inspect the model object
typeof(mod1)

str(mod1)
str(mod1, give.attr = FALSE)

str(mod1, give.attr = FALSE, max.level =1)
str(mod1, give.attr = FALSE, max.level =2)



# EXTRACT INFORMATION FROM REGRESSION OBJECT, mod1 --------------------

# 1. Extract all estimated regression coefficients

mod1["coefficients"]
str(mod1["coefficients"]) # we usually don't want this!


# 1. Extract all estimated regression coefficients
mod1[["coefficients"]]

# Save coefficients as a separate object
coef <- mod1[["coefficients"]]
coef
typeof(coef)
str(coef)



# inspect object created by summary() function

summary(mod1)

str(summary(mod1))

sum_mod1 <- summary(mod1)

sum_mod1

str(sum_mod1)
str(sum_mod1, give.attr = FALSE)

str(sum_mod1['coefficients'])
sum_mod1[['coefficients']]

str(sum_mod1[['coefficients']])



# Extract standard errors
se <- summary(mod1)[["coefficients"]][, "Std. Error"]
se

# Create a table using the two vectors
reg_table <- data.frame(
  coefficient = coef,
  std_error = se
)

# Print table
reg_table

# 2. Extract just the coefficient for income decile 2
mod1[["coefficients"]][["income_decile2"]]

# 3. Extract just the coefficient for Hispanic decile 2
mod1[["coefficients"]][["hispanic_decile2"]]

# 4. Extract the first 10 predicted values
# These represent predicted probabilities of a school receiving a visit
head(mod1[["fitted.values"]], 10)

# 5. Extract the first 10 residuals
# Residual = observed value of Y minus predicted value of Y
head(mod1[["residuals"]], 10)

# 6. Extract the number of observations used in the regression
mod1[["df.residual"]] + mod1[["rank"]]

# 7. Extract the call used to estimate the model
mod1[["call"]]

# Inspect the structure of the regression object
str(mod1, max.level = 2)