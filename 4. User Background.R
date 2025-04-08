#Proportion of Each User Type
{
bike_sharing_data %>% 
  summarise(Casual = sum(casual)*100/sum(cnt),
            Registered = sum(registered)*100/sum(cnt),
            .groups = "drop") %>% 
  pivot_longer(cols = c(Casual, Registered), names_to = "UserType", values_to = "Proportion") %>%  
  ggplot(aes(x = UserType, y = Proportion, fill = UserType))+
  geom_col(position = position_dodge(), width = 0.6)+
  geom_text(aes(label = paste0(round(Proportion,2),"%")),
            fontface = "bold", color = color_code, vjust = -0.5, 
            position = position_dodge(0.8), size = 6)+
  scale_fill_manual(values = c("Casual" = color_code, "Registered" = registered_color)) +
  labs(
    title = "Proportion of Each User Type",
    x = NULL, y = "Proportion(%)", fill = "User Type"
  ) +
  theme_classic()+
  theme(
    plot.title = element_text(size = 18, color = color_code, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 13, color = color_code),
    axis.text.y = element_text(size = 12, color = color_code),
    axis.text.x = element_text(size = 12, color = color_code),
    strip.text = element_text(size = 14, color = color_code, face = "bold"), 
    strip.background = element_rect(color = color_code),
    legend.title = element_text(size = 13, color = color_code, face = "bold"),
    legend.text = element_text(size = 12, color = color_code)
  )
}

#Box Plot of Each User Type across Hour Blocks
{
  bike_sharing_data %>% 
    group_by(hr_cat) %>% 
    reframe(Casual = casual,
            Registered = registered) %>% 
    pivot_longer(cols = c(Casual, Registered), names_to = "UserType", values_to = "Usage") %>%  
    ggplot(aes(x = hr_cat, y = Usage, fill = UserType))+
    geom_boxplot(alpha = 0.6,
                 outlier.colour =  color_code,
                 color =  color_code, size = 0.5
    )+
    scale_fill_manual(values = c("Casual" = color_code, "Registered" = registered_color)) +
    labs(
      title = "Box Plot of Each User Type across Hour Blocks",
      x = NULL, y = "Usage", fill = "User Type"
    ) +
    facet_grid(UserType~., scales = "free")+
    theme_classic()+
    theme(
      plot.title = element_text(size = 18, color = color_code, face = "bold", hjust = 0.5),
      axis.title = element_text(size = 15, color = color_code),
      axis.text.y = element_text(size = 13, color = color_code),
      axis.text.x = element_text(size = 13, color = color_code),
      strip.text = element_text(size = 15, color = color_code, face = "bold"), 
      strip.background = element_rect(color = color_code),
      legend.title = element_text(size = 14, color = color_code, face = "bold"),
      legend.text = element_text(size = 13, color = color_code)
    )
}

#Box Plots of Casual Users in each Hour Block across Day Type
{
  bike_sharing_data %>% 
    group_by(hr_cat, weekend, holiday) %>% 
    reframe(Casual = casual) %>% 
    pivot_longer(cols = c(Casual), names_to = "UserType", values_to = "Usage") %>%  
    ggplot(aes(x = hr_cat, y = Usage, fill = UserType))+
    geom_boxplot(width = 0.6,
                 alpha = 0.6,
                 outlier.colour =  color_code,
                 color =  color_code, size = 0.5)+
    scale_fill_manual(values = c("Casual" = color_code, "Registered" = registered_color)) +
    labs(title = 'Box Plots of Casual Users in each Hour Block across Day Type\n', 
         x = NULL, y = "Usage", color = "User Type") + 
    facet_grid(
      holiday ~ weekend,
      labeller = labeller(
        weekend = c(`0` = "Weekday", `1` = "Weekend"),
        holiday = c(`0` = "Non-Holiday", `1` = "Holiday")))+
    theme_classic()+
    theme(
      plot.title = element_text(size = 18, color = color_code, face = "bold", hjust = 0.5),
      axis.title = element_text(size = 15, color = color_code),
      axis.text.y = element_text(size = 13, color = color_code),
      axis.text.x = element_text(size = 11, color = color_code, lineheight = 0.9),
      strip.text = element_text(size = 15, color = color_code, face = "bold"), 
      strip.background = element_rect(color = color_code),
      legend.position = "none"
    )
}
#Box Plots of Registered  Users in each Hour Block across Day Type
{
  bike_sharing_data %>% 
  group_by(hr_cat, weekend, holiday) %>% 
  reframe(Registered = registered) %>% 
  pivot_longer(cols = c(Registered), names_to = "UserType", values_to = "Usage") %>%
  ggplot(aes(x = hr_cat, y = Usage, fill = UserType))+
  geom_boxplot(width = 0.6,
               alpha = 0.6,
               outlier.colour =  color_code,
               color =  color_code, size = 0.5)+
  scale_fill_manual(values = c("Casual" = color_code, "Registered" = registered_color)) +
    labs(title = 'Box Plots of Registered Users in each Hour Block across Day Type\n', 
         x = NULL, y = "Usage", color = "User Type") + 
  facet_grid(
    holiday ~ weekend,
    labeller = labeller(
      weekend = c(`0` = "Weekday", `1` = "Weekend"),
      holiday = c(`0` = "Non-Holiday", `1` = "Holiday")))+
  theme_classic()+
  theme(
    plot.title = element_text(size = 18, color = color_code, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 15, color = color_code),
    axis.text.y = element_text(size = 13, color = color_code),
    axis.text.x = element_text(size = 11, color = color_code),
    strip.text = element_text(size = 15, color = color_code, face = "bold"), 
    strip.background = element_rect(color = color_code),
    legend.position = "none")
}

#Column charts of seasonal proportion and box plots of seasonal usage of each user type
{
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(nrow = 2, ncol =1)))
  #Proportion of Seasonal Usage between Two User Types
  print(
    bike_sharing_data %>% 
      group_by(season) %>%
      summarise(Casual = sum(casual),
                Registered = sum(registered),
                .groups = "drop") %>%
      pivot_longer(cols = c(Casual, Registered),
                   names_to = "UserType",
                   values_to = "Total") %>%
      group_by(UserType) %>%
      mutate(Proportion = (Total / sum(Total)) * 100) %>%
      ungroup() %>%  
      ggplot(aes(x = season, y = Proportion, fill = UserType))+
      geom_col(position = position_dodge(), width = 0.8)+
      geom_text(aes(label = paste0(round(Proportion,2),"%")), fontface = "bold", vjust = -0.25, 
                position = position_dodge(0.8), size = 3)+
      scale_fill_manual(values = c("Casual" = color_code, "Registered" = registered_color)) +
      scale_x_discrete(label = c("1"="Winter", "2"="Spring", "3"="Summer", "4"="Fall"))+
      labs(
        title = "Proportion of Seasonal Usage between Two User Types",
        x = NULL, y = "Proportion (%)", fill = "User Type") +
      facet_grid(~UserType)+
      theme_classic()+
      theme(
        plot.title = element_text(size = 16, color = color_code, face = "bold"),
        axis.title = element_text(size = 14, color = color_code),
        axis.text.y = element_text(size = 12, color = color_code),
        axis.text.x = element_text(size = 10, color = color_code),
        strip.text = element_text(size = 13, color = color_code, face = "bold"), 
        strip.background = element_rect(color = color_code),
        legend.position = "none"),
    vp = viewport(layout.pos.row = 1, layout.pos.col = 1),
    newplot = FALSE)
  #Boxplot of Seasonal Usage between Two User Types
  print(
    bike_sharing_data %>% 
      group_by(season) %>%
      reframe(Casual = casual,
              Registered = registered) %>%
      pivot_longer(cols = c(Casual, Registered),
                   names_to = "UserType",
                   values_to = "Usage") %>%
      ggplot(aes(x = season, y = Usage, fill = UserType))+
      geom_boxplot(width = 0.6,
                   alpha = 0.6,
                   outlier.colour =  color_code,
                   color =  color_code, size = 0.5)+
      scale_fill_manual(values = c("Casual" = color_code, "Registered" = registered_color)) +      
      scale_x_discrete(label = c("1"="Winter", "2"="Spring", "3"="Summer", "4"="Fall"))+
      labs(
        title = "Boxplot of Seasonal Usage between Two User Types",
        x = NULL, y = "Usage", fill = "User Type") +
      facet_grid(~UserType)+
      theme_classic()+
      theme(
        plot.title = element_text(size = 16, color = color_code, face = "bold"),
        axis.title = element_text(size = 14, color = color_code),
        axis.text.y = element_text(size = 12, color = color_code),
        axis.text.x = element_text(size = 10, color = color_code),
        strip.text = element_text(size = 13, color = color_code, face = "bold"), 
        strip.background = element_rect(color = color_code),
        legend.position = "none"),
    vp = viewport(layout.pos.row = 2, layout.pos.col = 1),
    newplot = FALSE)
}

#
{
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(nrow = 3, ncol =2)))
  print(
    bike_sharing_data %>% 
      group_by(weathersit) %>%
      reframe(Casual = casual,
              Registered = registered) %>%
      pivot_longer(cols = c(Casual, Registered),
                   names_to = "UserType",
                   values_to = "Usage") %>%
      ggplot(aes(x = weathersit, y = Usage, fill = UserType))+
      geom_boxplot(width = 0.6,
                   alpha = 0.6,
                   outlier.colour =  color_code,
                   color =  color_code, size = 0.5)+
      scale_fill_manual(values = c("Casual" = color_code, "Registered" = registered_color)) +
      scale_x_discrete(label = c("1"="Clear", "2"="Mild Cloud", "3"="Light Rain", "4"="Heavy Rain"))+
      labs(
        title = "Box Plots of Usage in Different Weather Situation",
        x = NULL, y = "Usage", fill = "User Type") +
      facet_grid(~UserType)+
      theme_classic()+
      theme(
        plot.title = element_text(size = 18, color = color_code, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 15, color = color_code),
        axis.text.y = element_text(size = 11, color = color_code),
        axis.text.x = element_text(size = 11, color = color_code),
        strip.text = element_text(size = 15, color = color_code, face = "bold"), 
        strip.background = element_rect(color = color_code),
        legend.position = "none"),
    vp = viewport(layout.pos.row = 1:3, layout.pos.col = 1),
    newplot = FALSE
  )
  
  print(
    bike_sharing_data %>% 
      group_by(weathersit) %>%
      ggplot(aes(x = weathersit, y = raw_felt_temp, fill = "weathersit"))+
      geom_boxplot(fill ="#1f77b4",
                   alpha = 0.6,
                   outlier.colour =  color_code,
                   color =  color_code, size = 0.5)+
      scale_x_discrete(label = c("1"="Clear", "2"="Mild Cloud", "3"="Light Rain", "4"="Heavy Rain"))+
      labs(
        title = "Box Plots of Felt Temperature",
        x = NULL, y = "°C") +
      theme_classic()+
      theme(
        plot.title = element_text(size = 18, color = color_code, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 15, color = color_code),
        axis.text.y = element_text(size = 11, color = color_code),
        axis.text.x = element_text(size = 11, color = color_code),
        strip.text = element_text(size = 15, color = color_code, face = "bold"), 
        strip.background = element_rect(color = color_code),
        legend.position = "none"),
    vp = viewport(layout.pos.row = 1, layout.pos.col = 2),
    newplot = FALSE
  )
  
  print(
    bike_sharing_data %>% 
      group_by(weathersit) %>%
      ggplot(aes(x = weathersit, y = hum, fill = "weathersit"))+
      geom_boxplot(fill ="#1f77b4",
                   alpha = 0.6,
                   outlier.colour =  color_code,
                   color =  color_code, size = 0.5)+
      scale_x_discrete(label = c("1"="Clear", "2"="Mild Cloud", "3"="Light Rain", "4"="Heavy Rain"))+
      labs(
        title = "Box Plots of Humidity",
        x = NULL, y = "Unit") +
      theme_classic()+
      theme(
        plot.title = element_text(size = 18, color = color_code, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 15, color = color_code),
        axis.text.y = element_text(size = 11, color = color_code),
        axis.text.x = element_text(size = 11, color = color_code),
        strip.text = element_text(size = 15, color = color_code, face = "bold"), 
        strip.background = element_rect(color = color_code),
        legend.position = "none"),
    vp = viewport(layout.pos.row = 2, layout.pos.col = 2),
    newplot = FALSE
  )
  
  print(
    bike_sharing_data %>% 
      group_by(weathersit) %>%
      ggplot(aes(x = weathersit, y = raw_windspeed, fill = "weathersit"))+
      geom_boxplot(fill ="#1f77b4",
                   alpha = 0.6,
                   outlier.colour =  color_code,
                   color =  color_code, size = 0.5)+
      scale_x_discrete(label = c("1"="Clear", "2"="Mild Cloud", "3"="Light Rain", "4"="Heavy Rain"))+
      labs(
        title = "Box Plots of Windspeed",
        x = NULL, y = "km/h") +
      theme_classic()+
      theme(
        plot.title = element_text(size = 18, color = color_code, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 15, color = color_code),
        axis.text.y = element_text(size = 11, color = color_code),
        axis.text.x = element_text(size = 11, color = color_code),
        strip.text = element_text(size = 15, color = color_code, face = "bold"), 
        strip.background = element_rect(color = color_code),
        legend.position = "none"),
    vp = viewport(layout.pos.row = 3, layout.pos.col = 2),
    newplot = FALSE
  )
}

