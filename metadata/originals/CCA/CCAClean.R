# Clean up CCA metadata
library(tidyverse)
cca.field.add = read_csv("FieldAdditions.csv")
cca = read_csv("BorevitzCCAMetadata.csv.xz") %>% 
  rename(Voucher=DNVoucher) %>% 
  mutate_if(is.character, trimws) %>% 
  mutate(DNNumber = as.integer(sub("DN *", "", Voucher))) %>% 
  filter(!is.na(CurrentName),
         ! FieldID %in% cca.field.add$FieldID) %>%  # remove rows in updated field metadata
  bind_rows(cca.field.add)

sort(table(cca$FieldID), decreasing = T) %>% head

cca %>% 
  filter(is.na(DNNumber)) %>% 
  group_by(Voucher) %>% 
  summarise(n=n())



write_csv(cca, "../CCATreesCleaned.csv")