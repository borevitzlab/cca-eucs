## CCA trees joined with DN vouchers for GPS
library(tidyverse)
library(ggplot)
library(ggmap)

cca = read_csv("originals/CCATreesCleaned.csv.xz")
dnvouch = read.csv("originals/DNVoucherRecordsCleaned.csv.xz") %>% 
  filter(!is.na(DNNumber))

cca_with_md = cca %>%
  left_join(dnvouch, by="DNNumber")

# ggmap(get_map("australia", zoom=4))