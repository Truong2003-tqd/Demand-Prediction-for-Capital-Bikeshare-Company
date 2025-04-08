#Casual model without interaction (selected model)
lm(log(casual+1)~
     hr_cat+
     weekend+
     weathersit+
     season+
     holiday+
     hum+
     raw_felt_temp
   ,
   data = bike_sharing_data) %>%
  summary()

#Casual model with interaction
lm(log(casual+1)~
  hr_cat*weekend+
  weathersit+
  season+
  hum+
  raw_felt_temp+
  holiday
,  
data = bike_sharing_data) %>% 
  summary()

#Registered model without interaction
lm(log(registered+1)~
     hr_cat+
     weekend+
     weathersit+
     season+
     holiday+
     hum+
     raw_felt_temp
   ,
   data = bike_sharing_data) %>% 
  summary()

#Registered model with interaction
lm(log(registered+1)~
     hr_cat*weekend+
     weathersit+
     season+
     holiday+
     hum+
     raw_felt_temp
   ,
   data = bike_sharing_data) %>% 
  summary()
