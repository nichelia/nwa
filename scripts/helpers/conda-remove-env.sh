#!/usr/bin/env bash

###############################################################################
#
# Remove an already existing conda environment.
#
###############################################################################

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

usage()
{
    echo -e "${bold}${green}$script_name:${no_color}"
    echo "    " "Script to remove a conda environment."
    echo "    " "options:"
    echo "    " "  --help, -h              Show this help message and exit."
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        *)
            >&2 echo "error: '$1' not a recognized argument/option"
            >&2 usage
            exit 1
            ;;
    esac
done

# Get the directory the script is running in
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get conda commands
# shellcheck source=/dev/null
source "${script_dir}/conda-binary.sh"

echo -e "${green}Returning to base conda environment...${no_color}"
# This ensures we deactivate the environment we're deleting if we're using it.
conda activate

# Get the conda environment yml to use
echo -e "${green}Locating conda environment file...${no_color}"
conda_setup_file=$("${script_dir}/conda-get-env.sh")

if [[ ! "${conda_setup_file}" ]]; then
    echo -e "${red}ERROR: No conda environment file found in the current directory."\
    "Please check the \$CONDA_ENVIRONMENT_YML environment variable"\
    " or create an 'environment.yml'."\
    "Exiting.${no_color}"
    exit 1
fi

# Read the conda environment name from the conda environment yml
conda_env_name=$(< "${conda_setup_file}" grep "^name:" --color=never | cut -d " " -f2)

echo -e "${green}Checking for existing \"${conda_env_name}\" conda environment...${no_color}"
if [[ $(conda env list | grep -cw "${conda_env_name}") -eq 0 ]]; then
    echo -e "${green}The \"${conda_env_name}\" conda environment doesn't exist.${no_color}"
else
    echo -e "${green}Removing \"${conda_env_name}\" conda environment...${no_color}"
    conda env remove --name "${conda_env_name}" --yes
fi
