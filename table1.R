library(dplyr)

db2020_res <- research %>% filter(year_firstpub == 2020)
db2021_res <- research %>% filter(year_firstpub == 2021)
db2022_res <- research %>% filter(year_firstpub == 2022)

db2020_rct <- rct %>% filter(year_firstpub == 2020)
db2021_rct <- rct %>% filter(year_firstpub == 2021)
db2022_rct <- rct %>% filter(year_firstpub == 2022)

db2020_rev <- review %>% filter(year_firstpub == 2020)
db2021_rev <- review %>% filter(year_firstpub == 2021)
db2022_rev <- review %>% filter(year_firstpub == 2022)



kable(round(epi.prev(pos = length(db2021_res$is_coi_pred[db2021_res$is_coi_pred == TRUE]),
                     tested = nrow(db2021_res),
                     se = 0.992,
                     sp = 0.995)$ap, 
            1))



kable(round(epi.prev(pos = length(db2021_res$is_fund_pred[db2021_res$is_fund_pred == TRUE]),
                     tested = nrow(db2020_res),
                     se = 0.997,
                     sp = 0.981)$ap, 
            1))


kable(round(epi.prev(pos = length(db2020_res$is_register_pred[db2020_res$is_register_pred == TRUE]),
                     tested = nrow(db2020_res),
                     se = 0.955,
                     sp = 0.997)$ap, 
            1))



kable(round(epi.prev(pos = length(db2020_res$is_open_data[db2020_res$is_open_data == TRUE]),
                     tested = nrow(db2020_res),
                     se = 0.758,
                     sp = 0.986)$ap, 
            1))


kable(round(epi.prev(pos = length(db2020_res$is_open_code[db2020_res$is_open_code == TRUE]),
                     tested = nrow(db2020_res),
                     se = 0.587,
                     sp = 0.997)$ap, 
            1))

