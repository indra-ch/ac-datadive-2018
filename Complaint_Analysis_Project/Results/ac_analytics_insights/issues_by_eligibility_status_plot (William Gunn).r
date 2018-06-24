complaints_long_issues<-melt(complaints, measure.vars = c(17:26))
tb<-ddply(complaints_long_issues, .(value, Eligibility_Status), nrow, .drop=F)
tb[,"total_issues"]<-rep(ddply(complaints_long_issues, .(value), nrow)$V1, each=4)
tb[,"percent_of_total"]<-tb$V1/tb$total_issues
ggplot(tb, aes(x=value, y=percent_of_total)) + geom_point(aes(colour=Eligibility_Status)) + theme(axis.text.x = element_text(angle = 90, hjust = 1))