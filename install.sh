#!/bin/bash

BLUE=36
RED=31
GREEN=32

function println ()  {
	printf '\e[%sm%s\n' "$2" "$1"
	printf '\e[m'
};


println "Starting installing mandatory librairies" $BLUE

# set up zsh shell environment
if [ -d $HOME/.oh-my-zsh ]; then
  println "OH-MY-ZSH is already installed" $GREEN
else
  println "Installing OH-MY-ZSH..." $GREEN
  git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi
 
println "Starting dotfiles installation" $BLUE
println "Setting up the symbolic links" $GREEN

ln -siv $HOME/dotfiles/.zshrc $HOME
ln -siv $HOME/dotfiles/git/.gitconfig $HOME
ln -siv $HOME/dotfiles/oh-my-zsh $HOME/.oh-my-zsh/custom/

# load gnome-terminal configuration
gconftool-2 --load $HOME/dotfiles/gnome-terminal/conf.xml

