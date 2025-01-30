# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first
setopt HIST_IGNORE_DUPS       # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries
setopt HIST_FIND_NO_DUPS      # No duplicates when searching
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt HIST_VERIFY            # Don't execute immediately upon history expansion
setopt HIST_IGNORE_SPACE      # Don't record entries starting with a space
setopt INC_APPEND_HISTORY     # Add commands to history as they are typed
setopt EXTENDED_HISTORY       # Add timestamps to history

# Enhanced Completion System
autoload -Uz compinit && compinit
zmodload zsh/complist

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

# History search configuration
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Better history search keybindings
bindkey '^[[A' history-beginning-search-backward-end    # Up arrow
bindkey '^[[B' history-beginning-search-forward-end     # Down arrow
bindkey '^P' history-beginning-search-backward-end      # Ctrl+P
bindkey '^N' history-beginning-search-forward-end       # Ctrl+N
bindkey '^R' history-incremental-search-backward        # Ctrl+R for history search
bindkey '^S' history-incremental-search-forward         # Ctrl+S for forward history search

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Additional key bindings for better completion
bindkey '^[[Z' reverse-menu-complete  # Shift-Tab to reverse completion menu
bindkey '^I' complete-word            # Tab to complete

# Prompt Configuration
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info
precmd() { vcs_info }

# Configure git info in prompt
zstyle ':vcs_info:git:*' formats '%F{242} (%b)%f'

# Create an attractive prompt with softer colors
setopt PROMPT_SUBST
PROMPT='%F{075}%n%f%F{242}@%f%F{075}%m%f%F{242}:%f%F{111}%~%f${vcs_info_msg_0_} %F{242}❯%f '

# Directory Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Aliases with softer colored output
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Softer directory colors
export LS_COLORS="di=38;5;111:ln=38;5;075:so=38;5;075:pi=38;5;075:ex=38;5;075:bd=38;5;075:cd=38;5;075:su=38;5;075:sg=38;5;075:tw=38;5;075:ow=38;5;075"

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Enhanced Path
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Load colors
autoload -U colors && colors

# Better command line editing
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Install and load syntax highlighting
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[comment]='fg=242'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=075'
    ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=075'
    ZSH_HIGHLIGHT_STYLES[global-alias]='fg=075'
    ZSH_HIGHLIGHT_STYLES[function]='fg=075'
    ZSH_HIGHLIGHT_STYLES[command]='fg=075'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=075'
    ZSH_HIGHLIGHT_STYLES[path]='fg=111'
fi

# Install and load autosuggestions (this provides history-based suggestions)
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # Configure autosuggestion color and strategy
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    bindkey '^ ' autosuggest-accept  # Ctrl+Space to accept suggestion
    bindkey '^f' autosuggest-accept  # Ctrl+f to accept suggestion
fi

# pnpm
export PNPM_HOME="/home/binoy/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(zoxide init zsh)"
alias cd="z"

alias ff="fastfetch"

alias vi="nvim"
source /usr/share/nvm/init-nvm.sh
