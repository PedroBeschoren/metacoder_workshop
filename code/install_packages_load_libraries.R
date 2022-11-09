
# If these packages are missing, install them
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

if (!require("devtools", quietly = TRUE))
  install.packages("devtools")

if (!require("phyloseq", quietly = TRUE))
  BiocManager::install("phyloseq")

if (!require("metacoder", quietly = TRUE))
  install.packages("metacoder")

if (!require("dplyr", quietly = TRUE))
  install.packages("dplyr")

if (!require("tidyverse", quietly = TRUE))
  install.packages("tidyverse")

if (!require("tibble", quietly = TRUE))
  install.packages("tibble")

library(devtools) # you need this package to isntall the next package
if (!require("metagMisc", quietly = TRUE))
  devtools::install_github("vmikk/metagMisc",quiet = TRUE)

if (!require("purrr", quietly = TRUE))
  install.packages("purrr")




#load libraries
library(metacoder) # base package we will work with
library(phyloseq) # essential data container
library(metagMisc) # turns ps objects into lists of ps objects
library(purrr) # has map() to extract values from lists
library(dplyr)
library(tibble)
library(tidyverse)





