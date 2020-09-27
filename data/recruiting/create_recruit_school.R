

########
######## CREATE CLASS DATASET FOR DATA WITH ONE OBSERVATION PER HIGH SCHOOL
########

rm(list = ls()) # remove all objects

#use all school data
#setwd("/Users/Karina/Dropbox/recruiting-m1/analysis/data")
#all<-read.csv("data/recruiting/data_hs.csv", na.strings = "")

all <-read.csv("data/recruiting/data_hs.csv", 
               na.strings = "",
               colClasses=c(state_code="character",
                            ncessch="character",
                            name="character",
                            address="character",
                            city="character",
                            zip_code="character",
                            total_students="numeric",
                            school_type="character"
               )
)


str(all)
names(all)
all <- as.tibble(all)


#set INST state
all$inst_196097<-"NY"
all$inst_186380<-"NJ"
all$inst_215293<-"PA"
all$inst_201885<-"OH"
all$inst_181464<-"NE"
all$inst_139959<-"GA"
all$inst_218663<-"SC"
all$inst_100751<-"AL"
all$inst_199193<-"NC"
all$inst_110635<-"CA"
all$inst_110653<-"CA"
all$inst_126614<-"CO"
all$inst_155317<-"KS"
all$inst_106397<-"AR"
all$inst_149222<-"IL"
all$inst_166629<-"MA"

names(all)
table(all$school_type)

#"110635"="UC Berkeley",
#"126614"="CU Boulder" ,
#"100751"="Bama",

table(all$visits_by_110635) # berkeley
table(all$visits_by_126614) # Boulder
table(all$visits_by_100751) # Bama

#these vars are just always equal to the state of the university
table(all$inst_110635) # berkeley
table(all$inst_126614) # Boulder
table(all$inst_100751) # Bama

names(all)

#save version with all variables
df_school_all <- all

save(df_school_all, file = "data/recruiting/recruit_school_allvars.RData")
rm(list = ls()) # remove all objects
load("data/recruiting/recruit_school_allvars.Rdata")
names(df_school_all)

#save version with selected variables
df_school <- select(df_school_all,state_code,school_type,ncessch,name,address,city,zip_code,pct_white,pct_black,pct_hispanic,pct_asian,pct_amerindian,pct_other,num_fr_lunch,total_students,num_took_math,num_prof_math,num_took_rla,num_prof_rla,avgmedian_inc_2564,visits_by_110635,visits_by_126614,visits_by_100751,inst_110635,inst_126614,inst_100751)

names(df_school)

attributes(df_school)

save(df_school, file = "data/recruiting/recruit_school_somevars.RData")
rm(list = ls()) # remove all objects
load("data/recruiting/recruit_school_somevars.Rdata")

