# syntax=docker/dockerfile:1
#
# Base Dockerfile for PharmCAT
#
FROM pgkb/pharmcat:latest

# clone the tutorial repository for data
RUN git clone https://github.com/PharmGKB/PharmCAT-tutorial.git
RUN mv PharmCAT-tutorial/* ./
# change directory
WORKDIR /pharmcat/

# install R
#RUN apt install -y dirmngr gnupg apt-transport-https ca-certificates software-properties-common
RUN apt install -y software-properties-common
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian bullseye-cran40/'
RUN apt update
RUN apt install -y r-base
RUN R -e "install.packages('rjson', version = '0.2.21', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('optparse', version = '1.7.3', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tidyverse', version = '1.3.2', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('foreach', version = '1.5.2', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('doParallel', version = '1.0.17', dependencies=TRUE, repos='http://cran.rstudio.com/')"


# set time zone
ENV TZ="America/Los_Angeles"
