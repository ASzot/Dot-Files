# Put system dependent setup here.
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
