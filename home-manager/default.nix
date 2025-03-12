{
  config,
  inputs,
  isWorkstation,
  lib,
  outputs,
  pkgs,
  stateVersion,
  username,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nix-index-database.hmModules.nix-index
    ./_mixins/features
    ./_mixins/desktop
  ];

  catppuccin = {
    accent = "blue";
    flavor = "mocha";
    alacritty.enable = config.programs.alacritty.enable;
    bat.enable = config.programs.bat.enable;
    fish.enable = config.programs.fish.enable;
    fzf.enable = config.programs.fzf.enable;
    gh-dash.enable = config.programs.gh.extensions.gh-dash;
    micro.enable = config.programs.micro.enable;
    starship.enable = config.programs.starship.enable;
    yazi.enable = config.programs.yazi.enable;
  };

  home = {
    inherit stateVersion;
    inherit username;

    homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

    file = {
      "${config.xdg.configHome}/fastfetch/config.jsonc".text =
        builtins.readFile ./_mixins/configs/fastfetch.jsonc;
      "${config.xdg.configHome}/borders/bordersrc".text = builtins.readFile ./_mixins/configs/bordersrc;
      # "${config.xdg.configHome}/aerospace/aerospace.toml".text =
      #   builtins.readFile ./_mixins/configs/aerospace.toml;
      "${config.xdg.configHome}/yazi/keymap.toml".text =
        builtins.readFile ./_mixins/configs/yazi-keymap.toml;
      "${config.xdg.configHome}/ghostty/config".text = builtins.readFile ./_mixins/configs/ghostty-config;
      ".hidden".text = ''snap'';
    };
    packages =
      with pkgs;
      [
        cpufetch # Terminal CPU info
        fastfetch # Modern Unix system info
        ipfetch # Terminal IP info
        onefetch # Terminal git project info
        rustmission # Modern Unix Transmission client
        micro
      ]
      ++ lib.optionals isLinux [
        ramfetch
      ]
      ++ lib.optionals isDarwin [
        m-cli
        nh
        coreutils
      ];
    sessionVariables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  fonts.fontconfig.enable = true;

  # Workaround home-manager bug
  # - https://github.com/nix-community/home-manager/issues/2033
  news = {
    display = "silent";
    entries = lib.mkForce [ ];
  };

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;
  };

  programs = {
    alacritty = {
      enable = true;
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batgrep
        batwatch
        prettybat
      ];
      config = {
        style = "plain";
      };
    };

    bottom = {
      enable = true;
      settings = {
        disk_filter = {
          is_list_ignored = true;
          list = [ "/dev/loop" ];
          regex = true;
          case_sensitive = false;
          whole_word = false;
        };
        flags = {
          dot_marker = false;
          enable_gpu_memory = true;
          group_processes = true;
          hide_table_gap = true;
          mem_as_value = true;
          tree = true;
        };
      };
    };

    btop = {
      enable = true;
      package = pkgs.btop.override {
        cudaSupport = true;
      };
    };

    dircolors = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = "auto";
    };

    fd = {
      enable = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-dash
        gh-markdown-preview
      ];
      settings = {
        editor = "micro";
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    git = {
      enable = true;
      userName = "heisenbergs-uncertainty";
      userEmail = "matthewreedholden@icloud.com";
    };

    home-manager.enable = true;

    jq.enable = true;

    kubecolor = {
      enable = true;
      enableAlias = true;
    };

    lazygit = {
      enable = true;
    };

    nix-index.enable = true;

    ripgrep = {
      arguments = [
        "--colors=line:style:bold"
        "--max-columns-preview"
        "--smart-case"
      ];
      enable = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      # https://github.com/etrigan63/Catppuccin-starship
    };

    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = false;
          show_symlink = true;
          sort_by = "natural";
          sort_dir_first = true;
          sort_sensitive = false;
          sort_reverse = false;
        };
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      # Replace cd with z and add cdi to access zi
      options = [ "--cmd cd" ];
    };

    zsh = {
      autocd = true;
      autosuggestion = {
        enable = true;
      };
      completionInit = "autoload -U compinit && compinit";
      dotDir = ".config/zsh";
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      historySubstringSearch.enable = true;
      # initExtraBeforCompInit = ''
      #   export NVM_DIR="$HOME/.config/nvm"
      #   [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
      #   [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
      # '';
      profileExtra = ''
        export KUBECONFIG="$HOME/.config/kube/config"
        export PATH="$PATH:$HOME/Code/github/heisenbergoss/streampipes/installer/cli"
      '';
      syntaxHighlighting = {
        enable = true;
      };
    };
  };
}
