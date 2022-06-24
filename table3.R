journal <- "Viruses"


kable(round(epi.prev(pos = nrow(filter(review, journalTitle == journal & is_coi_pred == TRUE)),
                     tested = nrow(filter(review, journalTitle == journal)),
                     se = 0.992,
                     sp = 0.995)$ap, 
            1))



kable(round(epi.prev(pos = nrow(filter(review, journalTitle == journal & is_fund_pred == TRUE)),
                     tested = nrow(filter(review, journalTitle == journal)),
                     se = 0.997,
                     sp = 0.981)$ap, 
            1))


kable(round(epi.prev(pos = nrow(filter(review, journalTitle == journal & is_register_pred == TRUE)),
                     tested = nrow(filter(review, journalTitle == journal)),
                     se = 0.955,
                     sp = 0.997)$ap, 
            1))



kable(round(epi.prev(pos = nrow(filter(review, journalTitle == journal & is_open_data == TRUE)),
                     tested = nrow(filter(review, journalTitle == journal)),
                     se = 0.758,
                     sp = 0.986)$ap, 
            1))


kable(round(epi.prev(pos = nrow(filter(review, journalTitle == journal & is_open_code == TRUE)),
                     tested = nrow(filter(review, journalTitle == journal)),
                     se = 0.587,
                     sp = 0.997)$ap, 
            1))




# For others:
'%ni%' <- Negate("%in%")

top_journals = c("Int J Environ Res Public Health", "Front Immunol", "Int J Mol Sci", "J Clin Med", "Vaccines (Basel)", "Lancet Respir")


kable(round(epi.prev(pos = nrow(filter(review, journalTitle %ni% top_journals & is_coi_pred == TRUE)),
                     tested = nrow(filter(review, journalTitle %ni% top_journals)),
                     se = 0.992,
                     sp = 0.995)$ap, 
            1))



kable(round(epi.prev(pos = nrow(filter(review, journalTitle %ni% top_journals & is_fund_pred == TRUE)),
                     tested = nrow(filter(review, journalTitle %ni% top_journals)),
                     se = 0.997,
                     sp = 0.981)$ap, 
            1))


kable(round(epi.prev(pos = nrow(filter(review, journalTitle %ni% top_journals & is_register_pred == TRUE)),
                     tested = nrow(filter(review, journalTitle %ni% top_journals)),
                     se = 0.955,
                     sp = 0.997)$ap, 
            1))



kable(round(epi.prev(pos = nrow(filter(review, journalTitle %ni% top_journals & is_open_data == TRUE)),
                     tested = nrow(filter(review, journalTitle %ni% top_journals)),
                     se = 0.758,
                     sp = 0.986)$ap, 
            1))


kable(round(epi.prev(pos = nrow(filter(review, journalTitle %ni% top_journals & is_open_code == TRUE)),
                     tested = nrow(filter(review, journalTitle %ni% top_journals)),
                     se = 0.587,
                     sp = 0.997)$ap, 
            1))

