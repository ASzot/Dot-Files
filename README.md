# Computer Dot Files
The goal of these dot files is to provide the optimal computing experience for Mac OS X and Ubuntu. 
These are all of the config files that I use on my development machine. 

# Getting Started
It is important to clone this repo to the right location. It must be in
`.dot-files` in your home directory. 

```
git clone https://github.com/ASzot/Dot-Files.git ~/.dot-files
```

Run `sh update.sh` to install all of the configurations. Reload your zsh. If you are installing a new system read the mac environment setup or the ubuntu environment setup.

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
1. Install 1pass: https://1password.com/downloads/mac/
2. Install spectacle: https://www.spectacleapp.com
3. Install iterm: https://iterm2.com
4. Download this repo `git clone https://github.com/ASzot/Dot-Files.git .dot-files`
5. Install brew https://brew.sh/ 
6. Install oh-my-zsh `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
7. Run installation script: `sh ~/.dot-files/macos_setup.sh`
8. Download drive for desktop: https://www.google.com/drive/download/
9. Download slack from app store
10. Link `me` folder: `ln -s "/Users/andrewszot/My Drive/personal/me" /Users/andrewszot/me`
11. Download forklift https://binarynights.com see `me/wiki/guides/code/macos.md` for product key. 
12. Turn off system sounds: `System Preferences -> Sound -> Sound Effects`

### Vim Usage
There are a couple of things that need to be configured for vim usage. You need
to pip install a couple of things. Activate the Python environment you will be
using for Vim development. Then run `sh vim_setup.sh`.

#### Server (with gpu for deep learning)
Run `sh ubuntu_16_04_server_fresh_part_1.sh` then restart the computer then run `sh ubuntu_16_04_server_fresh_part_2.sh`. You also probably want to set up the default bashrc. `sudo vim /etc/skel/.bashrc` and add `export PATH=/opt/conda/bin:$PATH`.

#### Regular
Run `sh ubuntu_16_04_fresh.sh`
