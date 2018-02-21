# Create a symlink to this file in the home directory
# ln -s ~/.dotfiles/.bash_profile ~

for file in ~/.dotfiles/.{aliases,prompt,path,env,functions,btc,hue,search,gitcreds}; do
		[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;