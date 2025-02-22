#!/usr/bin/env bash
VERSION='1.0.1'
RELEASE_DATE='4 Jul 2022'
EPACE='        '

echow(){
    FLAG=${1}
    shift
    echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"
}

help_message(){
    echo -e "\033[1mOPTIONS\033[0m"
    echow '[-V, --version]'
    echo "${EPACE}${EPACE}Example: version.sh -V, to check latest version."
    echow '-H, --help'
    echo "${EPACE}${EPACE}Display help and exit."
    exit 0
}

check_input(){
    if [ -z "${1}" ]; then
        help_message
        exit 1
    fi
}

check_version() {
    echo "Dhanabhon Server Docker Version ${VERSION}, ${RELEASE_DATE}"
}

check_input ${1}
while [ ! -z "${1}" ]; do
    case ${1} in
        -[hH] | -help | --help)
            help_message
            ;;
        -[vV] | -version | --version)
            check_version
            ;;            
        *)
            check_version
            ;;
    esac
    shift
done