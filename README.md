#Computer Dot Files
The goal of these dot files is to provide the optimal computing experience for Mac OS X and Ubuntu. 

macOS Requirements:
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

Ubuntu Requirements:
* System:
  * Rebind the caps lock key as another control key `setxkbmap -option caps:ctrl_modifier`
  * Copy the necessary config files `sh ubuntu_pull.sh`