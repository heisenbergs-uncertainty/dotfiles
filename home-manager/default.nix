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
  ] ++ lib.optional isWorkstation ./_mixins/desktop;

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
      "${config.xdg.configHome}/fastfetch/config.jsonc".text =
        builtins.readFile ./_mixins/configs/fastfetch.jsonc;
      "${config.xdg.configHome}/yazi/keymap.toml".text =
        builtins.readFile ./_mixins/configs/yazi-keymap.toml;
      "${config.xdg.configHome}/fish/functions/help.fish".text =
        builtins.readFile ./_mixins/configs/help.fish;
      "${config.xdg.configHome}/fish/functions/h.fish".text = builtins.readFile ./_mixins/configs/h.fish;
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
    aria2.enable = true;

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
      userName = "heisenbergs-uncertainty";
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
      settings = {
        add_newline = false;
        command_timeout = 1000;
        time = {
          disabled = true;
        };
        format = lib.concatStrings [
          "[](surface1)"
          "$os"
          "[](bg:surface2 fg:surface1)"
          "$username"
          "$sudo"
          "[](bg:overlay0 fg:surface2)"
          "$hostname"
          "[](bg:mauve fg:overlay0)"
          "$directory"
          "[](fg:mauve bg:peach)"
          "$c"
          "$dart"
          "$dotnet"
          "$elixir"
          "$elm"
          "$erlang"
          "$golang"
          "$haskell"
          "$haxe"
          "$java"
          "$julia"
          "$kotlin"
          "$lua"
          "$nim"
          "$nodejs"
          "$rlang"
          "$ruby"
          "$rust"
          "$perl"
          "$php"
          "$python"
          "$scala"
          "$swift"
          "$zig"
          "$package"
          "$git_branch"
          "[](fg:peach bg:yellow)"
          "$git_status"
          "[](fg:yellow bg:teal)"
          "$container"
          "$direnv"
          "$nix_shell"
          "$cmd_duration"
          "$jobs"
          "$shlvl"
          "$status"
          "$character"
        ];
        os = {
          disabled = false;
          format = "$symbol";
          style = "";
        };
        os.symbols = {
          AlmaLinux = "[](fg:text bg:surface1)";
          Alpine = "[](fg:blue bg:surface1)";
          Amazon = "[](fg:peach bg:surface1)";
          Android = "[](fg:green bg:surface1)";
          Arch = "[󰣇](fg:sapphire bg:surface1)";
          Artix = "[](fg:sapphire bg:surface1)";
          CentOS = "[](fg:mauve bg:surface1)";
          Debian = "[](fg:red bg:surface1)";
          DragonFly = "[](fg:teal bg:surface1)";
          EndeavourOS = "[](fg:mauve bg:surface1)";
          Fedora = "[](fg:blue bg:surface1)";
          FreeBSD = "[](fg:red bg:surface1)";
          Garuda = "[](fg:sapphire bg:surface1)";
          Gentoo = "[](fg:lavender bg:surface1)";
          Illumos = "[](fg:peach bg:surface1)";
          Kali = "[](fg:blue bg:surface1)";
          Linux = "[](fg:yellow bg:surface1)";
          Macos = "[](fg:text bg:surface1)";
          Manjaro = "[](fg:green bg:surface1)";
          Mariner = "[](fg:sky bg:surface1)";
          MidnightBSD = "[](fg:yellow bg:surface1)";
          Mint = "[󰣭](fg:teal bg:surface1)";
          NetBSD = "[](fg:peach bg:surface1)";
          NixOS = "[](fg:sky bg:surface1)";
          OpenBSD = "[](fg:yellow bg:surface1)";
          openSUSE = "[](fg:green bg:surface1)";
          OracleLinux = "[󰌷](fg:red bg:surface1)";
          Pop = "[](fg:sapphire bg:surface1)";
          Raspbian = "[](fg:maroon bg:surface1)";
          Redhat = "[](fg:red bg:surface1)";
          RedHatEnterprise = "[](fg:red bg:surface1)";
          RockyLinux = "[](fg:green bg:surface1)";
          Solus = "[](fg:blue bg:surface1)";
          SUSE = "[](fg:green bg:surface1)";
          Ubuntu = "[](fg:peach bg:surface1)";
          Unknown = "[](fg:text bg:surface1)";
          Void = "[](fg:green bg:surface1)";
          Windows = "[󰖳](fg:sky bg:surface1)";
        };
        username = {
          aliases = {
            "matthewholden" = "󰝴";
            "root" = "󰱯";
          };
          format = "[ $user]($style)";
          show_always = true;
          style_user = "fg:green bg:surface2";
          style_root = "fg:red bg:surface2";
        };
        sudo = {
          disabled = false;
          format = "[ $symbol]($style)";
          style = "fg:rosewater bg:surface2";
          symbol = "󰌋";
        };
        hostname = {
          disabled = false;
          style = "bg:overlay0 fg:red";
          ssh_only = false;
          ssh_symbol = " 󰖈";
          format = "[ $hostname]($style)[$ssh_symbol](bg:overlay0 fg:maroon)";
        };
        directory = {
          format = "[ $path]($style)[$read_only]($read_only_style)";
          home_symbol = "";
          read_only = " 󰈈";
          read_only_style = "bold fg:crust bg:mauve";
          style = "fg:base bg:mauve";
          truncation_length = 3;
          truncation_symbol = "…/";
        };
        # Shorten long paths by text replacement. Order matters
        directory.substitutions = {
          "Apps" = "󰵆";
          "Desktop" = "";
          "Code" = "";
          "Documents" = "󰈙";
          "Downloads" = "󰉍";
          "Dropbox" = "";
          "Games" = "󰊴";
          "Keybase" = "󰯄";
          "Music" = "󰎄";
          "Pictures" = "";
          "Public" = "";
          "Quickemu" = "";
          "Studio" = "󰡇";
          "Vaults" = "󰌿";
          "Videos" = "";
          "Volatile" = "󱪃";
          "Websites" = "󰖟";
          ".config" = "󱄅";
          "dotfiles" = "󰎡";
        };
        # Languages
        c = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        dart = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        dotnet = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        elixir = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        elm = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        erlang = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        golang = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        haskell = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "󰲒";
        };
        haxe = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        java = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "󰬷";
        };
        julia = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        kotlin = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        lua = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        nim = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        nodejs = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        perl = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        php = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "󰌟";
        };
        python = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        rlang = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        ruby = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        rust = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        scala = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        swift = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        zig = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        package = {
          format = "[ $version]($style)";
          style = "fg:base bg:peach";
          version_format = "$raw";
        };
        git_branch = {
          format = "[ $symbol $branch]($style)";
          style = "fg:base bg:peach";
          symbol = "";
        };
        git_status = {
          format = "[ $all_status$ahead_behind]($style)";
          conflicted = "󰳤 ";
          untracked = " ";
          stashed = " ";
          modified = " ";
          staged = " ";
          renamed = " ";
          deleted = " ";
          typechanged = " ";
          # $ahead_behind is just one of these
          ahead = "󰜹";
          behind = "󰜰";
          diverged = "";
          up_to_date = "󰤓";
          style = "fg:base bg:yellow";
        };
        # "Shells"
        container = {
          format = "[ $symbol $name]($style)";
          style = "fg:base bg:teal";
          symbol = "󱋩";
        };
        direnv = {
          disabled = false;
          format = "[ $loaded]($style)";
          allowed_msg = "";
          not_allowed_msg = "";
          denied_msg = "";
          loaded_msg = "󰐍";
          unloaded_msg = "󰙧";
          style = "fg:base bg:teal";
          symbol = "";
        };
        nix_shell = {
          format = "[ $symbol]($style)";
          style = "fg:base bg:teal";
          symbol = "󱄅";
        };
        cmd_duration = {
          format = "[  $duration]($style)";
          min_time = 2500;
          min_time_to_notify = 60000;
          show_notifications = false;
          style = "fg:base bg:teal";
        };
        jobs = {
          format = "[ $symbol $number]($style)";
          style = "fg:base bg:teal";
          symbol = "󰣖";
        };
        shlvl = {
          disabled = false;
          format = "[ $symbol]($style)";
          repeat = false;
          style = "fg:surface1 bg:teal";
          symbol = "󱆃";
          threshold = 3;
        };
        status = {
          disabled = false;
          format = "$symbol";
          map_symbol = true;
          pipestatus = false;
          style = "";
          symbol = "[](fg:teal bg:pink)[  $status](fg:red bg:pink)";
          success_symbol = "[](fg:teal bg:blue)";
          not_executable_symbol = "[](fg:teal bg:pink)[  $common_meaning](fg:red bg:pink)";
          not_found_symbol = "[](fg:teal bg:pink)[ 󰩌 $common_meaning](fg:red bg:pink)";
          sigint_symbol = "[](fg:teal bg:pink)[  $signal_name](fg:red bg:pink)";
          signal_symbol = "[](fg:teal bg:pink)[ ⚡ $signal_name](fg:red bg:pink)";
        };
        character = {
          disabled = false;
          format = "$symbol";
          error_symbol = "(fg:red bg:pink)[](fg:pink) ";
          success_symbol = "[](fg:blue) ";
        };
      };
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
