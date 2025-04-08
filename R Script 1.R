#Open libraries
library(readr)
library(tidyverse)
library(naniar)
library(gtExtras)
library(patchwork)
library(gridExtra)
library(skimr)
library(VIM)
library(plotly)
library(corrplot)
library(ggplot2)
library(grid)
library(car)
#Processing
{
#Import data
bike_sharing_data <- read_csv("hour.csv")
#View
View(bike_sharing_data)
#Glimpse
glimpse(bike_sharing_data)
#Skim
skim(bike_sharing_data) %>% 
  select(-c(n_missing,complete_rate))
#Remove dteday
bike_sharing_data <- bike_sharing_data %>% 
  select(-dteday) 
#Check duplication
sum(duplicated(bike_sharing_data))
#Convert to 2 decimal place
bike_sharing_data <- bike_sharing_data %>% 
  mutate(across(c('temp','atemp','hum','windspeed'),~round(.x,2))) 
#Descriptive summary
summary(bike_sharing_data) 
#Convert to factors
bike_sharing_data <- bike_sharing_data %>% 
  mutate(across(c(season,holiday,workingday,weathersit), as.factor))
#Convert to integer
bike_sharing_data <- bike_sharing_data %>% 
  mutate(across(c(instant,yr,mnth,hr,casual,registered,cnt), as.integer))
#Create raw temperature, raw felt temperature and raw_windspeed columns
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
#Split the data by year
year_2011 <- bike_sharing_data %>% 
  filter(yr == 0)
year_2012 <- bike_sharing_data %>% 
  filter(yr == 1)
}
#Users by each hour from 1/1/2011 to 31/12/2012
{
#Total users by each hour from 1/1/2011 to 31/12/2012
bike_sharing_data %>% 
  ggplot(aes(x = instant, y = cnt))+
  geom_point(size = 1, alpha = .5)+ 
  geom_vline(xintercept = 2068, linewidth = 2, colour = "red")+
  geom_vline(xintercept = c(7000, 10000), linewidth = 2, colour = "green")+
  labs(y = "Count")
#Casual users by each hour from 1/1/2011 to 31/12/2012
bike_sharing_data %>% 
  ggplot(aes(x = instant, y = casual))+
  geom_point(size = 1, alpha = .5)+ 
  geom_vline(xintercept = 2068, linewidth = 2, colour = "red")+
  geom_vline(xintercept = c(7000, 10000), linewidth = 2, colour = "green")+
  labs( y = "Count")
#Registered users by each hour from 1/1/2011 to 31/12/2012
bike_sharing_data %>% 
  ggplot(aes(x = instant, y = registered))+
  geom_point(size = 1, alpha = .5)+ 
  geom_vline(xintercept = 2068, linewidth = 2, colour = "red")+
  geom_vline(xintercept = c(7000, 10000), linewidth = 2, colour = "green")+
  labs( y = "Count")
}
#Usage distribution by hours across years
{
# Set up a 2x1 grid layout before printing the plots
grid::grid.newpage()
grid::pushViewport(grid::viewport(layout = grid::grid.layout(nrow = 2, ncol = 1)))

# Print the first plot in the top viewport
print(
  bike_sharing_data %>%
    ggplot() +
    geom_bar(aes(x = hr, y = casual), stat = 'identity') +
    theme_classic() +
    facet_grid(~yr),
  vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 1),
  newplot = FALSE
)

# Print the second plot in the bottom viewport
print(
  bike_sharing_data %>%
    ggplot() +
    geom_bar(aes(x = hr, y = registered), stat = 'identity') +
    theme_classic() +
    facet_grid(~yr),
  vp = grid::viewport(layout.pos.row = 2, layout.pos.col = 1),
  newplot = FALSE
)

grid::popViewport()
}
#Working travel from 7 to 9h and 16-19h
{
bike_sharing_data %>%
  mutate(
    travelling_purpose = case_when(
      ((hr >= 7 & hr <= 9) | (hr >= 16 & hr <= 19)) ~ "work",
      TRUE ~ "non work"
    )
  ) %>%
  filter(yr == 0) %>%
  group_by(travelling_purpose) %>%
  summarise(n = n()) %>%
  mutate(percentage = n / sum(n)) %>%
  ggplot(aes(x = travelling_purpose, y = percentage, fill = travelling_purpose)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = scales::percent(percentage)),
            position = position_dodge(width = 0.9),
            vjust = -0.25) +
  scale_y_continuous(labels = scales::percent) +
  theme_classic() +
  labs(y = "Percentage")
}
bike_sharing_data %>% 
  ggplot(aes(x = mnth, y = cnt))+
  geom_bar(stat = 'identity')+
  theme_classic()
{
# Set up a 2x1 grid layout before printing the plots
grid::grid.newpage()
grid::pushViewport(grid::viewport(layout = grid::grid.layout(nrow = 3, ncol = 1)))
# Print the first plot in the top viewport
print(
  bike_sharing_data %>% 
    filter(yr == 0) %>% 
    ggplot(aes(x = season, y = cnt))+
    geom_boxplot(color = "steelblue", fill = "lightblue")+
    theme_classic(),
  vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 1),
  newplot = FALSE
)
# Print the second plot in the bottom viewport
print(
  bike_sharing_data %>% 
    ggplot(aes(x = season, y = casual))+
    geom_boxplot(color = "steelblue", fill = "lightblue")+
    theme_classic(),
  vp = grid::viewport(layout.pos.row = 2, layout.pos.col = 1),
  newplot = FALSE
)
# Print the second plot in the bottom viewport
print(
  bike_sharing_data %>% 
    ggplot(aes(x = season, y = registered))+
    geom_boxplot(color = "steelblue", fill = "lightblue")+
    theme_classic(),
  vp = grid::viewport(layout.pos.row = 3, layout.pos.col = 1),
  newplot = FALSE
)
grid::popViewport()
}

{
#Set up a 2x1 grid layout before printing the plots
grid::grid.newpage()
  grid::pushViewport(grid::viewport(layout = grid::grid.layout(nrow = 3, ncol = 1)))
#Distribution of casual by hours across weekdays
print(
  bike_sharing_data %>%
    ggplot(aes(x = hr, y = casual)) +
    geom_bar(stat = 'identity') +
    theme_classic() +
    facet_grid(~weekday),
  vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 1),
  newplot = FALSE
)
#Distribution of registered by hours across weekdays
print(
  bike_sharing_data %>%
    ggplot(aes(x = hr, y = registered)) +
    geom_bar(stat = 'identity') +
    theme_classic() +
    facet_grid(~weekday),
  vp = grid::viewport(layout.pos.row = 2, layout.pos.col = 1),
  newplot = FALSE
)
#Distribution of total by hours across weekdays
print(
  bike_sharing_data %>%
    ggplot(aes(x = hr, y = cnt)) +
    geom_bar(stat = 'identity') +
    theme_classic() +
    facet_grid(~weekday),
  vp = grid::viewport(layout.pos.row = 3, layout.pos.col = 1),
  newplot = FALSE
)
}

bike_sharing_data %>%
  ggplot(aes(x = hr, y = casual)) +
  geom_bar(stat = 'identity') +
  theme_classic() +
  facet_grid(season~weekday)
bike_sharing_data %>%
  ggplot(aes(x = hr, y = cnt)) +
  geom_bar(stat = 'identity') +
  theme_classic() +
  facet_grid(season~weekday)

bike_sharing_data %>% 
  filter(mnth == 1 & weekday == 0) %>% 
  ggplot(aes(x = hr, y = cnt, group = hr))+
  geom_boxplot(color = "steelblue", fill = "lightblue")+
  theme_classic()

#Number of holiday and non-holiday
bike_sharing_data %>% 
  group_by(across(c(holiday,yr))) %>% 
  summarise(n = n(), .groups = 'drop') %>% 
  ggplot(aes(x = holiday, y = n, fill = holiday))+
  geom_bar(stat = 'identity')+
  geom_text(aes(label = n), vjust = -0.25, size = 3.5)+
  theme_classic()+
  facet_grid(~yr)+
  labs(title = "Number of holiday in each year", y ="")
  

bike_sharing_data %>% 
  group_by(across(c(holiday,yr))) %>% 
  summarise(casual = sum(casual), .groups = 'drop') %>% 
  ggplot(aes(x = holiday, y = casual))+
  geom_bar(stat = 'identity')+
  geom_text(aes(label = casual), vjust = -0.5, size = 3.5)+
  theme_classic()+
  facet_grid(~yr)+
  labs(title = "Usage in ", y ="")

bike_sharing_data %>%
  group_by(across(c(hr,workingday,holiday))) %>%  
  summarise(Casual = mean(casual), .groups = 'drop') %>%
  ggplot(aes(x = hr, y = Casual)) +
  geom_bar(fill = "steelblue", stat = 'identity') +
  theme_classic() +
  labs(title =  'Pairwise distribution Workingday - Holiday')+
  labs(title = 'Pairwise Distribution: Workingday vs. Holiday',
       x = "Hours", y = "Average Casual") +
  facet_grid(
    holiday ~ workingday,
    labeller = labeller(
      workingday = c(`0` = "Non-working Day", `1` = "Working Day"),
      holiday = c(`0` = "Non-Holiday", `1` = "Holiday")
    )
  )+
  bike_sharing_data %>%
  group_by(across(c(hr,workingday,holiday))) %>%  
  summarise(Registered = mean(registered), .groups = 'drop') %>%
  ggplot(aes(x = hr, y = Registered)) +
  geom_bar(fill = "steelblue", stat = 'identity') +
  theme_classic() +
  labs(title =  'Pairwise distribution Workingday - Holiday')+
  labs(title = 'Pairwise Distribution: Workingday vs. Holiday',
       x = "Hours", y = "Average Registered") +
  facet_grid(
    holiday ~ workingday,
    labeller = labeller(
      workingday = c(`0` = "Non-working Day", `1` = "Working Day"),
      holiday = c(`0` = "Non-Holiday", `1` = "Holiday")
    )
  )


bike_sharing_data %>%
  group_by(across(c(weekday, workingday, holiday))) %>%  
  summarise(Total = mean(cnt), .groups = 'drop') %>%
  ggplot(aes(x = weekday, y = Total)) +
  geom_bar(fill = "steelblue", stat = 'identity') +
  scale_x_continuous(breaks = 0:6) +
  theme_classic() +
  labs(title = 'Pairwise Distribution: Holiday vs. Working Day',
       x = "Weekday", y = "Average Count") +
  facet_grid(
    holiday ~ workingday,
    labeller = labeller(
      workingday = c(`0` = "Non-working Day", `1` = "Working Day"),
      holiday = c(`0` = "Non-Holiday", `1` = "Holiday")
    )
  )




#Proportion of Casual and Registered Users by Year
bike_sharing_data %>% 
  group_by(yr) %>% 
  summarise(Casual = sum(casual)*100/sum(cnt),
            Registered = sum(registered)*100/sum(cnt),
            .groups = "drop") %>% 
  pivot_longer(cols = c(Casual, Registered), names_to = "UserType", values_to = "Proportion") %>%  
  ggplot(aes(x = factor(yr), y = Proportion, fill = UserType))+
  geom_col(position = position_dodge(), width = 0.8)+
  geom_text(aes(label = round(Proportion,2)), fontface = "bold", vjust = -0.5, 
            position = position_dodge(0.8), size = 4)+
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e")) +
  scale_x_discrete(label = c("0"=2011, "1"=2012))+
  labs(
    title = "Proportion of Casual and Registered Users by Year",
    x = "Year", y = "Proportion of Total Users", fill = "User Type"
  ) +
  theme_classic()

#Proportion of Casual and Registered Users by Season
bike_sharing_data %>% 
  group_by(yr, season) %>%
  summarise(Casual = sum(casual),
            Registered = sum(registered),
            .groups = "drop") %>%
  pivot_longer(cols = c(Casual, Registered),
               names_to = "UserType",
               values_to = "Total") %>%
  group_by(yr, UserType) %>%
  mutate(Proportion = (Total / sum(Total)) * 100) %>%
  ungroup() %>%  
  ggplot(aes(x = factor(season), y = Proportion, fill = UserType))+
  geom_col(position = position_dodge(), width = 0.8)+
  geom_text(aes(label = round(Proportion,2)), fontface = "bold", vjust = -0.5, 
            position = position_dodge(0.8), size = 3)+
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e")) +
  scale_x_discrete(label = c("1"="Winter", "2"="Spring", "3"="Summer", "4"="Fall"))+
  labs(
    title = "Proportion of Casual and Registered Users by Season",
    x = "Season", y = "Proportion of Total Users", fill = "User Type"
  ) +
  facet_grid(yr~UserType)+
  theme_classic()

#Proportion of Casual and Registered Users by Months
bike_sharing_data %>% 
  group_by(yr, mnth) %>% 
  summarise(Casual = sum(casual),
            Registered = sum(registered),
            .groups = "drop") %>%
  pivot_longer(cols = c(Casual, Registered), names_to = "UserType", values_to = "Total") %>%  
  group_by(yr, UserType) %>% 
  mutate(Proportion = Total*100/sum(Total)) %>%
  ungroup() %>% 
  ggplot(aes(x = factor(mnth), y = Proportion, fill = UserType))+
  geom_col(position = position_dodge(0.9), width = 0.8)+
  geom_text(aes(label = round(Proportion,2)), fontface = "bold", vjust = -0.5, 
            position = position_dodge(0.9), size = 2.8)+
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e")) +
  labs(
    title = "Proportion of Casual and Registered Users by Months",
    x = "Month", y = "Proportion of Total Users", fill = "User Type"
  ) +
  facet_grid(yr~ UserType)+
  theme_classic()

#Proportion of Casual and Registered Users by Weekday
bike_sharing_data %>% 
  group_by(yr, weekday) %>% 
  summarise(Casual = sum(casual),
            Registered = sum(registered),
            .groups = "drop") %>%
  pivot_longer(cols = c(Casual, Registered), names_to = "UserType", values_to = "Total") %>%  
  group_by(yr, UserType) %>% 
  mutate(Proportion = Total*100/sum(Total)) %>%
  ungroup() %>%  
  ggplot(aes(x = factor(weekday), y = Proportion, fill = UserType))+
  geom_col(position = position_dodge(), width = 0.8)+
  geom_text(aes(label = round(Proportion,2)), fontface = "bold", vjust = -0.5, 
            position = position_dodge(0.9), size = 2.8)+
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e")) +
  labs(
    title = "Proportion of Casual and Registered Users by Weekday",
    x = "Month", y = "Proportion of Total Users", fill = "User Type"
  ) +
  facet_grid(yr~UserType)+
  theme_classic()

#Proportion of Casual and Registered Users by Hours
bike_sharing_data %>% 
  group_by(yr, hr) %>% 
  summarise(Casual = sum(casual),
            Registered = sum(registered),
            .groups = "drop") %>%
  pivot_longer(cols = c(Casual, Registered), names_to = "UserType", values_to = "Total") %>%  
  group_by(yr, UserType) %>% 
  mutate(Proportion = Total/sum(Total)) %>%
  ungroup() %>%    
  ggplot(aes(x = factor(hr), y = Proportion, fill = UserType))+
  geom_col(position = position_dodge(), width = 0.8)+
  scale_x_discrete(breaks = c(0,6,12,18,23))+
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e")) +
  scale_y_continuous(label = scales::percent)+
  labs(
    title = "Proportion of Casual and Registered Users by Hours",
    x = "Hours", y = "Proportion of Total Users", fill = "User Type"
  ) +
  facet_grid(yr~UserType)+
  theme_classic()

#Proportion of Hourly Usage across Day Type
bike_sharing_data %>%
  group_by(hr, workingday, holiday) %>%
  summarise(Casual = sum(casual),
            Registered = sum(registered),
            .groups = "drop") %>%
  pivot_longer(cols = c(Casual, Registered), names_to = "UserType", values_to = "Total") %>%
  group_by(holiday, workingday) %>% 
  mutate(Proportion = Total * 100 / sum(Total)) %>%
  ungroup() %>%
  ggplot(aes(x = hr, y = Proportion, color = UserType)) + 
  geom_line(linewidth = 1) +
  scale_color_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e")) +
  geom_point(size = 2) + 
  geom_text(aes(label = round(Proportion,2)), fontface = "bold", vjust = -0.5,
            position = position_dodge(0.8), size = 4)+
  theme_classic() +
  labs(title = 'Proportion of Hourly Usage across Day Type', 
       x = "Hour", y = "Proportion of Total Users (%)", color = "User Type") + 
  facet_grid(
    holiday ~ workingday,
    labeller = labeller(
      workingday = c(`0` = "Non-working Day", `1` = "Working Day"),
      holiday = c(`0` = "Non-Holiday", `1` = "Holiday")
    )
  ) 
#Proportion of Daily Usage across Months
bike_sharing_data %>% 
  group_by(mnth, weekday) %>% 
  summarise(Casual = sum(casual),
            Registered = sum(registered),
            .groups = "drop") %>%
  pivot_longer(cols = c(Casual, Registered), names_to = "UserType", values_to = "Total") %>%  
  group_by(mnth, UserType) %>% 
  mutate(Proportion = Total*100/sum(Total)) %>%
  ungroup() %>% 
  ggplot(aes(x = factor(weekday), y = Proportion, fill = UserType)) + 
  geom_col(position = position_dodge(), width = 0.6)+
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e")) +
  theme_classic()+
  labs(
    title = "Proportion of Daily Usage across Months",
    x = "Month", y = "Proportion of Total Users", color = "User Type"
  ) +
  facet_grid(mnth~ UserType)

#Average Hourly Usage by Day Type
bike_sharing_data %>% 
group_by(workingday, holiday, hr) %>% 
  summarise(Casual = mean(casual),
            Registered = mean(registered),
            .groups = "drop") %>%
  pivot_longer(cols = c(Casual, Registered), names_to = "UserType", values_to = "Average") %>%  
  ggplot(aes(x = factor(hr), y = Average, fill = UserType)) +
  geom_col(position = position_dodge(), width = 0.6)+
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e")) +
  scale_x_discrete(breaks = c(0,6,12,18,23))+
  facet_grid(holiday~workingday,
             labeller = labeller(
               workingday = c(`0` = "Non-working Day", `1` = "Working Day"),
               holiday = c(`0` = "Non-Holiday", `1` = "Holiday")
             ))+
  theme_classic()+
  labs(
    title = "Average Hourly Usage by Day Type",
    x = "Hour", y = "Average Usage", color = "User Type"
  ) 

#Average Usage of Each User Type by Hour Block
bike_sharing_data %>%
  group_by(hr_cat) %>%
  summarise(Casual = mean(casual),
            Registered = mean(registered),
            .groups = "drop") %>%
  pivot_longer(cols =  c(Casual, Registered), names_to = "UserType", values_to = "Average") %>% 
  ggplot(aes(x = hr_cat, y = Average, fill =UserType)) +
  geom_col(position = position_dodge(), width = 0.8) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e")) +
  labs(title = "Average Usage of Each User Type by Hour Block",
       x = "Hour Block",
       y = "Average Usage")+
  facet_grid(UserType~.)+
  theme_classic() 

#Average Usage in Each Weekday Across 4 Seasons
bike_sharing_data %>%
  group_by(hr_cat, weekday, season) %>%
  summarise(Casual = mean(casual),
            Registered = mean(registered),
            .groups = "drop") %>%
  pivot_longer(cols = c(Casual, Registered), names_to = "UserType", values_to = "Average") %>%
  ggplot(aes(x = hr_cat, y = Average, fill = UserType)) + 
  geom_col(position = position_dodge(), width = 0.8) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e")) +
  labs(title = 'Average Usage in Each Weekday Across 4 Seasons', 
       x = "Hour Block", y = "Proportion of Total Users (%)", color = "User Type") + 
  facet_grid(
    weekday ~ season
  )+
  theme_classic()  

#
bike_sharing_data %>% 
  ggplot(aes(x = factor(weathersit), y = raw_felt_temp, color = factor(weathersit)))+
  geom_boxplot()+
  theme_classic()



#Correlation plot with numeric variables
num_correl_table <- correlation_df %>%
  select(cnt,casual,registered,raw_felt_temp,raw_windspeed,hum) %>% 
  cor(.)
corrplot(num_correl_table, 
         method = "color", 
         type = "lower",
         addCoef.col = "#0F4761",
         number.cex = 0.6,
         tl.col = "#0F4761", 
         tl.srt = 30) 

#Correlation plot with numeric variables (log transformered DV)
log_num_correl_table <- bike_sharing_data %>% 
  mutate(registered = log(registered+1),
         casual = log(registered+1),
         cnt = log(cnt)) %>% 
  select(cnt,casual,registered,raw_felt_temp,raw_windspeed,hum) %>% 
  cor(.)

corrplot(log_num_correl_table, 
         method = "color", 
         type = "lower",
         addCoef.col = "#0F4761",
         number.cex = 0.6,
         tl.col = "#0F4761", 
         tl.srt = 30) 

#Correlation plot with ordinal variables
ordinal_correl_table <- correlation_df %>% 
  mutate(season = as.numeric(season),
         workingday = as.numeric(workingday),
         holiday = as.numeric(holiday),
         hr_cat = as.numeric(hr_cat),
         weathersit = as.numeric(weathersit)) %>% 
  select(cnt,casual,registered,weekday,season,workingday,holiday,weathersit,hr_cat) %>% 
  cor(., method = "spearman")

corrplot(ordinal_correl_table, 
         method = "color", 
         type = "lower",
         addCoef.col = "#0F4761",
         number.cex = 0.6,
         tl.col = "#0F4761", 
         tl.srt = 30)

#All variables correlation plot
all_correl_table <- correlation_df %>% 
  mutate(season = as.numeric(season),
         workingday = as.numeric(workingday),
         holiday = as.numeric(holiday),
         hr_cat = as.numeric(hr_cat),
         weathersit = as.numeric(weathersit)) %>% 
  select(cnt,casual,registered,weekday,season,workingday,holiday,weathersit,hr_cat, raw_felt_temp, hum, raw_windspeed) %>% 
  cor(., method = "spearman")

corrplot(all_correl_table, 
         method = "color", 
         type = "lower",
         addCoef.col = "#0F4761",
         number.cex = 0.6,
         tl.col = "#0F4761", 
         tl.srt = 30) 

lm(log(casual+1)~
     hum
   ,data = bike_sharing_data) %>% 
  summary()


#Casual linear regression
#Baseline model (R-squared  = 0.77)
lm(log(casual+1)~
     factor(hr_cat)+
     factor(weekend)+
     factor(weathersit)+
     factor(season)+
     factor(holiday)+
     hum+
     raw_felt_temp
     ,
   data = bike_sharing_data) %>% 
  summary()

plot(lm(log(casual+1)~
          factor(hr_cat)+
          factor(weekend)+
          factor(weathersit)+
          factor(season)+
          factor(holiday)+
          hum+
          raw_felt_temp
        ,
        data = bike_sharing_data))

#Interaction model (R-squared = 0.79)
lm(log(casual+1)~
     factor(hr_cat)*
     factor(workingday)+
     factor(weathersit)+
     factor(season)+
     hum+
     atemp+
     factor(holiday)
   ,
   data = bike_sharing_data) %>% 
  summary()


mean(bike_sharing_data$casual)
#Registered linear regression
#Baseline model (R-squared  = 0.71)
lm(log(registered+1)~
     factor(hr_cat)+
     factor(workingday)+
     factor(weathersit)+
     factor(season)+
     factor(holiday)+
     hum+
     atemp
   ,
   data = bike_sharing_data) %>% 
  summary()


#Interaction model (R-squared = 0.81)
lm(log(registered+1)~
     factor(hr_cat)*factor(workingday)+
     factor(weathersit)+
     factor(season)+
     factor(holiday)+
     hum+
     atemp
   ,
   data = bike_sharing_data) %>% 
  summary()

bike_sharing_data %>% 
  group_by(season, hr) %>% 
  reframe(Casual = casual,
            Registered = registered) %>% 
  pivot_longer(cols = c(Casual, Registered),
               names_to = "UserType",
               values_to = "Usage") %>%
  ggplot(aes(x = factor(hr), y = Usage, fill = UserType))+
  geom_boxplot()+
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e"))+
  facet_grid(UserType~season) 

bike_sharing_data %>% 
  group_by(season) %>% 
  summarise(holiday = n,
          .groups = "drop")%>% 
  pivot_longer(cols = hum,
               names_to = "hum",
               values_to = "%") %>%
  ggplot(aes(x = UserType, y = Total, fill = UserType))+
  geom_col(position = position_dodge(), width = 0.8)+
  scale_fill_manual(values = c("Casual" = "#1f77b4", "Registered" = "#ff7f0e"))+
  facet_grid(~holiday) 

bike_sharing_data %>% 
  group_by(season) %>% 
  summarise(q0 = quantile(raw_felt_temp,0),
            q1 = quantile(raw_felt_temp,0.25),
            q2 = quantile(raw_felt_temp,0.5),
            q3 = quantile(raw_felt_temp,0.75),
            q4 = quantile(raw_felt_temp,1)) 

bike_sharing_data %>% 
  group_by(season) %>% 
  summarise(q0 = quantile(hum,0),
            q1 = quantile(hum,0.25),
            q2 = quantile(hum,0.5),
            q3 = quantile(hum,0.75),
            q4 = quantile(hum,1)) 


