# load libraries
library(readr)
library(dplyr)
library(stringr)

# import data for June
p <- read_csv("raw_data/T201806PDPI+BNFT.csv")

# because we're just going for 

# fix column names
colnames(p) <- make.names(colnames(p))

p <- left_join(p, ccg, by = c("PCT" = "CCG17CDH"))

# convert columns to numeric
# ACT COST and NIC are per unit and NOT totals
p$ITEMS <- as.numeric(p$ITEMS)
p$QUANTITY <- as.numeric(p$QUANTITY) 
p$ACT.COST <- as.numeric(p$ACT.COST)
p$NIC <- as.numeric(p$NIC)

# filter by postcode so all CAXX XXX and some LA5 to LA23

p %>%
#  filter(CCG17NM == "NHS North Cumbria CCG") %>% 
  select(BNF.NAME,BNF.CODE, ITEMS, NIC) %>% 
  filter(BNF.NAME=="Dextrometh Hydrob_Oral Susp 30mg/5ml") %>% 
  arrange(-`NIC`)

p %>%
  filter(BNF.NAME=="Dextrometh Hydrob_Oral Susp 30mg/5ml")

p %>%
  filter(PCT=="01H") %>% 
  group_by(`BNF NAME`) %>% 
  summarise(total=sum(`ACT COST`) / sum(ITEMS)) %>% 
  arrange(-total)

p %>%
  filter(PCT=="01H") %>% 
  filter(ITEMS=="1" | ITEMS=="2") %>% 
  filter(QUANTITY=="200")
  
p %>%
  filter(PCT=="01H") %>% 
  filter(ITEMS=="1" | ITEMS=="4") %>% 
  filter(QUANTITY=="200") %>% View
  
