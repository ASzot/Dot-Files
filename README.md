# Computer Dot Files
The goal of these dot files is to provide the optimal computing experience for Mac OS X and Ubuntu. 
These are all of the config files that I use on my development machine. 

# Getting Started
It is important to clone this repo to the right location. It must be in
`.dot-files` in your home directory. 

```
git clone https://github.com/ASzot/Dot-Files.git ~/.dot-files
```

Run `sh update.sh` to install all of the configurations. Reload your bash. Then run `upme` to update the configurations. If you are installing a new system read the mac environment setup or the ubuntu environment setup.

### Scripts:
* `mac_push.sh`
  * Pushes the current settings from the machine into the repository.
* `ubuntu_pull.sh`
  * Pulls the current settings from the GitHub repository and puts them on the
    Ubuntu machine.
    
### Setting Up a Mac Environment
* First thing you have to do is install brew here https://brew.sh/. 
* Install iTerm2 https://www.iterm2.com/
  * Be sure to disable the border
  * Disable all of the settings possible for the tabs and put the tabs at the
    bottom. 
* Download Ubersicht http://tracesof.net/uebersicht/. Use whatever widget you
  want 
  * Good for light themes with padding https://github.com/chris-etheridge/bar.
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


### Vim Usage
There are a couple of things that need to be configured for vim usage. You need
to pip install a couple of things. Activate the Python environment you will be
using for Vim development. Then run `sh vim_setup.sh`.

### Ubuntu Requirements:
First install git and clone this repo to `~/.dot-files`

#### Server (with gpu for deep learning)
Run `sh ubuntu_16_04_server_fresh_part_1.sh` then restart the computer then run `sh ubuntu_16_04_server_fresh_part_2.sh`. You also probably want to set up the default bashrc. `sudo vim /etc/skel/.bashrc` and add `export PATH=/opt/conda/bin:$PATH`.

#### Regular
Run `sh ubuntu_16_04_fresh.sh`

* System:
  * Rebind the caps lock key as another control key `setxkbmap -option caps:ctrl_modifier`
  * Copy the necessary config files `sh ubuntu_pull.sh`
  * Change the path line in ~/.zshrc file to the appropriate home folder.


## Common Usage
Here are some common usages of the plugins and configurations for these dot
files that I often forget. 

* Working with LaTeX files:
  * `:LLPStartPreview` begin live preview of `.tex` file.
* Moving around quickly with vim
  * ctrl-o, ctrl-i to move forward and backward in file history
