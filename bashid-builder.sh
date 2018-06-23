#!/bin/bash
# BashID Sites Manager

# init
for file in bashid_modules/*; do
    . "bashid_modules/${file##*/}"
done 

banner
while [ "$1" != "" ]; do
    argv=`echo $1 | awk -F= '{print $1}'`
    val=`echo $2 | sed 's/^[^=]*=//g'`
    case $argv in
        -h | --help)
            echo "help me"
            exit
            ;;
        --create)
            check_pkg
            hugo new "blog/${val// /-}.md" > /dev/null 2>&1
            vi "content/blog/${val// /-}.md"
            ;;
        --deploy)
            check_pkg
            [[ ${val,,} == "staging" || ${val} == 0 ]] && {
                deploy 0
            };

            [[ ${val,,} == "production" || ${val} == 1 ]] && {
                deploy 1
            };
            ;;
        *)
            exit 1
            ;;
    esac
    shift
done

[[ $# -eq 0 ]] && { check_pkg
    declare -a options=("Create post" "Deploy Sites");
    generateDialog "options" "Choose an option" "${options[@]}"
    read -p ">> " choice
    clear
    
    case $choice in
        1 )
            while [[ $title == '' ]]; do
                read -p ">> title: " title
            done
            
            hugo new "blog/${title// /-}.md" > /dev/null 2>&1
            vi "content/blog/${title// /-}.md"
        ;;
        2 )
            declare -a instructions=("Staging" "Production");
            generateDialog "instructions" "Deploying mode" "${instructions[@]}"
            read -p ">> " mode
            
            [[ $mode == 1 ]] && {
                deploy 0
            };

            [[ $mode == 2 ]] && {
                deploy 1
            };
        ;;
    esac
};