
######## LOAD LIBRARIES ##########
#options(max.print=999999)
library(tidyverse)
library(haven)
library(labelled)
#################################

getwd()
list.files("../../Dropbox/teaching-data/nls/data/analysis/stu")

#nls_stu <- read_dta(file="../../Dropbox/teaching-data/nls/data/analysis/stu/nls72stu_v2.dta", encoding=NULL)
#nls_stu <- read_dta(file="../../Dropbox/teaching-data/nls/data/analysis/stu/nls72stu_common_vars.dta", encoding=NULL)
nls_stu <- read_dta(file="../../Dropbox/teaching-data/nls/data/analysis/stu/nls72stu_percontor_vars.dta", encoding=NULL)


names(nls_stu)
nls_stu %>% var_label