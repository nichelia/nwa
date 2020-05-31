#!/usr/bin/env bash

###############################################################################
#
# Setup poetry for project.
#
###############################################################################

# shellcheck disable=SC2034
script_name="$(basename -- "$0")"

# Colour Formats
# shellcheck disable=SC2034
bold="\033[1m"
# shellcheck disable=SC2034
green="\033[0;32m"
# shellcheck disable=SC2034
red="\033[91m"
# shellcheck disable=SC2034
no_color="\033[0m"

poetry config virtualenvs.create false

echo -e "\n${green}Poetry config:${no_color}"
poetry config --list
