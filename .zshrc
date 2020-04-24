# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# Ubuntu
#export ZSH=/home/andy/.oh-my-zsh
# OSX
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="af-magic"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


git_custom_status() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

bindkey -v
export KEYTIMEOUT=1
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% VIM]% %{$reset_color%}"
    HOST_DISPLAY="$(hostname)"

    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $USER@$HOST_DISPLAY $EPS1"
    zle reset-prompt
}

function haskr() {
  ghc -o output "$1" && ./output
}

zle -N zle-line-init
zle -N zle-keymap-select
bindkey '^k' up-history
bindkey '^j' down-history
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^f' vi-cmd-mode

export PATH=/usr/local/bin:$PATH
export PATH=~/anaconda3/bin:$PATH
export PATH=~/miniconda3/bin:$PATH

if [ -f "$HOME/.dot-files/set_env_vars.sh" ];
then
  source ~/.dot-files/set_env_vars.sh
fi

# Aliases
alias upme='sh ~/.dot-files/update.sh'
alias creategit="sh ~/.dot-files/create_gh_key.sh"
alias gup='~/go/bin/drive push linux'
alias py=python
alias ep='python rlf/exp_mgr/run_exp.py'
alias nv='nvidia-smi'
alias sfor='ps aux | grep'
alias sa='source deactivate && source activate'
alias rs='source ~/.zshrc'
alias cw='tmux kill-window -a'

# Default env
#source activate tor 

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/aszot/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/aszot/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/aszot/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/aszot/google-cloud-sdk/completion.zsh.inc'; fi

systemName=$(uname -s)

# Needed for deepmind control suite.
export MJLIB_PATH=/home/aszot/.mujoco/mujoco200/bin/libmujoco200.so

