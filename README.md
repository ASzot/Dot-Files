# Computer Dot Files
The goal of these dot files is to provide the optimal computing experience for Mac OS X and Ubuntu. 
These are all of the config files that I use on my development machine. 

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

