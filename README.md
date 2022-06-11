# Computer Dot Files
Used for Mac OS X and Ubuntu. 

# Getting Started
```
git clone https://github.com/ASzot/Dot-Files.git ~/.dot-files
```

Run `sh update.sh` to install all of the configurations. Reload your zsh. If you are installing a new system read the mac environment setup or the ubuntu environment setup.

For older versions of tmux, copy the old tmux conf file. 

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

## Scripts
* `push.sh`: Pushes the current settings from the machine into the repository.
* `pull.sh`: Pulls the current settings from the GitHub repository and puts them on the Ubuntu machine.
* `create_gh_key.sh`: Script for automatically configuring GitHub keys. 
* `first_pull.sh`: Pulls all settings from repo to local machine and also pulls
  additional files such as SSH config that should only be pulled once as they
  will be overwritten. 


### Setting Up a Mac Environment
* Install 1pass: https://1password.com/downloads/mac/
* Install spectacle: https://www.spectacleapp.com
* Install iterm: https://iterm2.com
* Download drive for desktop: https://www.google.com/drive/download/
* Download slack from app store
* Download this repo `git clone https://github.com/ASzot/Dot-Files.git .dot-files`
* Install brew https://brew.sh/ 
* Install oh-my-zsh `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
* Run installation script: `sh ~/.dot-files/macos_setup.sh`
* Link `me` folder: `ln -s "/Users/andrewszot/My Drive/personal/me" /Users/andrewszot/me`
* Download forklift https://binarynights.com see `me/wiki/guides/code/macos.md` for product key. 
* Turn off system sounds: `System Preferences -> Sound -> Sound Effects`
* Install daily cron job `env EDITOR=nano crontab -e` then `0 9 * * * ~/.dot-files/cron/daily.sh`

### Vim Usage
Then run `sh vim_setup.sh`.

