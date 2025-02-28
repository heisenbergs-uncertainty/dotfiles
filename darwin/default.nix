{
  config,
  hostname,
  inputs,
  lib,
  outputs,
  pkgs,
  platform,
  username,
  ...
}:
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  # Only install the docs I use
  documentation.enable = true;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = true;

  environment = {
    shells = [
      pkgs.fish
      pkgs.zsh
    ];
    systemPackages = with pkgs; [
      git
      m-cli
      mas
      nix-output-monitor
      nvd
      plistwatch
      sops
    ];

   variables = {
      EDITOR = "micro";
      SYSTEMD_EDITOR = "micro";
      VISUAL = "micro";
    };
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    
    brews = [
      "neovim"
      "helm"
      "kubernetes-cli"
      "docker"
      "minikube"
      "nvm"
      "pyenv"
      "go"
      "lua"
      "rustup"
      "switchaudio-osx"
      "nowplaying-cli"
      "python3"
      "node"
      "lazydocker"
      "emqx/mqttx/mqttx-cli"
      "borders"
      "sketchybar"
      "jq"
      "maven"
    ];

    casks = [
      "alfred"
      "ghostty"
      "mqttx"
      "sf-symbols"
      "font-sf-mono"
      "font-sf-pro"
    ];


    taps = [
      "FelixKratz/formulae"
    ];
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    autoMigrate = true;
    user = "${username}";
    mutableTaps = true;
  };

  nixpkgs = {
    # Configure your nixpkgs instance
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${platform}";
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "flakes nix-command";
        # Disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        trusted-users = [
          "root"
          "${username}"
        ];
        warn-dirty = false;
      };
      enable = false;
      # Disable channels
      channel.enable = false;
      # Make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };
    
    networking.hostName = hostname;
    networking.computerName = hostname;
    
    programs = {
      fish = {
        enable = true;
        shellAliases = {
          nano = "micro";
        };
      };
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      info.enable = false;
    #nix-index-database.comma.enable = true;
      zsh = {
        enable = true;
      };
    };
    
    # Enable TouchID for sudo authentication
    security.pam.services.sudo_local.touchIdAuth = true;
    
    services = {
      tailscale.enable = true;
    };
    
    system = {
      stateVersion = 6;   
      defaults = {
        CustomUserPreferences = {
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
          "com.apple.controlcenter" = {
            BatteryShowPercentage = true;
          };
          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.finder" = {
            _FXSortFoldersFirst = true;
            FXDefaultSearchScope = "SCcf"; # Search current folder by default
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = false;
            ShowMountedServersOnDesktop = true;
            ShowRemovableMediaOnDesktop = true;
          };
          # Prevent Photos from opening automatically
          "com.apple.ImageCapture".disableHotPlug = true;
          "com.apple.screencapture" = {
            location = "~/Pictures/Screenshots";
            type = "png";
          };
          "com.apple.SoftwareUpdate" = {
            AutomaticCheckEnabled = true;
            # Check for software updates daily, not just once per week
            ScheduleFrequency = 1;
            # Download newly available updates in background
            AutomaticDownload = 0;
            # Install System data files & security updates
            CriticalUpdateInstall = 1;
          };
          "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
          # Turn on app auto-update
          "com.apple.commerce".AutoUpdate = true;
        };
        NSGlobalDomain = {
          AppleICUForce24HourTime = true;
          AppleInterfaceStyle = "Dark";
          AppleInterfaceStyleSwitchesAutomatically = false;
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          AppleTemperatureUnit = "Celsius";
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = true;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
        };
        SoftwareUpdate = {
          AutomaticallyInstallMacOSUpdates = false;
        };
        dock = {
          orientation = "left";
          show-recents = false;
          tilesize = 48;
          # Disable hot corners
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
        };
        finder = {
          _FXShowPosixPathInTitle = true;
          FXEnableExtensionChangeWarning = false;
          FXPreferredViewStyle = "Nlsv";
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          QuitMenuItem = true;
          ShowPathbar = true;
          ShowStatusBar = true;
        };
        menuExtraClock = {
          ShowAMPM = false;
          ShowDate = 1; # Always
          Show24Hour = true;
          ShowSeconds = false;
        };
        screensaver = {
          askForPassword = true;
          askForPasswordDelay = 300;
        };
        smb.NetBIOSName = hostname;
        trackpad = {
          Clicking = true;
          TrackpadRightClick = true; # enable two finger right click
          TrackpadThreeFingerDrag = true; # enable three finger drag
        };
      };
    };
  }
