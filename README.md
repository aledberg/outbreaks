# outbreaks

Data and R-code related to the manuscript _Mortality of the COVID-19 outbreak in Sweden in relation to previous severe disease outbreaks_[available here](https://www.medrxiv.org/content/10.1101/2020.05.22.20110320v2)

---

## Data source
The data used in this project originates from two sources. From [Sveriges dödbok](https://www.rotter.se/produkter/cd-dvd-usb/svdb), and [Statistics Sweden](www.scb.se). Sveriges dödbok is a genealogical database with information about people who have died in Sweden since 1860 and is released by Sveriges Släktforskarförbund (The Federation of Swedish Genealogical Societies). I am grateful to them for allowing me to use the data. 

---

## The data included here

The data included in this project consists of daily death counts for Sweden from 1860 to the 31st of August 2020.

---

## How-to process the data


The code is organized in a set of R-scripts as follows:

* main.R:  Contains the code to read data into R and calls a number of other scripts where estimation and plotting are done

* estimateRates.R: Code to estimate hazard rates for all the cohorts

* figure1.R: Generate figure 1 in the manuscript

* figure2.R: Generate figure 2 in the manuscript

* figure3.R: Generate figure 3 in the manuscript

* figure4.R: Generate figure 4 in the manuscript


**Example:**

To generate the figures do the following: 

* clone the repository (git clone https://github.com/aledberg/seasons)

* start R in the cloned directory

* at the R prompt execute source("main.R")


