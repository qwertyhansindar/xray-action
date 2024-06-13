#!/bin/bash

# Skiping recursive load of script
[ "${LOAD_CI_OUTPUT_FILE}" == "true" ] && echo_debug "CI_OUTPUT is already loaded, skiping ..." >&2 && return 0  || LOAD_CI_OUTPUT_FILE=true

FONT_BLACK='\e[30m'
FONT_RED='\e[31m'
FONT_GREEN='\e[32m'
FONT_YELLOW='\e[33m'
FONT_BLUE='\e[34m'
FONT_PURPLE='\e[35m'
FONT_CYAN='\e[36m'
FONT_WHITE='\e[37m'

FONT_RESET='\e[0m'
FONT_BOLD="\e[1m"
FONT_SHADE="\e[2m"

function send_mesage() {
    local message_color message_type message_text
    message_color="${1}"
    message_type="${2:-UNDEF}"
    message_text="${3}"

    echo -e "${message_color} ${FONT_SHADE}$(date '+%F %T')${FONT_RESET} ${message_color}${FONT_BOLD}[${message_type}]${FONT_RESET} ${message_color}${message_text}${FONT_RESET}"
}

function echo_error() {
    local message
    message="${1}"
    send_mesage "${FONT_RED}" 'ERROR' "${message}"
}

function echo_warn() {
    local message
    message="${1}"
    send_mesage "${FONT_YELLOW}" 'WARN ' "${message}"
}

function echo_info() {
    local message
    message="${1}"
    send_mesage "${FONT_CYAN}" 'INFO ' "${message}"
}

function echo_debug() {
    local message
    message="${1}"
    if [ "${CI_DEBUG}" == 'true' ]; then
        send_mesage "${FONT_BLUE}" 'DEBUG' "${message}"
    fi
}

function echo_success() {
    local message
    message="${1}"
    send_mesage "${FONT_GREEN}" ' OK  ' "${message}"
}

# Cleaning all color symbols from message
function echo_clean_color() {
    local string clean_string
    string="${1}"

    clean_string="$( echo "${string}" | sed -e 's/\x1b\[[0-9;]*m//g' )"

    echo "${clean_string}"
}

# Echo the string with up and under lines with the same size as the message
# Arguments:
#   - str      : String to output
#   - [type]   : Optional, Type of message (debug|info|warn|error|success) by default 'info'
#   - [symbol] : Optional, Symbol for the header by default '-'
# Output:
#     ------------
#     Message Text
#     ------------
function echo_title() {
    local str type str_type_var count_chars print_header
    str="${1}"
    type="${2:-info}"
    symbol="${3:--}"

    if ! [[ "${type}" =~ ^(debug|info|warn|error|success)$ ]]; then
        type="info"
    fi

#   Getting only 1 char from provided string
    symbol="${symbol:0:1}"

    if [ -z "${symbol}" ]; then
        symbol="-"
    fi

#   Getting echo depending on type of string
    str_type_var="echo_${type}"
    str_output="$($str_type_var "${str}")"

#   Cleaning string from colors and counting chars
    clean_str_output="$(echo_clean_color "${str_output}")"
    count_chars="${#clean_str_output}"

#   Creating print_header using = char
    print_header=$(seq -s${symbol} "$((count_chars + 1))" | tr -d '[:digit:]')

#   Printing the string
    echo "${print_header}"
    echo "${str_output}"
    echo "${print_header}"
}

function echo_print_color() {
#     for x in {0..8}; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo ""
    for x in {0..8}; do
        for i in {30..37}; do
            for a in {40..47}; do
                echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
            done;

            echo;
        done;
    done;
    echo ""
}