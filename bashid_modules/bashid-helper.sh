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
            git add .
            git status
            
            read -p "Are you sure? " -n 1 -r
            echo

            if [[ $REPLY =~ ^[Yy]$ ]]
            then
                git commit -m "[BASHID-BOT] Adding new content | $(cat /proc/sys/kernel/random/uuid)"
                git push origin bashid-content
            else
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    git status | grep 'new file:' | cut -f2 -d: | sed 's/^ *//' | while read -r files; do
                        git rm --cached $files > /dev/null 2>&1
                    done
                    echo -e "[!] Canceled..."
                fi
            fi
        fi
    fi
}

function ec {
    printf " [${1}] ${2}\n"
}