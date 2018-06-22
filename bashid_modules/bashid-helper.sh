banner () {
    echo "H4sIABOvJ1sAA42OsQoCQQxEa/crprs7EFd7G7/B0pO5LQ4VVEQt9+PNJCeKlYEdNpmXIQCt8FXR0MehSKia9x+oaoIqlvJkiqrsTLWpXfWcaN8wmbLWyOAgMarx7F8qslrze893l+/HoHRgFjCn/jl8vzs0213/VJrtsD09xwcu5VoO4x3LxQrt5nw7lg779AJ040U9KQEAAA==" | base64 -d | gunzip
    echo
}

check_pkg () {
    ec "*" "Checking Requirements..."
    showSpin 'checking hugo'
    sleep 1
    which hugo > /dev/null 2>&1
    hideSpin $?

    showSpin 'checking npm'
    sleep 1
    which npm > /dev/null 2>&1
    hideSpin $?
    
    showSpin 'checking node_modules directory'
    sleep 1
    [[ -d "node_modules" ]] > /dev/null 2>&1
    
    if [[ ! $? -eq 0 ]]; then
        hideSpin 1
        showSpin 'installing from package.json'
        xterm -geometry 96x25+0+0 -title "Installing node modules" -e npm install
    fi
    hideSpin $?
    
    showSpin 'checking public directory'
    sleep 1
    [[ -z "$(ls -A public)" ]] >> /dev/null 2>&1
    
    if [[ $? -eq 0 ]]; then
        hideSpin 1
        showSpin 'get datas from submodule'
        xterm -geometry 96x25+0+0 -title "Github submodule" -e git submodule update --init --recursive --remote
    fi
    hideSpin $?

    clear # clear console after checking all pkg
}

function deploy {
	if [[ $1 == 0 ]]; then
		gulp deploy
        # xdg-open "http://localhost:1313" && hugo server -w // crash at google-chrome
        hugo server -w
    else 
    	if [[ $1 == 1 ]]; then
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
	fi
}

function ec {
    printf " [${1}] ${2}\n"
}