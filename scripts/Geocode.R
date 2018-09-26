# http://learn.r-journalism.com/en/mapping/geolocating/geolocating/

library(ggmap)

options(device = "X11") 
X11.options(type = "cairo")

addresses <- cumbriarx %>% 
  select(PRACTICE, NAME:POSTCODE) %>% 
  unique()

addresses <- addresses %>%
  mutate(location = paste0(ADDRESS, ", ", ifelse(is.na(STREET), "" , paste0(STREET, ", ")), TOWN, ", ", ifelse(is.na(COUNTY), "CUMBRIA, " , paste0(COUNTY, ", ")), POSTCODE))

geo <- mutate_geocode(addresses, location)

cumbriarx <- left_join(cumbriarx, geo, by = c("PRACTICE", "PRACTICE"))
opioidsgeo <- left_join(opioids, geo, by = c("name" = "NAME"))

cumbriageo <- read_sf("raw_data/LADistricts/Local_Authority_Districts_December_2017_Full_Clipped_Boundaries_in_United_Kingdom_WGS84.shp") %>% 
  filter(objectid < 72, objectid > 65)

opioidsgeo <- opioidsgeo %>% 
  mutate(mycolor = ifelse(pct.change>0, "red1", "green1"))

ggplot(cumbriageo) +
  geom_sf(fill="transparent") +
  geom_point(data=opioidsgeo, aes(x=lon, y=lat, size=pct.change), fill=opioidsgeo$mycolor, color="black", shape=21) +
  theme_void() +
  theme(panel.grid.major = element_line(colour = 'transparent'))

write_csv(opioidsgeo, "output_data/opioidsgeo.csv")
write_sf(cumbriageo, "output_data/opioidsgeo.shp")