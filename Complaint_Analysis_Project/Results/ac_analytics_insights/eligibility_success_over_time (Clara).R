dat_compl %>%
 mutate(Year_Filed = year(Filing_Date)) %>%
 filter(!is.na(ELIGIBLE) & !is.na(Year_Filed)) %>%
 ggplot(aes(factor(Year_Filed), fill=factor(ELIGIBLE))) +
 geom_bar() +
 labs(title=“Eligibility success over time”,x=“Year filed”,fill=“Eligible”,y=“Percent of complaints”)