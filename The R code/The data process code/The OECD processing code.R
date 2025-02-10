########################################################################
#note, this code is designed to access the data from the OECD and then processing it
#fit for later use of the regression analysis code in the Matlab.
#if you ask me why I do it in the different langauge? 
#R make me feel better
#Tie - 2024/11/18
########################################################################

#clean the enviroment
rm(list = ls())

#set the working direction
setwd("~/one drive/OneDrive - Carleton University/The GDP data cleaning-TIEMA/The data process code")

#create a new file for the data 
dir.create("~/one drive/OneDrive - Carleton University/The GDP data cleaning-TIEMA/The data process code/Data", recursive = TRUE)


#Step one Lode the all package that necessary. 
library (lubridate)    
library (cansim)       
library (WDI)          
library (fredr)        
library (tsbox)
library (RColorBrewer)
library(wesanderson)
library(writexl)
library(tidyr)
library(tsbox)
library(xts)
library(dplyr)

library(devtools)
install_github("expersso/OECD")

library(OECD)
#################################################################################

#################################################################################
#try to do the data cleaning
#################################################################################
OECD_clean
clean_oecd_yearly<- function(dataset, filter) {
  require(tidyr)
  require(dplyr)
  require(tsbox)
  require(xts) 
  require(writexl)
  require(OECD)
  
  # Access the data from the OECD
  raw_data <- get_dataset(dataset, filter)
  
  # Select relevant columns
  selection_data <- select(raw_data, ObsValue, REF_AREA, TIME_PERIOD, UNIT_MEASURE, MEASURE)
  
  # Convert observations from character to numeric
  selection_data$ObsValue <- as.numeric(selection_data$ObsValue)
  
  # Ensure TIME_PERIOD is numeric in the selection_data
  selection_data$TIME_PERIOD <- as.numeric(selection_data$TIME_PERIOD)
  
  # Define a complete range of years and countries
  all_countries <- unique(selection_data$REF_AREA)
  all_years <- seq(min(selection_data$TIME_PERIOD, na.rm = TRUE), max(selection_data$TIME_PERIOD, na.rm = TRUE), by = 1)
  
  # Create a full grid of TIME_PERIOD, REF_AREA, MEASURE, and UNIT_MEASURE
  full_grid <- expand.grid(
    TIME_PERIOD = all_years,
    REF_AREA = all_countries,
    MEASURE = unique(selection_data$MEASURE),
    UNIT_MEASURE = unique(selection_data$UNIT_MEASURE)
  )
  
  # Convert TIME_PERIOD to numeric in full_grid to match selection_data
  full_grid$TIME_PERIOD <- as.numeric(full_grid$TIME_PERIOD)
  
  # Merge full grid with actual data, filling in NAs where no data exists
  selection_data <- full_grid %>%
    left_join(selection_data, by = c("TIME_PERIOD", "REF_AREA", "MEASURE", "UNIT_MEASURE"))
  
  # Pivot data to wider format
  wide_data <- selection_data %>%
    pivot_wider(
      names_from = c(MEASURE, UNIT_MEASURE),
      values_from = ObsValue,
      names_sep = "_"
    )
  
  # Return the cleaned and widened data
  return(wide_data)
################################################################################
#the code up there is the code for OECD data cleaning fucntion
################################################################################
#next step is to use that fucntion to downlode the data


dataset <- "OECD.SDD.NAD,DSD_NAAG@DF_NAAG_I,1.0"
filter <- "A.AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE+DNK+EST+FIN+FRA+DEU+GRC+HUN+ISL+IRL+ISR+ITA+JPN+KOR+LVA+LTU+LUX+MEX+NLD+NZL+NOR+POL+PRT+SVK+SVN+ESP+SWE+CHE+TUR+GBR+USA.B1GQ+B1GQ_R.USD_PPP+USD_EXC."
Annual_GDP <- clean_oecd(dataset, filter)

#remove the unecessary col
Annual_GDP  <- Annual_GDP$B1GQ_R_USD_EXC <- NULL

#You can add another column that reports the “Price Level”, which is the ratio of BIGQ_USD_PPP/BIGQ_R_USD_PPP. 
if ("B1GQ_USD_PPP" %in% names(Annual_GDP) && "B1GQ_R_USD_PPP" %in% names(Annual_GDP)) {
  Annual_GDP$Price_Level <- ifelse(Annual_GDP$B1GQ_R_USD_PPP == 0 | is.na(Annual_GDP$B1GQ_R_USD_PPP), 
                                   NA, 
                                   Annual_GDP$B1GQ_USD_PPP / Annual_GDP$B1GQ_R_USD_PPP)
} else {
  warning("One or more required columns are missing.")
}

library(writexl)

install.packages("openxlsx")  # Install the package
library(openxlsx)             # Load the package

write.xlsx(Annual_GDP, file = "~/one drive/OneDrive - Carleton University/The GDP data cleaning-TIEMA/The data process code/Data/Ultra_raw_Annual_GDP.xlsx")

################################################################################
#the next step is for further anaysis and data cleaning.
################################################################################























