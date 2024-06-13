#!/bin/bash

BASH_CI_LIB_DIR="$(dirname "${BASH_SOURCE[0]}")"

chmod +x "${BASH_CI_LIB_DIR}"/*.sh

source "${BASH_CI_LIB_DIR}/CI_OUTPUT.sh"
