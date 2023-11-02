
library(pacman)
pacman::p_load(dplyr, shiny, rio, httr, tidyr, lubridate, ggplot2, ggvis, GGally,
               pacman, readr, rmarkdown, skimr, stringr, tidyverse, plotly, scales, flexdashboard, highcharter, gt, htmltools,
               viridis)

## importing the datasets



main_data <- read.csv("C:\\Users\\Acer\\Desktop\\courses\\R\\covid19_datasets\\owid-covid-data.csv")


## { the followings are the key questions to answer
## 1. What are the top 10 country's percentage of Deaths to cases reported?
## 2. what are the top 10 countries with highest number of deaths recorded
## 3. what are the top 10 country's highest percentage of tested/vacinated to total cases reported
## 4. Which region or continent have the highest number of reported cases
## 5. which region or continent have the highest number of death cases  }


## WHAT TO LOOK OUT FOR
## 1. Total cases vs Total Death



## navigating and creating an understanding of the data

head(main_data)
dim(main_data)
colnames(main_data)
str(main_data)
summary(main_data)
View(main_data)

## create percentage of cases to death column

## get the total cases grouped by country

main_data2 <- main_data %>%
  select(location, new_cases, new_deaths, date) %>%
  filter(main_data$continent != "" & main_data$new_cases > 0) %>%
  group_by(location, date) %>%
  summarize(Total_cases = sum(new_cases),
            Total_deaths = sum(new_deaths))


View(main_data2)
write.csv(main_data2, "main_data2.csv")

main_data2_an <- read.csv("main_data2.csv", row.names = "X")

View(main_data2_an)
typeof(main_data2_an$date)
class(main_data2_an$date)

## format the date column
md2an_date = as.Date(main_data2_an$date)

md2an_year <- as.numeric(format(md2an_date, "%Y"))
head(md2an_year)


md2an_month <- (format(md2an_date, "%b"))
head(md2an_month)

## let's add the years and the month to our table

main_data2_an <- cbind(main_data2_an, md2an_year, md2an_month)
View(main_data2_an)
main_data2_an <- main_data2_an[ , !duplicated(names(main_data2_an))]


## plot the year with the highest number of cases

plot1 <- ggplot(main_data2_an) +
  geom_col(aes(x=md2an_year, y=Total_cases), fill="purple") +
  labs( title = "Number of cases By Year",
        x = "Years",
        y = "Number of cases") +
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))

plot1

## confirmation of the highest point

main_data2_an %>%
  filter(md2an_year == 2020) %>%
  summarize( sum(Total_cases))
main_data2_an %>%
  filter(md2an_year == 2021) %>%
  summarize( sum(Total_cases))
main_data2_an %>%
  filter(md2an_year == 2022) %>%
  summarize( sum(Total_cases))
main_data2_an %>%
  filter(md2an_year == 2023) %>%
  summarize( sum(Total_cases))

## total
main_data2_an %>%
  summarize( sum(Total_cases))

## plot the month with the highest number of cases

month_order <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
main_data2_an$md2an_month <- factor(md2an_month, levels = month_order)

plot2 <- ggplot(main_data2_an) +
  geom_col(aes(x=md2an_month, y=Total_cases), fill="purple") +
  labs( title = "Number of cases By Month",
        x = "Months",
        y = "Number of cases") +
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))

plot2

## plot the year with the highest number of death

plot3 <- ggplot(main_data2_an) +
  geom_col(aes(x=md2an_year, y=Total_deaths), fill="darkred") +
  labs( title = "Number of deaths By Year",
        x = "Years",
        y = "Number of deaths") +
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))

plot3

## plot the year with the highest number of death

plot4 <- ggplot(main_data2_an) +
  geom_col(aes(x=md2an_month, y=Total_deaths), fill="darkred") +
  labs( title = "Number of deaths By Month",
        x = "Months",
        y = "Number of deaths") +
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))

plot4

## create percentage of cases to population

main_data3 <- main_data %>%
  select(location, population, total_cases, new_cases, date) %>%
  filter(main_data$continent != "" & main_data$new_cases > 0) %>%
  group_by(location) %>%
  summarize(Population = max(population),
            Total_case = max(total_cases),
            percentage = round(max(total_cases)/max(population),2) )  %>%
  arrange(desc(percentage))

View(main_data3)
write.csv(main_data3, "main_data3.csv") 


## percentage of death to population

main_data4 <- main_data %>%
  select(location, population, total_deaths, date) %>%
  filter(main_data$continent != "" & main_data$total_deaths > 0) %>%
  group_by(location) %>%
  summarize(Total_population = max(population, na.rm = T),
            Total_death = max(total_deaths, na.rm = T),
            percentage = round((max(total_deaths, na.rm = T)/max(population, na.rm = T)),4)) %>%
  arrange(desc(percentage))


View(main_data4)
write.csv(main_data4, "covid_main_data4.csv")



## Top 10 countries with highest number of cases and deaths

main_data3_an <- read.csv("main_data3.csv") ## this represent the number of cases per countries
View(main_data3_an)

main_data4_an <- read.csv("covid_main_data4.csv") ## this represent the number of deaths per countries
View(main_data4_an)


md3an_ordering1 <- main_data3_an %>%
  arrange(desc(Total_case))
md4an_ordering1 <- main_data4_an %>%
  arrange(desc(Total_death))

md3an_top10_case <- head(md3an_ordering1, 10)
md4an_top10_case <- head(md4an_ordering1, 10)


## plot the Top 10 countries with highest number of cases
plot5 <- ggplot(md3an_top10_case) +
  geom_col(aes(x=location, y=Total_case), fill="purple") +
  labs(
    title = "Top 10 countries with the Highest number of Cases",
    x= "Country",
    y="Cases"
  ) +
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))
  

plot5

## plot the Top 10 countries with highest number of deaths
plot6 <- ggplot(md4an_top10_case) +
  geom_col(aes(x=location, y=Total_death), fill="darkred") +
  labs(
    title = "Top 10 countries with the Highest number of Deaths",
    x= "Country",
    y="Deaths"
  ) +
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6))


plot6



## Top 10 countries with highest percentage number of cases relative to populations

md3an_ordering2 <- main_data3_an %>%
  arrange(desc(percentage))


md3an_top10_per <- head(md3an_ordering2, 10)

plot7 <- ggplot(md3an_top10_per) +
  geom_col(aes(x=reorder(location, -percentage), y=percentage), fill="purple") +
  labs(
    title = "Top 10 countries Percentage of Cases to Population",
    x= "Country",
    y="Percentage of Cases"
  ) +
  scale_y_continuous(labels = percent_format(scale = 100))


plot7


## Top 10 countries with highest percentage number of cases relative to populations

md4an_ordering2 <- main_data4_an %>%
  arrange(desc(percentage))

md4an_top10_per <- head(md4an_ordering2, 10)

plot8 <- ggplot(md4an_top10_per) +
  geom_col(aes(x=reorder(location, -percentage), y=percentage), fill="darkred") +
  labs(
    title = "Top 10 countries Percentage of Deaths to Population",
    x= "Country",
    y="Percentage of Deaths"
  ) +
  scale_y_continuous(labels = percent_format(scale = 100)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


plot8


par(mfrow=c(4,2))



## CONTINENTAL ANALYSIS

## number of cases by continent

main_data5 <- main_data %>%
  select(continent, location, population, new_cases, new_deaths) %>%
  filter(continent == "" & !str_detect(location, "income") & !str_detect(location, "World") 
         & !str_detect(location, "European Union")) %>%
  group_by(location) %>%
  summarize(Population = max(population),
            Total_case = sum(new_cases),
            Total_death = sum(new_deaths))

View(main_data5)
write.csv(main_data5, "covid_main_data5.csv")

main_data5_an <- read.csv("covid_main_data5.csv", row.names = "X")

main_data5_an

## get rate of cases to population
pop_case_rate_md5an <- main_data5_an[,3]/main_data5_an[,2]
pop_to_case_rate <- pop_case_rate_md5an

## get rate of deaths to population
pop_death_rate_md5an <- main_data5_an[,4]/main_data5_an[,2]
pop_to_death_rate <- pop_death_rate_md5an


## join the rates to the continental table

main_data5_an <- cbind(main_data5_an, pop_to_case_rate, pop_to_death_rate)

main_data5_an

## now it's time to plot graph for the continents

## number of cases

plot9 <- ggplot(main_data5_an) +
  geom_col(aes(x=reorder(location, -Total_case), y=Total_case), fill="purple") +
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6)) +
  labs(
    title = "Number of Cases by Continent",
    x = "Continent",
    y = "Number of Cases")

plot9

## number of deaths

plot10 <- ggplot(main_data5_an) +
  geom_col(aes(x=reorder(location, -Total_death), y=Total_death), fill="darkred") +
  scale_y_continuous(labels = unit_format(unit = "M", scale = 1e-6)) +
  labs(
    title = "Number of Deaths by Continent",
    x = "Continent",
    y = "Number of Deaths")

plot10

## percentage of cases to population
main_data5_an

plot11 <- ggplot(main_data5_an) +
  geom_col(aes(x=reorder(location, -pop_case_rate_md5an), y=pop_case_rate_md5an), fill="purple") +
  scale_y_continuous(labels = percent_format(scale = 100)) +
  labs(
    title = "Rate of Cases to population",
    x = "Continent",
    y = "Rates")

plot11


## percentage of deaths to population
main_data5_an

plot12 <- ggplot(main_data5_an) +
  geom_col(aes(x=reorder(location, -pop_death_rate_md5an), y=pop_death_rate_md5an), fill="darkred") +
  scale_y_continuous(labels = percent_format(scale = 100)) +
  labs(
    title = "Rate of Deaths to population",
    x = "Continent",
    y = "Rates")

plot12


## analysis of the Vaccinations

colnames(main_data)
## creating the vaccination table containing the new cases, new deaths, population, location, dates and new Vaccinations



main_data6 <- main_data %>%
  select(continent, population, location, new_vaccinations, new_cases, new_deaths) %>%
  filter(continent != "") %>%
  group_by(location) %>%
  summarize(Population = max(population),
            Total_vaccinations = sum(new_vaccinations, na.rm = T))



View(main_data6)



## creating the table

write.csv(main_data6, "covid_main_data6.csv")

## importing the table for further anlysis.

main_data6_an <- read.csv("covid_main_data6.csv", row.names = "X")
View(main_data6_an)


## Top 10 countries with the most vaccinations

md6an_top10_vacc <- main_data6_an %>%
  arrange(desc(Total_vaccinations))

md6an_top10_vacc <- head(md6an_top10_vacc, 10)

View(md6an_top10_vacc)


## Rate of population to amount of vaccinations given by Top 10 countries

per_cases_to_vac <- round(main_data6_an$Total_vaccinations/main_data6_an$Population,2)

md6an_vac_cases <- cbind(main_data6_an, per_cases_to_vac) %>%
  arrange(desc(per_cases_to_vac))

md6an_vac_cases <- head(md6an_vac_cases, 10)

View(md6an_vac_cases)


plot13 <- ggplot(md6an_vac_cases) +
  geom_col(aes(x=reorder(location, -per_cases_to_vac), y=per_cases_to_vac), fill="darkgreen") + 
  scale_y_continuous(labels = percent_format(scale = 100)) +
  labs(
    title = "Rate of Vaccines To countries Compare To their Population (Top 10)",
    x = "Countries",
    y = "Rates"
  )

plot13

plot14 <- ggplot(md6an_top10_vacc) +
  geom_col(aes(x=reorder(location, -Total_vaccinations), y=Total_vaccinations), fill="darkgreen") +
  scale_y_continuous(labels = unit_format(unit = "B", scale = 1e-9) ) +
  labs(
    title = "Vaccinations To Countries (Top 10)",
    x = "Countries",
    y = "Vaccines"
  )

plot14

