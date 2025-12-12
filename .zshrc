# Performance optimizations
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# export PATH="/home/llenharo/miniconda3/bin:$PATH"  # commented out by conda initialize

# Cache completions aggressively
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Theme config - fixed syntax
ZSH_THEME="llenharo"

# Spaceship settings (fixed syntax)
SPACESHIP_PROMPT_ASYNC=true
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CHAR_SYMBOL="⚡"

# Minimal spaceship sections for performance
SPACESHIP_PROMPT_ORDER=(
  time
  user
  dir
  git
  line_sep
  char
)

# Carefully ordered plugins (syntax highlighting must be last)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Autosuggest settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Alias expansion function
globalias() {
   if [[ $LBUFFER =~ '[a-zA-Z0-9]+$' ]]; then
       zle _expand_alias
       zle expand-word
   fi
   zle self-insert
}
zle -N globalias
bindkey " " globalias
bindkey "^[[Z" magic-space
bindkey -M isearch " " magic-space

# Lazy load SSH agent
function _load_ssh_agent() {
    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" > /dev/null
        ssh-add ~/.ssh/id_github_sign_and_auth 2>/dev/null
    fi
}
autoload -U add-zsh-hook
add-zsh-hook precmd _load_ssh_agent

# Path configurations
export VOLTA_HOME="$HOME/.volta"
PATH="$VOLTA_HOME/bin:$PATH:/home/scott/.turso"
export PATH

# Source aliases last
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/llenharo/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/llenharo/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/llenharo/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/llenharo/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Coder (miniconda - base)
export PATH="/home/llenharo/miniconda3/bin:$PATH"

# Alias
alias nv="nvim ."

# JAVA_HOME
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH=$JAVA_HOME/bin:$PATH
