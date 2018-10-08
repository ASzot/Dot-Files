# NVIDIA DRIVERS NEED TO BE INSTALLED AND COMPUTER REBOOTED
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt-get update
sudo apt-get install -y cuda

# Settings related setup
sudo apt-get install tmux
sudo apt-get install zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sh ~/.dot-files/update.sh


# Add proper paths 
cat <<EOF >> ~/.dot-files/set_env_vars.sh
export CUDA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=\${CUDA_HOME}/lib64
export PATH=\${CUDA_HOME}/bin:\${PATH}
EOF

cd /tmp
tar xvzf cudnn-9.0-linux-x64-v7.3.1.20.tgz
sudo cp -P cuda/include/cudnn.h $CUDA_HOME/include
sudo cp -P cuda/lib64/libcudnn* $CUDA_HOME/lib64
sudo chmod u+w $CUDA_HOME/include/cudnn.h
sudo chmod a+r $CUDA_HOME/lib64/libcudnn*

sudo apt-get install -y libcupti-dev
sudo apt-get install -y ffmpeg

# Install conda now 
sudo chmod -R 777 /opt/

# Specify /opt/conda in the installation.
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
cat <<EOF >> ~/.dot-files/set_env_vars.sh
export PATH=/opt/conda/bin:$PATH
EOF

source ~/.zshrc

