## Metacoder package workshop by Pedro Beschoren da Costa

In this workshop, we will learn how to use the metacoder R package. This workshop was designed for *R version 4.1.2*

## Requirements

* R version 4.1.2 or above
* R studio from 2020 or above. you likely won't have any problems with R studio versions.  v0.98.932 was one of the first R studio versions to handle markdown documents in 2014... I've used R studio version 2022.07.2 to prepare the workshop
* Download files for the workshop
* install packages by running code chunk # 1.0 - install packages, load libraries

## Download files for the workshop

### option 1: download from GitHub page with a browser
* click on the green bottom "Code" on the top right portion of the page
* select download ZIP from the dropdown menu
* unzip the files
* execute the R.project file to start an R project session that is ready for the workshop

### option 2: clone the repository from GitHub with R studio

* on an open R studio session, click: File-> new project -> version control -> Git
* now fill
    * repository ULR: https://github.com/PedroBeschoren/metacoder_workshop"
    * Project directory name: metacoder_workshop"
    * Create project as a subdirectory of (the folder in your computer where the folder metacoder_workshop will be created)


## setup and package installation

To install all packages for this workshop, run chunk # 1.0 - "install packages, load libraries". It will check if you have the requested packages, and if you don't, they will be installed. it also loads all the libraries we will need for this project
This step can take some minutes. please install packages ahead of time​
Are you curious about the code being sourced from another R script? keep "install_packages_load_libraries.R" selected with your cursor and press F2!

## running code chunks

Bite-sized code chunks will make your script more understandable. even if you don't share, future you will be happy to see small pieces of code instead of huge and complex functions all at once To run a code chunk, you may:
*click the green triangle on the top right of each chunk ("run current chunk")
*select the code with the mouse and execute it (ctrl+enter)
*leave the cursor on the line you want to execute and just execute line by line (ctrl+enter)

## Code outline

The code outline was designed to help to navigate the script during the workshop. To open it, Click on the outline bottom in your R studio, or just press Ctrl+Shift+O

## Workshop (tentative) Schedule

- Welcome and presentation (10 min)
- create a single heat tree (5 min)
- compare two groups of samples (5 min)
- compare 3 or more groups of samples (5 min)
- create heat trees from a custom function (10 min)
- run custom function over a list of phyloseq objects (5 min)
- add external data to heat trees (10 min)
- add results of a fisher test to the heat trees (10 min)

### More resources

There are many resources for the metacoder package

Documentation (with examples): https://grunwaldlab.github.io/metacoder_documentation/​
Original paper: https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005404​
GitHub: https://github.com/grunwaldlab/metacoder​
CRAN manual: https://cran.r-project.org/web/packages/metacoder/metacoder.pdf​
Youtube (kind of old): https://www.youtube.com/watch?v=Nv6dsWjr5sA