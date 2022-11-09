# syntax=docker/dockerfile:1
#
# Base Dockerfile for PharmCAT
#
FROM pgkb/pharmcat:latest

# install R
RUN apt install -y r-base
RUN R -e "install.packages('rjson', version = '0.2.20', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('optparse', version = '1.6.6', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tidyverse', version = '1.3.0', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('foreach', version = '1.5.2', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('doParallel', version = '1.0.17', dependencies=TRUE, repos='http://cran.rstudio.com/')"

# clone the tutorial repository for data
RUN git clone https://github.com/PharmGKB/PharmCAT-tutorial.git
RUN mv PharmCAT-tutorial/* ./
# change directory
WORKDIR /pharmcat/
