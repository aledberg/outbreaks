# outbreaks

Data and R-code related to the manuscript _Mortality of the COVID-19 outbreak in Sweden in relation to previous severe disease outbreaks_ [available here](https://www.medrxiv.org/content/10.1101/2020.05.22.20110320v2)

---

## Data sources
The data used in this project originates from two sources. From [Sveriges dödbok](https://www.rotter.se/produkter/cd-dvd-usb/svdb), and [Statistics Sweden](https://www.scb.se). Sveriges dödbok is a genealogical database with information about people who have died in Sweden since 1860 and is released by Sveriges Släktforskarförbund (The Federation of Swedish Genealogical Societies). I am grateful to them for allowing me to use the data. 

---

## The data included 

The data included in this project consists of daily death counts for Sweden from 1860 to the 31st of August 2020. Also included are data on the total population of Sweden for the years 1860 to 2019 (from Statistics Sweden).

---

## How-to process the data


The code is organized in a set of R-scripts as follows:

* main.R:  Contains the code to read data into R and calls a number of other scripts where plotting and tabulation is done

* figure1.R: Generate figure 1 in the manuscript

* figure2.R: Generate figure 2 in the manuscript

* table1.R: Generate the table

These figures use predefined outbreaks (outbreaks.csv). To run the algorithm described in the paper
please run the script detectOutbreaks.R.

**Example:**

To generate the figures and table from the manuscript do the following: 

* clone the repository (git clone https://github.com/aledberg/outbreaks)

* start R in the cloned directory

* at the R prompt execute source("main.R")


