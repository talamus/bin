
# Customizing standard bash things:
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
unalias ll 2> /dev/null
unalias la 2> /dev/null
unalias l  2> /dev/null

alias nuke="rm -frI"	# Safer `rm -fr`
alias untar="tar zxvf"  # When you do not remember how to explode a tarball
alias git-tree="git log --oneline --graph --decorate --all"  # Pretty git branch tree
alias ssh-nohostkeycheck="ssh -o StrictHostKeyChecking=no"

# File explorer
function e {
    if [[ "$WSL_DISTRO_NAME" == "" ]]
    then
        xdg-open "$*"
    else
        "explorer.exe" "$*"
    fi
}

# Output current branch name
function current-git-branch {
    regex="\* ([A-Za-z0-9/_-]+)"
    [[ $(git branch 2> /dev/null) =~ $regex ]] && echo "${BASH_REMATCH[1]}"
}

# Say something (in WSL2)
function win-speak {
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "(New-Object -ComObject Sapi.spvoice).speak('$*')" > /dev/null
}

### Fancy color prompt #######################################################


PS1_COLOR="1;37"
PS1_PATH_COLOR="1;96"
PS1_GIT_COLOR="1;30"
PS1_TIME_COLOR="1;30"

case "$HOSTNAME" in
    "nimbus")
        PS1_COLOR="1;35"
        PS1_PATH_COLOR="1;97"
        ;;
    "happy-robot")
        PS1_COLOR="1;34"
        PS1_PATH_COLOR="1;97"
        ;;
    "raspberrypi")
        PS1_COLOR="1;32"
        PS1_PATH_COLOR="1;97"
        ;;
esac

PS1=""
#PS1+="\[\e[0;${PS1_TIME_COLOR}m\r\e[K\e[$((COLUMNS-20))C\$( date +'%F %H:%M:%S' )\r\]" # date and time
PS1+="\[\e[${PS1_COLOR}m\]"
PS1+="\u@\H ["                          # user@host [
    PS1+="\[\e[${PS1_PATH_COLOR}m\]"
    PS1+="\w"                           # pwd
    PS1+="\[\e[${PS1_COLOR}m\]"
PS1+="]"                                # ]
PS1+="\[\e[${PS1_GIT_COLOR}m\]"
PS1+=" \$(current-git-branch)"          # git branch
PS1+="\[\e[0m\]"
PS1+="\n"                               # \n
#PS1+="\[\e[K\]"                        # clear to the end of the line
PS1+="\$ "                              # $
export PS1

# Command line completion for Hetzner CLI
hcloud --help > /dev/null 2>&1 && . <(hcloud completion bash)

# eof
