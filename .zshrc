if [[ -a $HOME/.zshrc ]]; then
    NOT_TRANSITIVE=true
    if ((! $+SKIP_HOME_ZSH_TEST)); then
        export SKIP_HOME_ZSH_TEST=true
        . $HOME/.zshrc
    fi
fi

if (($+RC_RUN)); then
    return
fi
RC_RUN=yes

autoload -U colors
colors

DISPLAYED_COLOURS=(green cyan yellow blue red magenta)

if [[ -a "$HOME/.host" ]]; then

    COMPUTER=`cat $HOME/.host`

    if [[ $COMPUTER = 'desktop' ]]; then
        HOST_COLOUR=blue
    fi

    if [[ $COMPUTER = 'laptop' ]]; then
        HOST_COLOUR=magenta
    fi

    PS1="%{$fg_no_bold[$HOST_COLOUR]%}[%{$fg_bold[$HOST_COLOUR]%}%*%{$fg_no_bold[$HOST_COLOUR]%}] %{$fg_no_bold[green]%}%4~ %{$reset_color%} "

    PATH="$HOME/bin/local:$HOME/bin:$PATH"

    export R_HISTFILE=$HOME/.r_history

else
    if (($+NOT_TRANSITIVE)); then
        DATE_COLOUR=cyan
    else
        DATE_COLOUR=red
    fi

    HOST_COLOUR=$DISPLAYED_COLOURS[$(($(hostname | cksum | cut -c1-3) % $#DISPLAYED_COLOURS + 1))]
    PS1="%{$fg_no_bold[$DATE_COLOUR]%}[%{$fg_bold[$HOST_COLOUR]%}%2m %{$fg_no_bold[$DATE_COLOUR]%}%*] %{$fg_no_bold[green]%}%4~ %{$reset_color%} "

    PATH="$HOME/bin/remote:$HOME/bin:$PATH"
fi

unset HOST_COLOUR COMPUTER DISPLAYED_COLOURS SKIP_HOME_ZSH_TEST DATE_COLOUR

if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

HISTFILE=~/.history

SAVEHIST=10000
HISTSIZE=10000

autoload -U compinit
compinit

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY

setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS


setopt AUTO_CD

setopt ZLE

setopt NO_FLOW_CONTROL


setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
setopt GLOB_COMPLETE
setopt EXTENDED_GLOB


bindkey '^[[Z' undo
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# Meta-u to chdir to the parent directory
bindkey -s '\eu' '^Ucd ..; ls^M'

# Pipe the current command through less
bindkey -s "\el" " 2>&1|less^M"

export EDITOR="vim"

insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo


alias -g ...='../..'
setopt autopushd


bindkey "^[[1~" beginning-of-line
bindkey "^[[3~" delete-char
bindkey "^[[4~" end-of-line
