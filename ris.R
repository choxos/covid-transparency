library(dplyr)
library(stringr)

ris_covid <- read.delim("data/covid-rcts-iloveevidence.ris", 
                        quote = "", 
                        fill = F)

dois <- ris_covid %>% 
        filter(str_detect(TY....JOUR, "DO  - "))

# Remove DO - from rows

dois[] <- sapply(dois, function(x) gsub("DO  - ", "", as.character(x)))

names(dois) <- "doi"

data1 <- merge(opendata, dois, by="doi")


# All papers

ris_covid_all <- read.delim("data/06102022.litcovid.export.tsv", 
                            quote = "", 
                            fill = F)

names(ris_covid_all) <- "pmid"

pmids <- as.data.frame(ris_covid_all[!is.na(as.numeric(ris_covid_all$pmid)), ])
names(pmids) <- "pmid"


ris_covid_all <- read.csv("data/litcovid.export.all.tsv",
                          sep = "\t",
                          header = T)


db_1 <- epmc_search(query = '(FIRST_PDATE:[2020-01-01 TO 2020-06-30]) AND (OPEN_ACCESS:y) AND (SRC:"MED") AND (LANG:"eng" OR LANG:"en" OR LANG:"us")',
                    limit = 2000000,
                    output = "parsed",
                    verbose = F)

db_2 <- epmc_search(query = '(FIRST_PDATE:[2020-07-01 TO 2020-12-31]) AND (OPEN_ACCESS:y) AND (SRC:"MED") AND (LANG:"eng" OR LANG:"en" OR LANG:"us")',
                    limit = 2000000,
                    output = "parsed",
                    verbose = F)

db_3 <- epmc_search(query = '(FIRST_PDATE:[2021-01-01 TO 2021-06-30]) AND (OPEN_ACCESS:y) AND (SRC:"MED") AND (LANG:"eng" OR LANG:"en" OR LANG:"us")',
                    limit = 2000000,
                    output = "parsed",
                    verbose = F)

db_4 <- epmc_search(query = '(FIRST_PDATE:[2021-07-01 TO 2021-12-31]) AND (OPEN_ACCESS:y) AND (SRC:"MED") AND (LANG:"eng" OR LANG:"en" OR LANG:"us")',
                    limit = 2000000,
                    output = "parsed",
                    verbose = F)

db_5 <- epmc_search(query = '(FIRST_PDATE:[2022-01-01 TO 2022-06-09]) AND (OPEN_ACCESS:y) AND (SRC:"MED") AND (LANG:"eng" OR LANG:"en" OR LANG:"us")',
                    limit = 2000000,
                    output = "parsed",
                    verbose = F)

data1 <- merge(db_1, pmids, by = "pmid")

db_all <- rbind(data1, data2, data3, data4, data5)
write.csv(db_all, "data/db_all.csv")
