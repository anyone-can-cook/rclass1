---
title: "R Operators & Pipes"
author: 
date: 
urlcolor: blue
output: 
  html_document:
    toc: true
    toc_depth: 2
    toc_float: true # toc_float option to float the table of contents to the left of the main document content. floating table of contents will always be visible even when the document is scrolled
      #collapsed: false # collapsed (defaults to TRUE) controls whether the TOC appears with only the top-level (e.g., H2) headers. If collapsed initially, the TOC is automatically expanded inline when necessary
      #smooth_scroll: true # smooth_scroll (defaults to TRUE) controls whether page scrolls are animated when TOC items are navigated to via mouse clicks
    number_sections: true
    fig_caption: true # ? this option doesn't seem to be working for figure inserted below outside of r code chunk    
    highlight: tango # Supported styles include "default", "tango", "pygments", "kate", "monochrome", "espresso", "zenburn", and "haddock" (specify null to prevent syntax    
    theme: default # theme specifies the Bootstrap theme to use for the page. Valid themes include default, cerulean, journal, flatly, readable, spacelab, united, cosmo, lumen, paper, sandstone, simplex, and yeti.
    df_print: tibble #options: default, tibble, paged
    keep_md: true # may be helpful for storing on github
    
---



# Introduction

Load packages:

```r
#install.packages('tidyverse')
library(tidyverse)
```


Load data:  

```r
#data we used in the last problem set
load(url('https://github.com/anyone-can-cook/rclass1/raw/master/data/recruiting/recruit_event_somevars.RData'))  

#data we are using in this lecture 
load(url("https://github.com/ozanj/rclass/raw/master/data/prospect_list/wwlist_merged.RData"))
```

Resources used to create this document:

- https://www.datamentor.io/r-programming/precedence-associativity/  
- https://stat.ethz.ch/R-manual/R-devel/library/base/html/Syntax.html  
- https://www.w3adda.com/r-tutorial/r-operator-precedence


# Operator Precedence and Associativity  

It is important to understand operator precedence and associativity when working with data in general, but particularly when we use logical operators like `&` or `|` to filter data.  

<br>  

**Operator Precedence**  

Operator Precedence refers to the order in which operators are executed. If you recall [PEMDAS](https://study.com/academy/lesson/what-is-pemdas-definition-rule-examples.html#:~:text=PEMDAS%20is%20an%20acronym%20for,until%20the%20calculation%20is%20complete.), multiplication `*` takes precedence over addition `+`.   


```r
1 + 2 * 6
```

```
## [1] 13
```

If we add a parenthesis to the equation, our answer changes.  

```r
(1 + 2) * 6
```

```
## [1] 18
```

<br>   

**Operator Associativity**  

When you are working with operators with the same precedence, the execution of the operators is determined through associativity. 


```r
8 / 4 / 2
```

```
## [1] 1
```


```r
8 / (4 / 2)
```

```
## [1] 4
```

*Credit: [R Operator Precedence and Associativity](https://www.w3adda.com/r-tutorial/r-operator-precedence), [Operator Syntax and Precedence](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Syntax.html)*
  
<br>   
  
**R logical operator precedence**  

According to this [link](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Syntax.html), the `&` takes precedence over `|`. And both logical operators are left-associative, meaning they are evaluated from left to right.  

*Credit [R Operator Precedence](https://www.datamentor.io/r-programming/precedence-associativity/)*  

<br>  

**Now let's see an example using the data frame from problem set 3**   


Why do we get different results?

```r
nrow(subset(df_event, event_state %in% c("CA", "FL", "MA") & event_type == "public hs" | total_students_pri > 1000))
```

```
## [1] 2911
```

```r
nrow(subset(df_event, event_state %in% c("CA", "FL", "MA") & (event_type == "public hs" | total_students_pri > 1000)))
```

```
## [1] 2151
```


Let's try to put our code into words.   

The first code reads. Return observations where the recruiting visit took place at a public high school in the state of California, Florida, or Massachusetts **OR** a private high school where the total number of students is greater than 1000. 


```r
tail(subset(df_event, event_state %in% c("CA", "FL", "MA") & event_type == "public hs" | total_students_pri > 1000, select = c(event_state, event_type, total_students_pri)))
```

```
## # A tibble: 6 x 3
##   event_state event_type total_students_pri
##   <chr>       <chr>                   <dbl>
## 1 HI          private hs               1383
## 2 HI          private hs               1880
## 3 OR          private hs               1300
## 4 OR          private hs               1300
## 5 OR          private hs               1300
## 6 WA          private hs               1132
```

The second code reads. Return observations where the recruiting visit took place at a public high school **OR** private high school where the total number of students is greater than 1000 in the state of California, Florida, or Massachusetts.


```r
tail(subset(df_event, event_state %in% c("CA", "FL", "MA") & (event_type == "public hs" | total_students_pri > 1000), select = c(event_state, event_type, total_students_pri)))
```

```
## # A tibble: 6 x 3
##   event_state event_type total_students_pri
##   <chr>       <chr>                   <dbl>
## 1 CA          public hs                  NA
## 2 CA          public hs                  NA
## 3 CA          public hs                  NA
## 4 CA          public hs                  NA
## 5 CA          public hs                  NA
## 6 CA          public hs                  NA
```


# Practice with pipes    

**wwlist** data frame  

- De-identified list of prospective students purchased by Western Washington University from College Board
- We collected these data using public records requests request


```r
dim(wwlist)
```

```
## [1] 268396     41
```

```r
names(wwlist)
```

```
##  [1] "receive_date"           "psat_range"             "state"                 
##  [4] "zip9"                   "for_country"            "sex"                   
##  [7] "hs_ceeb_code"           "hs_name"                "hs_city"               
## [10] "hs_state"               "hs_grad_date"           "ethn_code"             
## [13] "homeschool"             "firstgen"               "zip5"                  
## [16] "pop_total_zip"          "pop_white_zip"          "pop_black_zip"         
## [19] "pop_asian_zip"          "pop_latinx_zip"         "pop_nativeam_zip"      
## [22] "pop_nativehawaii_zip"   "pop_multirace_zip"      "pop_otherrace_zip"     
## [25] "med_inc_zip"            "school_type"            "merged_hs"             
## [28] "school_category"        "total_12"               "total_students"        
## [31] "fr_lunch"               "pop_total_state"        "pop_white_state"       
## [34] "pop_black_state"        "pop_nativeam_state"     "pop_asian_state"       
## [37] "pop_nativehawaii_state" "pop_otherrace_state"    "pop_multirace_state"   
## [40] "pop_latinx_state"       "med_inc_state"
```

```r
#glimpse(wwlist)
#str(wwlist)
```

Let's use `select()`, `filter()`, and `arrange()` to do the following using the Base R approach:  

- Sort `wwlist` descending by `total_students`  
- Select the following variables: `hs_state`,  `hs_city`, `hs_name`, `school_type`, `total_students`  
- Filter for private schools `(school_type == "private")`  
- Print the first 10 observations

```r
head(select(arrange(filter(wwlist, school_type == "private"), desc(total_students)), hs_state, hs_city, hs_name, school_type, total_students), n = 10)
```

```
## # A tibble: 10 x 5
##    hs_state hs_city   hs_name                      school_type total_students
##    <chr>    <chr>     <chr>                        <chr>                <int>
##  1 GA       Norcross  James Madison High School    private               4500
##  2 GA       Norcross  James Madison High School    private               4500
##  3 IL       Lansing   American School              private               3356
##  4 <NA>     <NA>      <NA>                         private               2014
##  5 NC       Charlotte Charlotte Country Day School private               1603
##  6 NC       Charlotte Providence Day School        private               1603
##  7 NC       Charlotte Charlotte Country Day School private               1603
##  8 NC       Charlotte Providence Day School        private               1603
##  9 NC       Charlotte Providence Day School        private               1603
## 10 NC       Charlotte Charlotte Country Day School private               1603
```


```r
df_temp <- filter(wwlist,school_type == "private")
df_temp2 <- arrange(df_temp,desc(total_students))
head(select(df_temp2, hs_state, hs_city, hs_name, school_type, total_students),n=10)
```

```
## # A tibble: 10 x 5
##    hs_state hs_city   hs_name                      school_type total_students
##    <chr>    <chr>     <chr>                        <chr>                <int>
##  1 GA       Norcross  James Madison High School    private               4500
##  2 GA       Norcross  James Madison High School    private               4500
##  3 IL       Lansing   American School              private               3356
##  4 <NA>     <NA>      <NA>                         private               2014
##  5 NC       Charlotte Charlotte Country Day School private               1603
##  6 NC       Charlotte Providence Day School        private               1603
##  7 NC       Charlotte Charlotte Country Day School private               1603
##  8 NC       Charlotte Providence Day School        private               1603
##  9 NC       Charlotte Providence Day School        private               1603
## 10 NC       Charlotte Charlotte Country Day School private               1603
```

```r
rm(df_temp,df_temp2)
```

Now let's use pipes `%` 

```r
wwlist %>%
  filter(school_type == "private") %>%
  arrange(desc(total_students)) %>%
  select(state, hs_name, school_type, total_students) %>%
  head(n = 10)
```

```
## # A tibble: 10 x 4
##    state hs_name                      school_type total_students
##    <chr> <chr>                        <chr>                <int>
##  1 SD    James Madison High School    private               4500
##  2 HI    James Madison High School    private               4500
##  3 MT    American School              private               3356
##  4 HI    <NA>                         private               2014
##  5 NC    Charlotte Country Day School private               1603
##  6 NC    Providence Day School        private               1603
##  7 NC    Charlotte Country Day School private               1603
##  8 NC    Providence Day School        private               1603
##  9 NC    Providence Day School        private               1603
## 10 NC    Charlotte Country Day School private               1603
```

<br>  

**Your turn**  

Use`select()`, `filter()`, and `arrange()` to do the following using both the Base R & tidyverse approach:

- Sort `wwlist` descending by `med_inc_zip`  
- Select the following variables: `hs_state`,  `hs_city`, `hs_name`, `school_type`, `med_inc_zip`, `ethn_code`, `med_inc_state`  
- Filter for public schools `(school_type == "public")` in the state of New York `hs_state == "NY"`
- Print the first 10 observations

**Base R**


**Tidyverse using pipes**  



<br>  

Now let's use`select()`, `filter()`, and `arrange()` to do the following using both the Base R & tidyverse approach:  

- Sort `wwlist` descending by `med_inc_zip`  
- Select the following variables: `hs_state`,  `hs_city`, `hs_name`, `school_type`, `med_inc_zip`, `ethn_code`, `med_inc_state`  
- Filter for public schools `(school_type == "public")` where the `med_inc_zip` is less than the `med_inc_state`
- Print the first 10 observations

**Base R**


**Tidyverse using pipes**


<br>  

**Bonus** question   

- Write down a question you have about the data.  
- Using any or all of the following functions `select()`, `filter()`, `arrange()`, how would you go about subsetting and sorting the data to answer your question?  

Write down your question below:  


Now try to work through your question. 


  
