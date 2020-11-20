################################################################################
##
## [ PROJ ] < Rclass1, strings_dates_time lecture >
## [ FILE ] < date_example_df_events.R >
## [ AUTH ] < Ozan Jaquette / github @ozanj >
## [ INIT ] < 11/12/2020 >
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(lubridate) # tidyverse package for dates, but not automatically loaded w/ tidyverse

## ---------------------------
## load data
## ---------------------------

#load dataset with one obs per recruiting event
load(url("https://github.com/ozanj/rclass/raw/master/data/recruiting/recruit_event_somevars.RData"))

df_event %>% glimpse()

# in-state visits
df_event %>% 
  filter(
    event_type %in% c("public hs","private hs"), 
    event_date > dmy("1/9/2017"),
    event_inst == "In-State"
  ) %>%
  ggplot(aes(event_date)) + geom_histogram() +
  facet_wrap(~ instnm) +
  ggtitle(label = "In-state recruiting visits by date, 9/1/2017 through 12/31/2017")
  
# out-of-state visits
df_event %>% 
  filter(
    event_type %in% c("public hs","private hs"), 
    event_date > dmy("1/9/2017"),
    event_inst == "Out-State"
  ) %>%
  arrange(instnm, event_date) %>% 
  ggplot(aes(event_date)) + geom_histogram() +
  facet_wrap(~ instnm) +
  ggtitle(label = "Out-of-state recruiting visits by date, 9/1/2017 through 12/31/2017")
