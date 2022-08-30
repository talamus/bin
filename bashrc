
function e {
    if [[ "$WSL_DISTRO_NAME" == "" ]]
    then
        xdg-open "$*"
    else
        "explorer.exe" "$*"
    fi
}

function current-git-branch {
    regex="\* ([A-Za-z0-9\-\_/]+)"
    [[ $(git branch 2> /dev/null) =~ $regex ]] && echo "${BASH_REMATCH[1]}"
}

PS1="\[\e[0;37;1m\]"
PS1+="\u@\H ["
    PS1+="\[\e[36m\]"
    PS1+="\w"
    PS1+="\[\e[37m\]"
PS1+="]"
PS1+="\[\e[30m\]\]"
PS1+=" \$(current-git-branch)"
PS1+="\[\e[0m\]"
PS1+="\n\$ "
export PS1
