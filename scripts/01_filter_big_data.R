# load libraries
library(readr)
library(purrr)
library(dplyr)
library(tidyr)

# let's use handy website openprescribing.net to find out which CCG codes we need to filter by
northcumbria <- read_csv("https://openprescribing.net/api/1.0/org_code/?q=Cumbria&org_type=CCG&format=csv")
morecambebay <- read_csv("https://openprescribing.net/api/1.0/org_code/?q=Morecambe&org_type=CCG&format=csv")
ccgs <- c(northcumbria$id, morecambebay$id)

# import data - these are BIG files so this is the first step towards filtering them down... YMMV, but I couldn't import the whole year's worth of data using my Macbook Air (only 8GB RAM) so had to split it into two first. 
# Uncomment the first line, then the second for that. Make sure to follow the next two steps twice.

rx <- list.files(path = "raw_data", pattern = "*.CSV", full.names = T) %>%
  .[1:6] %>% 
  map_df(~read_csv(., col_types = "cccccddddcc"))

# time to fix column names
colnames(rx) <- make.names(colnames(rx))

# now let's filter our BIG data by these codes AND write it to a file for further analysis. Same deal as before, uncomment the first line, then the second. 
rx %>% 
  filter(PCT %in% ccgs) %>%
  separate(PERIOD, sep = 4, into = c("year", "month"), convert = T, remove = F) %>%
  select(-X11) %>% 
  write_csv(path = "raw_data/processed/cumbria_1.csv", na="")

# delete the rx dataframe so we can start again
rm(rx)

rx <- list.files(path = "raw_data", pattern = "*.CSV", full.names = T) %>%
  .[7:12] %>% 
  map_df(~read_csv(., col_types = "cccccddddcc"))
colnames(rx) <- make.names(colnames(rx))

rx %>% 
  filter(PCT %in% ccgs) %>%
  separate(PERIOD, sep = 4, into = c("year", "month"), convert = T, remove = F) %>%
  select(-X11) %>% 
  write_csv(path = "raw_data/processed/cumbria_2.csv", na="")

# how does it look?

cumbria <- read_csv("raw_data/processed/cumbria_1.csv")
cumbria2 <- read_csv("raw_data/processed/cumbria_2.csv")
cumbria <- bind_rows(cumbria, cumbria2)
rm(cumbria2)

# let's do a simple check - top spending practices.

cumbria %>% 
  group_by(PCT, PRACTICE) %>% 
  summarise(total=sum(ACT.COST)) %>% 
  arrange(desc(total)) %>% 
  head(5)