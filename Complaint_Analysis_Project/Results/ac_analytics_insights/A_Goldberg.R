library(tidyverse)
library(lubridate)
library(janitor)
library(rpart)
library(rpart.plot)

options(na.action = "na.omit")

if(getwd()!="C:/Users/thewi/Documents/Complaint_Analysis_Project/Complaint_Analysis_Project/Data"){setwd("C:/Users/thewi/Documents/Complaint_Analysis_Project/Complaint_Analysis_Project/Data")}

#data sets with c_ are from the complaing file "accountability_console_data_cleaned.csv"
#data sets with b_ are from the benchmark data
c_raw<-read_csv("accountability_console_data_cleaned.csv", trim_ws=TRUE  )

b_raw<-read_csv("benchmark_data_cleaned_melted.csv"  , trim_ws=TRUE)

#set column names to lower and snake case.
#Fix the transcription errors in the complaint data set
c<-c_raw %>%
      janitor::clean_names() %>% 
      mutate(uid=paste0(iam, external_id),
             iam=case_when(
                   iam=="ABD_SPF_CRP" ~"ADB_SPF_CRP",
                   iam=="ERBD_PCM"|iam=="ERBD_IRM" ~"EBRD_PCM",
                   TRUE ~ iam
             ))

      
b<-b_raw %>% 
      clean_names() %>% 
      filter(!is.na(value)) %>% 
      rename(iam=variable)

#count the number of categories for each iam
b_cat_count<-b %>% group_by(iam,category) %>% 
      summarise(count=n())

#get a matrix of categories, count by iam
b_iam_count<-b_cat_count %>% 
      spread(key=category, value=count, fill=0) %>% 
      clean_names()

#get a matrix of outcomes count by iam c=complaint data
c_iam_count<-c %>% filter(iam %in% b$iam) %>% 
      group_by(iam, status) %>% 
      summarise(count=n()) %>%
      spread(key=status, value=count, fill = 0) %>% 
      clean_names() %>% 
      left_join(c %>% group_by(iam) %>% count()) %>% 
      mutate(percent_result=closed_with_results/n)

#plot the count of complaints by iam, using forcats library refactor the iams to the percent result.  Flip the plot.
ggplot(c_iam_count, aes(x=forcats::fct_reorder(iam, percent_result), y=percent_result))+
      labs(x="IAM",y="% Completed With Result")+
      geom_col(fill='red')+
      theme_bw()+
      coord_flip()
      
#plot to explore if the number of complaints has an effect on completion with result.
ggplot(c_iam_count, aes(x=percent_result, y=n))+
      annotate("text", label="mean # complaints", x = 0, y=mean(c_iam_count$n), vjust=0, hjust=0, alpha=0.5, size=4)+
      geom_point(size=2, aes(color=iam))+
      geom_hline(yintercept=mean(c_iam_count$n), linetype="dashed")+
      labs(title="Volume of Complaints Does Not Appear\nto Have an Impact on Rate of Completion With Result", x="% Completed With Result", y="Number of Complaints")+
      theme_bw()

# bc_iam_count<-left_join(b_iam_count, c_iam_count)

##Split the benchmark data into boolean sets and string sets
b_bool<-b %>% 
      filter(value %in% c("0","1")) %>% 
      mutate(value=as.numeric(value))

b_string<-b %>% 
      filter(!value %in% c("0","1"))

#pivot on iam and status.  
c_count<-c %>% 
      group_by(iam, status) %>% 
      count() %>% 
      ungroup() %>% 
      mutate(iam, as.factor(iam))






#Plot the count
c_count %>% 
      ungroup() %>% 
      ggplot(.)+
      geom_col(aes(x=iam, y=n, fill=status))+ 
      coord_flip()

b_count<-b %>% 
      filter(!is.na(value)) %>% 
      group_by(iam) %>% 
      count()

c_date<-c %>% 
      select_if(is.Date) %>% 
      bind_cols(c %>% select(project, iam)) %>% 
      gather(key=benchmark, value=date, 1:12) %>% 
      filter(!is.na(date))

#use benchmark boolean data and compare against completed with result


b_bool_wide=b_bool %>%select(-category) %>% 
      spread(benchmark,value) %>% 
      left_join(c %>% select(complaint_name, iam))

#create a base data frame with outcomes based on the eligibility_status column as binary
c_result<-c %>% 
      filter(filing_date<"2015-01-01") %>% 
      select(iam, project, eligibility_status ) %>% 
      filter(eligibility_status %in% c("closed_without_outcome","closed_with_outcome") ) %>% 
      mutate(outcome=ifelse(grepl("without", eligibility_status),0,1)) %>% 
      select(-eligibility_status)

#gather and spread the sectors turn into binary data
c_result_by_sector<-c %>% select(iam, project, sector_1, sector_2, sector_3) %>% 
      gather(key=drop, value=sector, 3:5,na.rm = T) %>% 
      filter(sector !="Other") %>% 
      select(-drop) %>% 
      distinct() %>% 
      left_join(c_result) %>% 
      group_by(iam, project, sector,outcome) %>% 
      count() %>% 
      ungroup() %>% 
      mutate(sector=paste0("s_", sector)) %>% 
      spread(sector, n, fill = 0) %>% 
      filter(!is.na(outcome))

#gather and spread the issues, turn into binary data. We're removing data labeled "Other" because it does not provide useful information for the model
c_result_by_issue<-c %>% select(project, iam, 17:26) %>%   gather(key=drop, value=issue, 3:12)%>% 
      select(-drop) %>% 
      filter(!is.na(issue), issue !="Other") %>% 
      mutate(count=1) %>% 
      distinct() %>% 
      ungroup() %>% 
      mutate(issue=paste0("i_", issue)) %>% 
      spread(issue, count, fill=0)

#join the sector and issue tables
c_sector_issue<-c_result_by_issue %>% 
      left_join(c_result_by_sector, by=c("project", "iam"))

#create a dataframe for fitting. This set includes only iam, project, outcome and the sector and issue variables
issue_sector_fit_data<-c_sector_issue %>%
      filter(!is.na(outcome))

#Adding back in additional data from the original complaint file. gather and spread the ifi_support columns
c_for_join<-c %>% select(2:13) %>% 
      select(-c(external_id, status, filer)) %>% 
      gather(key=drop, value=ifi_support, 7:8) %>% 
      distinct() %>% 
      select(-drop)

#create the full dataframe with issues, sectors and ifi_status
i_s_full<-left_join(c_result_by_sector, c_result_by_issue, by=c("project", "iam")) %>% 
      left_join(c_for_join, by=c("iam","project")) %>% 
      select(-project)

#not sure why I melted the data again, but here it is.
i_s_full_iam_long<-i_s_full %>% gather(key=variable, value=value,2:41) %>% 
      filter(!is.na(value))

#write files to share on slack
write.csv(issue_sector_fit_data, "issue_sector_fit_data.csv", row.names=FALSE)

write.csv(i_s_full, "issue_sector_fit_data_full.csv", row.names=FALSE)
library(rpart.plot)

#model excluding country data
i_s_no_country<-i_s_full %>% select(-country_1, -country_2, -country_3, -country_4)
fit<-rpart(outcome~.,i_s_no_country)
rpart.plot(fit, cex=.5)
plot(fit)
text(fit)

#Clara shared her data set in an RDATA file.  Used that to compare models
rpart.plot(rpart(ELIGIBLE~.,dat_here), cex=.5)
