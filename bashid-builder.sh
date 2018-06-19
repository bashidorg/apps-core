#!/bin/bash
# BashID Sites Manager

# init
for file in bashid_modules/*; do
    . "bashid_modules/${file##*/}"
done

banner
ec "*" "Checking Requirements..."
xSpin 'checking hugo'
	sleep 1
	which hugo > /dev/null 2>&1
ySpin $?

xSpin 'checking npm'
	sleep 1
	which npm > /dev/null 2>&1
ySpin $?

xSpin 'checking node_modules directory'
	sleep 1
	[[ -d "node_modules" ]] > /dev/null 2>&1

	if [[ ! $? -eq 0 ]]; then
		ySpin 1
		xSpin 'installing from package.json'
		xterm -geometry 96x25+0+0 -title "Installing node modules" -e npm install
	fi
ySpin $?

xSpin 'checking public directory'
    sleep 1
    [[ -z "$(ls -A public)" ]] >> /dev/null 2>&1

    if [[ $? -eq 0 ]]; then
        ySpin 1
        xSpin 'get datas from submodule'
        xterm -geometry 96x25+0+0 -title "Github submodule" -e git submodule update --init --recursive --remote
    fi
ySpin $?

clear

declare -a options=("Create post" "Deploy Sites");
generateDialog "options" "Choose an option" "${options[@]}"
read -p ">> " choice
clear

case $choice in
    1 )
        while [[ $title == '' ]]; do
            read -p ">> title: " title
        done
        
        hugo new "blog/${title}.md"
    ;;
    2 )
        declare -a instructions=("Staging" "Production");
        generateDialog "instructions" "Deploying mode" "${instructions[@]}"
        read -p ">> " mode
        
        if [[ $mode == 1 ]]; then clear
            gulp deploy
            hugo server -w
        fi
        
        if [[ $mode == 2 ]]; then clear
            rm -r public/blog
            
            gulp deploy
            hugo --quiet
            
            cd public
            # deploy github as production
            git add .
            git commit -m "[BASHID-BOT] Deploying sites | $(cat /proc/sys/kernel/random/uuid)"
            git push origin master
            cd ..
        fi
    ;;
esac