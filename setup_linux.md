## Setup tips
These are some setup tips that should be general for all distros.
- Install ctags with whatever package manager you are using. 

Personal tips and tricks for running Openbox + Manjaro

- xbacklight controls the backlight properties. `xbacklight +10` will increase
  the screen brightness. 
- `~/.config/openbox/rc.xml` contains all the keybind settings for openbox
- `polybar -r` will watch changes `~/.config/polybar/config`. 
- `openbox --reconfigure` refreshes openbox for new keybindings
- `openbox --restart` restarts all of openbox, probably just use this instead
  of reconfigure...
