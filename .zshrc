# ~/.zshrc: executed by zsh(1) for non-login shells.

# Save history into file
HISTFILE=~/.zsh_history

# For setting history length see HISTSIZE and SAVEHIST in zsh(1)
HISTSIZE=1000
SAVEHIST=2000

# Don't put duplicate lines in the history
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# Setup prompt
setopt PROMPT_SUBST
PROMPT="%B%F{blue}%n%f%b@%B%F{blue}%m%f%b:%F{blue}%c%f$ "
PROMPT2="%F{blue}>%f"

case $TERM in
  xterm*)
    precmd() { print -Pn "\e]0;%n@%m: %~\a" }
    ;;
  rxvt*)
    precmd() { print -Pn "\e]0;%n@%m: %~\a" }
    ;;
esac

#bindkey -v

#bindkey '\e[1~' vi-beginning-of-line
#bindkey '\eOH' vi-beginning-of-line

#bindkey '\e[4~' vi-end-of-line
#bindkey '\eOF' vi-end-of-line

# Create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# Setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is active
#function zle-line-init () {
#  echoti smkx
#}
#function zle-line-finish () {
#  echoti rmkx
#}
#zle -N zle-line-init
#zle -N zle-line-finish

# Ensures that $terminfo values are valid and updates editor information when
# the keymap changes.
function zle-keymap-select zle-line-init zle-line-finish {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( ${+terminfo[smkx]} )); then
    printf '%s' ${terminfo[smkx]}
  fi
  if (( ${+terminfo[rmkx]} )); then
    printf '%s' ${terminfo[rmkx]}
  fi

  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

bindkey -v

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
fi

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  #RPS1='$(vi_mode_prompt_info)'
  RPROMPT='$(vi_mode_prompt_info)'
fi

bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

# Perform cd if the command is the name of directory
setopt AUTO_CD

# Make cd push the old directory onto the directory stack
setopt AUTO_PUSHD

# Tread single word commands as candidate jobs for resumption
setopt AUTO_RESUME

# List jobs in the long format by default
setopt LONG_LIST_JOBS

# Append history rather than replacing it
setopt APPEND_HISTORY

## Both imports commands from history and append typed commands
setopt SHARE_HISTORY

# Treat the '#', '~' and '^' characters as part of patterns for filenames
setopt EXTENDED_GLOB

# Completion
autoload -U compinit
compinit

# Completion of command line switches for aliases
setopt COMPLETE_ALIASES

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Approximate completion
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# No completion for command we do not have
zstyle ':completion:*:functions' ignored-patterns '_*'

# Use colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Provide description
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# Use cache
zstyle ':completion:*' use-cache on

# Tab completion for process identifiers
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Clever rm
zstyle ':completion:*:rm:*' ignore-line yes

# Change dir not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Colors
autoload -U colors
colors

#zmodload -i zsh/complist

# Colored ls
if [ -f ~/.dir_colors ]; then
  eval `dircolors ~/.dir_colors`
fi
#export CLICOLOR=true

# Colored man pages
export LESS_TERMCAP_mb=$'\e[00;31m'
export LESS_TERMCAP_md=$'\e[00;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[00;36m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[00;31m'

# Necessary to make colored man pages work
export GROFF_NO_SGR=1

# Enable massive renaming
autoload -U zmv

# Aliases
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Few more useful aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Alias definitions
# You may want to put all your additions into a separate file like
# ~/.zsh_aliases, instead of adding them here directly.
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# . /etc/profile.d/z.sh
