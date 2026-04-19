{
  description = "Prakhar's Mac System Flake";

  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Use the unstable branch for 2026 packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Match it with the nix-darwin master branch
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
      user = "prakharsingh";
      configuration = { pkgs, ... }: {
        # Batt Gui service
        system.activationScripts.postActivation.text = ''
        if ! pgrep -f "batt gui" > /dev/null; then
          echo "Batt GUI not found. Starting..."
          sudo -u prakharsingh /opt/homebrew/bin/batt gui > /dev/null 2>&1 &
        else
          echo "Batt GUI is already active. Skipping launch to avoid duplicates."
        fi
        '';

        programs.zsh.enable = true;

      # List packages that should be installed in the Nix store (CLI tools)
        nix.enable = false;
        system.primaryUser = user;
        users.users.${user}.home = "/Users/${user}";

        environment.systemPackages = [
          pkgs.btop
          pkgs.bat
          pkgs.zoxide
          pkgs.yt-dlp
          pkgs.wget
          pkgs.bun
          pkgs.curl
          pkgs.uv
          pkgs.git-lfs
          pkgs.neovim
          pkgs.tree
          pkgs.ripgrep
          pkgs.fzf
          pkgs.eza
          pkgs.fd
          pkgs.git
          pkgs.tmux
          pkgs.neovim
          pkgs.nodejs
          pkgs.docker
          pkgs.ffmpeg
          pkgs.ollama
        ];

      # Homebrew management (GUI Apps)
        homebrew = {
          enable = true;
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
          onActivation.cleanup = "zap";
          taps = [
            "sozercan/repo"
            "xykong/tap"
          ];
          brews = [
            {
              name = "batt";
            }
          ];
          casks = [
            "visual-studio-code"
            "ghostty"
            "raycast"
            "nook"
            "font-caskaydia-cove-nerd-font"
            "macs-fan-control"
            "prismlauncher"
            "localsend"
            "sozercan/repo/kaset"
            "temurin@21"
            "xykong/tap/flux-markdown"
            "android-platform-tools"
          ];
        };

        # batt needs a root daemon on Apple Silicon, so manage it directly via launchd.
        environment.etc."batt.json".text = ''
          {
            "charge_limit": 80
          }
        '';

        launchd.daemons.batt = {
          serviceConfig = {
            ProgramArguments = [
              "/opt/homebrew/bin/batt"
              "daemon"
              "--config=/etc/batt.json"
              "--always-allow-non-root-access"
            ];
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/var/log/batt.log";
            StandardErrorPath = "/var/log/batt.log";
          };
        };

      # Essential Nix settings
        nix.settings.experimental-features = "nix-command flakes";
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      darwinConfigurations."Prakhars-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./zshrc/prakharsingh.nix;
          }
        ];
      };
    };
}
