# plot4.R loads data and creates the fourth plot described in README.md

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
    
    # all lower case is easier to type
    names(DT) <- tolower(names(DT))
    
    # FIXME: if this errors, there may be problems re-running this code 
    message("Cleaning data file")
    # note: time zone must be specified otherwise, when daylight savings time
    # occurs, R treats rollover as na value
    DT$datetime <- strptime(paste(DT$date,DT$time,sep=" "), 
                            format="%d/%m/%Y %H:%M:%S",
                            tz="GMT")
    if (exists("subDT")) rm(subDT)
}else {
    message("using previously loaded and cleaned data")
}
# IMPORTANT: do not modify DT below this point, 
# unexpected behavior may occur

## =========== Generate plot =========== 

# extract sub data for all of days 2007-02-01 and 2007-02-02
message("extracting dates")
tstart <- as.POSIXct("2007-02-01 00:00:00",tz="GMT")
tend <- as.POSIXct("2007-02-03 00:00:00",tz="GMT")
plotidx <- (DT$datetime >= tstart) & (DT$datetime < tend)

# open window
PPI <- 96 # pixels per inch
if (exists("devid")) {
    # this is not safe if window is closed
    dev.set(devid)
} else {
    windows(width=480/PPI, height=480/PPI, xpinch=PPI, ypinch=PPI)
}
devid <- dev.cur()

# set up multiple plots
par(mfrow = c(2,2), mar=c(4,4,3,2))

# plot top left
with(subset(DT, plotidx), 
     plot(datetime, global_active_power, 
          type="l",
          xlab="",
          ylab="Global Active Power"))

# plot top right (becuase used mfrow, instead of mfcol)
with(subset(DT, plotidx), 
     plot(datetime, voltage, type="l"))

# plot bottom left
with(subset(DT, plotidx), 
     plot(datetime, sub_metering_1, 
          type="l",
          col="black", 
          xlab="",
          ylab="Energy sub metering"))

with(subset(DT, plotidx), 
     points(datetime, sub_metering_2, type="l", col="red"))

with(subset(DT, plotidx), 
     points(datetime, sub_metering_3, type="l", col="blue"))

legend("topright",
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black","red","blue"),
       lty=1, 
       cex=.75,
       bty="n")

# plot bottom right
with(subset(DT, plotidx), 
     plot(datetime, global_reactive_power, type="l",lwd=.5))

# save plot
dev.copy(png, file="plot4.png")
dev.off()