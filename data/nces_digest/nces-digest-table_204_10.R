
library(readxl)

getwd()

##link to online table: http://nces.ed.gov/programs/digest/d14/tables/dt14_204.10.asp
##link to excel file: https://nces.ed.gov/programs/digest/d14/tables/xls/tabn204.10.xls

download.file("http://nces.ed.gov/programs/digest/d14/tables/xls/tabn204.10.xls",
              destfile="data/nces_digest/tabn204_10.xls", mode="wb")

tabn204_10 <- read_excel("data/nces_digest/tabn204_10.xls",skip=4,col_names=FALSE)

head(tabn204_10)

# Now need to clean up 
#Get rid of unwanted columns

tabn204_10v2 <- tabn204_10[ ,-(c(3,6,9,12,15,18))]
names(tabn204_10v2)
#Get rid of unwanted rows

tabn204_10v2 <- tabn204_10v2 %>% filter(is.na(X__1)==FALSE)

##50 states plus dc only
tabn204_10v2<-tabn204_10v2[2:52,]

head(tabn204_10v2)
tail(tabn204_10v2)

names(tabn204_10v2)<-c("state",
                "tot_2000",
                "tot_2010",
                "tot_2011",
                "tot_2012",
                "frl_2000",
                "frl_2010",
                "frl_2011",
                "frl_2012",
                "p_frl_2000",
                "p_frl_2010",
                "p_frl_2011",
                "p_frl_2012")

names(tabn204_10v2)
class(tabn204_10v2)
str(tabn204_10v2)

table204_10 <- tabn204_10v2
rm(tabn204_10,tabn204_10v2)
#save as .rdata file
save(table204_10, file = "data/nces_digest/nces_digest_table_204_10.RData")

load("data/nces_digest/nces_digest_table_204_10.RData")
head(table204_10)

## CREATING TIDY DATA [FROM DOYLE LECTURE]

total<-table204_10%>%select(state,
                           tot_2000,
                           tot_2010,
                           tot_2011,
                           tot_2012)

names(total)<-c("state","2000","2010","2011","2012")

head(total)

total_long<-total%>%gather(`2000`,`2010`,`2011`,`2012`,key=year,value=total_students)

total_long<- total_long %>% arrange(state,year)

head(total_long, n=10)



#### CODE FROM WILL I HAVEN'T CHANGED YET
frl_total<-free2%>%select(state,
                          frl.2000,
                          frl.2010,
                          frl.2011,
                          frl.2012)

names(frl_total)<-c("state","2000","2010","2011","2012")

frl_total<-frl_total%>%gather(`2000`,`2010`,`2011`,`2012`,key=year,value=frl_students)



free_tidy<-left_join(free_total,frl_total,by=c("state","year"))

free_tidy

## Total by year

free_tidy%>%group_by(year)%>%summarize(sum(frl_students))



pc.frl_total<-free2%>%select(state,
                             pc.frl.2000,
                             pc.frl.2010,
                             pc.frl.2011,
                             pc.frl.2012)

names(pc.frl_total)<-c("state","2000","2010","2011","2012")

pc_frl_total<-pc.frl_total%>%gather(`2000`,`2010`,`2011`,`2012`,key=year,value=pc_frl_students)