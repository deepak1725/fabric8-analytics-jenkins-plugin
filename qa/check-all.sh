#!/bin/bash

# Script to check the sources for all detectable errors and issues


# error counter
errors=0



# check the terminal and set up the colors for terminal
terminal_setup() {
    # try to detect the terminal
    TERM=${TERM:-xterm}

    # set up terminal colors
    NORMAL=$(tput sgr0)
    RED=$(tput bold && tput setaf 1)
    GREEN=$(tput bold && tput setaf 2)
    YELLOW=$(tput bold && tput setaf 3)
    BLUE=$(tput bold && tput setaf 4)
}



# run selected checker or test script
run_checker() {
    local cmd="$1.sh"
    local log="$1.log"
    local err="$1.err"
    # run the checker, redirect all logs and errors
    "./${cmd}" > "${log}" 2> "${err}"
    return $?
}



# check results
check_results() {
    if [ "$1" -eq 0 ]
    then
        printf "    %sOK%s\n" "${GREEN}" "${NORMAL}"
    else
        printf "    %sError%s: " "${RED}" "${NORMAL}"
        printf "please look into files %s%s.log%s and %s%s.err%s for possible causes\n" "${BLUE}" "$2" "${NORMAL}" "${BLUE}" "$2" "${NORMAL}"
        errors=$((errors+1))
    fi
}



# run all checkers
run_all_checkers() {
    printf "%sRunning all tests and checkers%s\n" "${YELLOW}" "${NORMAL}"

    echo "  Check all BASH scripts"
    run_checker check-bashscripts
    check_results $? check-bashscripts

    printf "%sDone%s\n\n" "${YELLOW}" "${NORMAL}"
}



# print out overall results
overall_results() {
    printf "%sOveral result%s\n" "${YELLOW}" "${NORMAL}"

    if [ $errors -eq 0 ]
    then
        printf "  %sOK%s\n" "${GREEN}" "${NORMAL}"
    else
        if [ $errors -eq 1 ]
        then
            printf "  %sOne%s %serror detected!%s\n" "${BLUE}" "${NORMAL}" "${RED}" "${NORMAL}"
        else
            printf "  %s%s%s %serrors detected!%s\n" "${BLUE}" $errors "${NORMAL}" "${RED}" "${NORMAL}"
        fi
    fi
}



terminal_setup

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

pushd "${SCRIPT_DIR}/"
run_all_checkers
overall_results
popd

# 0 - ok
# >0 - some errors has been detected
exit $errors
