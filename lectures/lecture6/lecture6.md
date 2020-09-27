---
title: "Lecture 6: Tidy data"
subtitle:  "EDUC 263: Managing and Manipulating Data Using R"
author: Ozan Jaquette
date: 
urlcolor: blue
output: 
  html_document:
    toc: true
    toc_depth: 2
    toc_float: # toc_float option to float the table of contents to the left of the main document content. floating table of contents will always be visible even when the document is scrolled
      collapsed: false # collapsed (defaults to TRUE) controls whether the TOC appears with only the top-level (e.g., H2) headers. If collapsed initially, the TOC is automatically expanded inline when necessary
      smooth_scroll: true # smooth_scroll (defaults to TRUE) controls whether page scrolls are animated when TOC items are navigated to via mouse clicks
    number_sections: true
    fig_caption: true # ? this option doesn't seem to be working for figure inserted below outside of r code chunk    
    highlight: default # Supported styles include "default", "tango", "pygments", "kate", "monochrome", "espresso", "zenburn", and "haddock" (specify null to prevent syntax    
    theme: default # theme specifies the Bootstrap theme to use for the page. Valid themes include default, cerulean, journal, flatly, readable, spacelab, united, cosmo, lumen, paper, sandstone, simplex, and yeti.
    df_print: tibble #options: default, tibble, paged
    keep_md: true # may be helpful for storing on github
    
---

# Introduction

## Logistics

__Reading to do before next class:__

ADD TEXT

__Using `html_document` output for the next two lectures__

ADD TEXT

__Link to mid-term course survey__
[LINK TO MIDTERM SURVEY WILL BE POSTED ON PROBLEM SET #6]

\tableofcontents

## Overview

Creating analysis datasets often require __changing the organizational structure__ of data

Examples:

- You want analysis dataset to have one obs per student, but your data has one obs per student-course
- You want analysis dataset to have one obs per institution, but enrollment data has one obs per institution-enrollment level

Two common ways to change organizational structure of data

1. Use `group_by` to perform calculations separately within groups and then use `summarise` to create an object with one observation per group
    - We did this in week 5
1. __Reshape__ your data -- called __tidying__ in the R tidyverse world -- by transforming columns (variables) into rows (observations) and vice-versa
    - Our topic for today

This lecture is about changing the organizational structure of your data by transforming __untidy__ data into __tidy__ data.  Working with tidy data has many benefits, one of them is that all the packages in the tidyverse are designed to work with tidy data.

Libraries we will use

```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──
```

```
## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
## ✔ readr   1.1.1     ✔ forcats 0.3.0
```

```
## ── Conflicts ────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

```r
library(haven)
library(labelled)
```

We will perform data __tidying__ using functions from the __tidyr__ package, which is a package within tidyverse. 

Show index and example datasets in __tidyr__ package

```r
help(package="tidyr")
# note that example datasets table1, table2, etc. are listed in the index alongside functions

table1
tidyr::table1 # same same
df1 <- table1
str(df1)

table2
table3
```

# Data "structure" vs data "concepts"

Before we define tidy data, we should define the some core terms/concepts about datasets. 

This discussion draws from the 2014 article [Tidy Data](https://www.jstatsoft.org/article/view/v059i10) by Hadley Wickham.

- Wickham (2014) distinguishes between "__data structure__" and "__data concepts__"
    - (Wickham actually uses the term "data semantics", but I don't know what the word "semantics" means, so I'll use the term "data concepts")


## Dataset structure

Dataset structure refers to the "physical layout" of a dataset

- Typically, datasets are "rectangular __tables__ made up of __rows__ and __columns__" (emphasis added).
- a __cell__ is the intersection of one column and one row (think cells in Microsoft Excel)

There are many alternative data structures to present the same underlying data

- Below are two representations of the same underlying data that have different data structures (rows and columns transposed)


```r
#create structure a: treatment as columns, names as rows
structure_a <- tibble(
  name   = c("John Smith","Jane Doe","Mary Johnson"),
  treatmenta    = c(NA, 16, 3),
  treatmentb = c(2, 11, 1)
)

#create structure b: treatment as rows, names as columns
structure_b <- tibble(
  treatment   = c("treatmenta","treatmentb"),
  John_Smith    = c(NA, 2),
  Jane_Doe = c(16,11),
  Mary_Johnson = c(3,1)
)

structure_a
```

```
## # A tibble: 3 x 3
##   name         treatmenta treatmentb
##   <chr>             <dbl>      <dbl>
## 1 John Smith           NA          2
## 2 Jane Doe             16         11
## 3 Mary Johnson          3          1
```

```r
structure_b
```

```
## # A tibble: 2 x 4
##   treatment  John_Smith Jane_Doe Mary_Johnson
##   <chr>           <dbl>    <dbl>        <dbl>
## 1 treatmenta         NA       16            3
## 2 treatmentb          2       11            1
```
### Unit of analysis

__unit of analysis__ [my term, not Wickham's]: 

- What each row represents in a dataset (referring to physical layout of dataset). 

For example:

    - if each row represents a student, you have student level data
    - if each row represents a student-course, you have student-course level data
    - if each row represents an organization-year, you have organization-year level data
 
__Questions__: 

- What does each row represent in the data frame object `structure_a`?

```r
structure_a
```

```
## # A tibble: 3 x 3
##   name         treatmenta treatmentb
##   <chr>             <dbl>      <dbl>
## 1 John Smith           NA          2
## 2 Jane Doe             16         11
## 3 Mary Johnson          3          1
```

- What does each row represent in the data frame object `structure_b`?

```r
structure_b
```

```
## # A tibble: 2 x 4
##   treatment  John_Smith Jane_Doe Mary_Johnson
##   <chr>           <dbl>    <dbl>        <dbl>
## 1 treatmenta         NA       16            3
## 2 treatmentb          2       11            1
```

- What does each row represent in THE DATA FROME OBJECT `DATA_FRAME_NAME [BELOW] [WHAT DATA ARE YOU TRYING TO ADD HERE?]

```r
#INSERT OBJECT
```

## Dataset (semantics) concepts

Think of these dataset _concepts_ as being distinct from dataset _structure_ (rows and columns)

<br>
The difference between data __structure__ and data __concepts__:

- Data __structure__ refers to the the physical layout of the data (e.g., what the rows and columns in a dataset actually represent)
- data __concepts__ -- which were introduced by Wickham (2014) -- refer to how the data __should__ be structured 

### Values, variables, and observations

Wickham (2014, p. 3): "A dataset is a collection of _values_, usually either numbers (if quantitative) or strings (if qualitative). Values are organized in two ways. Every value belongs to a _variable_ and an _observation_."

Wickham (2014) definitions of dataset concepts: _values_, _variables_, and _observations_:

- __value__: A single element within some data structure (e.g., vector, list), usually a number or a character string.
    - e.g. the value of the variable `enrollment` for a one organization in a dataset where each observation represents a postsecondary education institution
- __variables__: "A variable contains all values that measure the same underlying attribute (like height, temperature, duration) across units"
    - e.g., the variable `enrollment` is a vector that contains total enrollment for each organization in the dataset
- __observations__: "An observation contains all values measured on the same unit (like a person, or a day)...across attributes"
    - e.g., the values of each variable for one organization in a dataset where each observation represents a postsecondary education institution

I Recommend writing these definitions down on a separate sheet of paper  
[NOT SURE WHY THIS DATASET IS HERE?]

```r
#Dataset
table1
```

```
## # A tibble: 6 x 4
##   country      year  cases population
##   <chr>       <int>  <int>      <int>
## 1 Afghanistan  1999    745   19987071
## 2 Afghanistan  2000   2666   20595360
## 3 Brazil       1999  37737  172006362
## 4 Brazil       2000  80488  174504898
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```

### Tables and observational unit

A particular project or data collection (e.g., longitudinal survey tracking student achievement from high school through college), may require several data sources:

- data on student characteristics (e.g., name, date of birth) with one observation per student
- data on the high school the student attends with one observation per school
- transcript data with one observation per student-course, etc.

Each of these data sources may use a different "level of observation" and each requiring a different "table" (i.e., dataframe):

- "Table" is the term database people use for what we would refer to as a "dataset" or a "data frame"
- We talk more about "tables" next week, which is about joining/merging data frames

<br>
__Observational unit/observational level__ [Wickham's term, not mine]

> "In a given analysis, there may be multiple __levels of observations__. For example, in a trial of new allergy medication we might have three observational types: demographic data collected from each person (age, sex, race), medical data collected from each person on each day (number of sneezes, redness of eyes), and meteorological data collected on each day (temperature,pollen count) (Wickham 2014, p. 4)"

### Summary/parting thoughts

These data concepts (e.g., value, variable, observation) seem easy on first glance, but can feel slippery on closer inspection. 

In particular, when you confronted with a particular dataset, sometimes it can feel confusing what the variables/observations/unit of analysis __are__ (data structure) and what they __should be__ (data concepts).

# Defining tidy vs. untidy data

## Rules of tidy data (defining tidy data)

Wickham chapter 12: "There are three interrelated rules which make a dataset tidy:

1. Each __variable__ must have its own __column__
1. Each __observation__ must have its own __row__
1. Each __value__ must have its own __cell__"
1. [Additional rule from Wickham (2014)] Each type of __observational unit__ forms a __table__

I Recommend writing these rules down on a separate sheet of paper

"These three rules are interrelated because it’s impossible to only satisfy two of the three" (Wickham chapter 12)

<br>
__Visual representation of the three rules of tidy data__:

![](http://r4ds.had.co.nz/images/tidy-1.png)
Here is an example of tidy data:

```r
#help(package="tidyr")
table1
```

```
## # A tibble: 6 x 4
##   country      year  cases population
##   <chr>       <int>  <int>      <int>
## 1 Afghanistan  1999    745   19987071
## 2 Afghanistan  2000   2666   20595360
## 3 Brazil       1999  37737  172006362
## 4 Brazil       2000  80488  174504898
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```

Question: 

- What is does each observation (data concept) represent in the above dataset?
- What is does each row (data structure) represent in the above dataset?

## Untidy data

> “Tidy datasets are all alike, but every messy dataset is messy in its own way.” –– Hadley Wickham

While __all__ tidy datasets are organized the same way, untidy datasets can have several different organizational structures

<br>
Here is an example of an untidy version of the same data shown in `table1`

```r
#Untidy data, table 2
#help(package="tidyr")
table2
```

```
## # A tibble: 12 x 4
##    country      year type            count
##    <chr>       <int> <chr>           <int>
##  1 Afghanistan  1999 cases             745
##  2 Afghanistan  1999 population   19987071
##  3 Afghanistan  2000 cases            2666
##  4 Afghanistan  2000 population   20595360
##  5 Brazil       1999 cases           37737
##  6 Brazil       1999 population  172006362
##  7 Brazil       2000 cases           80488
##  8 Brazil       2000 population  174504898
##  9 China        1999 cases          212258
## 10 China        1999 population 1272915272
## 11 China        2000 cases          213766
## 12 China        2000 population 1280428583
```

Other examples of untidy data (output omitted):

```r
table3

#tables 4a and 4b put the information from table1 in two separate data frames
table4a
table4b

table5
```

## Diagnosing untidy data

The first step in transforming untidy data to tidy data is diagnosing which principles of tidy data have been violated.

Recall the three principles of tidy data:

1. Each variable must have its own column.
1. Each observation must have its own row.
1. Each value must have its own cell.

Let's diagnose the problems with `table2` by answering these questions

1. Does each variable have its own column?
    - if not, how does the dataset violate this principle?
    - what _should_ the variables be?
1. Does each observation have its own row?
    - if not, how does the dataset violate this principle?
    - what does each row represent _actually_ represent?
    - what _should_ each row represent?
1. Does each value  have its own cell."
    - if not, how does the dataset violate this principle?
    
Printout of `table2`

```r
table2
```

```
## # A tibble: 12 x 4
##    country      year type            count
##    <chr>       <int> <chr>           <int>
##  1 Afghanistan  1999 cases             745
##  2 Afghanistan  1999 population   19987071
##  3 Afghanistan  2000 cases            2666
##  4 Afghanistan  2000 population   20595360
##  5 Brazil       1999 cases           37737
##  6 Brazil       1999 population  172006362
##  7 Brazil       2000 cases           80488
##  8 Brazil       2000 population  174504898
##  9 China        1999 cases          212258
## 10 China        1999 population 1272915272
## 11 China        2000 cases          213766
## 12 China        2000 population 1280428583
```

Answers to these questions:

1. Does each variable have its own column? __No__
    - if not, how does the dataset violate this principle? __"cases" and "population" should be two different variables because they are different attributes, but in `table2` these two attributes are recorded in the column "type" and the associated value for each type is recorded in the column "count"__
    - what _should_ the variables be? __country, year, cases, population__
1. Does each observation have its own row? __No__
    - if not, how does the dataset violate this principle? __there is one observation for each country-year-type. But the values of type (population, cases) represent attributes of a unit, which should be represented by distint variables rather than rows. So `table2` has two rows per observation but it should have one row per observation__
    - what does each row represent _actually_ represent? __country-year-type__
    - what _should_ each row represent? __country-year__
1. Does each value  have its own cell." Yes.
    - if not, how does the dataset violate this principle?

## Student exercise:

For each of the following datasets -- `table1`, `table3`, `table4a`, and `table5` -- answer the following questions:

1. Does each variable have its own column?
    - if not, how does the dataset violate this principle?
    - what _should_ the variables be?
1. Does each observation have its own row?
    - if not, how does the dataset violate this principle?
    - what does each row represent _actually_ represent?
    - what _should_ each row represent?
1. Does each value  have its own cell."
    - if not, how does the dataset violate this principle?

We'll give you ~15 minutes for this

<br>
__ANSWERS TO STUDENT EXERCISE BELOW__:

### `table1`

```r
table1
```

```
## # A tibble: 6 x 4
##   country      year  cases population
##   <chr>       <int>  <int>      <int>
## 1 Afghanistan  1999    745   19987071
## 2 Afghanistan  2000   2666   20595360
## 3 Brazil       1999  37737  172006362
## 4 Brazil       2000  80488  174504898
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```
1. Does each variable have its own column? YES
1. Does each observation have its own row? YES
    - what does each row represent _actually_ represent? COUNTRY-YEAR
    - what _should_ each row represent? COUNTERY-YEAR
1. Does each value  have its own cell." YES

### `table3`

```r
table3
```

```
## # A tibble: 6 x 3
##   country      year rate             
## * <chr>       <int> <chr>            
## 1 Afghanistan  1999 745/19987071     
## 2 Afghanistan  2000 2666/20595360    
## 3 Brazil       1999 37737/172006362  
## 4 Brazil       2000 80488/174504898  
## 5 China        1999 212258/1272915272
## 6 China        2000 213766/1280428583
```

1. Does each variable have its own column? __No__
    - if not, how does the dataset violate this principle? __The column `rate` contains two variables, `cases` and `population`__
    - what _should_ the variables be? __country, year, cases, population__
1. Does each observation have its own row? __Yes__
    - what does each row represent _actually_ represent? __country-year__
    - what _should_ each row represent? __country-year__
1. Does each value  have its own cell." __No__
    - if not, how does the dataset violate this principle? __In the `rate` column, each cell contains two values, a value for `cases` and a value for `population`__
    
### `table4a`

```r
table4a
```

```
## # A tibble: 3 x 3
##   country     `1999` `2000`
## * <chr>        <int>  <int>
## 1 Afghanistan    745   2666
## 2 Brazil       37737  80488
## 3 China       212258 213766
```
1. Does each variable have its own column? __No__
    - if not, how does the dataset violate this principle? __The variable `cases` is spread over two columns and the variable `year` is also spread over two columns__
    - what _should_ the variables be? __country, year, cases__
1. Does each observation have its own row? __No__
    - if not, how does the dataset violate this principle? __There are two country-year observations on each row__
    - what does each row represent _actually_ represent? __country__
    - what _should_ each row represent? __country-year__
1. Does each value  have its own cell." __Yes__

### `table4b` [not required to answer]

```r
table4b
```

```
## # A tibble: 3 x 3
##   country         `1999`     `2000`
## * <chr>            <int>      <int>
## 1 Afghanistan   19987071   20595360
## 2 Brazil       172006362  174504898
## 3 China       1272915272 1280428583
```
Answers pretty much the same as `table4a`, except `table4b` shows data for `population` rather than `cases'

### `table5`

```r
table5
```

```
## # A tibble: 6 x 4
##   country     century year  rate             
## * <chr>       <chr>   <chr> <chr>            
## 1 Afghanistan 19      99    745/19987071     
## 2 Afghanistan 20      00    2666/20595360    
## 3 Brazil      19      99    37737/172006362  
## 4 Brazil      20      00    80488/174504898  
## 5 China       19      99    212258/1272915272
## 6 China       20      00    213766/1280428583
```
1. Does each variable have its own column? __No__
    - if not, how does the dataset violate this principle? __Two problems. First, the single variable `year' is spread across two columns `century` and `year`. Second, the `rate` column contains the two variables `cases` and `population`__
    - what _should_ the variables be? __country, year, cases, population__
1. Does each observation have its own row? __Yes__
    - what does each row represent _actually_ represent? __country, year__
    - what _should_ each row represent?  __country, year__
1. Does each value  have its own cell?" __No__
    - if not, how does the dataset violate this principle? __Two problems. First, the each value of `year' is spread across two cells. Second, the each cell of the `rate` column contains two values, one for `cases` and one for `population`__

## Revisiting definitions of variables and observations

Worthwhile to revisit Wickham's (2014) defintions of _variables_, and _observations_ in light of what we now know about tidy vs. untidy data.

Whenever I work with datasets I tend to think of observations as being synonomous with rows and variables as being synonomous with columns. But if we use Wickham's definitions of observations and variables, this is not true.

- Wickham definition of __variables__: "A variable contains all values that measure the same underlying attribute (like height, temperature, duration) across units"
    - In a tidy dataset, variables and columns are the same thing. 
    - In an untidy dataset, variables and columns are not the same thing; a single variable (i.e., attribute) may be represented by two columns 
        - For example, in `table2` the attribute `population` was represented by two columns, `type` and `count`
- Wickham definition of __observations__: "An observation contains all values measured on the same unit (like a person, or a day)...across attributes"
    - In a tidy dataset, an observations is the same thing as a row
    - In an untidy dataset, the values for a particular unit may be spread across multiple rows. 
        - For example, in `table1` and `table2` Wickham would think of `country-year` as the proper __observational unit__. `table1` has one row per `country-year` (tidy) but `table2` has two rows per `country-year` (untidy). 
        
<br>
__"Observational unit" (data concept) vs. "unit of analysis" (my term; data structure)__

- __observational unit__. Wickham tends to think of observational unit as what each observation should represent (e.g., a person, a person-year) in a tidy dataset
- __unit of analysis__. By contrast (right or wrong), I tend to think of "unit of analysis" as what each row of data _actually_ represents (e.g., country-year-type)

<br>
__Takeways from this discussion of formal data concepts and tidy vs. untidy data__

- In everyday usage, the terms _variable_ and _observation_ refer to data structure, with :
    - variables=columns
    - observations=rows
- In Wickham's definition, the terms _variables_ and _observation_ refer to data contents, with:
    - A variable containing all values of one attribute for all _units_
    - An observation contains the value of all attributes for one _unit_ 
- Can think of Wickham's definitions of variables and observations as belonging only to tidy datasets.
    - Based on Wickham's definition, variables=columns and observations=rows __only__ if the dataset is tidy
    - Can think of Wickham's definitions of variables and observations as what _should be_. 
    
<br>
In real world, we encounter many untidy datasets. We can still equate variables with columns and rows with observations. 

- Just be mindful that you are using the "everyday" definitions of variables and observations rather than the Wickham definitions.






## Why tidy data 

Why should you create tidy datasets before conducting analyses?

1. If you have a consistent organizational structure for analysis datasets, easier to learn tools for analyzing data

2. tidy datasets are optimal for R
- Base R functions and tidyverse functions are designed to work with vectors of values
- In a tidy dataset, each column is the vector of values for a given variable, as shown below


```r
str(table1)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	6 obs. of  4 variables:
##  $ country   : chr  "Afghanistan" "Afghanistan" "Brazil" "Brazil" ...
##  $ year      : int  1999 2000 1999 2000 1999 2000
##  $ cases     : int  745 2666 37737 80488 212258 213766
##  $ population: int  19987071 20595360 172006362 174504898 1272915272 1280428583
```

```r
str(table1$country)
```

```
##  chr [1:6] "Afghanistan" "Afghanistan" "Brazil" "Brazil" "China" ...
```

```r
str(table1$cases)
```

```
##  int [1:6] 745 2666 37737 80488 212258 213766
```
<br>
__Example__:

- how would you calculate `rate` variable (`=cases/population*10000`) for `table1` (tidy) and `table2` (untidy)


```r
#table1
table1 %>% 
  mutate(rate = cases / population * 10000)
```

```
## # A tibble: 6 x 5
##   country      year  cases population  rate
##   <chr>       <int>  <int>      <int> <dbl>
## 1 Afghanistan  1999    745   19987071 0.373
## 2 Afghanistan  2000   2666   20595360 1.29 
## 3 Brazil       1999  37737  172006362 2.19 
## 4 Brazil       2000  80488  174504898 4.61 
## 5 China        1999 212258 1272915272 1.67 
## 6 China        2000 213766 1280428583 1.67
```

```r
#Just looking at table2, obvious that calculating rate is much harder
table2
```

```
## # A tibble: 12 x 4
##    country      year type            count
##    <chr>       <int> <chr>           <int>
##  1 Afghanistan  1999 cases             745
##  2 Afghanistan  1999 population   19987071
##  3 Afghanistan  2000 cases            2666
##  4 Afghanistan  2000 population   20595360
##  5 Brazil       1999 cases           37737
##  6 Brazil       1999 population  172006362
##  7 Brazil       2000 cases           80488
##  8 Brazil       2000 population  174504898
##  9 China        1999 cases          212258
## 10 China        1999 population 1272915272
## 11 China        2000 cases          213766
## 12 China        2000 population 1280428583
```

### Caveat: But tidy data not always best

Datasets are often stored in an untidy structure rather than a tidy structure when the untidy structure has a smaller file size than the tidy structure

- smaller file-size leads to faster processing time, which is very important for web applications (e.g., facebook) and data visualizations (e.g., interactive maps)

## Legacy concepts: "Long" vs. "wide" data

Prior to Wickham (2014) and the creation of the "tidyverse," the concepts of "tidy"/"untidy" (adjective) data and "tidying" (verb) did not exist.  

Instead, researchers would "reshape" (verb) data from "long" (adjective) to "wide" (adjective) and vice-versa

Think "wide" and "long" as alternative presentations of the exact same 

__"wide" data__ represented with fewer rows and more columns  
__"long" data__ represented with more rows and fewer columns

Example, Table 204.10 of the Digest for Education Statistics shows changer over time in the number and percentage of K-12 students on free/reduced lunch [LINK](http://nces.ed.gov/programs/digest/d14/tables/dt14_204.10.asp)

- Wide form display of data:

```r
#load("data/nces_digest/nces_digest_table_204_10.RData")
load(url("https://github.com/ozanj/rclass/raw/master/data/nces_digest/nces_digest_table_204_10.RData"))
table204_10
```

```
## # A tibble: 51 x 13
##    state tot_2000 tot_2010 tot_2011 tot_2012 frl_2000 frl_2010 frl_2011
##    <chr>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>
##  1 Alab…   728351   730427   731556   740475   335143   402386  420447 
##  2 Alas…   105333   132104   131166   131483    32468    50701   53238 
##  3 Ariz…   877696  1067210  1024454   990378   274277   482044  511885 
##  4 Arka…   449959   482114   483114   486157   205058   291608  294324 
##  5 Cali…  6050753  6169427  6202862  6178788  2820611  3335885 3353964.
##  6 Colo…   724349   842864   853610   863121   195148   336426  348896 
##  7 Conn…   562179   552919   543883   549295   143030   190554  194339 
##  8 Dela…   114676   128342   128470   127791    37766    61564   62774 
##  9 Dist…    68380    71263    72329    75411    47839    52027   45199 
## 10 Flor…  2434755  2641555  2668037  2691881  1079009  1479519 1535670 
## # ... with 41 more rows, and 5 more variables: frl_2012 <dbl>,
## #   p_frl_2000 <dbl>, p_frl_2010 <dbl>, p_frl_2011 <dbl>, p_frl_2012 <dbl>
```
- Long form display of data: 

```r
total <- table204_10 %>%
  select(state,tot_2000,tot_2010,tot_2011,tot_2012) #subset and assign to new object
names(total)<-c("state","2000","2010","2011","2012") #change names for year "tot_2010" -> "2010"

total_long <- total %>% 
  gather(`2000`,`2010`,`2011`,`2012`,key=year,value=total_students) %>% #will discuss this function shortly
  arrange(state, year) #arrange by state and year

head(total_long, n=10) #view 10 obs
```

```
## # A tibble: 10 x 3
##    state                         year  total_students
##    <chr>                         <chr>          <dbl>
##  1 Alabama ....................  2000          728351
##  2 Alabama ....................  2010          730427
##  3 Alabama ....................  2011          731556
##  4 Alabama ....................  2012          740475
##  5 Alaska ..................     2000          105333
##  6 Alaska ..................     2010          132104
##  7 Alaska ..................     2011          131166
##  8 Alaska ..................     2012          131483
##  9 Arizona ..................... 2000          877696
## 10 Arizona ..................... 2010         1067210
```

Note that the concepts "wide" vs. "long" are relative rather than absolute

- For example, comparing `table4a` and `table1`: `table4a` is wide and `table1` is long

```r
table4a
```

```
## # A tibble: 3 x 3
##   country     `1999` `2000`
## * <chr>        <int>  <int>
## 1 Afghanistan    745   2666
## 2 Brazil       37737  80488
## 3 China       212258 213766
```

```r
table1
```

```
## # A tibble: 6 x 4
##   country      year  cases population
##   <chr>       <int>  <int>      <int>
## 1 Afghanistan  1999    745   19987071
## 2 Afghanistan  2000   2666   20595360
## 3 Brazil       1999  37737  172006362
## 4 Brazil       2000  80488  174504898
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```
- But comparing `table1` and `table2`: `table1` is wide and `table2` is long

```r
table1
```

```
## # A tibble: 6 x 4
##   country      year  cases population
##   <chr>       <int>  <int>      <int>
## 1 Afghanistan  1999    745   19987071
## 2 Afghanistan  2000   2666   20595360
## 3 Brazil       1999  37737  172006362
## 4 Brazil       2000  80488  174504898
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```

```r
table2
```

```
## # A tibble: 12 x 4
##    country      year type            count
##    <chr>       <int> <chr>           <int>
##  1 Afghanistan  1999 cases             745
##  2 Afghanistan  1999 population   19987071
##  3 Afghanistan  2000 cases            2666
##  4 Afghanistan  2000 population   20595360
##  5 Brazil       1999 cases           37737
##  6 Brazil       1999 population  172006362
##  7 Brazil       2000 cases           80488
##  8 Brazil       2000 population  174504898
##  9 China        1999 cases          212258
## 10 China        1999 population 1272915272
## 11 China        2000 cases          213766
## 12 China        2000 population 1280428583
```


# Tidying data:

Steps in tidying untidy data:

1. Diagnose the problem
    - e.g., Which principles of tidy data are violated and how are they violated? What _should_ the unit of analysis be? What _should_ the variables and observations be?
2. Sketch out what the tidy data should look like [on piece of scrap paper is best!]
3. Transform untidy to tidy

## Common causes of untidy data

Tidy data can only have one organizational structure. 

However, untidy data can have several different organizational structures. In turn, several _causes_ of untidy data exist. Important to identify the most common causes of untidy data, so that we can develop solutions for each common cause.

__The two most common and most important causes of untidy data__

1. Some column names are not names of variables, but values of a variable" (e.g, `table4a`, `table4b`), which results in:
    - a single variable spread (e.g., `population`) over multiple columns (e.g., `1999`, `2000`)
    - a single row contains multiple observations

```r
table4b
```

```
## # A tibble: 3 x 3
##   country         `1999`     `2000`
## * <chr>            <int>      <int>
## 1 Afghanistan   19987071   20595360
## 2 Brazil       172006362  174504898
## 3 China       1272915272 1280428583
```
    
2. An observation is scattered across multiple rows (e.g., `table2`), such that:
    - One column identifies variable type (e.g., `type`) and another column contains the values for each variable (e.g., `count`)

```r
table2
```

```
## # A tibble: 12 x 4
##    country      year type            count
##    <chr>       <int> <chr>           <int>
##  1 Afghanistan  1999 cases             745
##  2 Afghanistan  1999 population   19987071
##  3 Afghanistan  2000 cases            2666
##  4 Afghanistan  2000 population   20595360
##  5 Brazil       1999 cases           37737
##  6 Brazil       1999 population  172006362
##  7 Brazil       2000 cases           80488
##  8 Brazil       2000 population  174504898
##  9 China        1999 cases          212258
## 10 China        1999 population 1272915272
## 11 China        2000 cases          213766
## 12 China        2000 population 1280428583
```
__Other common causes of untidy data (less important and/or less common)__

3. Individual cells in a column contain data from two variables (e.g., the `rate` column in `table3`)

```r
table3
```

```
## # A tibble: 6 x 3
##   country      year rate             
## * <chr>       <int> <chr>            
## 1 Afghanistan  1999 745/19987071     
## 2 Afghanistan  2000 2666/20595360    
## 3 Brazil       1999 37737/172006362  
## 4 Brazil       2000 80488/174504898  
## 5 China        1999 212258/1272915272
## 6 China        2000 213766/1280428583
```
4. Values from a single variable separated into two columns (e.g., in `table5`, values of the 4-digit `year`variable are separated into the two columns, `century` and 2-digit `year` )

```r
table5
```

```
## # A tibble: 6 x 4
##   country     century year  rate             
## * <chr>       <chr>   <chr> <chr>            
## 1 Afghanistan 19      99    745/19987071     
## 2 Afghanistan 20      00    2666/20595360    
## 3 Brazil      19      99    37737/172006362  
## 4 Brazil      20      00    80488/174504898  
## 5 China       19      99    212258/1272915272
## 6 China       20      00    213766/1280428583
```


## Tidying data: gathering

As discussed above, the first common reason for untidy data is that some of the column names are not names of variables, but values of a variable (e.g., `table4a`, `table4b`)

```r
table4a
```

```
## # A tibble: 3 x 3
##   country     `1999` `2000`
## * <chr>        <int>  <int>
## 1 Afghanistan    745   2666
## 2 Brazil       37737  80488
## 3 China       212258 213766
```

The solution to this problem is to transform the untidy columns (which represent variable values) into rows

- In the tidyverse, this process is called "gathering"
- Outside the tidyverse, this process is called "reshaping" from "wide" to "long"

In the above example, we want to transform `table4a` into something that looks like this:

```r
table1 %>% select(country, year, cases)
```

```
## # A tibble: 6 x 3
##   country      year  cases
##   <chr>       <int>  <int>
## 1 Afghanistan  1999    745
## 2 Afghanistan  2000   2666
## 3 Brazil       1999  37737
## 4 Brazil       2000  80488
## 5 China        1999 212258
## 6 China        2000 213766
```

We gather using the `gather()` function from the`tidyr` package. 

```r
#?gather
```

Gathering requires knowing three parameters:

1. names of the set of columns that represent values, not variables in your untidy data 
    - These are existing columns of the untidy data
    - in table 4a these are the columns `1999` and `2000`
2. __key variable__ : variable name you will assign to columns you are gathering from the untidy data
    - This var doesn't yet exist in untidy data, but will be a variable name in the tidy data
    - For the `table4a` example, we'll call this variable `year` because the values of this variable will be years
    - Said different: the "key" is the variable you will create whose values will be the column names from the untidy data. 
3. __value variable__: The name of the variable that will contain values in the tidy dataset you create and whose values are spread across multiple columns in the untidy dataset
    - This var doesn't yet exist in untidy data, but will be a variable name in the tidy data
    - in the `table4a` example, we'll call the "value variable" `cases` because the values refer to number of cases
    

```r
table4a %>% gather(`1999`, `2000`, key = "year", value = "cases")
```

```
## # A tibble: 6 x 3
##   country     year   cases
##   <chr>       <chr>  <int>
## 1 Afghanistan 1999     745
## 2 Brazil      1999   37737
## 3 China       1999  212258
## 4 Afghanistan 2000    2666
## 5 Brazil      2000   80488
## 6 China       2000  213766
```

```r
#Note that we write `1999` rather than 1999 because the column name starts with a number

#This would not work
#table4a %>% gather(1999, 2000, key = "year", value = "cases")

#But giving different names to the key variable and the value variable is fine
table4a %>% gather(`1999`, `2000`, key = "yr", value = "num_cases")
```

```
## # A tibble: 6 x 3
##   country     yr    num_cases
##   <chr>       <chr>     <int>
## 1 Afghanistan 1999        745
## 2 Brazil      1999      37737
## 3 China       1999     212258
## 4 Afghanistan 2000       2666
## 5 Brazil      2000      80488
## 6 China       2000     213766
```
### Student exercise: Real-world example of gathering

[In the task I present below, fine to just work through solution I have created or try doing on your own before you look at solution]

The following dataset is drawn from Table 204.10 of the NCES Digest for Education Statistics. 

- The table shows  change over time in the number and percentage of K-12 students on free/reduced lunch for selected years.
- [LINK to website with data](http://nces.ed.gov/programs/digest/d14/tables/dt14_204.10.asp)

```r
#Let's take a look at the data (we read in the data in the wide vs long section)
glimpse(table204_10)
```

```
## Observations: 51
## Variables: 13
## $ state      <chr> "Alabama ....................", "Alaska ..............
## $ tot_2000   <dbl> 728351, 105333, 877696, 449959, 6050753, 724349, 56...
## $ tot_2010   <dbl> 730427, 132104, 1067210, 482114, 6169427, 842864, 5...
## $ tot_2011   <dbl> 731556, 131166, 1024454, 483114, 6202862, 853610, 5...
## $ tot_2012   <dbl> 740475, 131483, 990378, 486157, 6178788, 863121, 54...
## $ frl_2000   <dbl> 335143, 32468, 274277, 205058, 2820611, 195148, 143...
## $ frl_2010   <dbl> 402386, 50701, 482044, 291608, 3335885, 336426, 190...
## $ frl_2011   <dbl> 420447.00, 53238.00, 511885.00, 294324.00, 3353963....
## $ frl_2012   <dbl> 429604, 53082, 514193, 298573, 3478407, 358876, 201...
## $ p_frl_2000 <dbl> 46.01394, 30.82415, 31.24966, 45.57260, 46.61587, 2...
## $ p_frl_2010 <dbl> 55.08915, 38.37961, 45.16862, 60.48528, 54.07123, 3...
## $ p_frl_2011 <dbl> 57.47298, 40.58826, 49.96662, 60.92227, 54.07123, 4...
## $ p_frl_2012 <dbl> 58.01735, 40.37176, 51.91886, 61.41493, 56.29594, 4...
```

```r
#Create smaller version of data frame for purpose of student exercise
total<- table204_10 %>% 
  select(state,tot_2000,tot_2010,tot_2011,tot_2012)
head(total)
```

```
## # A tibble: 6 x 5
##   state                         tot_2000 tot_2010 tot_2011 tot_2012
##   <chr>                            <dbl>    <dbl>    <dbl>    <dbl>
## 1 Alabama ....................    728351   730427   731556   740475
## 2 Alaska ..................       105333   132104   131166   131483
## 3 Arizona .....................   877696  1067210  1024454   990378
## 4 Arkansas ..................     449959   482114   483114   486157
## 5 California .................   6050753  6169427  6202862  6178788
## 6 Colorado ....................   724349   842864   853610   863121
```

__Task (using the data frame `total`)__: 

1. Diagnose the problem with the data frame `total`
2. Sketch out what the tidy data should look like    
3. Transform untidy to tidy

__Solution to student exercise__

1. Diagnose the problem with the data frame `total`
    - Column names `tot_2000`, `tot_2010`, etc. are not variables; rather they refer to values of the variable `year`
    - Currently each observation represents a state with separate enrollment variables for each year. 
    - Each observation _should_ be a state-year, with only one variable for enrollment
2. Sketch out what the tidy data should look like    
3. Transform untidy to tidy

```r
total_tidy <- total %>% 
  gather(tot_2000,tot_2010,tot_2011,tot_2012, key = year, value = total_students)

#sort data (optional)
total_tidy<- total_tidy %>%
  arrange(state,year)

#examine data
head(total_tidy, n=10)
```

```
## # A tibble: 10 x 3
##    state                         year     total_students
##    <chr>                         <chr>             <dbl>
##  1 Alabama ....................  tot_2000         728351
##  2 Alabama ....................  tot_2010         730427
##  3 Alabama ....................  tot_2011         731556
##  4 Alabama ....................  tot_2012         740475
##  5 Alaska ..................     tot_2000         105333
##  6 Alaska ..................     tot_2010         132104
##  7 Alaska ..................     tot_2011         131166
##  8 Alaska ..................     tot_2012         131483
##  9 Arizona ..................... tot_2000         877696
## 10 Arizona ..................... tot_2010        1067210
```
__Alternative solution to student exercise__

- __Note__: often helpful to rename columns of untidy data -- removing characters -- prior to gathering

```r
#create smaller version of data frame; same as before

totalv2 <- table204_10 %>% 
  select(state,tot_2000,tot_2010,tot_2011,tot_2012)

#rename columns that represent values so that the column names are numbers
  #(e.g., rename tot_2000 to 2000)
names(totalv2)<- c("state","2000","2010","2011","2012")
head(totalv2)
```

```
## # A tibble: 6 x 5
##   state                          `2000`  `2010`  `2011`  `2012`
##   <chr>                           <dbl>   <dbl>   <dbl>   <dbl>
## 1 Alabama ....................   728351  730427  731556  740475
## 2 Alaska ..................      105333  132104  131166  131483
## 3 Arizona .....................  877696 1067210 1024454  990378
## 4 Arkansas ..................    449959  482114  483114  486157
## 5 California .................  6050753 6169427 6202862 6178788
## 6 Colorado ....................  724349  842864  853610  863121
```

```r
#create tidy dataset by gathering, same as before
total_tidyv2 <- totalv2 %>% 
  gather(`2000`,`2010`,`2011`,`2012`, key = year, value = total_students)

#sort data (optional)
total_tidyv2<- total_tidyv2 %>%
  arrange(state,year)

head(total_tidyv2, n=10)
```

```
## # A tibble: 10 x 3
##    state                         year  total_students
##    <chr>                         <chr>          <dbl>
##  1 Alabama ....................  2000          728351
##  2 Alabama ....................  2010          730427
##  3 Alabama ....................  2011          731556
##  4 Alabama ....................  2012          740475
##  5 Alaska ..................     2000          105333
##  6 Alaska ..................     2010          132104
##  7 Alaska ..................     2011          131166
##  8 Alaska ..................     2012          131483
##  9 Arizona ..................... 2000          877696
## 10 Arizona ..................... 2010         1067210
```
PATRICIA - I HAVEN'T INVESTIGATED OUT HOW TO DO THIS BELOW TASK IN A WAY THAT DOESN'T REQUIRE ADVANCED PROGRAMMING. CAN YOU LOOK INTO THIS?

__Task__

- Complete the task above, keeping the free-reduced enrollment variables in addition to the total enrollment variables [ASK PATRICIA TO FIGURE OUT THE EASIEST WAY TO DO THIS THAT DOESN'T REQUIRE ADVANCED PROGRAMMING]

```r
totfrl <- table204_10 %>% 
  select(state,tot_2000,tot_2010,tot_2011,tot_2012,frl_2000,frl_2010,frl_2011,frl_2012)

#names(totalv2)<-c("state","2000","2010","2011","2012")
head(totfrl)

totfrl_tidy <- totfrl %>% 
  gather(tot_2000,tot_2010,tot_2011,tot_2012, key = year, value = total_students)

total_tidyv2<- total_tidyv2 %>% arrange(state,year)

head(total_tidyv2, n=10)
```



## Tidying data: spreading

The second important and common cause of untidy data:

- is when an observation is scattered across multiple rows with one column identifies variable type and another column contains the values for each variable.
- `table2` is an example of this sort of problem


```r
table2
```

```
## # A tibble: 12 x 4
##    country      year type            count
##    <chr>       <int> <chr>           <int>
##  1 Afghanistan  1999 cases             745
##  2 Afghanistan  1999 population   19987071
##  3 Afghanistan  2000 cases            2666
##  4 Afghanistan  2000 population   20595360
##  5 Brazil       1999 cases           37737
##  6 Brazil       1999 population  172006362
##  7 Brazil       2000 cases           80488
##  8 Brazil       2000 population  174504898
##  9 China        1999 cases          212258
## 10 China        1999 population 1272915272
## 11 China        2000 cases          213766
## 12 China        2000 population 1280428583
```

As my R guru Ben Skinner says, this sort of data structure is __very__ common "in the wild"

- often the data you download have this structure
- it is up to you to tidy before analyses

The solution to this problem is to transform the untidy rows (which represent different variables) into columns

- In the tidyverse, this process is called "spreading" (we spread observations across multiple columns); spreading is the opposite of gathering
- Outside the tidyverse, this process is called "reshaping" from "long" to "wide"

Goal: we want to transform `table2` so it looks like `table1`

```r
table2
table1
```

We spread observations into columns using the `spread()` function from the`tidyr` package. 

```r
?spread
```

Helpful to look at `table2` while we introduce `spread()` function

```r
table2 %>% head(n=8)
```

```
## # A tibble: 8 x 4
##   country      year type           count
##   <chr>       <int> <chr>          <int>
## 1 Afghanistan  1999 cases            745
## 2 Afghanistan  1999 population  19987071
## 3 Afghanistan  2000 cases           2666
## 4 Afghanistan  2000 population  20595360
## 5 Brazil       1999 cases          37737
## 6 Brazil       1999 population 172006362
## 7 Brazil       2000 cases          80488
## 8 Brazil       2000 population 174504898
```

Spreading requires knowing two parameters, which are the parameters of `spread()`:

1. __key column__. Column name in the untidy data whose values will become variable names in the tidy data
    - this column name exists as a variable in the untidy data
    - in `table2` the key column is `type`; the values of `type`, `cases` and `population`, will become variable names in the tidy data 

1. __value column__. Column name in untidy data that contains values for the new variables that will be created in the tidy data
    - this is a varname that exists in the untidy data
    - in `table2` the value column is `count`; the values of `count` will become the values of the new variables `cases` and `population` in the tidy data


```r
table2 %>%
    spread(key = type, value = count)
```

```
## # A tibble: 6 x 4
##   country      year  cases population
##   <chr>       <int>  <int>      <int>
## 1 Afghanistan  1999    745   19987071
## 2 Afghanistan  2000   2666   20595360
## 3 Brazil       1999  37737  172006362
## 4 Brazil       2000  80488  174504898
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```

```r
#compare to table 1
table1
```

```
## # A tibble: 6 x 4
##   country      year  cases population
##   <chr>       <int>  <int>      <int>
## 1 Afghanistan  1999    745   19987071
## 2 Afghanistan  2000   2666   20595360
## 3 Brazil       1999  37737  172006362
## 4 Brazil       2000  80488  174504898
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```

### Student exercise: real-world example of spreading

[In the task I present below, fine to just work through solution I have created or try doing on your own before you look at solution]

<br>
The Integrated Postsecondary Education Data System (IPEDS) collects data on colleges and universities

- Below we load IPEDS data on 12-month enrollment headcount for 2015-16 academic year

```r
#load these libraries if you haven't already
#library(haven)
#library(labelled)
ipeds_hc_all <- read_dta(file="https://github.com/ozanj/rclass/raw/master/data/ipeds/effy/ey15-16_hc.dta", encoding=NULL)
```

Create smaller version of dataset

```r
#ipeds_hc <- ipeds_hc_all %>% select(instnm,unitid,lstudy,efytotlt,efytotlm,efytotlw)
ipeds_hc <- ipeds_hc_all %>% select(instnm,unitid,lstudy,efytotlt)
```

Get to know data

```r
head(ipeds_hc)
```

```
## # A tibble: 6 x 4
##   instnm                              unitid lstudy    efytotlt
##   <chr>                                <dbl> <dbl+lbl>    <dbl>
## 1 Alabama A & M University            100654 999           6157
## 2 Alabama A & M University            100654 "  1"         4865
## 3 Alabama A & M University            100654 "  3"         1292
## 4 University of Alabama at Birmingham 100663 999          21554
## 5 University of Alabama at Birmingham 100663 "  1"        13440
## 6 University of Alabama at Birmingham 100663 "  3"         8114
```

```r
str(ipeds_hc)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	15726 obs. of  4 variables:
##  $ instnm  : chr  "Alabama A & M University" "Alabama A & M University" "Alabama A & M University" "University of Alabama at Birmingham" ...
##   ..- attr(*, "label")= chr "Institution (entity) name"
##   ..- attr(*, "format.stata")= chr "%91s"
##  $ unitid  : num  100654 100654 100654 100663 100663 ...
##   ..- attr(*, "label")= chr "Unique identification number of the institution"
##   ..- attr(*, "format.stata")= chr "%12.0g"
##  $ lstudy  : 'labelled' num  999 1 3 999 1 3 999 1 3 999 ...
##   ..- attr(*, "label")= chr "Original level of study on survey form"
##   ..- attr(*, "format.stata")= chr "%15.0g"
##   ..- attr(*, "labels")= Named num  1 3 999
##   .. ..- attr(*, "names")= chr  "Undergraduate" "Graduate" "Generated total"
##  $ efytotlt: num  6157 4865 1292 21554 13440 ...
##   ..- attr(*, "label")= chr "Grand total"
##   ..- attr(*, "format.stata")= chr "%12.0g"
##  - attr(*, "label")= chr "dct_s2015_is"
```

```r
#Variable labels
ipeds_hc %>% var_label()
```

```
## $instnm
## [1] "Institution (entity) name"
## 
## $unitid
## [1] "Unique identification number of the institution"
## 
## $lstudy
## [1] "Original level of study on survey form"
## 
## $efytotlt
## [1] "Grand total"
```

```r
#Only the variable lstudy has value labels
ipeds_hc %>% select(lstudy) %>% val_labels()
```

```
## $lstudy
##   Undergraduate        Graduate Generated total 
##               1               3             999
```



__Student Task__: 

1. Diagnose the problem with the data frame `ipeds_hc` (why is it untidy?)
2. Sketch out what the tidy data should look like    
3. Transform untidy to tidy

<br>
__Solution to student task__:

__1. Diagnose the problem with the data frame__
    - First, let's investigate the data

```r
ipeds_hc <- ipeds_hc %>% arrange(unitid, lstudy)
head(ipeds_hc, n=20)
```

```
## # A tibble: 20 x 4
##    instnm                              unitid lstudy    efytotlt
##    <chr>                                <dbl> <dbl+lbl>    <dbl>
##  1 Alabama A & M University            100654 "  1"         4865
##  2 Alabama A & M University            100654 "  3"         1292
##  3 Alabama A & M University            100654 999           6157
##  4 University of Alabama at Birmingham 100663 "  1"        13440
##  5 University of Alabama at Birmingham 100663 "  3"         8114
##  6 University of Alabama at Birmingham 100663 999          21554
##  7 Amridge University                  100690 "  1"          415
##  8 Amridge University                  100690 "  3"          415
##  9 Amridge University                  100690 999            830
## 10 University of Alabama in Huntsville 100706 "  1"         6994
## 11 University of Alabama in Huntsville 100706 "  3"         2212
## 12 University of Alabama in Huntsville 100706 999           9206
## 13 Alabama State University            100724 "  1"         5373
## 14 Alabama State University            100724 "  3"          728
## 15 Alabama State University            100724 999           6101
## 16 The University of Alabama           100751 "  1"        35199
## 17 The University of Alabama           100751 "  3"         6308
## 18 The University of Alabama           100751 999          41507
## 19 Central Alabama Community College   100760 "  1"         2379
## 20 Central Alabama Community College   100760 999           2379
```

```r
#code to investigate what each observation represents
  #I'll break this code down next week when we talk about joining data frames
ipeds_hc %>% group_by(unitid,lstudy) %>% # group_by our candidate
  mutate(n_per_id=n()) %>% # calculate number of obs per group
  ungroup() %>% # ungroup the data
  count(n_per_id==1) # count "true that only one obs per group"
```

```
## # A tibble: 1 x 2
##   `n_per_id == 1`     n
##   <lgl>           <int>
## 1 TRUE            15726
```
Summary of problems with the data frame:

- In the untidy data frame, each row represents college-level_of_study
    - there are separate rows for each value of level of study (`undergraduate`, `graduate`, `generated total`)
    - so three rows for each college
- the values of the column `lstudy` represent different attributes (`undergraduate`, `graduate`, `generated total`)
    - each of these attributes should be its own variable

    
__2. Sketch out what the tidy data should look like__ (sketch out on your own)

- What tidy data should look like:
    - Each observation (row) should be a college
    - There should be separate variables for each level of study, with each variable containing enrollment for that level of study

__3. Transform untidy to tidy__

- __key column__. Column name in the untidy data whose values will become variable names in the tidy data
that contains variable names
    - this variable name exists in the untidy data
    - in `ipeds_hc` the key column is `lstudy`; the values of `lstudy`, will become variable names in the tidy data 

- __value column__. Column name in untidy data that contains values for the new variables that will be created in the tidy data
    - this is a varname that exists in the untidy data
    - in `ipeds_hc` the value column is `efytotlt`; the values of `efytotlt` will become the values of the new variables in the tidy data
    

```r
ipeds_hc %>% 
    spread(key = lstudy, value = efytotlt)
```

```
## # A tibble: 6,951 x 5
##    instnm                                         unitid   `1`   `3` `999`
##    <chr>                                           <dbl> <dbl> <dbl> <dbl>
##  1 A T Still University of Health Sciences        177834    NA  4123  4123
##  2 Aaniiih Nakoda College                         180203   372    NA   372
##  3 Aaron's Academy of Beauty                      161615    42    NA    42
##  4 ABC Beauty College Inc                         106281    29    NA    29
##  5 ABCO Technology                                485500    58    NA    58
##  6 Abcott Institute                               461892   239    NA   239
##  7 Abdill Career College Inc                      208123   120    NA   120
##  8 Abilene Christian University                   222178  3845  1286  5131
##  9 Abington Memorial Hospital Dixon School of Nu… 210456   264    NA   264
## 10 Abraham Baldwin Agricultural College           138558  3991    NA  3991
## # ... with 6,941 more rows
```

__Alternative solution__

Helpful to create a character version of variable lstudy prior to spreading

```r
ipeds_hc %>% select(lstudy) %>% val_labels()
```

```
## $lstudy
##   Undergraduate        Graduate Generated total 
##               1               3             999
```

```r
str(ipeds_hc$lstudy)
```

```
##  'labelled' num [1:15726] 1 3 999 1 3 999 1 3 999 1 ...
##  - attr(*, "label")= chr "Original level of study on survey form"
##  - attr(*, "format.stata")= chr "%15.0g"
##  - attr(*, "labels")= Named num [1:3] 1 3 999
##   ..- attr(*, "names")= chr [1:3] "Undergraduate" "Graduate" "Generated total"
```

```r
ipeds_hcv2 <- ipeds_hc %>% 
  mutate(level = recode(as.integer(lstudy),
    `1` = "ug",
    `3` = "grad",
    `999` = "all")
  ) %>% select(-lstudy) # drop variable lstudy

head(ipeds_hcv2)
```

```
## # A tibble: 6 x 4
##   instnm                              unitid efytotlt level
##   <chr>                                <dbl>    <dbl> <chr>
## 1 Alabama A & M University            100654     4865 ug   
## 2 Alabama A & M University            100654     1292 grad 
## 3 Alabama A & M University            100654     6157 all  
## 4 University of Alabama at Birmingham 100663    13440 ug   
## 5 University of Alabama at Birmingham 100663     8114 grad 
## 6 University of Alabama at Birmingham 100663    21554 all
```

```r
ipeds_hcv2 %>% select(instnm,unitid,level,efytotlt) %>%
    spread(key = level, value = efytotlt)
```

```
## # A tibble: 6,951 x 5
##    instnm                                         unitid   all  grad    ug
##    <chr>                                           <dbl> <dbl> <dbl> <dbl>
##  1 A T Still University of Health Sciences        177834  4123  4123    NA
##  2 Aaniiih Nakoda College                         180203   372    NA   372
##  3 Aaron's Academy of Beauty                      161615    42    NA    42
##  4 ABC Beauty College Inc                         106281    29    NA    29
##  5 ABCO Technology                                485500    58    NA    58
##  6 Abcott Institute                               461892   239    NA   239
##  7 Abdill Career College Inc                      208123   120    NA   120
##  8 Abilene Christian University                   222178  5131  1286  3845
##  9 Abington Memorial Hospital Dixon School of Nu… 210456   264    NA   264
## 10 Abraham Baldwin Agricultural College           138558  3991    NA  3991
## # ... with 6,941 more rows
```





PATRICIA - SEE IF THERE IS EASY WAHT TO DO THIS; WANT TO SPREAD DATASET THAT INCLUDES MALE ENROLLMENT, FEMALE ENROLLMENT AND TOTAL ENROLLMENT

- Complete the task above, but having multiple value column (e.g., male enrollment, white male enrollment, etc)[ASK PATRICIA TO FIGURE OUT THE EASIEST WAY TO DO THIS THAT DOESN'T REQUIRE ADVANCED PROGRAMMING]

# Missing values

## Explicit and implicit missing values

This section deals with missing variables and tidying data.

But first, it is helpful to create a new version of the IPEDS enrollment dataset as follows:

- keeps observations for for-profit colleges
- keeps the following enrollment variables: 
    - total enrollment
    - enrollment of students who identify as "Black or African American"

```r
ipeds_hc_na <- ipeds_hc_all %>% filter(sector %in% c(3,6,9)) %>% #keep only for-profit colleges
  select(instnm,unitid,lstudy,efytotlt,efybkaam) %>% 
  mutate(level = recode(as.integer(lstudy), # create recoded version of lstudy
    `1` = "ug",
    `3` = "grad",
    `999` = "all")
  ) %>% select(instnm,unitid,level,efytotlt,efybkaam) %>% 
  arrange(unitid,desc(level))
```

Now, let's print some rows

- There is one row for each college-level_of_study
- Some colleges have three rows of data (ug, grad, all)
- Colleges that don't have any undergraduates or don't have any graduate students only have two rows of data

```r
ipeds_hc_na
```

```
## # A tibble: 6,265 x 5
##    instnm                               unitid level efytotlt efybkaam
##    <chr>                                 <dbl> <chr>    <dbl>    <dbl>
##  1 South University-Montgomery          101116 ug         777      122
##  2 South University-Montgomery          101116 grad       218       40
##  3 South University-Montgomery          101116 all        995      162
##  4 New Beginning College of Cosmetology 101277 ug         132        0
##  5 New Beginning College of Cosmetology 101277 all        132        0
##  6 Herzing University-Birmingham        101365 ug         675       73
##  7 Herzing University-Birmingham        101365 grad        15        5
##  8 Herzing University-Birmingham        101365 all        690       78
##  9 Prince Institute-Southeast           101958 ug          34        0
## 10 Prince Institute-Southeast           101958 all         34        0
## # ... with 6,255 more rows
```

Now let's create new versions of the enrollment variables, that replace `0` with `NA`

```r
ipeds_hc_na <- ipeds_hc_na %>% 
  mutate(
    efytotltv2 = ifelse(efytotlt == 0, NA, efytotlt),
    efybkaamv2 = ifelse(efybkaam == 0, NA, efybkaam)
  ) %>% select(instnm,unitid,level,efytotlt,efytotltv2,efybkaam,efybkaamv2)

ipeds_hc_na %>% select(unitid,level,efytotlt,efytotltv2,efybkaam,efybkaamv2)
```

```
## # A tibble: 6,265 x 6
##    unitid level efytotlt efytotltv2 efybkaam efybkaamv2
##     <dbl> <chr>    <dbl>      <dbl>    <dbl>      <dbl>
##  1 101116 ug         777        777      122        122
##  2 101116 grad       218        218       40         40
##  3 101116 all        995        995      162        162
##  4 101277 ug         132        132        0         NA
##  5 101277 all        132        132        0         NA
##  6 101365 ug         675        675       73         73
##  7 101365 grad        15         15        5          5
##  8 101365 all        690        690       78         78
##  9 101958 ug          34         34        0         NA
## 10 101958 all         34         34        0         NA
## # ... with 6,255 more rows
```

Create dataset that drops the original enrollment variables, keeps enrollment vars that replace `0` with `NA`

```r
ipeds_hc_nav2 <- ipeds_hc_na %>% select(-efytotlt,-efybkaam)
```
Now we can introduce the concepts of _explicit_ and _implicit_ missing values

There are two types of missing values:

- __Explicit missing values__: variable has the value `NA` for a parcitular row
- __Implicit missing values__: the row is simply not present in the data

Let's print data for the first two colleges

```r
ipeds_hc_nav2 %>% head(, n=5)
```

```
## # A tibble: 5 x 5
##   instnm                               unitid level efytotltv2 efybkaamv2
##   <chr>                                 <dbl> <chr>      <dbl>      <dbl>
## 1 South University-Montgomery          101116 ug           777        122
## 2 South University-Montgomery          101116 grad         218         40
## 3 South University-Montgomery          101116 all          995        162
## 4 New Beginning College of Cosmetology 101277 ug           132         NA
## 5 New Beginning College of Cosmetology 101277 all          132         NA
```
`South University-Montgomery` has three rows:

- variable `efytotltv2` has `0` explicit missing values and `0` implicit missing values
- variable `efybkaamv2` has `0` explicit missing values and `0` implicit missing values

`New Beginning College of Cosmetology` has two rows (because they have no graduate students):

- variable `efytotltv2` has `0` explicit missing values and `1` implicit missing values (no row for grad students)
- variable `efybkaamv2` has `2` explicit missing values and `1` implicit missing values (no row for grad students)

Let's look at another dataset called `stocks`, which shows stock `return` for each year and quarter for some hypothetical company. 

- Wickham uses this dataset to introduce explicit and implicit missing values


```r
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks # note: this data is already tidy
```

```
## # A tibble: 7 x 3
##    year   qtr return
##   <dbl> <dbl>  <dbl>
## 1  2015     1   1.88
## 2  2015     2   0.59
## 3  2015     3   0.35
## 4  2015     4  NA   
## 5  2016     2   0.92
## 6  2016     3   0.17
## 7  2016     4   2.66
```
The variable `return` has:

- `1` _explicit_ missing value in `year==2015` and `qtr==4`
- `1` _implicit_ missing value in `year==2016` and `qtr==1`; this row of data simply does not exist



```r
stocks %>% 
  complete(year, qtr)
```

```
## # A tibble: 8 x 3
##    year   qtr return
##   <dbl> <dbl>  <dbl>
## 1  2015     1   1.88
## 2  2015     2   0.59
## 3  2015     3   0.35
## 4  2015     4  NA   
## 5  2016     1  NA   
## 6  2016     2   0.92
## 7  2016     3   0.17
## 8  2016     4   2.66
```
## Making implicit missing values explicit

An _Implicit_ missing value is the result of a row not existing. If you want to make an an implicit missing value explicit, then make the non-existant row exist.

The `complete()` function within the `tidyr` package turns implicit missing values into explicit missing values

- Basically, you specificy the object (i.e., data frame) and a list of variables; 
- `complete()` returns an object that has all unique combinations of those variables, including those not found in the original data frame
- I'll skip additinoal options and complications


```r
stocks
```

```
## # A tibble: 7 x 3
##    year   qtr return
##   <dbl> <dbl>  <dbl>
## 1  2015     1   1.88
## 2  2015     2   0.59
## 3  2015     3   0.35
## 4  2015     4  NA   
## 5  2016     2   0.92
## 6  2016     3   0.17
## 7  2016     4   2.66
```

```r
stocks %>% complete(year, qtr)
```

```
## # A tibble: 8 x 3
##    year   qtr return
##   <dbl> <dbl>  <dbl>
## 1  2015     1   1.88
## 2  2015     2   0.59
## 3  2015     3   0.35
## 4  2015     4  NA   
## 5  2016     1  NA   
## 6  2016     2   0.92
## 7  2016     3   0.17
## 8  2016     4   2.66
```
Note that we now have a row for `year==2016` and `qtr==1` that has an _explicit_ missing value for `return`

Let's apply `complete()` to our IPEDS dataset


```r
ipeds_hc_nav2
```

```
## # A tibble: 6,265 x 5
##    instnm                               unitid level efytotltv2 efybkaamv2
##    <chr>                                 <dbl> <chr>      <dbl>      <dbl>
##  1 South University-Montgomery          101116 ug           777        122
##  2 South University-Montgomery          101116 grad         218         40
##  3 South University-Montgomery          101116 all          995        162
##  4 New Beginning College of Cosmetology 101277 ug           132         NA
##  5 New Beginning College of Cosmetology 101277 all          132         NA
##  6 Herzing University-Birmingham        101365 ug           675         73
##  7 Herzing University-Birmingham        101365 grad          15          5
##  8 Herzing University-Birmingham        101365 all          690         78
##  9 Prince Institute-Southeast           101958 ug            34         NA
## 10 Prince Institute-Southeast           101958 all           34         NA
## # ... with 6,255 more rows
```

```r
ipeds_complete <- ipeds_hc_nav2 %>% select(unitid,level,efytotltv2,efybkaamv2) %>%
  complete(unitid, level)
```

```
## Warning: Column `unitid` has different attributes on LHS and RHS of join
```

```r
ipeds_complete
```

```
## # A tibble: 9,063 x 4
##    unitid level efytotltv2 efybkaamv2
##     <dbl> <chr>      <dbl>      <dbl>
##  1 101116 all          995        162
##  2 101116 grad         218         40
##  3 101116 ug           777        122
##  4 101277 all          132         NA
##  5 101277 grad          NA         NA
##  6 101277 ug           132         NA
##  7 101365 all          690         78
##  8 101365 grad          15          5
##  9 101365 ug           675         73
## 10 101958 all           34         NA
## # ... with 9,053 more rows
```

```r
#Confirm that the "complete" dataset always has three observations per unitid
ipeds_complete %>% group_by(unitid) %>% summarise(n=n()) %>% count(n)
```

```
## # A tibble: 1 x 2
##       n    nn
##   <int> <int>
## 1     3  3021
```

```r
#Note that previous dataset did not
ipeds_hc_nav2 %>% group_by(unitid) %>% summarise(n=n()) %>% count(n)
```

```
## # A tibble: 2 x 2
##       n    nn
##   <int> <int>
## 1     2  2798
## 2     3   223
```

Should you make _implicit_ missing values _explicit_?

- No clear-cut answer; depends on many context-specific things about your project
- The important thing is to be aware of the presence of implicit missing values (both in the "input" datasets you read-in and the datasets you create from this inputs) and be purposeful about how you deal with implicit missing values
    - This is the sort of thing sloppy researchers forget/ignore
- My recommendation for the stage of creating analysis datasets from input data:
    - If you feel unsure about making implicit values explicit, then I recommend making them explicit
    - This forces you to be more fully aware of patterns of missing data; helps you avoid careless mistakes down the road
    - After making implicit missing values explicit, you can drop these rows once you are sure you don't need them

## Spreading and explicit/implicit missing values

We use `spread()` to transform rows into columns; outside the tidyverse, referred to as reshaping from "long" to "wide"

Let's look at two datasets that have similar structure. Which one of these is in need of tidying?

```r
stocks
```

```
## # A tibble: 7 x 3
##    year   qtr return
##   <dbl> <dbl>  <dbl>
## 1  2015     1   1.88
## 2  2015     2   0.59
## 3  2015     3   0.35
## 4  2015     4  NA   
## 5  2016     2   0.92
## 6  2016     3   0.17
## 7  2016     4   2.66
```

```r
ipeds_hc_nav2 %>% select (instnm,unitid,level,efytotltv2) %>% head(n=5)
```

```
## # A tibble: 5 x 4
##   instnm                               unitid level efytotltv2
##   <chr>                                 <dbl> <chr>      <dbl>
## 1 South University-Montgomery          101116 ug           777
## 2 South University-Montgomery          101116 grad         218
## 3 South University-Montgomery          101116 all          995
## 4 New Beginning College of Cosmetology 101277 ug           132
## 5 New Beginning College of Cosmetology 101277 all          132
```

Let's use `spread()` to tidy the IPEDS dataset, focusing on the total enrollment variable which has implicit missing values but no explicit missing values

```r
ipeds_hc_nav2 %>% select (instnm,unitid,level,efytotltv2) %>%
  spread(key = level, value = efytotltv2) %>% 
  arrange(unitid) %>% head(n=5)
```

```
## # A tibble: 5 x 5
##   instnm                               unitid   all  grad    ug
##   <chr>                                 <dbl> <dbl> <dbl> <dbl>
## 1 South University-Montgomery          101116   995   218   777
## 2 New Beginning College of Cosmetology 101277   132    NA   132
## 3 Herzing University-Birmingham        101365   690    15   675
## 4 Prince Institute-Southeast           101958    34    NA    34
## 5 Charter College                      102845  3996    20  3976
```

The resulting dataset has explicint missing values (i.e,. `NAs`) for rows that had implicit missing values in the input data.

Let's use `spread()` the IPEDS dataset again, this time focusing on the Black enrollment variable which has both explicit and implicit missing values

```r
ipeds_hc_nav2 %>% select (instnm,unitid,level,efybkaamv2) %>% head(n=5)
```

```
## # A tibble: 5 x 4
##   instnm                               unitid level efybkaamv2
##   <chr>                                 <dbl> <chr>      <dbl>
## 1 South University-Montgomery          101116 ug           122
## 2 South University-Montgomery          101116 grad          40
## 3 South University-Montgomery          101116 all          162
## 4 New Beginning College of Cosmetology 101277 ug            NA
## 5 New Beginning College of Cosmetology 101277 all           NA
```

```r
ipeds_hc_nav2 %>% select (instnm,unitid,level,efybkaamv2) %>%
  spread(key = level, value = efybkaamv2) %>% 
  arrange(unitid) %>% head(n=5)
```

```
## # A tibble: 5 x 5
##   instnm                               unitid   all  grad    ug
##   <chr>                                 <dbl> <dbl> <dbl> <dbl>
## 1 South University-Montgomery          101116   162    40   122
## 2 New Beginning College of Cosmetology 101277    NA    NA    NA
## 3 Herzing University-Birmingham        101365    78     5    73
## 4 Prince Institute-Southeast           101958    NA    NA    NA
## 5 Charter College                      102845   102     1   101
```

The resulting dataset has explicit missing values (i.e,. `NAs`) for rows that had implicit missing values in the input data and for rows that has explicit missing values in the data.

What if we spread a dataset that has explicit missing values and no implicit missing values?

- Resulting dataset has explicit missing values (i.e,. `NAs`) for rows that were explicit missing values in the input data.
    

```r
ipeds_complete %>% select(unitid,level,efybkaamv2) %>%
  spread(key = level, value = efybkaamv2) %>% 
  arrange(unitid) %>% head(n=5)
```

```
## # A tibble: 5 x 4
##   unitid   all  grad    ug
##    <dbl> <dbl> <dbl> <dbl>
## 1 101116   162    40   122
## 2 101277    NA    NA    NA
## 3 101365    78     5    73
## 4 101958    NA    NA    NA
## 5 102845   102     1   101
```

__Takeways about `spread()` and missing values__

- Explicit missing values in the input data become explicit missing values in the resulting dataset
- Implicit missing values in the input data become explicit missing values in the resulting dataset

Therefore, no need to make implicit missing values explicit (using `complete()`) prior to spreading

## Gathering and explicit/implicit missing values [SKIP]

We use `gather()` to transform columns into rows; outside the tidyverse, referred to as reshaping from "wide" to "long"

Let's create a dataset in need of gathering

- start w/ IPEDS dataset that has enrollment for Black students
- create a fictitious 2017 enrollment variable equal to 2016 enrollment + 20
- rename the enrollment vars `2016` and `2017`


```r
ipeds_gather <- ipeds_hc_nav2 %>% select (instnm,unitid,level,efybkaamv2) 


ipeds_gather <- ipeds_hc_nav2 %>% select (instnm,unitid,level,efybkaamv2) %>%
  mutate(
    efybkaamv2_2017= ifelse(!is.na(efybkaamv2),efybkaamv2+20,20)
  ) %>%
  rename("2016"=efybkaamv2,"2017"=efybkaamv2_2017)

ipeds_gather %>% head(n=10)
```

```
## # A tibble: 10 x 5
##    instnm                               unitid level `2016` `2017`
##    <chr>                                 <dbl> <chr>  <dbl>  <dbl>
##  1 South University-Montgomery          101116 ug       122    142
##  2 South University-Montgomery          101116 grad      40     60
##  3 South University-Montgomery          101116 all      162    182
##  4 New Beginning College of Cosmetology 101277 ug        NA     20
##  5 New Beginning College of Cosmetology 101277 all       NA     20
##  6 Herzing University-Birmingham        101365 ug        73     93
##  7 Herzing University-Birmingham        101365 grad       5     25
##  8 Herzing University-Birmingham        101365 all       78     98
##  9 Prince Institute-Southeast           101958 ug        NA     20
## 10 Prince Institute-Southeast           101958 all       NA     20
```
- The variable `2016` has both implicit and explicit missing values
- The variable `2017` has implicit but no explicit missing values

Let's use `gather()` to transform the columns `2016` and `2017` into rows

```r
ipeds_gatherv2 <- ipeds_gather %>% 
  gather(`2016`,`2017`,key = year, value = efybkaam) %>%
  arrange(unitid,desc(level),year) 

ipeds_gatherv2 %>% head(n=10)
```

```
## # A tibble: 10 x 5
##    instnm                               unitid level year  efybkaam
##    <chr>                                 <dbl> <chr> <chr>    <dbl>
##  1 South University-Montgomery          101116 ug    2016       122
##  2 South University-Montgomery          101116 ug    2017       142
##  3 South University-Montgomery          101116 grad  2016        40
##  4 South University-Montgomery          101116 grad  2017        60
##  5 South University-Montgomery          101116 all   2016       162
##  6 South University-Montgomery          101116 all   2017       182
##  7 New Beginning College of Cosmetology 101277 ug    2016        NA
##  8 New Beginning College of Cosmetology 101277 ug    2017        20
##  9 New Beginning College of Cosmetology 101277 all   2016        NA
## 10 New Beginning College of Cosmetology 101277 all   2017        20
```

Before looking at missing values, let's investigate data structure

```r
#number of rows after gathering is exactly 2X number of rows in input dataset
nrow(ipeds_gather)
```

```
## [1] 6265
```

```r
nrow(ipeds_gatherv2)
```

```
## [1] 12530
```

```r
nrow(ipeds_gatherv2)==nrow(ipeds_gather)*2
```

```
## [1] TRUE
```

```r
#How many observations for each combination of unitid and level? 
  #always 2: one for 2016 and one for 2017
ipeds_gatherv2 %>% group_by(unitid,level) %>% 
  summarise(n_per_unitid_level=n()) %>% ungroup %>% count(n_per_unitid_level)
```

```
## # A tibble: 1 x 2
##   n_per_unitid_level     n
##                <int> <int>
## 1                  2  6265
```

```r
#How many observations for each unitid? 
  # 4 observations for colleges that had two rows in the input dataset
  # 6 observations for colleges that had three rows in the input dataset
ipeds_gatherv2 %>% group_by(unitid) %>% 
  summarise(n_per_unitid=n()) %>% ungroup %>% count(n_per_unitid)
```

```
## # A tibble: 2 x 2
##   n_per_unitid     n
##          <int> <int>
## 1            4  2798
## 2            6   223
```

Let's compare the data before and after gathering for one college

```r
#before gathering
ipeds_gather %>% filter(unitid==101277)
```

```
## # A tibble: 2 x 5
##   instnm                               unitid level `2016` `2017`
##   <chr>                                 <dbl> <chr>  <dbl>  <dbl>
## 1 New Beginning College of Cosmetology 101277 ug        NA     20
## 2 New Beginning College of Cosmetology 101277 all       NA     20
```

```r
#after gathering
ipeds_gatherv2 %>% filter(unitid==101277)
```

```
## # A tibble: 4 x 5
##   instnm                               unitid level year  efybkaam
##   <chr>                                 <dbl> <chr> <chr>    <dbl>
## 1 New Beginning College of Cosmetology 101277 ug    2016        NA
## 2 New Beginning College of Cosmetology 101277 ug    2017        20
## 3 New Beginning College of Cosmetology 101277 all   2016        NA
## 4 New Beginning College of Cosmetology 101277 all   2017        20
```
__Takeaways about gathering and explicit/implicit missing values__

- Explicit missing values from the input dataset become explicit missing values in the resulting dataset after gathering
- Implicit missing values from the input dataset are implicit missing values the resulting dataset after gathering. Why:
    - In the input dataset, no row existed for these implicit missing values
    - For each existing row in the input dataset, `gather()` creates new rows
    - `gather()` does nothing to rows that do not exist in the input dataset

Therefore, if you want to make implicit values explicit after gathering, then prior to gathering you should use `complete()` to make missing values explicit

# Tidying data: separating and uniting [SKIP]


```r
table5
```

```
## # A tibble: 6 x 4
##   country     century year  rate             
## * <chr>       <chr>   <chr> <chr>            
## 1 Afghanistan 19      99    745/19987071     
## 2 Afghanistan 20      00    2666/20595360    
## 3 Brazil      19      99    37737/172006362  
## 4 Brazil      20      00    80488/174504898  
## 5 China       19      99    212258/1272915272
## 6 China       20      00    213766/1280428583
```
- "Separating" is for dealing with the problem in the `rate` column
- "Uniting" is for dealing with the problem in the `century` and `year` columns

Read about this in section 12.4 of Wickham text, but no homework questions on separating and uniting
