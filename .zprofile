if [ -f ~/.zshrc ]; then
  source ~/.zshrc
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

export NODE_PATH=/usr/local/share/npm/lib/node_modules
export PATH=$PATH:$HOME/.local/bin:$HOME/.rvm/bin:/usr/local/share/npm/bin
