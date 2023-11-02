Author: Anidu Yakubu Khalid
Title: Covid19 Analysis
Last updated: 2/11/2023

# Objective
Analyze COVID-19 datasets to examine the dynamics of COVID-19 cases, deaths, and vaccinations, with a focus on uncovering patterns and relationships that inform public health responses and strategies. 

# Key Questions
1. Which country record the highest number of cases? 
2. Which country record the highest number of deaths?
3. Which country have the highest amount of Vaccines administered?
4. Which country have the highest rate of cases, deaths and vaccines compare to it population?
5. Which month and year have the highest record of cases and deaths?


# Description of Data
 The analysis follow a pattern of naming data. For instance, the source data is name as: "main_data". And such is the same pattern followed throughout the analysis. For instance "main_data2_death_an_plot", is the plottable data relating to the number of deaths.
The analysis have 3 major sections of, Cases, Deaths and Vaccinations. Each of this sections have sub-sections of Yearly, Monthly, By country, Rates to Population and Continent, except for Vaccinations which only have two sub-section of By Country and Rates to Population.
#### The project seek to analyze the Covid19 pandemic between 2020 (the beginning) and 2023. Some of the guided questions are:


# Interpretations
Charts with purple color represent number of cases.
Charts with red color represent number of death.
Charts with green color reresent number vaccines administered.
Most of the data cleaning and manipulation are done in R script stored with the name "my_covid19_analysis.R". Thereafter, the needed files exported for further analysis in Rmarkdown flexdashboard. 
ggplot2 library was used to create visuals in R script while highcharter library was used to create visuals in the Rmarkdown flexdashboard.



