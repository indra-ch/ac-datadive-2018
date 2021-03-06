rm(list=ls())

setwd("./ac-datadive-2018/Compare_Scrapes/")

library(dplyr) # data manip
library(tidyr)

df_old_name <- "unified_scrape - 20180524.csv" # change these names to the files you want to compare
df_new_name <- "unified_scrape - 20180624.csv"

df_old <- read.csv(df_old_name,stringsAsFactors=FALSE)
df_new <- read.csv(df_new_name,stringsAsFactors = FALSE)

# set the timestamp based on the scrape date of the new file
new.file.scrap.date <- substr(as.numeric(gsub("\\D", "", df_new_name)) , start = 1, stop = 8)
old.file.scrap.date <- substr(as.numeric(gsub("\\D", "", df_old_name)) , start = 1, stop = 8)

# create unique ID
df_old$pid <- paste(df_old$IAM_ID, df_old$PROJECT_ID, df_old$PROJECT_NAME, sep="-")
df_new$pid <- paste(df_new$IAM_ID, df_new$PROJECT_ID, df_new$PROJECT_NAME, sep="-")

df_old$newold <- "old"
df_new$newold <- "new"

fulldf <- bind_rows(df_old,df_new)

fulldfl <-  fulldf %>% 
  gather(key = field, value = value, -pid, -newold)

#apply some data cleaning to avoid false positives
fulldfl$value <- trimws(fulldfl$value)
fulldfl$value <- toupper(fulldfl$value)
fulldfl$value <- gsub("^$|^ $", NA, fulldfl$value)

#for each unique row, compare value for new vs old
fulldfl <- fulldfl %>% 
  group_by(pid, field, value) %>% 
  mutate(pfv_count = n())

diffset <- fulldfl[fulldfl$pfv_count == 1,]
diffset$pidfield <- paste(diffset$pid,diffset$field,sep="_")

diffset.old <- diffset[diffset$newold == "old",]
colnames(diffset.old) <- paste(colnames(diffset.old),"old", sep = "_")

diffset.new <- diffset[diffset$newold == "new",]
colnames(diffset.new) <- paste(colnames(diffset.new),"new", sep = "_")


diffviz <- merge(diffset.old,diffset.new,by.x="pidfield_old",by.y="pidfield_new",all=TRUE)

# ensure all entries have a PID, even if only in one of the inputs
diffviz$pid_universal <- diffviz$pid_new
diffviz$pid_universal[is.na(diffviz$pid_new)] <- diffviz$pid_old[is.na(diffviz$pid_new)]

# highlight situations without matches in both files
diffviz$mergebreak[is.na(diffviz$pid_old) & !is.na(diffviz$pid_new)] <- "Complaint not found in old file"
diffviz$mergebreak[!is.na(diffviz$pid_old) & is.na(diffviz$pid_new)] <- "Complaint not found in new file"

# drop all but one entry if entry has no match in other file
diffviz <- diffviz[order(diffviz$pid_universal, diffviz$mergebreak),]
diffviz <- diffviz[!duplicated(paste(diffviz$pid_universal,diffviz$mergebreak)),]


# blank out the field values for such entries
diffviz[c("field_old","field_new","value_old","value_new")][!is.na(diffviz$mergebreak),] <- NA
diffviz$New_or_Lost[!is.na(diffviz$mergebreak)] <- diffviz$mergebreak[!is.na(diffviz$mergebreak)]


# prep for final output
#diffviz_out <- diffviz[c("pid.universal","mergebreak","field.new","value.old","value.new","timestamp.new")]

# gather project names and any other common data that we want to tie into the final output
project_names <- rbind(df_new[c("pid","PROJECT_NAME","HYPERLINK")],df_old[c("pid","PROJECT_NAME","HYPERLINK")])
project_names <- project_names[order(colnames(project_names))]
project_names <- project_names[!duplicated(project_names),]

# merge project names
diffviz <- merge(diffviz,project_names,by.x="pid_universal",by.y="pid",all.x=TRUE)

# set the timestamp for changes, using var set early on
diffviz$timestamp_new <- new.file.scrap.date 

# final output
diffviz_out <- diffviz[c("pid_universal","PROJECT_NAME","field_new","value_old","value_new","timestamp_new","New_or_Lost","HYPERLINK")]

diffviz_out <- diffviz_out[order(diffviz_out$New_or_Lost,diffviz_out$pid_universal),]

diffviz_out <- rename(diffviz_out, 
                      PID = pid_universal,
                      Project_Name = PROJECT_NAME,
                      Field = field_new,
                      Previous_Value = value_old,
                      Current_Value = value_new,
                      Change_Date = timestamp_new,
                      URL = HYPERLINK)

# add "critical" fields here - defined as fields that go from having a value to having no value
critical_list = c('COMPLAINT_STATUS', 'ELIGIBILITY_START_DATE')
diffviz_out = diffviz_out %>%
  mutate(Criticality = ifelse(Field %in% critical_list & is.na(Previous_Value)==F & 
                                is.na(Current_Value)==T, "High", "Normal"))

# save a file for just the current changes
filename = paste('current_change_log', old.file.scrap.date, new.file.scrap.date,".csv", sep='_')
write.csv(diffviz_out, filename, row.names = F)

# read in master change long, add new changes, and save
master_changes = read.csv('master_change_log.csv', stringsAsFactors = F)
master_changes = rbind(master_changes, diffviz_out)
write.csv(master_changes, 'master_change_log.csv', stringsAsFactors = F)