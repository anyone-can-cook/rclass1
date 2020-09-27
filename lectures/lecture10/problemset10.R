#=======================================================================================================================================================
#PROBLEM SET #10
#NAME
#=======================================================================================================================================================


#=======================================================================================================================================================
#RUN ALL THIS CODE, YOU WILL START AT LINE 175
#=======================================================================================================================================================


#=======================================================================================================================================================
#LOAD LIBRARIES
#options(max.print=999999)
library(tidyverse)
library(haven)
library(labelled)
#=======================================================================================================================================================


#=======================================================================================================================================================
#READ IN IC DIRECTORY DATA   
getwd()

#Set working directory before downloading  
#setwd()
#Downloading file from the ipeds website
download.file("https://nces.ed.gov/ipeds/datacenter/data/HD2017.zip",
              destfile = "hd2017", mode = "wb")

#unzip zip file and keep original name
unzip(zipfile = "hd2017" , unzip = "unzip")

#Review documentation before reading in data 
hd <- read_csv("hd2017.csv") 


#Change names to lowercase  
names(hd) <- tolower(names(hd))

names(hd)  

#Subset dataframe to only a few columns  
hd <- hd %>%
  select(unitid, instnm, city, stabbr, zip, opeid, sector,
         iclevel, control, hbcu, tribal, c15basic)

#Label variable and value labels  

#Variable labels
hd <- hd %>%
  set_variable_labels(
    unitid = "Unique identification number of the institution",
    instnm = "Institution name",
    city = "City location of institution",
    stabbr = "State abbreviation",
    zip = "Zip code",
    opeid = "Office of Postsecondary Education (OPE) ID Number",
    sector = "Sector of institution",
    iclevel = "Level of institution",
    control = "Control of institution",
    hbcu = "Historically Black College or University",
    tribal = "Tribal college",
    c15basic = "Carnegie Classification 2015: Basic"
  )

hd %>%
  count(hbcu)

hd %>%
  count(tribal)

hd %>% 
  count(c15basic)

#Set value labels

hd <- hd %>%
  set_value_labels(sector = c("Administrative Unit" = 0, 
                              "Public, 4-year or above" = 1, 
                              "Private not-for-profit, 4-year or above" = 2,
                              "Private for-profit, 4-year or above" = 3, 
                              "Public, 2-year" = 4, 
                              "Private not-for-profit, 2-year" = 5, 
                              "Private for-profit, 2-year" = 6,
                              "Public, less-than 2-year" = 7, 
                              "Private not-for-profit, less-than 2-year" = 8,
                              "Private for-profit, less-than 2-year" = 9, 
                              "Sector unknown (not active)" = 99), 
                   iclevel = c("Four or more years" = 1, 
                               "At least 2 but less than 4 years" = 2, 
                               "Less than 2 years (below associate)" = 3,
                               "{Not available}" = -3),
                   control = c("Public" = 1, "Private not-for-profit" = 2, 
                               "Private for-profit" = 3, 
                               "{Not available}" = -3),
                   hbcu = c("Yes" = 1,
                            "No" = 2),
                   tribal = c("Yes" = 1,
                              "No" = 2),
                   c15basic = c("Associate's Colleges: High Transfer-High Traditional" = 1,
                                "Associate's Colleges: High Transfer-Mixed Traditional/Nontraditional" = 2,
                                "Associate's Colleges: High Transfer-High Nontraditional" = 3,
                                "Associate's Colleges: Mixed Transfer/Career & Technical-High Traditional" = 4,
                                "Associate's Colleges: Mixed Transfer/Career & Technical-Mixed Traditional/Nontraditional" = 5,
                                "Associate's Colleges: Mixed Transfer/Career & Technical-High Nontraditional" = 6,
                                "Associate's Colleges: High Career & Technical-High Traditional" = 7,
                                "Associate's Colleges: High Career & Technical-Mixed Traditional/Nontraditional" = 8,
                                "Associate's Colleges: High Career & Technical-High Nontraditional" = 9,
                                "Special Focus Two-Year: Health Professions" = 10,
                                "Special Focus Two-Year: Technical Professions" = 11,
                                "Special Focus Two-Year: Arts & Design" = 12,
                                "Special Focus Two-Year: Other Fields" = 13,
                                "Baccalaureate/Associate's Colleges: Associate's Dominant" = 14,
                                "Doctoral Universities: Highest Research Activity" = 15,
                                "Doctoral Universities: Higher Research Activity" = 16,
                                "Doctoral Universities: Moderate Research Activity" = 17,
                                "Master's Colleges & Universities: Larger Programs" = 18,
                                "Master's Colleges & Universities: Medium Programs" = 19,
                                "Master's Colleges & Universities: Small Programs" = 20,
                                "Baccalaureate Colleges: Arts & Sciences Focus" = 21,
                                "Baccalaureate Colleges: Diverse Fields" = 22,
                                "Baccalaureate/Associate's Colleges: Mixed Baccalaureate/Associate's" = 23,
                                "Special Focus Four-Year: Faith-Related Institutions" = 24,
                                "Special Focus Four-Year: Medical Schools & Centers" = 25,
                                "Special Focus Four-Year: Other Health Professions Schools" = 26,
                                "Special Focus Four-Year: Engineering Schools" = 27,
                                "Special Focus Four-Year: Other Technology-Related Schools" = 28,
                                "Special Focus Four-Year: Business & Management Schools" = 29,
                                "Special Focus Four-Year: Arts, Music & Design Schools" = 30,
                                "Special Focus Four-Year: Law Schools" = 31,
                                "Special Focus Four-Year: Other Special Focus Institutions" = 32,
                                "Tribal Colleges" = 33,
                                "Not applicable, not in Carnegie universe (not accredited or nondegree-granting)" = -2)
  )

#Check a few vars
class(hd$sector)
typeof(hd$sector)

hd %>%
  count(sector) %>%
  as_factor()


class(hd$c15basic)
typeof(hd$c15basic)

hd %>%
  count(c15basic) %>%
  as_factor()


#View all variable labels
var_label(hd)

#View all value labels
val_labels(hd)


#Investigate data/tidy  
head(hd, n = 20)



#investigate data structure
hd %>% # start with data frame object 
  group_by(unitid) %>% # group by unitid
  summarise(n_per_group=n()) %>% # create measure of number of obs per group
  ungroup %>% # ungroup (otherwise frequency table [next step] created) separately for each group (i.e., separate frequency table for each value of unitid)
  count(n_per_group) 
#=======================================================================================================================================================


#=======================================================================================================================================================
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> YOUR CODE STARTS HERE. FOLLOW THE INSTRUCTIONS FROM PDF >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#=======================================================================================================================================================

