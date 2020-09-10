# NO to installing GPU drivers
# /home/aszot for where to install 
#wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux ~/
#chmod +x cuda_10.0.130_410.48_linux
#./cuda_10.0.130_410.48_linux
#touch ~/.dot-files/set_env_vars.sh
echo "export PATH=$HOME/cuda10/bin:$PATH" >> ~/.dot-files/set_env_vars.sh
echo "export LD_LIBRARY_PATH=$HOME/cuda10/lib:$LD_LIBRARY_PATH" >> ~/.dot-files/set_env_vars.sh
echo "export LD_LIBRARY_PATH=$HOME/cuda10/lib64:$LD_LIBRARY_PATH" >> ~/.dot-files/set_env_vars.sh
echo "export CUDA_PATH=$HOME/cuda10" >> ~/.dot-files/set_env_vars.sh
echo "export CUDA_ROOT=$HOME/cuda10" >> ~/.dot-files/set_env_vars.sh
echo "export CUDA_HOME=$HOME/cuda10" >> ~/.dot-files/set_env_vars.sh
