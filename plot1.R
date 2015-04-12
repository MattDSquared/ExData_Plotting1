# plot1.R loads data and creates the first plot described in README.md

## =========== download, load, and clean data =========== 

# load data if it hasn't already been loaded
filename <- "household_power_consumption.zip"

if (!file.exists(filename)){ 
    message("Downloading data")
    
    # download binary file from https using mode wb
    setInternet2(use = TRUE) # uses ie protocols to dl from https
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                  destfile = filename,
                  mode="wb")
    
    dateDL <- date()
} else {
    message("using previously downloaded file")
}


# load data file
if (!exists("DT")) {
    message("Loading data file")
    
    # unzip file
    datafile <- unzip("household_power_consumption.zip")
    
    DT <- read.csv(datafile, 
                   sep=";", 
                   na.strings="?", 
                   stringsAsFactors=FALSE)
    
    # FIXME: if this errors, there may be problems re-running this code 
    message("Cleaning data file")
    # note: time zone must be specified otherwise, when daylight savings time
    # occurs, R treats rollover as na value
    DT$DateTime <- strptime(paste(DT$Date,DT$Time,sep=" "), 
                            format="%d/%m/%Y %H:%M:%S",
                            tz="GMT")
    if (exists("subDT")) rm(subDT)
}else {
    message("using previously loaded and cleaned data")
}

# extract sub data for all of days 2007-02-01 and 2007-02-02
if (!exists("subDT")) {
    message("extracting dates")
    tstart <- as.POSIXct("2007-02-01 00:00:00")
    tend <- as.POSIXct("2007-02-03 00:00:00")
    subDT <- DT[(DT$DateTime >= tstart) & (DT$DateTime < tend),]
}else {
    message("using previously extracted dates")
}
# IMPORTANT: do not modify DT or subDT below this point, 
# unexpected behavior may occur

## =========== Generate plot =========== 
