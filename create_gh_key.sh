read -p "Name of GH project: " proj_name

key_path="$HOME/.ssh/ida_rsa_$proj_name"

ssh-keygen -b 2048 -t rsa -f "$key_path"
echo -e "Host $proj_name\n  User git\n  HostName github.com\n  IdentityFile $key_path\n" >> ~/.ssh/config
chmod 600 ~/.ssh/config
cat "$key_path.pub"
