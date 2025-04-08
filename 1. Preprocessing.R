#Import library
{
  library(readr)
  library(tidyverse)
  library(naniar)
  library(gtExtras)
  library(patchwork)
  library(gridExtra)
  library(skimr)
  library(VIM)
  library(corrplot)
  library(ggplot2)
  library(grid)
  library(car)
}

#Import data
bike_sharing_data <- read_csv("hour.csv")

#Glimpse data
glimpse(bike_sharing_data)

#Remove `instant` and `dteday`
bike_sharing_data <- bike_sharing_data %>% 
  select(-c(dteday,instant)) 

#Skim data
skim(bike_sharing_data) 

#Check duplication
sum(duplicated(bike_sharing_data))

#Convert variable to 2 decimal places
bike_sharing_data <- bike_sharing_data %>% 
  mutate(across(c('temp','atemp','hum','windspeed'),~round(.x,2)))

#Number of humidity error
bike_sharing_data %>% 
  filter(hum == 0.00) %>%
  summarise("Humidity Error" = n())

#Drop humidity error
bike_sharing_data <- bike_sharing_data %>% 
filter(hum != 0)

#Convert variable to 2 decimal places
bike_sharing_data <- bike_sharing_data %>% 
  mutate(across(c('temp','atemp','hum','windspeed'),~round(.x,2)))

#Descriptive Summary
summary(bike_sharing_data)

#Convert to factor
bike_sharing_data <- bike_sharing_data %>% 
  mutate(across(c(season,holiday,workingday,weathersit, weekday, yr, mnth), as.factor))

#Convert to integer
bike_sharing_data <- bike_sharing_data %>% 
  mutate(across(c(instant,casual,registered,cnt,hr), as.integer))

#Create raw temperature and raw felt temperature columns
bike_sharing_data <- bike_sharing_data %>% 
  mutate(raw_temp = temp*47-8,
         raw_felt_temp = atemp*66-16,
         raw_windspeed = windspeed*67)

#Create weekend column
bike_sharing_data <- bike_sharing_data %>% 
  mutate(weekend = case_when(
    weekday == 0 ~ 1,
    weekday == 6 ~ 1,
    TRUE ~ 0
  )) 

#Categorize hour
{
  #Create intervals and labels
  hour_interval <- c(0,5,7,10,17,20,Inf)
  hour_label <- c("Late Night", "Early Morning", "Morning Peak", "Midday", "Afternoon Peak", "Evening")
  
  #Create hour category variable
  bike_sharing_data <- bike_sharing_data %>% 
    mutate(hr_cat =  cut(hr, breaks = hour_interval, labels = hour_label, right = FALSE)) 
  }

#Drop unused column
bike_sharing_data <- bike_sharing_data %>% 
    select(-c(yr,mnth,weekday,workingday,temp,atemp,windspeed,hr))

#Skim after processing
skim(bike_sharing_data)

#Prepare meaningful variable labels
continuous_variable_labels <- c(
  `casual` = "Casual Users",
  `registered` = "Registered Users",
  `hum` = "Humidity",
  `raw_felt_temp` = "Felt Temperature (°C)", 
  `raw_temp` = "Actual Temperature (°C)",   
  `raw_windspeed` = "Wind Speed (km/h)"  
)
glimpse(bike_sharing_data)


