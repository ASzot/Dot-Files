# Computer Dot Files
Configuration files.

## Getting Started
```
git clone https://github.com/ASzot/Dot-Files.git ~/.dot-files
```

## Commands
Shortcuts are defined in `.zshrc`. They are listed here: 
* `creategit`: Create a GitHub deploy key. Note that when cloning you specify
  the project name as the host instead of git@github.com. So if you named the
  public key `myproj` and the project was at github.com/aszot/project, notice
  they don't have to match, you would clone with `git clone myproj:aszot/project.git`.
* `upme`: Fetch settings from github and apply them. 
* `sa`: Switch to the specified conda environment. 
* `rs`: Reload zshrc.
* `py`: Alias for `python`. 
* `cw`: Kill all tmux windows except for the current one. 
* `nv`: Alias for `nvidia-smi`
* `sfor`: Alias for `ps aux | grep` to search for a process. 

## Additonal Config
`./set_env_vars.sh` for system dependent settings. To setup auto conda activate, add this:
```
cd () { builtin cd "$@" && chpwd; }
chpwd () {
  case $PWD in
    /Users/andrewszot/Documents/code/habitat-lab)
      conda activate hablab
      ;;
    /Users/andrewszot/Documents/code/p-hr)
      conda activate hr
      ;;
  esac
}
```

## Scripts
* `push.sh`: Pushes the current settings from the machine into the repository.
* `pull.sh`: Pulls the current settings from the GitHub repository and puts them on the Ubuntu machine.
* `create_gh_key.sh`: Script for automatically configuring GitHub keys. 
* `first_pull.sh`: Pulls all settings from repo to local machine and also pulls additional files such as SSH config that should only be pulled once as they will be overwritten. 

### First Install
- `cd` into this directory.
- Run `sh first_pull.sh`.
- Start neovim. 
- `:PlugInstall`. Quit and run this again if you get an error about one of the plugins installing.


### Vim Usage
Then run `sh vim_setup.sh`.

