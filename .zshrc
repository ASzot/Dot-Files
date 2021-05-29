# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
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

git_custom_status() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

bindkey -v

# Easy command for compiling and running Haskell programs 
function haskr() {
  ghc -o output "$1" && ./output
}

# Some better shortcuts inzsh
#zle -N zle-line-init
#zle -N zle-keymap-select
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^f' vi-cmd-mode
bindkey "^E" edit-command-line

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
alias py=python
alias nv='nvidia-smi'
alias sfor='ps aux | grep'
alias sa='source deactivate && source activate'
alias rs='source ~/.zshrc'
alias cw='tmux kill-window -a'
alias ctags='/usr/local/bin/ctags'
alias bpush='git ca "Update"'

msync() {
  # Command for remote development. 
  fswatch -o . | while read f; do rsync -azP --exclude ".*/" --exclude ".*" --exclude ".pyc" --exclude "__pycache__" --exclude 'data' --exclude 'wandb' -e "ssh" ./* "$1" ; done
}

# Default env
#source activate tor 
systemName=$(uname -s)


# Needed for deepmind control suite.
export MJLIB_PATH=/home/aszot/.mujoco/mujoco200/bin/libmujoco200.so


# Replace this with the HOME dir in the future so it is agnostic to the computer? 
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/andrewszot/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/andrewszot/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/andrewszot/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/andrewszot/google-cloud-sdk/completion.zsh.inc'; fi

# For golang
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# Terminal settings (needed to have the terminal work sometimes)
export TERM=xterm
export LC_ALL=en_US.UTF-8

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
