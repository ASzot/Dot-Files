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

### Working with Changes
* `push.sh`
  * Pushes the current settings from the machine into the repository.
* `pull.sh`
  * Pulls the current settings from the GitHub repository and puts them on the
    Ubuntu machine.
    
### Setting Up a Mac Environment
* First thing you have to do is install brew here https://brew.sh/. 
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
* `sudo apt-get install ctags` to get better code navigation 

### GitHub Usage
Use password protected ssh keys for better project level security.
* Generate key `ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa_github`
* `cat ~/.ssh/id_rsa_github.pub` Add key to the GitHub project. Be sure to
  check the option for write access as well. 
* `git clone git@github.com:...`


#### Server (with gpu for deep learning)
Run `sh ubuntu_16_04_server_fresh_part_1.sh` then restart the computer then run `sh ubuntu_16_04_server_fresh_part_2.sh`. You also probably want to set up the default bashrc. `sudo vim /etc/skel/.bashrc` and add `export PATH=/opt/conda/bin:$PATH`.

#### Regular
Run `sh ubuntu_16_04_fresh.sh`
