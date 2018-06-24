dat_here %>%
 mutate(IAM = fct_reorder(IAM, issue_n,mean)) %>%
 ggplot(aes(x=IAM, y=issue_n,fill=IAM)) +
 geom_boxplot() +
 guides(fill=FALSE) +
 coord_flip() +
 labs(y=“Number of Issues”,title=“Number of issues filed by IAM”)