# Voucher records tidyer
library(tidyverse)
library(readxl)
library(lubridate)
vouch = read_xlsx("DNSpecimenDetailsApr2018.xlsx")

vouch.tidy = vouch %>%
  mutate(Date = as.Date(as.numeric(Date), origin="1899-12-30")) %>% 
  mutate_at(vars(LatitudeD:LongitudeS), function(x) {
    x=as.numeric(x)
    x[is.na(x)] = 0.0
    x
  }) %>% 
  mutate(
    Latitude=LatitudeD + LatitudeM/60 + LatitudeS/3600,
    Longitude=LongitudeD + LongitudeM/60 + LongitudeS/3600
  ) %>% 
  select(-ends_with("D"), -ends_with("M"), -ends_with("S"))

write_csv(vouch.tidy, "DNVoucherRecordsCleaned.csv.xz")

