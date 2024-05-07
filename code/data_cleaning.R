
# Data Cleaning -----------------------------------------------------------
# This code is called at the beginning of validation_study_analysis.qmd, so
# there is no reason to run it on its own.

# Defining the packages to use to clean the data
pkg <- c("tidyverse")

# Loading the groundhog package to install packages from a certain date
library(groundhog)

# Reading in the packages with the groundhog package for reproducibility
groundhog.library(pkg = pkg, date = "2024-04-22")

# Reading in the unclean data as data.unclean
data.unclean <- read.csv(file = "./data/validation_data_ready.csv")

# Turning gender responses into standardized labels
data.unclean <- data.unclean %>%
  mutate(
    gender = str_trim(gender),  # Remove leading and trailing spaces
    gender = str_to_lower(gender),  # Convert all to lowercase
    gender = case_when(
      gender %in% c("male", "man") ~ "Male",
      gender %in% c("female") ~ "Female",
      gender %in% c("non-binary") ~ "Non-binary",
      TRUE ~ NA_character_  # Assign NA to any unclassified responses
    )
  )

# Making variables into factor variables as appropriate
  # Gender
data.unclean$gender <- factor(data.unclean$gender)
  # Recruitment method
data.unclean$rec_meth <- factor(data.unclean$rec_meth)
  # Completed level of education
data.unclean$educ_complete <- factor(data.unclean$educ_complete)
  # Education currently in
data.unclean$educ_currently_in <- factor(data.unclean$educ_currently_in)
  # Religious affiliation
data.unclean$religious_affiliation <- factor(data.unclean$religious_affiliation)
  # Social media platform recruited from
data.unclean$social_media_platform <- factor(data.unclean$social_media_platform, 
                                             levels = c("Facebook", 
                                                        "Instagram", 
                                                        "Other (please specify)"), 
                                             labels = c("Facebook", 
                                                        "Instagram", 
                                                        "Other"))
  # Christian affiliation
data.unclean$christian_affiliation <- factor(data.unclean$christian_affiliation, 
                                             levels = c("Catholic Anglican / Episcopalian",
                                                        "Protestant", 
                                                        "Pentecostal / Apostolic", 
                                                        "Methodist", 
                                                        "Lutheran", 
                                                        "Orthodox / Eastern Orthodox", 
                                                        "Baptist", 
                                                        "Calvinist / Reformed / Presbyterian", 
                                                        "Christian -- no particular branch or denomination", 
                                                        "Other"), 
                                             labels = c("Catholic Anglican / Episcopalian",
                                                        "Protestant", 
                                                        "Pentecostal / Apostolic", 
                                                        "Methodist", 
                                                        "Lutheran", 
                                                        "Orthodox / Eastern Orthodox", 
                                                        "Baptist", 
                                                        "Calvinist / Reformed / Presbyterian", 
                                                        "Non-denominational", 
                                                        "Other"))


# Convert ID to character value
data.unclean$id <- as.character(data.unclean$id)

# Drop data_retention_consent
data.unclean <- data.unclean %>% select(-data_retention_consent)

# Standardize dates
  # Apply parsing and conversion directly using the mutate function for both start date and end date
    # Start date
data.unclean <- data.unclean %>%
  mutate(date_start = parse_date_time(date_start, orders = c("ymd HMS", "mdy HM"), tz = "UTC")) %>%
  mutate(date_start = as.POSIXct(date_start, origin = "1970-01-01", tz = "UTC"))
    # End date
data.unclean <- data.unclean %>%
  mutate(date_end = parse_date_time(date_end, orders = c("ymd HMS", "mdy HM"), tz = "UTC")) %>%
  mutate(date_end = as.POSIXct(date_end, origin = "1970-01-01", tz = "UTC"))

#Calculate time_taken from start date and end date
data.unclean <- data.unclean %>%
  mutate(time_taken = as.numeric(difftime(date_end, date_start, units = "mins")))


# Calculate Scale Item Values ---------------------------------------------

# Calculate item values for pathogen and moral disgust
  # Define function to extract and convert scale values from character state
clean_disgust_items <- function(column) {
  # Use str_extract to get the first number from the string
  numeric_part <- as.numeric(str_extract(column, "^[0-9]+"))
  return(numeric_part)
}
  # Apply this function to each scale item for pathogen disgust
data.unclean <- data.unclean %>%
  mutate(across(starts_with("PD"), clean_disgust_items))
  # Apply this function to each scale item for moral disgust
data.unclean <- data.unclean %>%
  mutate(across(starts_with("MD"), clean_disgust_items))

# Calculate item values for IOGS and DOGS
  # Convert character values to the correct numeric values
data.unclean <- data.unclean %>%
  mutate(across(starts_with("IOGS"), ~case_when(
    . == "very unlikely" ~ 1,
    . == "unlikely" ~ 2,
    . == "slightly unlikely" ~ 3,
    . == "neither likely nor unlikely" ~ 4,
    . == "somewhat likely" ~ 5,
    . == "likely" ~ 6,
    . == "very likely" ~ 7,
    TRUE ~ NA_real_
  ))) %>%
  mutate(across(starts_with("DOGS"), ~case_when(
    . == "very unlikely" ~ 1,
    . == "unlikely" ~ 2,
    . == "slightly unlikely" ~ 3,
    . == "neither likely nor unlikely" ~ 4,
    . == "somewhat likely" ~ 5,
    . == "likely" ~ 6,
    . == "very likely" ~ 7,
    TRUE ~ NA_real_
  )))

# Calculate item values for the PIOS
  # Convert character values to the correct numeric values
data.unclean <- data.unclean %>%
  mutate(across(starts_with("PIOS"), ~case_when(
    . == "0, Never" ~ 0,
    . == "1, Almost never" ~ 1,
    . == "2, Sometimes" ~ 2,
    . == "3, Often" ~ 3,
    . == "4, Constantly" ~ 4,
    TRUE ~ NA_real_
  )))

# Calculate item values for the religious social distance items
  # Convert character values to the correct numeric values
data.unclean <- data.unclean %>%
  mutate(across(c(athiest.1:athiest.7, christian.1:christian.7, sikh.1:sikh.7,
                  muslim.1:muslim.7, buddhist.1:buddhist.7, hindu.1:hindu.7,
                  jewish.1:jewish.7, protestant.1:protestant.7, catholic.1:catholic.7),
                ~ case_when(
                  . == "Strongly agree" ~ 1,
                  . == "Agree" ~ 2,
                  . == "Neither agree or disagree" ~ 3,
                  . == "Disagree" ~ 4,
                  . == "Strongly disagree" ~ 5,
                  TRUE ~ NA_real_  # Handles missing or unrecognized values
                )))
  # Scale the numerical values by the rank of the item in the scales
data.unclean <- data.unclean %>%
  mutate(across(matches("^athiest\\.|^christian\\.|^sikh\\.|^muslim\\.|^buddhist\\.|^hindu\\.|^jewish\\.|^protestant\\.|^catholic\\."),
                ~ . * as.numeric(sub("\\D+", "", cur_column())),
                .names = "rs_{.col}")) # Save the new values with rs_ (for rank scale) as a prefix


# Calculate Full Scale Scores ---------------------------------------------

# Calculate religious behavioral intentions scores
  # Calculate the means of the variables for the full scale and the subscales
data.unclean <- data.unclean %>%
  rowwise() %>%
  mutate(
    RBI.DOGS = mean(c_across(DOGS.1:DOGS.6), na.rm = FALSE),  # Mean for DOGS variables
    RBI.IOGS = mean(c_across(IOGS.1:IOGS.7), na.rm = FALSE),  # Mean for IOGS variables
    RBI.F = mean(c_across(c(DOGS.1:DOGS.6, IOGS.1:IOGS.7)), na.rm = FALSE)  # Mean for all DOGS and IOGS variables
  ) %>%
  ungroup()

# Calculate disgust scores
  # Calculate the sums for MD and PD variables
data.unclean <- data.unclean %>%
  rowwise() %>%
  mutate(
    MD = sum(c_across(c("MD.6", "MD.1", "MD.5", "MD.4", "MD.3", "MD.7", "MD.2")), na.rm = FALSE),  # Sum for MD variables
    PD = sum(c_across(c("PD.4", "PD.7", "PD.3", "PD.1", "PD.2", "PD.6", "PD.5")), na.rm = FALSE)   # Sum for PD variables
  ) %>%
  ungroup()

# Calculate Penn inventory of religiosity scores
  # Calculate sums for the full scale and each subscale
data.unclean <- data.unclean %>%
  rowwise() %>%
  mutate(
    PIOS = sum(c_across(PIOS.1:PIOS.15), na.rm = FALSE),  # Sum for the full PIOS scale
    FOG = sum(c_across(c(PIOS.4, PIOS.7, PIOS.10, PIOS.13, PIOS.15)), na.rm = FALSE),  # Sum for Fear of God
    FOS = sum(c_across(c(PIOS.1, PIOS.2, PIOS.3, PIOS.5, PIOS.6, PIOS.8, PIOS.9, PIOS.11, PIOS.12, PIOS.14)), na.rm = FALSE)  # Sum for Fear of Sin
  ) %>%
  ungroup()

# Calculate social distance scores
  # Compute the sum of the scaled items for each religion
data.unclean <- data.unclean %>%
  rowwise() %>%
  mutate(
    SD_athiest = sum(c_across(starts_with("rs_athiest")), na.rm = FALSE),
    SD_christian = sum(c_across(starts_with("rs_christian")), na.rm = FALSE),
    SD_sikh = sum(c_across(starts_with("rs_sikh")), na.rm = FALSE),
    SD_muslim = sum(c_across(starts_with("rs_muslim")), na.rm = FALSE),
    SD_buddhist = sum(c_across(starts_with("rs_buddhist")), na.rm = FALSE),
    SD_hindu = sum(c_across(starts_with("rs_hindu")), na.rm = FALSE),
    SD_jewish = sum(c_across(starts_with("rs_jewish")), na.rm = FALSE),
    SD_protestant = sum(c_across(starts_with("rs_protestant")), na.rm = FALSE),
    SD_catholic = sum(c_across(starts_with("rs_catholic")), na.rm = FALSE)
  ) %>%
  ungroup()


# Returning the Clean Data ------------------------------------------------

# Save the now clean data as data
data <- data.unclean

# Clean up environment except for the clean data
  # Save objects in the environment to object called objects
objects <- ls()
  # Remove all of the objects except for the clean data
rm(list = objects[objects != "data"])
rm(objects)
