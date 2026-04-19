{ config, pkgs, ... }:
{
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.ripgrep
  ];

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      custom = "${config.home.homeDirectory}/.oh-my-zsh-custom";
      theme = "powerlevel10k/powerlevel10k";
      plugins = [
        "git"
      ];
    };

    initContent = builtins.readFile ../zshrc/.zshrc;

    autosuggestion.enable = true;

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

  home.file.".p10k.zsh".source = ../p10k/.p10k.zsh;

  home.file.".oh-my-zsh-custom/themes/powerlevel10k/powerlevel10k.zsh-theme".source =
    "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
}
