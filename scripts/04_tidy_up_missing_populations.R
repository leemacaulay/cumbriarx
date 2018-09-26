## It goes a bit less automated here because I used http://geoportal.statistics.gov.uk to grab a much smaller csv file listing all of the postcodes in Cumbria. You could do this in R, but it's another 1.3GB file to deal with 

## load libraries
library(readr)
library(dplyr)
library(stringr)

## time to read more detailed data about gp practices you need to set the column names first though.

cols <- c("CODE", "NAME", "GROUPING", "GEO",
          "LINE.1", "LINE.2", "LINE.3", "LINE.4",
          "LINE.5", "POSTCODE", "OPEN.DATE",
          "CLOSE.DATE", "STATUS.CODE", 
          "ORG.SUB.CODE", "CCG", "JOIN.DATE", 
          "LEFT.DATE", "PHONENUMBER",
          "COL.19", "COL.20", "COL.21", "RECORD.IND", "COL.23", 
          "PROVIDE", "COL.25", "SETTING", "COL.27")

epsaccur <- read_csv("raw_data/epraccur.csv", col_names = cols)

# make the status of each practice more readable - some of them aren't actually GP Practices!

epsaccur <- epsaccur %>% 
  select(CODE, STATUS.CODE, SETTING, CLOSE.DATE) %>%
  mutate(SETTING=case_when(
    SETTING=="0" ~ "Other",
    SETTING=="2" ~ "Out of Hours",
    SETTING=="4" ~ "GP Practice",
    SETTING=="9" ~ "Community Health Service",
    SETTING=="10" ~ "Hospital Service",
    SETTING=="13" ~ "Hospice"
  ))

# join the new practises data to our prescriptions df
cumbriarx <- left_join(cumbriarx, epsaccur, by = c("PRACTICE" = "CODE"))

# now let's use a list of all postcodes in Cumbria to make sure our dataframe includes just Cumbrian GP practices

cumbria_postcodes <- read_csv("raw_data/ONS_Postcode_Directory_Latest_Centroids_Cumbria.csv") ## downloaded from ONS Open Geography Portal

# here's our final dataframe so let's save it. There are still a two practices missing patient figures for some months - but because they've closed or merged with other practices, those patients are represented elsewhere.
# weirdly, one figure in the whole data frame went missing(?) so we've got to add it back in here before making the final csv

missingvar <- cumbriarx %>% 
  mutate(position = 1:n()) %>%
  filter(is.na(ITEMS))
cumbriarx[missingvar$position, 6] <- 1000

cumbriarx %>% 
  filter(SETTING=="GP Practice") %>% 
  filter(POSTCODE %in% cumbria_postcodes$pcds) %>%
  write_csv("output_data/rx_cumbriaonly.csv")