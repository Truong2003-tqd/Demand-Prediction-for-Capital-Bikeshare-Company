#Calculate summer average temperature and humidity
bike_sharing_data %>% 
  filter(season == 3) %>% 
  summarise(AverageHumidity = mean(hum),
            AverageTemperature = mean(raw_felt_temp))

#Calculate average temperature and humidity for each season
bike_sharing_data %>% 
  group_by(season) %>% 
  summarise(AverageHumidity = mean(hum),
            AverageTemperature = mean(raw_felt_temp))

#Extract R table
write.csv(bike_sharing_data, "bike_sharing_data.csv", row.names = FALSE)
