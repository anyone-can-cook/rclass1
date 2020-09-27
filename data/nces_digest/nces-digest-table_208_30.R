library(readxl)

getwd()
setwd("~/Desktop/GitHub/rclass/data/nces_digest")

##link to online table: https://nces.ed.gov/programs/digest/d15/tables/dt15_208.30.asp
##link to excel file: https://nces.ed.gov/programs/digest/d15/tables/xls/tabn208.30.xls


download.file("https://nces.ed.gov/programs/digest/d15/tables/xls/tabn208.30.xls",
              destfile="tabn208_30.xls", mode="wb")

tabn208_30 <- read_excel("tabn208_30.xls",skip=5,col_names=FALSE)

head(tabn208_30)

# Now need to clean up 
#Get rid of unwanted columns

tabn208_30v2 <- tabn208_30[ ,-(c(3,5,7,9,11,13,15,17,20,22,24,26))]
names(tabn208_30v2)

#Get rid of other vars we do not need
tabn208_30v2 <- tabn208_30v2 %>%
  select(1:6)

#Don't need NA rows for X__1; Get rid of unwanted rows
tabn208_30v3 <- tabn208_30v2 %>%
  filter(!is.na(X__1))

head(tabn208_30v3)

##50 states plus dc only
tabn208_30v3<-tabn208_30v3[2:52,]

head(tabn208_30v3)
tail(tabn208_30v3)

names(tabn208_30v3)<-c("state",
                       "tot_fall_2000",
                       "tot_fall_2005",
                       "tot_fall_2009",
                       "tot_fall_2010",
                       "tot_fall_2011")

names(tabn208_30v3)
class(tabn208_30v3)
str(tabn208_30v3)

table208_30 <- tabn208_30v3

#save as .rdata file
save(table208_30, file = "nces_digest_table_208_30.RData")

load("nces_digest_table_208_30.RData")
head(tabn208_30)

