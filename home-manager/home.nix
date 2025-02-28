{ config, pkgs, catppuccin, ... }:

{

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "matthewholden";
  home.homeDirectory = "/Users/matthewholden";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    
        cpufetch
        fastfetch
        ipfetch
        onefetch 
        micro
        m-cli
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/matthewholden/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
  };


  nix = {
    package = pkgs.nixVersions.latest;
  };

  home.shell = {
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    eza.enable = true;

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

    bat.enable = true;

    lazygit.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    fd = {
      enable = true;
    };
	
    git = {
      enable = true;
      userName = "matthew-reed-holden";
      userEmail = "matthewreedholden@icloud.com";
    };

    gh = {
      enable = true;
    };


    kubecolor = {
      enable = true;
      enableAlias = true;
    };

    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
    };
    

    jq.enable = true;

    zoxide = {
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autocd = true;
      autosuggestion = {
        enable = true;
      };
      dotDir = ".config/zsh";
      historySubstringSearch.enable = true;
      initExtraBeforeCompInit = ''
      export KUBECONFIG="$HOME/.config/kube/config";
      export NVM_DIR="$HOME/.config/nvm"
      export XDH_CONFIG_HOME="$HOME/.config"
      export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

      eval "$(/opt/homebrew/bin/brew shellenv)"
	    eval "$(starship init zsh)"

      [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
      [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

      '';
      shellAliases = {
        ls = "eza --icons=always";
        hm-switch = "home-manager switch";
      };
      profileExtra = ''
        eval "$(brew shellenv)"
      '';
      syntaxHighlighting = {
        enable = true;
      };
    };
  };

  xdg = {
    enable = true;
  };
}
