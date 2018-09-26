
surgeries <- cumbriarx %>%
  drop_na(PATIENTS) %>%
  group_by(NAME, PERIOD) %>% 
  summarise("Items per patient"=sum(ITEMS)/mean(PATIENTS, na.rm = TRUE),
            "Average cost per item"=sum(ACT.COST)/sum(ITEMS)
  ) %>% 
  arrange(-(`Items per patient`))  %>% View

cumbriarx %>% 
  filter(str_detect(BNF.CODE, "^0501*")) %>%
  drop_na(PATIENTS) %>%
  mutate(month=month(month,label = TRUE)) %>% 
  group_by(NAME, month) %>% 
  summarise(Total=sum(ITEMS), Avg.Patients=mean(PATIENTS, na.rm = T), Rate=sum(ITEMS)/mean(PATIENTS, na.rm = TRUE) *100) %>%
  mutate(month = factor(month, levels = c(month.abb[7:12], month.abb[1:6]))) %>% 
  ggplot() +
  geom_line(aes(x=month, y=Rate, color=NAME)) +
  theme_minimal() +
  gghighlight(max(as.numeric(Rate)), max_highlight = 4L)

cumbriarx %>% 
  filter(str_detect(BNF.CODE, "^0501*")) %>% 
  group_by(NAME, month) %>%
  summarise(Total=sum(ITEMS), Avg.Patients=mean(PATIENTS, na.rm = T),Rate=sum(ITEMS)/mean(PATIENTS, na.rm = TRUE) * 100 ) %>% View
  ggplot() +
  geom_line(aes(x=month, y=Rate, group=NAME)) +
  theme_minimal() +
  gghighlight(max(as.numeric(Rate)), max_highlight = 4L)

cumbriarx %>% 
  filter(str_detect(BNF.CODE, "^040702*")) %>% 
  group_by(NAME, month) %>%
  summarise(Total=sum(ITEMS), Avg.Patients=mean(PATIENTS, na.rm = T),Rate=sum(ITEMS)/mean(PATIENTS, na.rm = TRUE) * 100 )%>% 
  ggplot() +
  geom_line(aes(x=month, y=Rate, color=NAME)) +
  theme_minimal() +
  gghighlight(max(as.numeric(Avg.Patients)), max_highlight = 5L)

cumbriarx %>% 
  filter(str_detect(BNF.CODE, "^0407020A0*")) %>% 
  group_by(NAME, month) %>%
  summarise(Total=sum(ITEMS), Avg.Patients=mean(PATIENTS, na.rm = T),Rate=sum(ITEMS)/mean(PATIENTS, na.rm = TRUE) * 100 )%>% 
  ggplot() +
  geom_line(aes(x=month, y=Rate, group=NAME)) +
  theme_minimal() +
  gghighlight(max(as.numeric(Rate)), max_highlight = 5L)
