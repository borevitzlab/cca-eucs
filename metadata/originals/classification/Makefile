
../TaxonomyCleaned.csv: coe-tabularised.tsv coe-cleaner.R
	Rscript coe-cleaner.R

coe-tabularised.tsv: Classification-Of-The-Eucalypts_TIDIED.txt coe-er.py
	python3 coe-er.py $< > $@



