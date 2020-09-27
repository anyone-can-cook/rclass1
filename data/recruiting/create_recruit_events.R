#CREATE DATASET WITH ONE OBSERVATION PER EVENT FOR USE IN R-CLASS
rm(list = ls()) # remove all objects

######## LOAD LIBRARIES ##########
#options(max.print=999999)
library(tidyverse)
#library(DataExplorer)
library(reshape2)
#library(stringr)
#library(plyr)
library(scales)
#options(scipen=999)



#########################################
"ACROSS UNIVERSITY EDA"
#########################################

######## LOAD DATA ##########

#change directory to open parsed csv

getwd()  
#setwd("/Users/Karina/Dropbox/recruiting-m1/analysis/data")

#load in csv
#all <-read.csv("data/recruiting/events_data.csv", 
all <-read.csv("data/recruiting/events_data_.csv", 
  na.strings = "",
  colClasses=c(school_id="character",
    determined_zip="character",
    event_date="Date",
    event_datetime_start="POSIXct",
    event_datetime_end="POSIXct",
    event_address="character",
    event_name="character",
    event_location_name="character",
    event_state="character",
    event_city="character"
  )
)
#    g09offered="factor"
str(all)

#add univ names
all$instnm[all$univ_id==196097]<-"Stony Brook" #checking
all$instnm[all$univ_id==186380]<-"Rutgers"
all$instnm[all$univ_id==215293]<-"Pitt"
all$instnm[all$univ_id==201885]<-"Cinci"
all$instnm[all$univ_id==181464 ]<-"UNL"
all$instnm[all$univ_id==139959]<-"UGA" #checked 
all$instnm[all$univ_id==218663]<-"USCC"
all$instnm[all$univ_id==100751]<-"Bama"
all$instnm[all$univ_id==199193]<-"NC State"
all$instnm[all$univ_id==110635]<-"UC Berkeley"
all$instnm[all$univ_id==110653]<-"UC Irvine"
all$instnm[all$univ_id==126614]<-"CU Boulder" 
all$instnm[all$univ_id==155317]<-"Kansas"
all$instnm[all$univ_id==106397]<-"Arkansas"
all$instnm[all$univ_id==149222]<-"S Illinois"
all$instnm[all$univ_id==166629]<-"UM Amherst"

table(all$instnm) #no missing


#add univ states
all$instst[all$univ_id==196097]<-"NY"
all$instst[all$univ_id==186380]<-"NJ"
all$instst[all$univ_id==215293]<-"PA"
all$instst[all$univ_id==201885]<-"OH"
all$instst[all$univ_id==181464 ]<-"NE"
all$instst[all$univ_id==139959]<-"GA"
all$instst[all$univ_id==218663]<-"SC"
all$instst[all$univ_id==100751]<-"AL"
all$instst[all$univ_id==199193]<-"NC"
all$instst[all$univ_id==110635]<-"CA"
all$instst[all$univ_id==110653]<-"CA"
all$instst[all$univ_id==126614]<-"CO"
all$instst[all$univ_id==155317]<-"KS"
all$instst[all$univ_id==106397]<-"AR"
all$instst[all$univ_id==149222]<-"IL"
all$instst[all$univ_id==166629]<-"MA"

table(all$instst) #no missing


#19 events have missing locations==wrong IDS attached [drop, we'll fix during manual checks address for all pubs]
count(all,event_state) #19 are missing 
all[is.na(all$event_state), "instnm"] #diff univs

all<-all[!is.na(all$event_state),]
count(all,event_state) #none are missing 


#drop if ipeds_id of recruting event =ipeds_id of institution (on campus event)
count(all,is.na(ipeds_id))
count(all,univ_id==all$ipeds_id) #none currently on-campus

#OZAN [8/3/2018]: I DON'T HAVE ACCESS TO THIS FOLDER
#merge in level of urbanicity

#setwd("/Users/Karina/Dropbox/acs/data")
getwd()

zip <-read.csv("../../Dropbox/acs_new/data/urbantozip.csv", colClasses=c('numeric', 'factor', 'factor'))

#some zips belong to more than one area, keep area with largest % of zip population
zip <- zip[order(zip$ZCTA5, -abs(zip$UAPOPPCT) ), ] #sort by id and reverse of abs(value) of pop
zip<- zip[ !duplicated(zip$ZCTA5), ]              # take the first row within each id

names(all)[names(all) == 'determined_zip'] <- 'zip'
names(zip)[names(zip) == 'ZCTA5'] <- 'zip'

df <- merge(x = all, y = zip[ , c("UANAME", "zip")], by="zip", all.x=TRUE)
#df <- all

#count of visits by type
table(df$sector)
df$eventtype[is.na(df$school_id) & is.na(df$ipeds_id)]<-"other"
df$eventtype[nchar(as.character(df$school_id))>8]<-"public hs"
df$eventtype[nchar(as.character(df$school_id))<= 8]<-"private hs"
df$eventtype[df$sector=="Public, 2-year"]<-"pub 2yr cc"
df$eventtype[df$sector=="Public, 4-year or above"]<-"pub 4yr univ"
df$eventtype[df$sector=="Private not-for-profit, 4-year or above"]<-"PNP 4yr univ"
df$eventtype[is.na(df$eventtype) & !is.na(df$sector)]<-"other college/univ"


df %>% dplyr::count(eventtype)
str(df$eventtype)

df$eventtype <- factor(df$eventtype) # convert to factor variable
str(df$eventtype)

df %>% dplyr::count(eventtype)


#lots of "other"/college fairs: Bama
#lots of events at both CCs and 4-year pub univs: Bama

#geographic markets, in-state vs out-state-ALL EVENT TYPES
df$event_inst[df$instst==df$event_state]<-"In-State"
df$event_inst[df$instst!=df$event_state]<-"Out-State"

#Modify order/name of factor associated with event_type
  df %>% dplyr::count(eventtype)
  
  df <- df %>% mutate(event_type = recode_factor(as.integer(eventtype), 
                `7` = "public hs", `4` = "private hs", `5` = "2yr college", `2` = "4yr college", `3` = "4yr college", `6` = "4yr college", `1` = "other"))
  
  df %>% dplyr::count(event_type)
  str(df$event_type)
  str(as.character(df$event_type))

  #convert event_type to character because students won't yet know about factors
  df$event_type <- (as.character(df$event_type))
  df %>% dplyr::count(event_type)
  str(df$event_type)
  

#SAVE DATASET FOR USE IN R CLASS [ALL VARIABLES]
df <- as.tibble(df)
df_event_all <- df
attributes(df_event_all)
save(df_event_all, file = "data/recruiting/recruit_event_allvars.RData")
rm(list = ls()) # remove all objects

load("data/recruiting/recruit_event_allvars.Rdata")


#Create version of dataset that has selected variables

#avgmedian_inc_2564
df_event <- select(df_event_all, instnm, univ_id, instst, pid, event_date, event_type, zip, school_id, ipeds_id, event_state, event_inst, avgmedian_inc_2564,pop_total,pct_white_zip,pct_black_zip,pct_asian_zip,pct_hispanic_zip,pct_amerindian_zip,pct_nativehawaii_zip,pct_tworaces_zip,pct_otherrace_zip,free_reduced_lunch,titlei_status_pub,total_12,school_type_pri,school_type_pub,g12offered,g12,total_students_pub,total_students_pri,event_name,event_location_name, event_datetime_start)


#shorten variable names
df_event <- dplyr::rename(df_event, med_inc = avgmedian_inc_2564, fr_lunch = free_reduced_lunch)
attributes(df_event$event_type)

glimpse(df_event)
save(df_event, file = "data/recruiting/recruit_event_somevars.RData")
rm(list = ls()) # remove all objects
load("data/recruiting/recruit_event_somevars.Rdata")
str(df_event)
