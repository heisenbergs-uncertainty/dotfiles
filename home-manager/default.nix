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
    inputs.mac-app-util.homeManagerModules.default
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
    kitty.enable = true;
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
      "${config.xdg.configHome}/aerospace/aerospace.toml".text =
        builtins.readFile ./_mixins/configs/aerospace.toml;
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
        micro
        rustmission # Modern Unix Transmission client
        rsync # Copy files in style
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

    home-manager.enable = true;

    jq.enable = true;

    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      font = {
        name = "Fira Code Mono";
        package = pkgs.nerd-fonts.fira-code;
        size = 10;
      };
      keybindings = {
        "kitty_mod+l" = "next_tab";
        "kitty_mod+h" = "previous_tab";
        "kitty_mod+m" = "toggle_layout stack";
        "kitty_mod+z" = "toggle_layout stack";
        "kitty_mod+enter" = "launch --location=split --cwd=current";
        "kitty_mod+v" = "launch --location=vsplit --cwd=current";
        "kitty_mod+minus" = "launch --location=hsplit --cwd=currentt";
        "kitty_mod+left" = "neighboring_window left";
        "kitty_mod+right" = "neighboring_window right";
        "kitty_mod+up" = "neighboring_window up";
        "kitty_mod+down" = "neighboring_window down";
        "kitty_mod+r" = "show_scrollback";
      };
      settings = {
        cursor_trail = 3;
        cursor = "none";
        kitty_mod = "cmd+shift";
        scrollback_lines = 10000;
        touch_scroll_multiplier = 2.0;
        copy_on_select = true;
        enable_audio_bell = false;
        remember_window_size = true;
        initial_window_width = 1600;
        initial_window_height = 1000;
        hide_window_decorations = true;
        tab_bar_style = "powerline";
        tab_separator = " ";
        enabled_layouts = "Splits,Stack";
        dynamic_background_opacity = true;
        tab_title_template = "{title}{fmt.bold}{'  ' if num_windows > 1 and layout_name == 'stack' else ''}";
        symbol_map = "U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E634,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF Symbols Nerd Font Mono";
        disable_ligatures = "cursor";
      };
    };

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
      initExtraBeforeCompInit = ''
        #### NVM ####
        #############

        export NVM_DIR="$HOME/.config/nvm"
        [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
        [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

        #### PYENV ####
        ###############

        export PYENV_ROOT="$HOME/.config/pyenv"

        [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

        eval "$(pyenv init - zsh)"
        eval "$(pyenv virtualenv-init -)"

        #### SDKMAN ####
        ################

        export SDKMAN_DIR="$HOMEBREW_PREFIX/opt/sdkman-cli/libexec"
        [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
      '';
      profileExtra = ''
        export KUBECONFIG="$HOME/.config/kube/config"
        export PATH="$PATH:$HOME/Code/github/holdem3_cat/streampipes/installer/cli"
      '';
      syntaxHighlighting = {
        enable = true;
      };
    };
  };

}
