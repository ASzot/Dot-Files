# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# OSX
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="kphoen"

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

if [ -f "$HOME/.dot-files/set_env_vars.sh" ];
then
  source ~/.dot-files/set_env_vars.sh
fi

# Aliases (shortcuts)
alias creategit="sh ~/.dot-files/create_gh_key.sh"
alias py=python
alias nv='nvidia-smi'
alias sfor='ps aux | grep'
alias sa='conda deactivate && conda activate'
alias rs='source ~/.zshrc'
alias ctags='/usr/local/bin/ctags'

# Helper programs
alias clean_latex='rm *.aux; rm *.bbl; rm *.blg; rm *.log; rm *.out; rm *.fdb*; rm *.fls'
alias upme='sh ~/.dot-files/update.sh'
alias cw='tmux kill-window -a'
alias bpush='git ca "Update"'
alias fpush='git pull --no-edit; git ca "Update" ; git po'
alias sshmeta="sshpass -f ~/.devpass ssh meta"

# Project specs
alias mbirlo='python -m rl_utils.launcher --cfg ~/.dot-files/configs/mbirlo.yaml'
alias hab='python -m rl_utils.launcher --cfg ~/.dot-files/configs/habitat.yaml'
alias hr='python -m rl_utils.launcher --cfg ~/.dot-files/configs/hr.yaml'
alias hreval='python -m rl_utils.launcher.eval_sys --cfg ~/.dot-files/configs/hr.yaml'
alias rlt='python -m rl_utils.launcher --cfg ~/.dot-files/configs/rlt.yaml'
alias rlteval='python -m rl_utils.launcher.eval_sys --cfg ~/.dot-files/configs/rlt.yaml'

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

nsync() {
  # Command for remote development. 
  rsync -azP --exclude ".pyc" --exclude "__pycache__" --exclude 'data' --exclude 'wandb' -e "ssh" ./ "$1"
}

# To use this you have to install sshpass: `brew install hudochenkov/sshpass/sshpass`
msyncpass() {
  # Command for remote development. 
  fswatch -o . | while read f; do sshpass -f ~/.devpass rsync -azP --exclude ".pyc" --exclude "__pycache__" --exclude 'data' --exclude 'wandb' -e "ssh" ./ "$1"; done
}

calc() {
  python -c "print($1)"
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
export HOMEBREW_NO_AUTO_UPDATE=1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if [ -f "/Users/andrewszot/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/Users/andrewszot/miniconda3/etc/profile.d/conda.sh"
else
    export PATH="/Users/andrewszot/miniconda3/bin:$PATH"
fi
# <<< conda initialize <<<


# This is needed for homebrew installation on macos silicon
export PATH="/opt/homebrew/bin:$PATH"
export PATH=~/miniconda3/bin:$PATH

if (command -v brew && brew list --formula | grep -c ctags ) > /dev/null 2>&1; then
    alias ctags="$(brew --prefix universal-ctags)/bin/ctags"
fi
export EDITOR=vim

# Activate base conda env
conda activate base

