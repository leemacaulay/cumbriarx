# load libraries
library(readr)
library(curl)

### PLEASE DON'T SOURCE THIS FILE WITHOUT UNDERSTANDING IT OR YOU'LL DOWNLOAD UP TO 30GB OF FILES ### 

# let's download the data programmatically - careful, these are BIG FILES (over 1.3GB each). If you do this, go away a get a cup of tea of something because it will take a while. 
# you could also get the data yourself from  
# https://digital.nhs.uk/data-and-information/publications/statistical/practice-level-prescribing-data

# we're using paste0 to produce a url which looks like this 
# http://datagov.ic.nhs.uk/presentation/2018_04_April/T201804PDPI+BNFT.CSV

urls <- paste0("http://datagov.ic.nhs.uk/presentation/", rep(2017:2018, each = 12),
               "_", sprintf("%02s",1:12), "_", month.name, "/", "T", 
               rep(2017:2018, each = 12), sprintf("%02s", 1:12), "PDPI+BNFT.CSV")

# subsetting urls vector to only download between July 2017 and June 2018 (p) and generating filenames (dest)
p <- urls[7:18]
dest <- paste0("./raw_data/", basename(urls[7:14]))

mapply(function(x, y) curl_download(x,y, quiet = FALSE), x = p, y = dest) # This is the final download command.

## Now let's do the same for surgery addresses

# we're reusing our snippet to produce a url which looks like this 
# http://datagov.ic.nhs.uk/presentation/2018_04_April/T201804ADDR+BNFT.CSV
addrurls <- paste0("http://datagov.ic.nhs.uk/presentation/", rep(2017:2018, each = 12),
               "_", sprintf("%02s",1:12), "_", month.name, "/", "T", 
               rep(2017:2018, each = 12), sprintf("%02s", 1:12), "ADDR+BNFT.CSV")

# subsetting urls vector to only download between July 2017 and June 2018 (p) and generating filenames (dest)
addrp <- addrurls[7:18]
addrdest <- paste0("./raw_data/", basename(addrurls[7:18]))

mapply(function(x, y) curl_download(x,y, quiet = FALSE), x = addrp, y = addrdest)

## Finally, it is time to get the surgery registered patients. We have to list all these urls manually because they're all different... 

regurls <- c(
  "https://files.digital.nhs.uk/E3/F090EF/gp-reg-pat-prac-all-jun-18.csv",
  "https://files.digital.nhs.uk/26/44B581/gp-reg-pat-prac-all-may-18.csv",
  "https://files.digital.nhs.uk/71/B59D99/gp-reg-pat-prac-all.csv",
  "https://files.digital.nhs.uk/publication/6/e/gp-reg-pat-prac-all-mar-18.csv",
  "https://files.digital.nhs.uk/publication/j/6/gp-reg-pat-prac-all-feb-18.csv",
  "https://files.digital.nhs.uk/excel/b/n/gp-reg-pat-prac-all-jan-18.csv",
  "https://files.digital.nhs.uk/publication/h/g/gp-reg-pat-prac-all-dec-17.csv",
  "https://files.digital.nhs.uk/publication/k/7/gp-reg-pat-prac-all-nov-17.csv",
  "https://files.digital.nhs.uk/publication/b/j/gp-reg-pat-prac-all-oct-17.csv",
  "https://files.digital.nhs.uk/publication/c/g/gp-reg-pat-prac-all-sep-17.csv",
  "https://files.digital.nhs.uk/publication/4/j/gp-reg-pat-prac-all-aug-17.csv",
  "https://files.digital.nhs.uk/excel/i/a/gp-reg-pat-prac-all-jul-17.csv"
)

# generating filenames (dest)
regdest <- paste0("./raw_data/", basename(regurls))

mapply(function(x, y) curl_download(x,y, quiet = FALSE), x = regurls, y = regdest)

# get more detailed data about practices (to filter out some weird cases)

eprurl <- "https://files.digital.nhs.uk/assets/ods/current/epraccur.zip"
eprdest <- paste0("./raw_data/", basename(eprurl))
curl_download(eprurl, eprdest, quiet = FALSE)
unzip(eprdest)