{ config, pkgs, ... }:
{
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.ripgrep
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    initContent = ''
      export ZSH = "${pkgs.oh-my-zsh}/share/oh-my-zsh"
      export PATH = "/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
      export LANG="en_US.UTF-8"
      export EDITOR="nvim"
      export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow"
      export NIX_CONF_DIR="$HOME/.config/nix"

      setopt prompt_subst
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':omz:update' mode auto
      zstyle ':omz:update' frequency 13
      COMPLETION_WAITING_DOTS="true"

      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

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

    '';
    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      custom = "${config.home.homeDirectory}/.oh-my-zsh-custom";
      theme = "powerlevel10k/powerlevel10k";
      plugins = [
        "git"
        "zoxide"
        "xcode"
        "vscode"
        "qrcode"
        "python"
        "pip"
        "npm"
        "node"
        "macos"
        "fzf"
        "eza"
        "docker"
        "command-not-found"
        "bun"
        "brew"
        "aliases"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "you-should-use"
        "zsh-bat"
      ];
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" ];
    };

    plugins = [
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
      }
    ];

    shellAliases = {
      ls = "eza";
      cat = "bat";
      gc = "git commit -m";
      ga = "git add";
      gp = "git push";
      gst = "git status";
      gco = "git checkout";
      edit = "nvim ~/.zshrc";
      reload = "exec zsh";
      cls = "clear";
      n = "nvim";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user = {
        name = "Prakhar Singh";
        email = "shaansinghd1209@gmail.com";
      };

      alias = {
        la = "log --all --graph --pretty=format:'%C(auto)%h%d %s %C(bold black)(%ar by <%aN>)%Creset'";
        law = "log --all --graph --pretty=format:'%C(auto)%h%d %w(100,0,8)%s %C(bold black)(%ar by <%aN>)%Creset'";
        lad = "log --all --graph --pretty=format:'%Cgreen%ad%Creset %C(auto)%h%d %s %C(bold black)<%aN>%Creset' --date=format-local:'%Y-%m-%d %H:%M (%a)'";
      };

      init.defaultBranch = "main";

      filter."lfs" = {
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
        clean = "git-lfs clean -- %f";
      };
    };
  };

  programs.ghostty = {
    enable = true;
    # Set package to null since you're managing the binary via Homebrew
    package = null; 

    settings = {
      "shell-integration" = "zsh";
      "theme" = "GitHub Dark";
      "background" = "#101216";
      "foreground" = "#8b949e";
      "selection-background" = "#3b5070";
      "selection-foreground" = "#ffffff";
      "cursor-color" = "#c9d1d9";
      "cursor-text" = "#101216";
      "cursor-style" = "block_hollow";
      
      # Palette needs to be a list for duplicate keys
      "palette" = [
        "0=#000000" "1=#f78166" "2=#56d364" "3=#e3b341" 
        "4=#6ca4f8" "5=#db61a2" "6=#2b7489" "7=#ffffff"
        "8=#4d4d4d" "9=#f78166" "10=#56d364" "11=#e3b341" 
        "12=#6ca4f8" "13=#db61a2" "14=#2b7489" "15=#ffffff"
      ];

      "mouse-hide-while-typing" = true;
      "mouse-shift-capture" = true;
      "focus-follows-mouse" = true;
      "macos-titlebar-style" = "native";
      "macos-window-shadow" = false;
      "macos-window-buttons" = "hidden";
      "auto-update" = "download";
      "auto-update-channel" = "stable";
      "macos-icon" = "retro";
      "macos-icon-frame" = "beige";
      "macos-icon-ghost-color" = "#10FF00";
      "macos-icon-screen-color" = "#FF0000";
    };
  };

  home.file.".p10k.zsh".source = ../powerLevel10k/.p10k.zsh;

  # home.file.".oh-my-zsh-custom/themes/powerlevel10k/powerlevel10k.zsh-theme".source =
  #   "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
}
