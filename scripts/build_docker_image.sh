#!/usr/bin/env bash

###############################################################################
#
# Build a docker image.
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

usage()
{
    echo -e "${bold}${green}$script_name:${no_color}"
    echo "    " "Script to build Docker image for python package."
    echo "    " "options:"
    echo "    " "  --test, -t              Build a test image tagged as test/image:latest from current source code."
    echo "    " "  --help, -h              Show this help message and exit."
}

test=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--test)
            test=true
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

if [[ ${test} = true ]]; then
  echo -e "${green}Building python package...${no_color}"
  poetry build
  echo -e "${green}Building test docker image from local python package (test/image:latest)...${no_color}"
  docker build -f ./deployment/docker/test.dockerfile -t test/image:latest .
  echo -e "${green}Cleanup...${no_color}"
  rm -rf -- dist *.egg-info
else
  echo -e "${green}Building docker image from remote python package...${no_color}"
  version="0.0.1"
  version=$(poetry version | sed 's/^.*[^0-9]\([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/')
  docker_image="nichelia/nwa:${version}"
  echo -e "${green}Using version ${version}${no_color}"
  docker build -f ./deployment/docker/prod.dockerfile -t "${docker_image}" --build-arg APP_VERSION="${version}" .
  echo -e "${green}Built image ${docker_image}${no_color}"
fi
