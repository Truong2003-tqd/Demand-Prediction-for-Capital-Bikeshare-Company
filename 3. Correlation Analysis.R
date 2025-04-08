#Create correlation dataframe
correlation_df <- bike_sharing_data
correlation_df <- correlation_df %>% 
  mutate(across(c(season,weekend,holiday,hr_cat,weathersit), as.numeric))

#Spearman Correlation Matrix
{
  #Ordinal variables correlation plot
  ordinal_correl_table <- correlation_df %>% 
    select(casual,registered,season,weekend,holiday,weathersit,hr_cat) %>% 
    cor(., method = "spearman")
  
  #Create categorical labels
  categorical_variable_labels <- c(
    `casual` = "Casual Users",             
    `registered` = "Registered Users",      
    `season` = "Season",                   
    `weekend` = "Weekend",          
    `holiday` = "Holiday",          
    `weathersit` = "Weather Situation",      
    `hr_cat` = "Hour Category")             
  
  #Set up labels
  rownames(ordinal_correl_table) <- categorical_variable_labels
  colnames(ordinal_correl_table) <- categorical_variable_labels
  
  #Create plot
  corrplot(ordinal_correl_table, 
           method = "color", 
           type = "lower",
           addCoef.col = color_code,
           number.cex = 1.2,
           tl.col = color_code, 
           tl.srt = 30,
           tl.cex = 1.4)
  mtext("Spearman Correlation Matrix", 
        side = 3,                   # Position: Top (1 - bottom, 2 - left, 3 - top, 4 - right)
        line = 1,                  # Adjust vertical position
        col = color_code,            # Title color
        cex = 3,                  # Title size
        font = 2)                   # Bold font
}

#Peasrson Correlation Matrix
{
  #Pearson Correlation
  numeric_correl_table <- correlation_df %>% 
    select(casual,registered,hum,raw_felt_temp,raw_temp,raw_windspeed) %>% 
    cor(.)
  
  #Set up labels
  rownames(numeric_correl_table) <- continuous_variable_labels
  colnames(numeric_correl_table) <- continuous_variable_labels
  
  #Create plot
  corrplot(numeric_correl_table, 
           method = "color", 
           type = "lower",
           addCoef.col = color_code,
           number.cex = 1.2,
           tl.col = color_code, 
           tl.srt = 30,
           tl.cex = 1.4) 
  mtext("Peasrson Correlation Matrix", 
        side = 3,                   # Position: Top (1 - bottom, 2 - left, 3 - top, 4 - right)
        line = -2,                  # Adjust vertical position
        col = color_code,            # Title color
        cex = 3,                  # Title size
        font = 2)                   # Bold font
}

#Correlation test
with(correlation_df,cor.test(registered,hr_cat, method = "spearman"))
with(correlation_df,cor.test(casual,hr_cat, method = "spearman"))
with(correlation_df,cor.test(registered,weathersit, method = "spearman"))
with(correlation_df,cor.test(casual,hr_cat, weathersit = "spearman"))
with(correlation_df,cor.test(registered,season, method = "spearman"))
with(correlation_df,cor.test(casual,season, method = "spearman"))
with(correlation_df,cor.test(registered,weekend, method = "spearman"))
with(correlation_df,cor.test(casual,weekend, method = "spearman"))
with(correlation_df,cor.test(registered,hum))
with(correlation_df,cor.test(casual,hum))
with(correlation_df,cor.test(registered,raw_felt_temp))
with(correlation_df,cor.test(casual,raw_felt_temp))
with(correlation_df,cor.test(registered,raw_windspeed))
with(correlation_df,cor.test(casual,raw_windspeed))
