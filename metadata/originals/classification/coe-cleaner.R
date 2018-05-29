library(tidyverse)
options("stringsAsFactors"=F)

taxtab = read.delim("coe-tabularised.tsv")
#str(taxtab)

cleaned = taxtab
# pre-tidy for extract below
cleaned = cleaned %>%
  mutate_at(1:7, function (x) {
    sub(" \\(([^()]+)\\)", "\t\\1", x)
  })
for (col in colnames(cleaned)[1:7]) {
  cleaned = cleaned %>%
    separate(col, into=c(col, paste0(col,"Common")),
             sep='\t', extra="merge", fill="right")
    #extract(col, into=c(col, "tmp", paste0(col,"Common")),
    #        regex = "([^()]+)( \\(([\\S ]+)\\))?")
}

cleaned = cleaned %>%
  mutate_if(is.character, function (x) {
    # replace fancy quotes
    x = gsub('[‘’]', "'", x)
    x = trimws(x)
    ifelse(is.na(x), "", x)
  })


# `cleaned` has all columns, but we'll also do a version
# where we have just the scientific names, without other symbols
sciclean = cleaned %>%
  select(Genus, Subgenus, Section, Series, Subseries, Species, Subspecies) %>%
  mutate_all(function (x){
    # remove sub/subsp from start of names
    x = gsub("sub\\.?|subsp\\.?", "", x)
    # remove dean's annotations like ? or [] around names (stays in orig)
    x = gsub('[\\[\\]\\?]', "", x, perl=T)
    # get rid of any leading/trailing whitespace this has introduced
    trimws(x)
  }) %>%
  mutate(Species = trimws(sub("^Eucalyptus|^Corymbia|^Angophora|^E\\.",
                              "", Species))) %>%
  mutate(
    Binomial = paste(Genus, ifelse(Subspecies == "", Species,
                                   paste(Species, "subsp.", Subspecies)))
  ) %>%
  select(Binomial, everything())

# Add cleaned binomial name back in for matching purposes
# (NB: rows are in same order still)
cleaned$CleanedBinomial = sciclean$Binomial
# for checking names match
# paste(cleaned$CleanedBinomial, paste(cleaned$Species, cleaned$Subspecies), sep="|")

# Write out
write_csv(cleaned, "FullCleanedTaxonomy.csv")
write_csv(cleaned, "../DNTaxonomyCleaned.csv")
