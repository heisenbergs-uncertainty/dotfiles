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
  ];

  catppuccin = {
    accent = "blue";
    flavor = "mocha";
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
      "${config.xdg.configHome}/fastfetch/config.jsonc".text = builtins.readFile ./_mixins/configs/fastfetch.jsonc;
      "${config.xdg.configHome}/yazi/keymap.toml".text = builtins.readFile ./_mixins/configs/yazi-keymap.toml;
      "${config.xdg.configHome}/fish/functions/help.fish".text = builtins.readFile ./_mixins/configs/help.fish;
      "${config.xdg.configHome}/fish/functions/h.fish".text = builtins.readFile ./_mixins/configs/h.fish;
      "${config.xdg.configHome}/ghostty/config".text = builtins.readFile ./_mixins/configs/ghostty-config.toml;
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
      EDITOR = "micro";
      SYSTEMD_EDITOR = "micro";
      VISUAL = "micro";
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
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;
  };

  programs = {

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

    fish = {
      enable = true;
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
      userName = "matthew-reed-holden";
      userEmail = "matthewreedholden@icloud.com";
    };


    home-manager.enable = true;

    jq.enable = true;

    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
    };

    kubecolor = {
      enable = true;
      enableAlias = true;
    };

    
    lazygit = {
      enable = true;
    };

    micro = {
      enable = true;
      settings = {
        autosu = true;
        diffgutter = true;
        paste = true;
        rmtrailingws = true;
        savecursor = true;
        saveundo = true;
        scrollbar = true;
        scrollbarchar = "░";
        scrollmargin = 4;
        scrollspeed = 1;
      };
    };

    nix-index.enable = true;

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
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
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autocd = true;
      autosuggestion = {
        enable = true;
      };
      completionInit = "autoload -U compinit && compinit";
      dotDir = ".config/zsh";
      historySubstringSearch.enable = true;
      profileExtra = "
      export KUBECONFIG='$HOME/.config/kube';
      ";
      syntaxHighlighting = {
        enable = true;
      };
    };
  };
}
