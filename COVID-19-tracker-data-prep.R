library(dplyr)
library(stringr)

setwd("/Users/saumyasinha/Documents/Learning/Projects/COVID-19-master Tracking/csse_covid_19_data/csse_covid_19_daily_reports/")

#=======================Load data from multiple files===========================
files <- list.files(pattern="*.csv")

data <- bind_rows(lapply(files, read.csv))

summary(data)
names(data)

#============================Rename column headers===============================
names(data)[1] <- "State"
names(data)[2] <- "Country"
names(data)[3] <- "LastUpdated"

#=================================Remove whitespaces=============================
#Remove whitespaces from State
data$State <- trimws(data$State, which = "both", whitespace = "[ \t\r\n]")
#unique(sort(data$State, decreasing = FALSE))

#Remove whitespaces from Country
data$Country <- trimws(data$Country, which = "both", whitespace = "[ \t\r\n]")
#unique(sort(data$Country, decreasing = FALSE))

#rename_country <- function(search_string_country, new_country) {
#  data$Country <-  ifelse(str_detect(data$Country,search_string_country)==TRUE,new_country,data$Country)
#}
 
#=================================Rename countries===============================
data$Country = ifelse(str_detect(data$Country,"China")==TRUE,"China",data$Country)
data$Country = ifelse(str_detect(data$Country,"Czech")==TRUE,"Czech Republic",data$Country)
data$Country = ifelse(str_detect(data$Country,"Niger")==TRUE,"Nigeria",data$Country)
data$Country = ifelse(str_detect(data$Country,"Hong Kong")==TRUE,"Hong Kong",data$Country)
data$Country = ifelse(str_detect(data$Country,"Gambia")==TRUE,"The Gambia",data$Country)
data$Country = ifelse(str_detect(data$Country,"Iran")==TRUE,"Iran",data$Country)
data$Country = ifelse(str_detect(data$Country,"Taiwan")==TRUE,"Taiwan",data$Country)
data$Country = ifelse(str_detect(data$Country,"United Kingdon")==TRUE,"UK",data$Country)
data$Country = ifelse(str_detect(data$Country,"United States")==TRUE,"US",data$Country)
data$Country = ifelse(str_detect(data$Country,"Bahamas")==TRUE,"The Bahamas",data$Country)
data$Country = ifelse(str_detect(data$Country,"Viet Nam")==TRUE,"Vietnam",data$Country)
data$Country = ifelse(str_detect(data$Country,"Taipei")==TRUE,"Taiwan",data$Country)
data$Country = ifelse(str_detect(data$Country,"Korea, South")==TRUE,"South Korea",data$Country)

#================================Format Dates====================================
#Initialize to a date class value
LastUpdatedDate=as.Date("2020-01-01")

#Get location and value of different date formats and convert to date
#Warning - LastUpdated2 has a caveat as length 13 can be of two different format; handled using is.na()
LastUpdated1_loc <- which(nchar(data$LastUpdated)==14 | nchar(data$LastUpdated)==15)
LastUpdated1_data <- data$LastUpdated[LastUpdated1_loc]
LastUpdatedDate[LastUpdated1_loc] <- as.Date(LastUpdated1_data,'%m/%d/%Y %H:%M')

LastUpdated2_loc <- which(nchar(data$LastUpdated)==13)
LastUpdated2_data <- data$LastUpdated[LastUpdated2_loc]
LastUpdatedDate[LastUpdated2_loc] <- as.Date(LastUpdated2_data,'%m/%d/%y %H:%M')

LastUpdated3_loc <- which(nchar(data$LastUpdated)==19)
LastUpdated3_data <- data$LastUpdated[LastUpdated3_loc]
LastUpdatedDate[LastUpdated3_loc] <- as.Date(LastUpdated3_data,'%Y-%m-%dT%H:%M:%S')

#Handling errors (NA) values produced by LastUpdated2
LastUpdatedDate[which(is.na(LastUpdatedDate))] <- as.Date(data$LastUpdated,'%m/%d/%Y %H:%M')

#Assign to original date column
data$LastUpdated <- LastUpdatedDate

#=========================Change NA count of cases to 0===========================
data$Confirmed[which(is.na(data$Confirmed))] <- 0
data$Deaths[which(is.na(data$Deaths))] <- 0
data$Recovered[which(is.na(data$Recovered))] <- 0

#=========================Show data===========================
data

#=========================Write to CSV===========================
write.csv(data,"Master_Data.csv", row.names = FALSE)
