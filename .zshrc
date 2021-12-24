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
alias fbt="tmux new -s ssh_local 'ssh -L 4004:localhost:22 devfair'"
alias fbtssh="sshpass -f ~/.devpass ssh dflocal"

compile_tex() {
  pdflatex $1.tex
  bibtex $1.aux
  pdflatex $1.tex
  pdflatex $1.tex
}

msync() {
  # Command for remote development. 
  fswatch -o . | while read f; do rsync -azP --exclude ".pyc" --exclude "__pycache__" --exclude 'data' --exclude 'wandb' -e "ssh" ./ "$1"; done
}

# To use this you have to install sshpass: brew install hudochenkov/sshpass/sshpass
msyncpass() {
  # Command for remote development. 
  fswatch -o . | while read f; do sshpass -f ~/.devpass rsync -azP --exclude ".pyc" --exclude "__pycache__" --exclude 'data' --exclude 'wandb' -e "ssh" ./ "$1"; done
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
export HABLAB_INSTALL_PATH=/Users/andrewszot/Documents/release-hab-lab

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/andrewszot/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/andrewszot/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/andrewszot/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/andrewszot/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

