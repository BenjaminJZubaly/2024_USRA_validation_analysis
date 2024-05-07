# Notes on Data Collection and Preparation
## This will review the process of collection and cleaning of our data for this analysis.

### Data Collection
- We collected data from four different sources:
1. Prolific
2. Social Media (Instagram, Facebook, Reddit, etc.)
3. Word of Mouth at Trinity Western University
4. TWU Psychology Research Pool (SONA)
- Each of these sources collected the same data except for the a second round of data collection through the TWU psychology research pool (SONA). For this later round, participants also completed a new measure, a slightly adapted form of Mather et al.’s (2017) Social Distance Scale, designed to assess religious in-group and out-group attitudes.

### Data Cleaning

#### Original Data Cleaning
- All data were originally exported from SurveyMonkey and added to the same dataset to allow for inclusion and exclusion of participants.

#### Participant Inclusion and Exclusion
- There were four inclusion criteria. All other participants were excluded.
	1. Must be self-described as Christian
	2. Must be in a college or university or graduated from a college/university
	3. Must be age 18 or older
	4. Must be fluent in English
- The unclean data for these participants (along with their inclusion/exclusion status) was saved.

#### Data Cleaning After Second SONA Recruitment
- Next, all data from the second round of data collection from the TWU Psychology Research Pool (SONA) were exported and copied and pasted into the unclean data set.
	- These participants were then checked and categorized as included or excluded based on the criteria above.
	- The resulting file was saved in the data folder as `all_validation_data_unclean.csv`.
		- This data is unavailable for viewing (added to .gitignore) because it contains identifying information.
- Next, I removed all identifying information from the `all_validation_data_unclean.csv` file and generated random participant IDs in the `Generated ID` column.
	- The resulting file was saved in the data folder as `all_validation_data_anon.csv`.
- Next, I removed the ineligible participants based on the criteria above.
	- The resulting file was saved in the data folder as `eligible_validation_data.csv`.
- Next, I cleaned up the data a bit to prepare it for further cleaning in R.
	- The following changes were made:
		- The column "Which of these is the highest level of education you have completed? Select all" was collapsed so that only the last response is present.
		- Then, unnecessary columns ("Inclusion Status", "Prolific Approval Status", "Are you fluent in English?", and "SONA Round").
		- Then, the column titles were changed to make them easier to deal with in R, and scale items were labeled with "scalename-itemnumber" format.
		- Then, participants with no data for most of the questions were removed from the data set.
			- These were 2100240420 and 6761379874.
	- The resulting file was saved as `validation_data_ready.csv` in the data folder.
- Next, I wrote the data cleaning script that is in the `code` directory called `data_cleaning.R`. This script will be called at the top of the quarto document to read in the data, clean it, write it to the data folder, and continue with the analysis.

**Reference**
Mather, D. M., Jones, S. W., & Moats, S. (2017). Improving upon Bogardus: Creating a More Sensitive and Dynamic Social Distance Scale. Survey Practice, 10(4). [https://doi.org/10.29115/SP-2017-0026](https://doi.org/10.29115/SP-2017-0026)
