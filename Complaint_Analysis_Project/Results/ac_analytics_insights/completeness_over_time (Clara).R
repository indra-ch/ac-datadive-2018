library(lubridate)
dat_compl %>%
 mutate(Year_Filed = year(Filing_Date),
        Status_complete = case_when(Status %in% c(“Closed With Results”,“Monitoring”) ~ “completed”,
                                    Status %in% c(“Closed Without Results”) ~ “not completed”)) %>%
 filter(!is.na(Status_complete) & !is.na(Year_Filed)) %>%
 ggplot(aes(factor(Year_Filed), fill=fct_rev(factor(Status_complete)))) +
 geom_bar() +
 labs(title=“Completeness over time”,x=“Year filed”,fill=“Completed”,y=“Percent of complaints”,
      subtitle=“Completed: closed with results or monitoring. Not completed: closed without results”)