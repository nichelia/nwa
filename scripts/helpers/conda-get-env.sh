#!/usr/bin/env bash

###############################################################################
#
# Locate conda environment file for the project.
# Order:
#  1. Environment variable $CONDA_ENVIRONMENT_YML
#  2. File: environment.yml
#  3. File: conda_setup.yml
#
###############################################################################

if [[ $CONDA_ENVIRONMENT_YML ]]; then
    conda_setup_file=$CONDA_ENVIRONMENT_YML
elif [[  -f "environment.yml" ]]; then
    conda_setup_file="environment.yml"
elif [[  -f "conda_setup.yml" ]]; then
    conda_setup_file="conda_setup.yml"
fi

echo ${conda_setup_file}
