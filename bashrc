
# Use nano as the editor (if available)
export EDITOR=$( which nano )

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

# Output current Git branch name
function current-git-branch {
    regex="\* ([A-Za-z0-9/_-]+)"
    [[ $(git branch 2> /dev/null) =~ $regex ]] && echo "${BASH_REMATCH[1]}"
}

# Output current Terraform workspace name (with color)
function current-terraform-workspace {
    [ -d .terraform ] || return 0
    WORKSPACE="$( terraform workspace show )"
    COLOR=97
    case $WORKSPACE in
        dev | development)
            COLOR=92
            ;;
        stag | staging)
            COLOR=93
            ;;
        prod | production)
            COLOR=31
            ;;
    esac
    echo -e "\e[0;1;${COLOR}m${WORKSPACE}\e[0m"
}

# Say something (in WSL2)
function win-speak {
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "(New-Object -ComObject Sapi.spvoice).speak('$*')" > /dev/null
}

### Fancy color prompt #######################################################

PS1_COLOR="1;97"
PS1_PATH_COLOR="1;96"
PS1_GIT_COLOR="0;2;3;97"
PS1_TIME_COLOR="1;90"

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
PS1+="\u@\H ["                                  # user@host [
    PS1+="\[\e[${PS1_PATH_COLOR}m\]"
    PS1+="\w"                                   # pwd
    PS1+="\[\e[${PS1_COLOR}m\]"
PS1+="]"                                        # ]
PS1+="\[\e[${PS1_GIT_COLOR}m\]"
PS1+=" \$(current-git-branch)"                  # Git branch
if [ $(which terraform) ]; then
    PS1+=" \$(current-terraform-workspace)"     # Terraform workspace
fi
PS1+="\[\e[0m\]"
PS1+="\n"                                       # \n
#PS1+="\[\e[K\]"                                # clear to the end of the line
PS1+="\$ "                                      # $
export PS1

### Command line completion ##################################################

# Hetzner Cloud CLI
[ $(which hcloud) ] && source <(hcloud completion bash)

# One Password CLI
[ $(which op) ] && source <(op completion bash)

# AWS CLI
[ $(which aws_completer) ] && complete -C /usr/local/bin/aws_completer aws

# Terraform
[ $(which terraform) ] && complete -C /usr/bin/terraform terraform

# Node Version Manager
if [ -d "$HOME/.nvm" ]
then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"           # This loads `nvm`
    source "$NVM_DIR/bash_completion"  # This loads `nvm` bash completion
fi

# eof
