# CLEAR MEMORY
rm(list = ls())


#LOAD LIBRARIES 
    options(max.print=999999)
    library(tidyverse)
    library(DataExplorer)
    library(reshape2)
    library(stringr)
    library(plyr)
    library(scales)
    library(ggmap) #uses google maps API
    library(maps)
    library(mapdata)
    library(ggplot2)
    library(mapproj)
    library(assertthat)
    library(zipcode)
    library(rgeos)
    library(rgdal)
    library(maptools)
    

    options(scipen=999)


#LOAD RECRUITING DATA, MERGE IN URBANICITY, CREATE EVENT TYPE CATEGORIZATION
    
  ##load in data
    all<-read.csv("../data/events_data_latlong.csv", na.strings="")

  #assert unitid and pid uniquely id obs
    assert_that(any(duplicated(all, by=c("univ_id", "pid")))==FALSE)
    
  ##for now drop events w missing location
    count(all$event_state) #19 are missing 
    all[is.na(all$event_state), "univ_id"] #missing are across diff univs
    all<-all[!is.na(all$event_state),] 
    all[is.na(all$event_state), "univ_id"] #now zero
    
  ##drop if ipeds_id of recruting event=ipeds_id of institution (on campus event)
    count(is.na(all$ipeds_id)) #1,200 events are on a coll/univ campus
    count(all$univ_id==all$ipeds_id) #Zero of 1,200 are on-campus
    
  ##load in urbanicity data
    zip<-read.csv("../data/urbantozip.csv", colClasses=c('numeric', 'factor', 'factor'))  
    
  ##some zips belong to more than one area, keep area with largest % of zip population
    zip <- zip[order(zip$ZCTA5, -abs(zip$UAPOPPCT) ), ] #sort by id and reverse of abs(value) of pop
    zip<- zip[ !duplicated(zip$ZCTA5), ] # take the first row within each id
    
    names(all)[names(all) == 'determined_zip'] <- 'zip'
    names(zip)[names(zip) == 'ZCTA5'] <- 'zip'
    
    df <- merge(x = all, y = zip[ , c("UANAME", "zip")], by="zip", all.x=TRUE)
    
  ##create visit type var
    table(df$sector)
    df$eventtype[is.na(df$school_id) & is.na(df$ipeds_id)]<-"other"
    df$eventtype[nchar(as.character(df$school_id))>8]<-"public hs"
    df$eventtype[nchar(as.character(df$school_id))<= 8]<-"private hs"
    df$eventtype[df$sector=="Public, 2-year"]<-"pub 2yr cc"
    df$eventtype[df$sector=="Public, 4-year or above"]<-"pub 4yr univ"
    df$eventtype[df$sector=="Private not-for-profit, 4-year or above"]<-"PNP 4yr"
    df$eventtype[is.na(df$eventtype) & !is.na(df$sector)]<-"other college/univ"
    count(df$eventtype)
    


#FREQ FUNCTION
    ##arguments: (1) university unitid (2) university name (3) in-state abbreviation
    
    freq<-function(unitid, univname, instate) {
      
      #create a tempdf based on unitid
      tempdf<-subset(df, df$univ_id==unitid)
      
      #total events
      print(paste(univname, " total events: ", table(tempdf$univ_id), sep=""))
      
      #count of visits by type
      x<- table(tempdf$eventtype)
      obs<-melt(x)
      print(ggplot(obs,aes(x=as.factor(Var1),y=value))+
              geom_bar(stat='identity') +
              xlab("Visits by Type") + ylab("Num of Visits") +
              ggtitle(univname))
      
      
      #count of visits by type and in-state/out-state
      tempdf$event_inst[tempdf$event_state==instate]<-"In-State"
      tempdf$event_inst[tempdf$event_state!=instate]<-"Out-State"
      
      props<- prop.table(table(tempdf$eventtype, tempdf$event_inst),1) 
      obs<-melt(props)
      print(props)
      
      ggplot(obs, aes(Var1, value)) +   
        geom_bar(aes(fill = Var2), position = "dodge", stat="identity") +
        scale_x_discrete(labels = wrap_format(8)) +
        labs(title = univname, x = "Visits by Type", y = "Proportion of Total Visits", col = "In State or Out of State") 
    
    }
    
    usa <- map_data("usa")
    
    ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group), fill="white", color="black") + 
      geom_point(data=) +
      coord_fixed(1.3)
       
    
#MAPPING FUNCTION 
    ##arguments: (1) university id
    
    
    ##populate map
    map<-function(unitid) {
      
        ##load USA map
        usa <- map_data("state")
        usa$stateabb <- state.abb[match(usa$region, tolower(state.name))]
      
        states <- aggregate(cbind(long, lat) ~ stateabb, data=usa, 
                          FUN=function(x)mean(range(x)))
        
        
        ##load in-state map
        usa <- map_data("state")
        usa$stateabb <- state.abb[match(usa$region, tolower(state.name))]
        
        states <- aggregate(cbind(long, lat) ~ stateabb, data=usa, 
                            FUN=function(x)mean(range(x)))
      
        #create a tempdf based on unitid
        tempdf<-subset(df, df$univ_id==unitid)  
        
        #print usa map
        print(ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group), fill="white", color="black") + 
                geom_point(aes(x = long, y = lat, color = eventtype), data=tempdf, size = 0.5) +
                geom_text(data=states, aes(long, lat, label=stateabb), size=3) +
                coord_fixed(1.3) )
    }
    
    
    # Prepare the zip poly data for US
    mydata <- readOGR(dsn = "../data/zip_geodata", layer = "cb_2017_us_zcta510_500k")
    
    # Get polygon data for TX only
    mypoly <- subset(mydata, ZCTA5CE10 %in% zip$zip)
  

    
    #merge by zipcode for characteristics data
    mypoly <- merge(mypoly, zip, by.x="ZCTA5CE10", by.y="zip", all.x = TRUE)
    
    # Create a new group with the first three digit.
    # Drop unnecessary factor levels.
    mypoly$group <- substr(mypoly$ZCTA5CE10, 1,3)
    mypoly$ZCTA5CE10 <- droplevels(mypoly$ZCTA5CE10)
    
    # Merge polygons using the group variable
    # Create a data frame for ggplot.
    mypoly.union <- unionSpatialPolygons(mypoly, mypoly$group)
    
    mymap <- fortify(mypoly.union)
    plot(mypoly)
    plot(mypoly.union, add = T, border = "red", lwd = 1)
    
  
#CALL FUNCTIONS 
    
    ##freq arguments: (1) university unitid (2) university name (3) in-state abbreviation
    freq(196097, "SUNY Stony Brook", "NY")
    
    ##map arguments: (1) university unitid
    map(196097)

  
    
