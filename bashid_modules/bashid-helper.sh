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
                git commit -m "[BASHID-BUILDER] Adding new content | $(cat /proc/sys/kernel/random/uuid)"
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