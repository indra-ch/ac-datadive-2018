library(tidyverse)

# load data

load("~/R/Misc/Datakind/accountability_console_data_cleaned.RData")
load("~/R/Misc/Datakind/benchmark_data_cleaned.RData")
load("~/R/Misc/Datakind/benchmark_data_cleaned_melted.RData")




# Countries with the most complaints

complaints %>%
  select (starts_with("Country")) %>%
  gather (key, country) %>%
  group_by (country) %>%
  summarise ( n = n()) %>%
  filter (!is.na(country) & n> 5) %>%
  ggplot (aes(reorder(country , n), y=n)) +
  geom_col() +
  coord_flip()


# complaints by region

library (countrycode)

complaints %>%
  select (starts_with("Country")) %>%
  gather (key, country) %>%
  mutate (region = countrycode(country,'country.name', 'continent')) %>%
  group_by (region) %>%
  summarise ( n = n()) %>%
  filter (!is.na(region)) %>%
  ggplot (aes(reorder(region , n), y=n)) +
  geom_col() +
  coord_flip() +
  labs (title = "Complaints by Continent", x="Continents", y="Number of Complaints")

complaints %>%
  select (starts_with("Country")) %>%
  gather (key, country) %>%
  mutate (region = countrycode(country,'country.name', 'region')) %>%
  group_by (region) %>%
  summarise ( n = n()) %>%
  filter (!is.na(region)) %>%
  ggplot (aes(reorder(region , n), y=n)) +
  geom_col() +
  coord_flip() +
  labs (title = "Complaints by region (World Bank Definitions)", x="Region", y="Number of Complaints")

# Which IAMs has investigate the most complaints
complaints %>%
  group_by (IAM) %>%
  summarise (n = n()) %>%
  ggplot(aes(x= reorder(IAM, n), y= n)) +
  geom_col() +
  coord_flip()


complaints %>%
  group_by (IAM, Status) %>%
  summarise (n = n()) %>%
  ggplot(aes(x= reorder(IAM, n), y= n, fill = Status)) +
  geom_col() +
  coord_flip()



eligibility <- complaints %>%
  filter (grepl ("closed", Eligibility_Status)) %>%
  mutate (ineligible = ifelse (Eligibility_Status=="closed_without_outcome", 1, 0),
          e_status = factor(ifelse (Eligibility_Status == "closed_without_outcome", "ineligible", "eligible"))
                          )
# Countries with the most ineligible          

eligibility %>%
  select (starts_with("Country"), ineligible, e_status) %>%
  gather (key, country, Country_1:Country_4) %>%
  group_by (country) %>%
  summarise ( pct_ineligible = mean(ineligible), complaints_in_mechanism=n()) %>%
  filter (!is.na(country)& complaints_in_mechanism > 5 ) %>%
  ggplot (aes(reorder(country , pct_ineligible), y=pct_ineligible, fill = complaints_in_mechanism)) +
  geom_col() +
  coord_flip() +
  labs (title = "complaints ineligible by country", x = "Country", y = "Percent Ineligible")

# Continents with the most ineligilble

eligibility %>%
  select (starts_with("Country"), ineligible, e_status) %>%
  gather (key, country, Country_1:Country_4) %>%
  mutate (region = countrycode(country,'country.name', 'continent')) %>%
  group_by (region) %>%
  summarise ( pct_ineligible = mean(ineligible), complaints_in_mechanism=n()) %>%
  filter (!is.na(region)& complaints_in_mechanism > 5 ) %>%
  ggplot (aes(reorder(region , pct_ineligible), y=pct_ineligible, fill = complaints_in_mechanism)) +
  geom_col() +
  coord_flip() +
  labs (title = "complaints ineligible by continent", x = "Country", y = "Percent Ineligible")


# Regions with the most ineligible

eligibility %>%
  select (starts_with("Country"), ineligible, e_status) %>%
  gather (key, country, Country_1:Country_4) %>%
  mutate (region = countrycode(country,'country.name', 'region')) %>%
  group_by (region) %>%
  summarise ( pct_ineligible = mean(ineligible), complaints_in_mechanism=n()) %>%
  filter (!is.na(region)& complaints_in_mechanism > 5 ) %>%
  ggplot (aes(reorder(region , pct_ineligible), y=pct_ineligible, fill = complaints_in_mechanism)) +
  geom_col() +
  coord_flip() +
  labs (title = "complaints ineligible by region (World Bank definition)", x = "Country", y = "Percent Ineligible")

# percent eligibility by AIM


  eligibility %>%
    select (IAM, ineligible, e_status) %>%
    group_by (IAM) %>%
    summarise ( pct_ineligible = mean(ineligible), complaints_in_mechanism=n()) %>%
    filter (!is.na(IAM)) %>%
    ggplot (aes(reorder(IAM , pct_ineligible), y=pct_ineligible, fill = complaints_in_mechanism)) +
    geom_col() +
    coord_flip() +
    labs (title = "complaints ineligible by IAM", x = "IAM", y = "Percent Ineligible")
  
# percent elibility by sector
  
  
  eligibility %>%
    select (starts_with("Sector"), ineligible, e_status) %>%
    gather (key, sector, Sector_1:Sector_3) %>%
    group_by (sector) %>%
    summarise ( pct_ineligible = mean(ineligible), complaints_in_mechanism=n()) %>%
    arrange (desc(pct_ineligible)) %>%
    filter (!is.na(sector)& complaints_in_mechanism > 5 ) %>%
    ggplot (aes(reorder(sector , pct_ineligible), y=pct_ineligible, fill = complaints_in_mechanism)) +
    geom_col() +
    coord_flip() +
    labs (title = "complaints ineligible by sector", x = "sector", y = "Percent Ineligible")
  
  
  # percent elibility by issue
  
  
  eligibility %>%
    select (starts_with("Issue"), ineligible, e_status) %>%
    gather (key, issue, Issues_1:Issues_10) %>%
    group_by (issue) %>%
    summarise ( pct_ineligible = mean(ineligible), complaints_in_mechanism=n()) %>%
    arrange (desc(pct_ineligible)) %>%
    filter (!is.na(issue)& complaints_in_mechanism > 5 ) %>%
    ggplot (aes(reorder(issue , pct_ineligible), y=pct_ineligible, fill = complaints_in_mechanism)) +
    geom_col() +
    coord_flip() +
    labs (title = "complaints ineligible by issue", x = "issue", y = "Percent Ineligible")
  
  eligibility %>%
    filter (ineligible == 1) %>%
    select (starts_with("If_No_Eligi"), ineligible, e_status ) %>%
    gather (key, reason, If_No_Eligibility_Why_1:If_No_Eligibility_Why_3) %>%
    group_by (reason) %>%
    summarise ( n=n()) %>%
    filter (!is.na(reason)) %>%
    ggplot (aes(reorder(reason , n), y=n)) +
    geom_col() +
    coord_flip() +
    labs (title = "Reason for ineligibility", x = "Reason", y = "Count")
  
  