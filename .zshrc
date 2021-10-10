# Max Masterton's Config for the Z Shell
#         _     
# _______| |__  
#|_  / __| '_ \ 
# / /\__ \ | | |
#/___|___/_| |_|              

# load configs
for config (~/zsh/*.zsh) source $config
export PATH=$PATH:/home/maxm/bin:/home/maxm/.local/bin
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
