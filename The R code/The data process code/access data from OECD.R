######
#The code here is trying to access the direct data from OECD and clean it the way as reuqired
#Tie 2024/05/08 
######

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

#OECD_clean
clean_oecd <- function(dataset, filter) {
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
  return(wide_data)}

#################################################################################
#test try
#################################################################################

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


write.xlsx(Annual_GDP, file = "~/one drive/OneDrive - Carleton University/The GDP data cleaning-TIEMA/The data process code/Data/Annual_GDP.xlsx")



#################################################################################
#2. the quality data
#################################################################################

# Define the dataset identifier and filter based on the provided URL
dataset <- "OECD.SDD.NAD,DSD_NAMAIN1@DF_QNA,1.0"
#filter <- "Q.Y.AUS+BEL+CAN+CHL+COL+CRI+DNK+CZE+FIN+EST+DEU+FRA+GRC+HUN+IRL+ISL+ITA+ISR+KOR+LVA+JPN+LUX+NZL+NOR+POL+PRT+NLD+LTU+MEX+SVKN+SWE+CHE+ESP+TUR+GBR+USA+AUT.S1..B1GQ+PPP_B1GQ._Z._Z...LR+V.LA.T0102"

#filter <- "Q.Y.AUS+BEL+CAN+CHL+COL+CRI+DNK+CZE+FIN+EST+DEU+FRA+GRC+HUN+IRL+ISL+ITA+ISR+KOR+LVA+JPN+LUX+NZL+NOR+POL+PRT+NLD+LTU+MEX+SVK+SVN+SWE+CHE+ESP+TUR+GBR+USA+AUT.S1..B1GQ+PPP_B1GQ._Z._Z...LR+V.LA.T0102"
filter <- "Q.Y.AUS+BEL+CAN+CHL+COL+CRI+DNK+CZE+FIN+EST+DEU+FRA+GRC+HUN+IRL+ISL+ITA+ISR+KOR+LVA+JPN+LUX+NZL+NOR+POL+PRT+NLD+LTU+MEX+SVK+SVN+SWE+CHE+ESP+TUR+GBR+USA+AUT.S1..B1GQ+PPP_B1GQ._Z._Z...LR+V.LA.T0102"

#https://sdmx.oecd.org/public/rest/data/OECD.SDD.NAD,DSD_NAMAIN1@DF_QNA,1.0/Q.Y.AUS.S1..B1GQ+PPP_B1GQ._Z._Z...LR+V.LA.T0102?startPeriod=1970-Q1&endPeriod=2023-Q4&dimensionAtObservation=AllDimensions
# Define the time period
startPeriod <- "1950-Q1"
endPeriod <- "2023-Q4"

# Fetch the data from the OECD API and name it quarterly_oecd
quarterly_oecd <- get_dataset(dataset = dataset, filter = filter, start_time = startPeriod, end_time = endPeriod)

#check the data
head(quarterly_oecd )


write.xlsx(quarterly_oecd , file = "~/one drive/OneDrive - Carleton University/The GDP data cleaning-TIEMA/The data process code/Data/quarterly_oecd .xlsx")

# Get the column names of the dataset
column_names <- names(quarterly_oecd)

# Initialize a 21x1 matrix to store the results
check_matrix <- matrix(nrow = length(column_names), ncol = 1)
rownames(check_matrix) <- column_names
colnames(check_matrix) <- "Check"

# Check each column and store the result in the matrix
for (i in 1:length(column_names)) {
  col <- column_names[i]
  check_matrix[i, 1] <- all(quarterly_oecd[[col]] == quarterly_oecd[[col]][1])
}

# Convert the matrix to T/F
check_matrix <- ifelse(check_matrix, "T", "F")

# Convert matrix to data frame for easier sorting
check_df <- as.data.frame(check_matrix)
check_df$Column <- rownames(check_df)

# Sort the data frame to have all "T" at the top and "F" at the bottom
sorted_check_df <- check_df[order(check_df$Check, decreasing = TRUE), ]

# Convert back to matrix
sorted_check_matrix <- as.matrix(sorted_check_df$Check)
rownames(sorted_check_matrix) <- sorted_check_df$Column
colnames(sorted_check_matrix) <- "Check"

# Print the sorted matrix
print(sorted_check_matrix)


#next step: find the useful data here 

half_raw_quarterly_oecd <- data.frame(
  CURRENCY = quarterly_oecd$CURRENCY,
  OBS_STATUS = quarterly_oecd$OBS_STATUS,
  ObsValue = quarterly_oecd$ObsValue,
  PRICE_BASE = quarterly_oecd$PRICE_BASE,
  REF_AREA = quarterly_oecd$REF_AREA,
  TIME_PERIOD = quarterly_oecd$TIME_PERIOD,
  UNIT_MEASURE = quarterly_oecd$UNIT_MEASURE,
  REF_YEAR_PRICE = quarterly_oecd$REF_YEAR_PRICE
)

#replace the empty place with the NA 
half_raw_quarterly_oecd$REF_YEAR_PRICE[half_raw_quarterly_oecd$REF_YEAR_PRICE == ""] <- NA

#remove the currency that is not equal to USD
# Remove rows where CURRENCY is not equal to "USD"
half_raw_quarterly_oecd_usd <- half_raw_quarterly_oecd[half_raw_quarterly_oecd$CURRENCY == "USD", ]

#replace 0 with NA
half_raw_quarterly_oecd_usd$ObsValue[half_raw_quarterly_oecd_usd$ObsValue == 0] <- NA
half_raw_quarterly_oecd_usd$ObsValue[half_raw_quarterly_oecd_usd$ObsValue == ""] <- NA

# Print the first few rows of the filtered data frame to verify
#head(half_raw_quarterly_oecd_usd)

############################################################
#transfer the data into the time series 
start_time <- as.Date("1970-01-01")
end_time <- as.Date("2023-10-01")
time_seq <- seq.Date(start_time, end_time, by = "quarter")
time_period <- format(time_seq, "%Y-Q%q")

# Print the time periods to verify
head(time_period)
tail(time_period)

############################################################
#filter and reshapre the data
# Filter for real quality GDP (LR) and normal quality GDP (V)
real_gdp <- subset(half_raw_quarterly_oecd_usd, PRICE_BASE == "LR", select = c(TIME_PERIOD, REF_AREA, ObsValue))
normal_gdp <- subset(half_raw_quarterly_oecd_usd, PRICE_BASE == "V", select = c(TIME_PERIOD, REF_AREA, ObsValue))

# Rename columns for clarity
colnames(real_gdp) <- c("TIME_PERIOD", "REF_AREA", "Real_GDP")
colnames(normal_gdp) <- c("TIME_PERIOD", "REF_AREA", "Normal_GDP")


############################################################
# Merge real and normal GDP data
merged_data <- merge(real_gdp, normal_gdp, by = c("TIME_PERIOD", "REF_AREA"), all = TRUE)

#create the final data frame 
# Ensure the time period column is in the correct order
merged_data <- merged_data[order(merged_data$TIME_PERIOD), ]

# Assuming merged_data is already created

# Create a sequence of time periods from 1970-Q1 to 2023-Q4
start_time <- as.Date("1970-01-01")
end_time <- as.Date("2023-10-01")
time_seq <- seq.Date(start_time, end_time, by = "quarter")
time_period <- format(time_seq, "%Y-Q%q")

# Get unique countries from the data
countries <- unique(merged_data$REF_AREA)

# Create a complete time grid for each country
complete_grid <- expand.grid(TIME_PERIOD = time_period, REF_AREA = countries)

# Merge the complete grid with the existing data
final_data <- merge(complete_grid, merged_data, by = c("TIME_PERIOD", "REF_AREA"), all.x = TRUE)

# Replace 0 values with NA in Real_GDP and Normal_GDP columns
final_data$Real_GDP[is.na(final_data$Real_GDP) | final_data$Real_GDP == 0] <- NA
final_data$Normal_GDP[is.na(final_data$Normal_GDP) | final_data$Normal_GDP == 0] <- NA

# Sort the final data by REF_AREA and TIME_PERIOD
final_data <- final_data[order(final_data$REF_AREA, final_data$TIME_PERIOD), ]

#You can add another column that reports the “Price Level”, which is the ratio of BIGQ_USD_PPP/BIGQ_R_USD_PPP. 
if ("B1GQ_USD_PPP" %in% names(Annual_GDP) && "B1GQ_R_USD_PPP" %in% names(Annual_GDP)) {
  Annual_GDP$Price_Level <- ifelse(Annual_GDP$B1GQ_R_USD_PPP == 0 | is.na(Annual_GDP$B1GQ_R_USD_PPP), 
                                   NA, 
                                   Annual_GDP$B1GQ_USD_PPP / Annual_GDP$B1GQ_R_USD_PPP)
} else {
  warning("One or more required columns are missing.")
}


