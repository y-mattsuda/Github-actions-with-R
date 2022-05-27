#!/bin/bash
# setup package
poetry install
R -q -e "if (!require('renv')) install.packages('renv')"
R -q -e "library(renv)"
R -q -e "renv::restore()"

# run R code
Rscript R/run_ts_analysis.r

# run Python code
poetry run python slack/file_sender.py Output/result1.png

# remove image in Output/
rm Output/result1.png
