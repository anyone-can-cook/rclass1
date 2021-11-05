library(tidyverse)
library(haven)


data_dir <- file.path('.', 'data', 'nls72')


nls_crs <- read_dta('https://github.com/anyone-can-cook/rclass1/raw/master/data/nls72/nls72petscrs_v2.dta')
nls_tran <- read_dta('https://github.com/anyone-can-cook/rclass1/raw/master/data/nls72/nls72petstrn_v2.dta')

names(nls_crs)
names(nls_tran)
nls_crs %>% left_join(y=nls_tran, by = c('id', 'transnum')) %>% count(itype)

nls_crs_itype <- nls_crs %>%
  left_join(y=nls_tran %>% select(id, transnum, itype), by = c('id', 'transnum'))

nls_crs_itype %>% count(itype)

write_dta(nls_crs_itype, path = file.path(data_dir, 'nls72petscrs_v2.dta'))
