
# libraries
library(ggplot2)

# complaints
complaints <- read.csv("accountability_console_data_cleaned.csv")

# eligible
eligible_complaints <- complaints[complaints$ELIGIBLE==1&!is.na(complaints$ELIGIBLE),]
# not eligible
ineligible_complaints <- complaints[complaints$ELIGIBLE==0&!is.na(complaints$ELIGIBLE),]

# function - data by country
data_by_country <- function(column1,column2,name2) {
  data = aggregate(column1,list(column2),FUN=length)
  names(data) <- c("Country",name2)
  return(data)
}
# countries - eligible complaints
eligible_complaints_by_country1 <- data_by_country(eligible_complaints$Complaint_Name,eligible_complaints$Country_1,"Count1")
eligible_complaints_by_country2 <- data_by_country(eligible_complaints$Complaint_Name,eligible_complaints$Country_2,"Count2")
eligible_complaints_by_country3 <- data_by_country(eligible_complaints$Complaint_Name,eligible_complaints$Country_3,"Count3")
eligible_complaints_by_country4 <- data_by_country(eligible_complaints$Complaint_Name,eligible_complaints$Country_4,"Count4")

# countries - ineligible complaints
ineligible_complaints_by_country1 <- data_by_country(ineligible_complaints$Complaint_Name,ineligible_complaints$Country_1,"Count1")
ineligible_complaints_by_country2 <- data_by_country(ineligible_complaints$Complaint_Name,ineligible_complaints$Country_2,"Count2")
ineligible_complaints_by_country3 <- data_by_country(ineligible_complaints$Complaint_Name,ineligible_complaints$Country_3,"Count3")
ineligible_complaints_by_country4 <- data_by_country(ineligible_complaints$Complaint_Name,ineligible_complaints$Country_4,"Count4")

# compaints by countries
complaints_by_countries <- function(df1,df2,df3,df4,name1,name2) {
  data <- Reduce(function(dtf1,dtf2) merge(dtf1,dtf2,by=name1,all=TRUE),list(df1,df2,df3,df4))
  for (i in 2:5) {
    data[,i][is.na(data[,i])] = 0
  }
  data <- data.frame(data[,1],(data[,2]+data[,3]+data[,4]+data[,5]))
  names(data) <- c(name1,name2)
  return(data)
}
eligible_complaints_by_countries <- complaints_by_countries(eligible_complaints_by_country1,eligible_complaints_by_country2,eligible_complaints_by_country3,eligible_complaints_by_country4,"Country","TotalCount")
ineligible_complaints_by_countries <- complaints_by_countries(ineligible_complaints_by_country1,ineligible_complaints_by_country2,ineligible_complaints_by_country3,ineligible_complaints_by_country4,"Country","TotalCount")

# all complaints by countries
complaints_by_countries <- merge(eligible_complaints_by_countries,ineligible_complaints_by_countries,by.x="Country",by.y="Country",all=TRUE)
names(complaints_by_countries) <- c("Country","Eligible Complaints Count","Ineligible Complaints Count")
complaints_by_countries[,2][is.na(complaints_by_countries[,2])] = 0; complaints_by_countries[,3][is.na(complaints_by_countries[,3])] = 0
complaints_by_countries[,4] = complaints_by_countries[,2]+complaints_by_countries[,3]
names(complaints_by_countries) <- c("Country","Eligible Complaints Count","Ineligible Complaints Count","Total Count")
complaints_by_countries[,5] = round((complaints_by_countries[,2]/complaints_by_countries[,4])*100,2)
complaints_by_countries[,6] = round((complaints_by_countries[,3]/complaints_by_countries[,4])*100,2)
names(complaints_by_countries) <- c("Country","Eligible Complaints Count","Ineligible Complaints Count","Total Count",
                                    "% of Total Count Eligible Complaints","% of Total Count Ineligible Complaints")
# visualize data

# percentages - eligible country
# eligible countries
percentages1 <- rbind(complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),5][2:28],
           complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),6][2:28])
barplot(percentages1,beside=FALSE,legend=TRUE,col=c("grey","orange"),names.arg=complaints_by_countries$Country[2:28],cex.names=0.25,main="% of Total Count Eligible Complaints")

# both countries
percentages2 <- rbind(complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),5][29:55],
                      complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),6][29:55])
barplot(percentages2,beside=FALSE,legend=TRUE,col=c("grey","orange"),names.arg=complaints_by_countries$Country[29:55],cex.names=0.25,main="% of Total Count Eligible + Ineligible Complaints")
# both countries
percentages3 <- rbind(complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),5][56:82],
                      complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),6][56:82])
barplot(percentages3,beside=FALSE,legend=TRUE,col=c("grey","orange"),names.arg=complaints_by_countries$Country[56:82],cex.names=0.25,main="% of Total Count Eligible + Ineligible Complaints")
# both countries
percentages4 <- rbind(complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),5][83:92],
                      complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),6][83:92])
barplot(percentages4,beside=FALSE,legend=TRUE,col=c("grey","orange"),names.arg=complaints_by_countries$Country[83:92],cex.names=0.25,main="% of Total Count Eligible + Ineligible Complaints")

# ineligible countries
percentages5 <- rbind(complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),5][93:119],
                      complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),6][93:119])
barplot(percentages5,beside=FALSE,legend=TRUE,col=c("grey","orange"),names.arg=complaints_by_countries$Country[93:119],cex.names=0.25,main="% of Total Count Ineligible Complaints")
# ineligible countries
percentages6 <- rbind(complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),5][120:146],
                      complaints_by_countries[order(complaints_by_countries$`% of Total Count Eligible Complaints`,decreasing=TRUE),6][120:146])
barplot(percentages6,beside=FALSE,legend=TRUE,col=c("grey","orange"),names.arg=complaints_by_countries$Country[120:146],cex.names=0.25,main="% of Total Count Ineligible Complaints")



