# Computer Dot Files
The goal of these dot files is to provide the optimal computing experience for Mac OS X and Ubuntu. 
These are all of the config files that I use on my development machine. 

# Getting Started
It is important to clone this repo to the right location. It must be in
`.dot-files` in your home directory. 

```
git clone https://github.com/ASzot/Dot-Files.git ~/.dot-files
```

Step one is to make sure you have everything installed on your computer. If you
are using ubuntu 16.04 you can use the `ubuntu_16_04_fresh.sh` install script
to set up your system. 

### Scripts:
* `mac_push.sh`
  * Pushes the current settings from the machine into the repository.
* `ubuntu_pull.sh`
  * Pulls the current settings from the GitHub repository and puts them on the
    Ubuntu machine.

### macOS Requirements:
* tmux
  * Installation:
    * `brew install tmux`
  * Usage:
    * `tmux` to start tmux session.
    * `tmux ls` to list the active tmux sessions. 
    * `C-a` is the binding key for this tmux setup.
    * `C-a+c` create a window.
    * `C-a+n` next window.
    * `C-a+p` previous window.
    * `C-a+%` split vertical pane.
    * `C-a+"` split horizontal pane.
* kwm
  * Installation:
    * `brew install koekeishiya/formulae/kwm`
* ctags for vim tagbar plugin
  * Installation:
    * `brew install ctags`
### Setting Up a Mac Environment
* First thing you have to do is install brew here https://brew.sh/. 
* Install iTerm2 https://www.iterm2.com/
  * Be sure to disable the border
  * Disable all of the settings possible for the tabs and put the tabs at the
    bottom. 
* Download Ubersicht http://tracesof.net/uebersicht/. Use whatever widget you
  want 
  * Good for light themes with padding https://github.com/chris-etheridge/bar.

### Ubuntu Requirements:
* tmux
  * Installation:
    * `sudo apt-get install tmux`
  * Usage:
    * See macOS instructions. 
* Oh-My-Zsh
  * Installation:
    * Install the Z shell. `sudo apt-get install zsh`
    * `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
    * Set zsh as the default shell `chsh -s `which zsh`
    * Restart computer.
* System:
  * Rebind the caps lock key as another control key `setxkbmap -option caps:ctrl_modifier`
  * Copy the necessary config files `sh ubuntu_pull.sh`
  * Change the path line in ~/.zshrc file to the appropriate home folder.

