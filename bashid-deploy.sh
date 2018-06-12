#!/bin/bash

function echo_fail {
  printf "${1} \e[31m✘"
  printf "\033\e[0m\n"
}

function echo_pass {
  printf "${1} \e[32m✔"
  printf "\033\e[0m\n"
}

clear
	# which hugo > /dev/null 2>&1
	# if [[ "$?" -eq "0" ]]; then
	# 	echo_pass "Hugo" echo ""
	# else 
	# 	echo $(echo_fail "-> Hugo")
	# fi

	# which gulp > /dev/null 2>&1
	# if [[ "$?" -eq "0" ]]; then
	# 	echo_pass "Gulp"
	# else
	# 	npm install
	# fi

	# sleep 0.5
	# clear

	source deploy_modules/configure-menu.sh
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