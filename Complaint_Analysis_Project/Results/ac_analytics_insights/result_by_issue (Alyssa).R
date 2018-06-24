c=complaint data.  Adding prefix i_

c_result_by_issue<-c %>% select(project, iam, 17:26) %>%   gather(key=drop, value=issue, 3:12)%>%
     select(-drop) %>%
     filter(!is.na(issue), issue !="Other") %>%
     mutate(count=1) %>%
     distinct() %>%
     ungroup() %>%
     mutate(issue=paste0("i_", issue)) %>%
     spread(key = issue, value=count, fill=0)