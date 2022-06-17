# Creating dataset and xml files for the research project:
## Transparency indicators across the dentistry and oral health literature
## Authors: Ahmad Sofi-Mahmudi, Eero Raittio, KSergio E. Uribe
## Codes by: Ahmad Sofi-Mahmudi

# Loading required packages
pacman::p_load(dplyr,
               tidyr,
               rtransparent, 
               metareadr, 
               europepmc,
               here,
               stringr)

# Creating the dataset
## Getting all open access records from EPMC
### As the number was high (1.5M), we divided that to five parts, each half a year.

db_2020_1 <- epmc_search(query = '(FIRST_PDATE:[2020-01-01 TO 2020-06-30]) 
                                AND (OPEN_ACCESS:y) 
                                AND (SRC:"MED")
                                AND (LANG:"eng" OR LANG:"en" OR LANG:"us")',
                        limit = 1000000,
                        output = "parsed",
                        verbose = F)

### and four other more: db_2020_2, db_2021_1, db_2021_2, db_2022


## We then do the following for each of them
### Removing the duplicates:
db_2020_1 <- db_2020_1 %>% distinct(pmid, .keep_all = TRUE)
db_2020_2 <- db_2020_2 %>% distinct(pmid, .keep_all = TRUE)
db_2021_1 <- db_2021_1 %>% distinct(pmid, .keep_all = TRUE)
db_2021_2 <- db_2021_2 %>% distinct(pmid, .keep_all = TRUE)
db_2022 <- db_2022 %>% distinct(pmid, .keep_all = TRUE)


## In the next step, we gather COVID-19-related papers' PMIDs from LitCovid database.

ris_covid_all <- read.delim("data/06102022.litcovid.export.tsv", 
                            quote = "", 
                            fill = F)

names(ris_covid_all) <- "pmid"

pmids <- as.data.frame(ris_covid_all[!is.na(as.numeric(ris_covid_all$pmid)), ])
names(pmids) <- "pmid"

## Then, we merge (inner-join) pmids with each of the db to have the intersection
## between these two. The intersection would be open access COVID-19-related papers.

covid_2020_1 <- merge(db_2020_1, pmids, by = "pmid")
covid_2020_2 <- merge(db_2020_2, pmids, by = "pmid")
covid_2021_1 <- merge(db_2021_1, pmids, by = "pmid")
covid_2021_2 <- merge(db_2021_2, pmids, by = "pmid")
covid_2022 <- merge(db_2022, pmids, by = "pmid")



## That's it! Next, we'll download xml files.
### Creating a new column from pmcid column and removing "PMC" from the cells:
db_2020_1$pmcid_ <- gsub("PMC", "", as.character(db_2020_1$pmcid))
db_2020_2$pmcid_ <- gsub("PMC", "", as.character(db_2020_2$pmcid))
db_2021_1$pmcid_ <- gsub("PMC", "", as.character(db_2021_1$pmcid))
db_2021_2$pmcid_ <- gsub("PMC", "", as.character(db_2021_2$pmcid))
db_2022$pmcid_ <- gsub("PMC", "", as.character(db_2022$pmcid))

###Now, we make five folders for xml format articles:
dir.create(c("pmc_ 2020_1", "pmc_2020_2", "pmc_2021_1", "pmc_2021_2", "pmc_2022"))

### Next, we download xmls in format accessible with metareadr.
### To skip errors (i.e., The metadata format 'pmc' is not supported by the
### item or by the repository.), first define a new function:
skipping_errors <- function(x) tryCatch(mt_read_pmcoa(x), error = function(e) e)

### Next, we download xmls in format accessible with rtransparent:
setwd("pmc_2020_1")
sapply(db_2020_1$pmcid_, skipping_errors)

setwd("../pmc_2020_2")
sapply(db_2020_2$pmcid_, skipping_errors)

setwd("../pmc_2021_1")
sapply(db_2021_1$pmcid_, skipping_errors)

setwd("../pmc_2021_2")
sapply(db_2021_2$pmcid_, skipping_errors)

setwd("../pmc_2022")
sapply(db_2022$pmcid_, skipping_errors)

### Now we run rtransparent (do for all others as well (f2-f5)):
filepath1 = dir(pattern=glob2rx("PMC*.xml"))

results_all_2020_1 <- sapply(filepath1, rt_all_pmc)

results_data_2020_1 <- rt_data_code_pmc_list(
        filepath1,
        remove_ns=F,
        specificity = "low")

### A list is created now. We should convert this list to a dataframe:
results_all_2020_1 <- data.table::rbindlist(results_all_2020_1, fill = TRUE)

### Merge data sharing results to database file:
setwd('..')
db <- db[!duplicated(db[, 4]),]
opendata_2020_1 <- merge(db_2020_1, results_data_2020_1, by = "pmid") %>% merge(results_all_2020_1)

### Then, rbin all opendata:
opendata <- rbind(opendata_2020_1, opendata_2020_2, opendata_2021_1, opendata_2021_2, opendata_2022)

### Selecting only needed columns:
opendata <- opendata %>% select(pmid,
                                pmcid,
                                doi,
                                title,
                                authorString,
                                journalTitle,
                                journalIssn,
                                publisher,
                                firstPublicationDate,
                                journalVolume,
                                pageInfo,
                                issue,
                                type,
                                is_research,
                                is_review,
                                citedByCount,
                                is_coi_pred,
                                coi_text,
                                is_fund_pred,
                                fund_text,
                                is_register_pred,
                                register_text,
                                is_open_data,
                                open_data_category,
                                is_open_code,
                                open_data_statements,
                                open_code_statements)

### Adding JIFs:
#### First, importing jif file:
jif <- read.csv(here("data", "covid_transparency_jif2020.csv"))

#### Merging it with opendata:
opendata$journalIssn <- toupper(opendata$journalIssn)

opendata <- opendata %>% separate(journalIssn, c("issn1", "issn2"), sep = "; ")

opendata <- merge(x = opendata, 
                  y = jif[, c("issn", "jif2020")],
                  by.x = "issn1",
                  by.y = "issn",
                  all.x = TRUE)

opendata <- merge(x = opendata, 
                  y = jif[, c("issn", "jif2020")],
                  by.x = "issn2",
                  by.y = "issn",
                  all.x = TRUE)

opendata <- opendata %>% distinct(pmid, .keep_all = TRUE) #Removing duplicates

opendata <- opendata %>% 
        mutate(jif2020 = coalesce(jif2020.x, jif2020.y)) %>%
        subset(select = -c(jif2020.x, jif2020.y))

opendata$jif2020 <- as.numeric(opendata$jif2020)

### Adding SCImago:
scimago <- read.csv(here("data", "covid_transparency_scimagojr_2020.csv"), sep = ";")

scimago <- scimago %>% separate(Issn, c("issn1", "issn2"))

scimago$issn1 <- gsub("(\\d{4})(\\d{4})$", "\\1-\\2", scimago$issn1)
scimago$issn2 <- gsub("(\\d{4})(\\d{4})$", "\\1-\\2", scimago$issn2)

#### Merging with opendata:
opendata <- merge(x = opendata, 
                  y = scimago[, c("issn1", "issn2", "SJR", "H.index", "Publisher")],
                  by.x = "issn1",
                  by.y = "issn1",
                  all.x = TRUE)

opendata <- merge(x = opendata, 
                  y = scimago[, c("issn1", "issn2", "SJR", "H.index", "Publisher")],
                  by.x = "issn2.x",
                  by.y = "issn1",
                  all.x = TRUE)

opendata <- merge(x = opendata, 
                  y = scimago[, c("issn1", "issn2", "SJR", "H.index", "Publisher")],
                  by.x = "issn1",
                  by.y = "issn2",
                  all.x = TRUE)

opendata <- opendata %>% distinct(pmid, .keep_all = TRUE) #Removing duplicates

opendata <- opendata %>% 
        mutate(sjr2020 = coalesce(SJR, SJR.x, SJR.y),
               scimago_publisher = coalesce(Publisher.x, Publisher.y, Publisher),
               scimago_hindex = coalesce(H.index.x, H.index.y, H.index)) %>%
        subset(select = -c(SJR.x, SJR.y, SJR, issn2.y, issn2.x, issn1.y, H.index.x, H.index.y, H.index, Publisher.x, Publisher.y, Publisher))

#### Changing commas to dots:
opendata$sjr2020 <- gsub(",", ".", as.character(opendata$sjr2020))

#### And changing type to numeric:
opendata$sjr2020 <- as.numeric(opendata$sjr2020)

opendata <- opendata[, c(2:7, 1, 29, 8:28, 30:32)]

# Adding is_rct columns
ris_covid <- read.delim("data/covid-rcts-iloveevidence.ris", 
                        quote = "", 
                        fill = F)

pmids <- ris_covid %>% 
        filter(str_detect(TY....JOUR, "pmid"))

# Removing unnecessary strings from rows

pmids[] <- sapply(pmids, function(x) gsub("U1  - ", "", as.character(x)))
pmids[] <- sapply(pmids, function(x) gsub("[pmid]", "", as.character(x), fixed = T))
pmids[] <- sapply(pmids, function(x) gsub("NLM", "", as.character(x)))

pmids[,1] <- as.numeric(pmids[,1])

names(pmids) <- "pmid"

# Adding is_rct as a column. This takes a little while.

for (i in 1:nrow(opendata)) {
        a <- opendata$pmid[i]
        b <- pmids[which(pmids$pmid == a), 1]
        ifelse(rlang::is_empty(b) == TRUE, 
               opendata$is_rct[i] <- FALSE, 
               opendata$is_rct[i] <- TRUE)
}



# Writing to CSV
write.csv(opendata, "data/covid_transparency_opendata_final.csv")


# Random samples
### Random sample for manual study type detection and for indicators validation (100 refs):
set.seed(100)
randomsample <- filter(opendata, type == "research-article")
randomsample <- opendata[sample(nrow(opendata), 100), ]
randomsample <- randomsample %>% select(title,
                                        authorString,
                                        journalTitle,
                                        pmid,
                                        pmcid,
                                        doi,
                                        is_coi_pred,
                                        coi_text,
                                        is_fund_pred,
                                        fund_text,
                                        is_register_pred,
                                        register_text,
                                        is_open_data,
                                        open_data_statements,
                                        is_open_code,
                                        open_code_statements) %>%
        mutate(study_type = NA,
               disc_coi = TRUE,
               disc_fund = TRUE,
               disc_register = FALSE,
               disc_data = FALSE,
               disc_code = FALSE)

write.csv(randomsample, "data/covid_transparency_randomsample.csv")

