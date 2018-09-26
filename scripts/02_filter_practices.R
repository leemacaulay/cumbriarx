# todo: get practice names, join them to file, filter further by postcode
# todo: the csv files don't have title rows.
# todo: turn the snippet into a function?

# load libraries
library(readr)
library(dplyr)

cols <- c("PERIOD", "PRACTICE", "NAME", "ADDRESS", "STREET", "TOWN", "COUNTY", "POSTCODE")

addresses <- list.files(path = "raw_data", pattern = "(ADDR)", full.names = T) %>%
  map_df(~read_csv(., col_names = cols))

cumbria <- left_join(cumbria, addresses, by = c("PRACTICE" = "PRACTICE", "PERIOD" = "PERIOD"))

cumbria %>% 
  group_by(PCT, PRACTICE, NAME) %>% 
  summarise(total=sum(ACT.COST)) %>% 
  arrange(desc(total)) %>% 
  head(5)