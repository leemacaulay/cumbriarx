# load libraries
library(readr)
library(purrr)
library(dplyr)

# todo - need to join addresses per month, urgh, because if not we won't get changes in gp surgeries. WAIT - couldn't we just grab all the address files we need and bind_rows() and then check for dupes?

patients <- list.files(path = "raw_data", pattern = "(gp-reg-pat-prac)", full.names = T) %>%
  map_df(~read_csv(.))

patients <- patients %>% 
  mutate(PERIOD=case_when(
    EXTRACT_DATE=="01JUN2018" ~ "201806",
    EXTRACT_DATE=="01MAY2018" ~ "201805",
    EXTRACT_DATE=="01APR2018" ~ "201804",
    EXTRACT_DATE=="01MAR2018" ~ "201803",
    EXTRACT_DATE=="01FEB2018" ~ "201802",
    EXTRACT_DATE=="01JAN2018" ~ "201801",
    EXTRACT_DATE=="01DEC2017" ~ "201712",
    EXTRACT_DATE=="01NOV2017" ~ "201711",
    EXTRACT_DATE=="01OCT2017" ~ "201710",
    EXTRACT_DATE=="01SEP2017" ~ "201709",
    EXTRACT_DATE=="01AUG2017" ~ "201708",
    EXTRACT_DATE=="01JUL2017" ~ "201707")) %>% 
  select(
    PERIOD,
    PRACTICE = CODE,
    PATIENTS = NUMBER_OF_PATIENTS
  )

patients$PERIOD <- as.numeric(patients$PERIOD)

cumbria <- left_join(cumbria, patients, by = c("PRACTICE" = "PRACTICE", "PERIOD" = "PERIOD"))

cumbria %>% 
  group_by(PCT, NAME, TOWN) %>% 
  summarise(total_per_patient=sum(ACT.COST)/mean(PATIENTS)) %>% 
  arrange(desc(total_per_patient)) %>% 
  head(5)

write_csv(cumbria, "output_data/cumbriarx.csv")
