setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# refresh completion after installing package
zstyle ':completion:*' rehash true

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

bindkey -s '^o' '^ucd "$(dirname "$(fzf)")"\n'

# replace history search with fzf
fzf_history_search() {
  ret=$(eval fc -l -1 0 | awk '{ a=$0; gsub("^\\s*[0-9]+\\s*", ""); if (!x[$0]++) print a }' | fzf +s +m -x -e | sed 's/^\s*//g' | cut -d' ' -f1)
  zle vi-fetch-history -n "$ret"
  zle reset-prompt
}
zle -N fzf_history_search
bindkey -v '^r' fzf_history_search

# vi mode
source $HOME/.config/zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh 2>/dev/null

# Load syntax highlighting; should be last.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null

eval "$(starship init zsh)"
