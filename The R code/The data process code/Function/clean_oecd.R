#The OECD data cleaning functtion
#It clean the OECD data in the clean data set 
#Tie Ma

#################################################################################
#note
#0.0.1 the construction of the function
#0.0.2 remove the excel generate process and it will transfer in the time series
#################################################################################
#OECD_clean
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
}

