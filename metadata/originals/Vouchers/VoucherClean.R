# Voucher records tidyer
library(tidyverse)
library(readxl)
library(lubridate)
vouch = read_xlsx("DNSpecimenDetailsApr2018.xlsx")

vouch.tidy = vouch %>%
  mutate_if(is.character, function (s) {trimws(gsub("\n", " ", s))}) %>% 
  mutate(Date = as.Date(as.numeric(Date), origin="1899-12-30")) %>% 
  mutate_at(vars(LatitudeD:LongitudeS), function(x) {
    x=as.numeric(x)
    x
  }) %>% 
  mutate(
    # this rowsums crap is to preserve NA for degrees, but treat NA as 0 when missing
    # values exist for minutes and seconds (as some don't have that precision)
    Latitude=-(LatitudeD + rowSums(cbind(LatitudeM/60, LatitudeS/3600), na.rm=T)),
    Longitude=LongitudeD + rowSums(cbind(LongitudeM/60, LongitudeS/3600), na.rm=T)
  ) %>% 
  select(-ends_with("D"), -ends_with("M"), -ends_with("S"))
#View(vouch.tidy)

write.csv(vouch.tidy, "../DNVoucherRecordsCleaned.csv", quote =T, row.names = F)