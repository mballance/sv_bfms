#!/bin/sh

etc_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd)"
SV_BFMS=`cd $etc_dir/.. ; pwd`
export SV_BFMS

# Add a path to the simscripts directory
export PATH=$SV_BFMS/packages/simscripts/bin:$PATH

# Force the PACKAGES_DIR
export PACKAGES_DIR=$SV_BFMS/packages

