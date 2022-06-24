round(median(review$jif2020[review$is_coi_pred==FALSE], na.rm = T), 1)
round(IQR(review$jif2020[review$is_coi_pred==FALSE], na.rm = T), 1)

round(median(review$jif2020[review$is_fund_pred==FALSE], na.rm = T), 1)
round(IQR(review$jif2020[review$is_fund_pred==FALSE], na.rm = T), 1)

round(median(review$jif2020[review$is_register_pred==FALSE], na.rm = T), 1)
round(IQR(review$jif2020[review$is_register_pred==FALSE], na.rm = T), 1)

round(median(review$jif2020[review$is_open_data==FALSE], na.rm = T), 1)
round(IQR(review$jif2020[review$is_open_data==FALSE], na.rm = T), 1)

round(median(review$jif2020[review$is_open_code==FALSE], na.rm = T), 1)
round(IQR(review$jif2020[review$is_open_code==FALSE], na.rm = T), 1)


res <- wilcox.test(review$jif2020 ~ review$is_open_code, exact = FALSE)
round(res$p.value, 3)

