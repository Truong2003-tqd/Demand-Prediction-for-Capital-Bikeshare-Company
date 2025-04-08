#Color code
color_code <- "#00004d"
registered_color <- "#B02133"

#Box Plots of All Continuous Variables
bike_sharing_data %>%
  pivot_longer(cols = c(casual, registered, hum, raw_felt_temp, raw_temp, raw_windspeed),
               names_to = "variable",
               values_to = "value")%>% 
  ggplot(aes( y = value)) +
  geom_boxplot(fill = color_code, alpha = 0.7,
               outlier.colour =  color_code,
               color =  color_code, size = 0.5
               ) +
  facet_wrap(~variable, scales = "free",
             labeller = labeller(
               variable = continuous_variable_labels)) +
  labs(x = NULL, y = "Value", title = "Box Plots of All Continuous Variables")+
  theme_classic()+
  theme(
    plot.title = element_text(size = 18, color = color_code, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 13, color = color_code),
    axis.text = element_text(size = 12, color = color_code),
    strip.text = element_text(size = 14, color = color_code, face = "bold"), 
    strip.background = element_rect(color = color_code))

