# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory notify
unsetopt autocd beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
autoload -Uz promptinit
promptinit
prompt clint

if [ "$TERM" = "rxvt" ] ; then
   export TERM=rxvt-256color 
fi

# OPAM configuration
. /usr/home/allie/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
