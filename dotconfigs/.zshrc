##############################################################
######################### ZSH CONFIG #########################
##############################################################
# @binoy_manoj                   https://github.com/binoymanoj



###################################
############## ZINIT ##############
###################################

# Zinit Plugin Manager Initializing
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# # Previous Method (now it's handled with zinit above)
# # Install and load syntax highlighting
# if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
#     source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#     typeset -A ZSH_HIGHLIGHT_STYLES
#     ZSH_HIGHLIGHT_STYLES[comment]='fg=242'
#     ZSH_HIGHLIGHT_STYLES[alias]='fg=075'
#     ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=075'
#     ZSH_HIGHLIGHT_STYLES[global-alias]='fg=075'
#     ZSH_HIGHLIGHT_STYLES[function]='fg=075'
#     ZSH_HIGHLIGHT_STYLES[command]='fg=075'
#     ZSH_HIGHLIGHT_STYLES[builtin]='fg=075'
#     ZSH_HIGHLIGHT_STYLES[path]='fg=111'
# fi
#
# # Install and load autosuggestions (this provides history-based suggestions)
# if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
#     source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#     # Configure autosuggestion color and strategy
#     ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
#     ZSH_AUTOSUGGEST_STRATEGY=(history completion)
#     ZSH_AUTOSUGGEST_USE_ASYNC=1
#     bindkey '^ ' autosuggest-accept  # Ctrl+Space to accept suggestion
#     bindkey '^f' autosuggest-accept  # Ctrl+f to accept suggestion
# fi


# No Idea what is the following line for, it was there in my config so kept it as it is. maybe useful in future
# ## [Completion]
# ## Completion scripts setup. Remove the following line to uninstall
# [[ -f ~/.dart-cli-completion/zsh-config.zsh ]] && . ~/.dart-cli-completion/zsh-config.zsh || true
# ## [/Completion]


#####################################
############## HISTORY ##############
#####################################

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory          # Append history 
setopt sharehistory           # Share history between all sessions
setopt hist_ignore_space      # Won't save in history when we leave a space before command (helpful for not saving credentials)
setopt hist_ignore_all_dups   # Don't record duplicates
setopt hist_ignore_dups       # Remove older duplicate entries
setopt hist_save_no_dups      # Don't record duplicates
setopt hist_find_no_dups      # No duplicates when searching
setopt hist_expire_dups_first # Expire duplicate entries first
setopt hist_reduce_blanks     # Remove superfluous blanks
setopt hist_verify            # Don't execute immediately upon history expansion
setopt inc_append_history     # Add commands to history as they are typed
setopt extended_history       # Add timestamps to history


# Directory Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# From previous configuration, keeping it just in case
# # History search configuration
# autoload -U history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
#
# # Better history search keybindings
# bindkey '^[[A' history-beginning-search-backward-end    # Up arrow
# bindkey '^[[B' history-beginning-search-forward-end     # Down arrow
# bindkey '^P' history-beginning-search-backward-end      # Ctrl+P
# bindkey '^N' history-beginning-search-forward-end       # Ctrl+N
# bindkey '^R' history-incremental-search-backward        # Ctrl+R for history search
# bindkey '^S' history-incremental-search-forward         # Ctrl+S for forward history search

##############################################
############## AUTO COMPLETIONS ##############
##############################################

# Load auto-completions
autoload -U compinit && compinit

# Advanced completion settings
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' completer _oldlist _expand _complete _match _prefix _history
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:corrections' format ' %F{075}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{075}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{075}-- %d --%f'
zstyle ':completion:*:warnings' format ' %F{075}-- no matches found --%f'
zstyle ':completion:*' format ' %F{075}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

alias ls='ls --color'


######################################
############## VIM MODE ##############
######################################

bindkey -v            # Enables Vim mode
export KEYTIMEOUT=1


#########################################
############## KEYBINDINGS ##############
#########################################

# Keybindings for History
bindkey '^p' history-search-backward    # Search backwards in history using CTRL + p  (eg. curl then CTRL + P)
bindkey '^n' history-search-forward     # Search forwards in history using CTRL + n

# Additional key bindings for better completion
bindkey '^[[Z' reverse-menu-complete  # Shift-Tab to reverse completion menu
bindkey '^I' complete-word            # Tab to complete


############################################
############## SHELL PACKAGES ##############
############################################

# FZF Shell Integration
eval "$(fzf --zsh)"

# ZOXIDE for better cd
eval "$(zoxide init zsh)"

##########################################
############## SHELL CONFIG ##############
##########################################

# Prompt Configuration
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info
precmd() { vcs_info }

# Enhanced Path
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Change cursor shape based on mode
function zle-keymap-select {
  case $KEYMAP in
    vicmd) echo -ne "\e[2 q" ;;  # Block cursor (normal mode)
    viins|main) echo -ne "\e[6 q" ;;  # Line cursor (insert mode)
  esac
}
# Apply cursor changes immediately on shell start
echo -ne "\e[6 q"

zle -N zle-keymap-select

bindkey '^H' backward-kill-word

# Better command line editing
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Aliases with softer colored output
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Load colors
autoload -U colors && colors

# Softer directory colors
export LS_COLORS="di=38;5;111:ln=38;5;075:so=38;5;075:pi=38;5;075:ex=38;5;075:bd=38;5;075:cd=38;5;075:su=38;5;075:sg=38;5;075:tw=38;5;075:ow=38;5;075"

# Configure git info in prompt
zstyle ':vcs_info:git:*' formats '%F{242} (%b)%f'

# SHELL Prompt
setopt PROMPT_SUBST
# PROMPT='%F{075}%n%f%F{242}@%f%F{075}%m%f%F{242}:%f%F{111}%~%f${vcs_info_msg_0_} %F{242}❯%f '    # cyph3r@archlinux:~ ❯
# PROMPT='%F{242}❯%f '      # ❯
#
# ~/Codes
# ❯
PROMPT='%F{183}%~%f${vcs_info_msg_0_}       
%F{211}❯%f '    


####################################
############## CUSTOM ##############
####################################

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PNPM Setup
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# PNPM End

#####################################
############## EXPORTS ##############
#####################################

export EDITOR=nvim

#####################################
############## ALIASES ##############
#####################################

alias cd="z"             # replacing cd with z (zoxide) for jumping to location from history
alias ff="fastfetch"     # ff for fastfetch
alias vi="nvim"          # vi for neovim

# Git Aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git pull'
alias gp='git push'
alias gs='git status'
alias gst='git status -sb'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias greset='git reset'
alias gclean='git clean -fd'



#########################################
############## END OF FILE ##############
#########################################
