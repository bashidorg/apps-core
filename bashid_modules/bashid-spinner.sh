#!/bin/bash
# Thanks Tasos Latsas

function _spinner() {
    local on_success="OK"
    local on_fail="FAIL"
    local white="\e[1;37m"
    local green="\e[1;32m"
    local red="\e[1;31m"
    local nc="\e[0m"
    
    case $1 in
        start)
            let column=$(tput cols)-${#2}-8
            echo -ne " > ${2}"
            printf "%${column}s"
            
            # start spinner
            i=1
            sp='\|/-'
            delay=${SPINNER_DELAY:-0.15}
            
            while :
            do
                printf "\b${sp:i++%${#sp}:1}"
                sleep $delay
            done
        ;;
        stop)
            if [[ -z ${3} ]]; then
                exit 1
            fi
            
            kill $3 > /dev/null 2>&1
            
            # inform the user uppon success or failure
            echo -en "\b["
            if [[ $2 -eq 0 ]]; then
                echo -en "${green}${on_success}${nc}"
            else
                echo -en "${red}${on_fail}${nc}"
            fi
            echo -e "]"
        ;;
        *)
            echo "invalid argument, try {start/stop}"
            exit 1
        ;;
    esac
}

function xSpin {
    _spinner "start" "${1}" & _sp_pid=$!
    disown
}

function ySpin {
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}