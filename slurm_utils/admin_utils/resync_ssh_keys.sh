# Syncs the ssh key with newly upgraded ubuntu 20 nodes.
USER="aszot3"

for NODE in "$@"
do
    IP_ADDRESS=$(dig +short $NODE.cc.gatech.edu)
    ssh-keygen -f "/nethome/aszot3/.ssh/known_hosts" -R $NODE.cc.gatech.edu
    ssh-keygen -f "/nethome/aszot3/.ssh/known_hosts" -R $IP_ADDRESS
    ssh-copy-id -i /nethome/aszot3/.ssh/id_rsa.pub -f $USER@$NODE.cc.gatech.edu
done
