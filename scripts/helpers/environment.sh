#!/usr/bin/env bash

###############################################################################
#
# Setup project environment (conda and poetry).
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
    echo "    " "Script to setup environment for project (conda and poetry)."
    echo "    " "options:"
    echo "    " "  --force, -f             Force to re-create project environment."
    echo "    " "  --prod, -p              Create project environment for production."
    echo "    " "  --help, -h              Show this help message and exit."
}

force=false
prod=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            force=true
            shift # past argument
            ;;
        -p|--prod)
            prod=true
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

setup_environment()
{
  # shellcheck source=/dev/null
  source "${script_dir}/conda-create-env.sh"
  # shellcheck source=/dev/null
  source "${script_dir}/poetry_setup.sh"

  if [[ ${prod} = true ]]; then
    echo -e "\n${green}Setting up poetry prod dependencies...${no_color}"
    poetry install --no-dev
  else
    echo -e "\n${green}Setting up poetry dependencies...${no_color}"
    poetry install
  fi
}

setup_precommits()
{
  echo -e "\n${green}Setting up pre-commit hooks...${no_color}"
  pre-commit install
}

if [[ ${force} = true ]]; then
  setup_environment
  setup_precommits
  return
fi

# Try and activate conda environment first.
# If fails, then create environment.
# shellcheck source=/dev/null
# shellcheck disable=SC2034
activated_environment=$(source "${script_dir}/conda-create-env.sh" -a >/dev/null 2>&1)
status=$?
if [[ status -ne 0 ]]; then
  setup_environment
  setup_precommits
else
  # shellcheck source=/dev/null
  source "${script_dir}/conda-create-env.sh" -a
fi
