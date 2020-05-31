#!/usr/bin/env bash

###############################################################################
#
# Create/Update/Activate a conda environment.
# This is based on the conda yaml file
# on project's root directory.
# File specified by CONDA_ENVIRONMENT_YML environment variable or
# defaults to environment.yml/conda_setup.yml
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
    echo "    " "Script to create/update/activate a conda environment."
    echo "    " "options:"
    echo "    " "  --activate, -a          Activate the environment if it exists."
    echo "    " "  --update, -u            Re-use and update the environment if it exists."
    echo "    " "  --help, -h              Show this help message and exit."
}

activate=false
update=false
missing_environment=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -a|--activate)
            activate=true
            shift # past argument
            ;;
        -u|--update)
            update=true
            shift # past argument
            ;;
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

# Get the conda environment yml to use
echo -e "${green}Locating conda environment file...${no_color}"
conda_setup_file=$("${script_dir}/conda-get-env.sh")

if [[ ! ${conda_setup_file} ]]; then
    echo -e "${red}ERROR: No conda environment file found in the current directory."\
    "Please check the \$CONDA_ENVIRONMENT_YML environment variable"\
    " or create an 'environment.yml'."\
    "Exiting.${no_color}"
    exit 1
fi

# Read the conda environment name from the conda environment yml
conda_env_name=$(< "${conda_setup_file}" grep "^name:" --color=never | cut -d " " -f2)

# Read Operating System name
operating_system=$(uname -s)

if [[ ${operating_system} == "Darwin" ]]; then
    extra_conda_file="build-mac.yml"
elif [[ ${operating_system} == "Linux" ]]; then
    extra_conda_file="build-linux.yml"
fi

# Get conda commands
# shellcheck source=/dev/null
source "${script_dir}/conda-binary.sh"

if [[ $(conda env list | grep -cw "${conda_env_name}") -eq 0 ]]; then
    echo -e "${green}No existing \"${conda_env_name}\" conda environment found...${no_color}"
    missing_environment=true
fi

if [[ ${activate} = true ]] && [[ ${missing_environment} = true ]]; then
    exit 1
fi

# Create the environment if we're not in update mode or the environment doesn't exist
if [[ ( ${activate} = false && ${update} = false ) || ( ${missing_environment} = true ) ]]; then
    echo -e "${green}Creating \"${conda_env_name}\" environment...${no_color}"
    if [[ -f "${extra_conda_file}" ]]; then
          echo -e "${green}Creating with ${extra_conda_file} ...${no_color}"
          conda env create -f "${extra_conda_file}" --force
    else
      conda create --name "${conda_env_name}" --yes --force
    fi
    echo -e "${green}Updating \"${conda_env_name}\" environment from ${conda_setup_file}...${no_color}"
    conda env update -f "${conda_setup_file}"
fi
# Update the existing environment
if [[ ${update} = true ]]; then
    if [[ -f "${extra_conda_file}" ]]; then
        echo -e "${green}Updating \"${conda_env_name}\" environment from ${extra_conda_file}...${no_color}"
        conda env update -f ${extra_conda_file}
    fi
    echo -e "${green}Updating \"${conda_env_name}\" environment from ${conda_setup_file}...${no_color}"
    conda env update -f "${conda_setup_file}"
fi

echo -e "${green}Activating \"${conda_env_name}\" conda environment...${no_color}"
conda activate "${conda_env_name}"
