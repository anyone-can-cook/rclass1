################################################################################
##
## [ PROJ ] R class 1
## [ FILE ] base_r_week1_video_lecture_script.R
## [ AUTH ] Ozan Jaquette, github = @ozanj
## [ INIT ] 10/8/2020
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

## ---------------------------
## directory paths
## ---------------------------

## ---------------------------
## Load data and create objects
## ---------------------------

rm(list = ls()) # remove all objects in current environment

#load dataset with one obs per recruiting event
load(url("https://github.com/ozanj/rclass/raw/master/data/recruiting/recruit_event_somevars.RData"))

#load dataset with one obs per high school
load(url("https://github.com/ozanj/rclass/raw/master/data/recruiting/recruit_school_somevars.RData"))

# create simple atomic vector
x <- c(1.1, 2.2, 3.3, 4.4, 5.5)

# create list object
list_x <- list(1:3, "a", 4:6) 
  # list_x <- list(var1=1:3, var2="a", var3=4:6) # same as above, but here we name the elements

## ---------------------------
## functions to investigate objects, typeof(), length(), str(), names()
## ---------------------------

#typeof(), length(), str(), names()
?typeof

x

typeof(x)
length(x)
str(x)
names(x)

list_x <- list(var1=1:3, var2="a", var3=4:6) # same as above, but here we name the elements

list_x
typeof(list_x)
length(list_x)
str(list_x)
names(list_x)
names_list_x <- names(list_x)

names_list_x
str(names_list_x)

typeof(df_event)
length(df_event)
str(df_event)
names(df_event)


## ---------------------------
## intro to sub-setting atomic vectors using []
## ---------------------------

x <- c(1.1, 2.2, 3.3, 4.4, 5.5)

x[]
x[1]
x[c(1)]
x[c(1,4)]
x[1:3]
x[4:6]

# simplest approach: subset based on element position

## ---------------------------
## subsetting vectors, approach 3: "using logicals to return elements where the logical == TRUE
## ---------------------------

x
length(x)

length(c(TRUE,TRUE,TRUE,TRUE,TRUE))

x[c(TRUE,TRUE,TRUE,TRUE,TRUE)]

x[c(TRUE,FALSE,TRUE,FALSE,TRUE)]

# isolate elements of x where value of element is greater than 3
x
x[x>3]

# applying this approach to working with "real" datasets
names(df_school)

typeof(df_school$visits_by_100751)
length(df_school$visits_by_100751)
str(df_school$visits_by_100751)

df_school$visits_by_100751[1:100] # print first 100 observations

df_school$visits_by_100751[1:100]>2 # for first 100 obs, did school receive more than 2 visits?

df_school$visits_by_100751[df_school$visits_by_100751>2] # for all obs, return the elements where number of visits >2

df_school$visits_by_100751[1:100][df_school$visits_by_100751[1:100]>2] # for first obs, return the elements where number of visits >2


## ---------------------------
## subsetting elements, focus on train metaphor and [] vs. [[]]
## ---------------------------


list_x <- list(1:3, "a", 4:6) 

list_x[1:2]
str(list_x[1:2])

str(list_x[])

list_x[[1]]

str(list_x[[1]])

str(list_x[1])


list_x <- list(var1=1:3, var2="a", var3=4:6) # same as above, but here we name the elements

names(list_x)

list_x[[1]]
list_x[["var1"]]

typeof(df_event)
names(df_event)

df_event[["event_type"]]

typeof(df_event[["event_type"]])
length(df_event[["event_type"]])
str(df_event[["event_type"]])


## -----------------------------------------------------------------------------
## END SCRIPT
## -----------------------------------------------------------------------------