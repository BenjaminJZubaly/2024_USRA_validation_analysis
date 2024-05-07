
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

# Drop data_retention_consent
data.unclean <- data.unclean %>% select(-data_retention_consent)
