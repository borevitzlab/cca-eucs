# Clean up CCA metadata
library(tidyverse)
cca = read_csv("BorevitzCCAMetadata.csv.xz") %>% 
  rename(Voucher=DNVoucher) %>% 
  mutate_if(is.character, trimws) %>% 
  mutate(DNNumber = as.integer(sub("DN *", "", Voucher)))

cca %>% 
  filter(is.na(DNNumber)) %>% 
  group_by(Voucher) %>% 
  summarise(n=n())

write_csv(cca, "../CCATreesCleaned.csv.xz")