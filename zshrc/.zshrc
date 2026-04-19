# Extra Zsh init managed declaratively via Home Manager:
# programs.zsh.initContent = builtins.readFile ../zshrc/.zshrc;

setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
COMPLETION_WAITING_DOTS="true"

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

export PATH="/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
export NIX_CONF_DIR="$HOME/.config/nix"

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

mkcd() {
  mkdir -p "$1" && cd "$1"
}

cx() {
  cd "$@" && l
}

fcd() {
  cd "$(find . -type d -not -path '*/.*' | fzf)" && l
}

f() {
  echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy
}

fv() {
  nvim "$(find . -type f -not -path '*/.*' | fzf)"
}
