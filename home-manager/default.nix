{
  lib,
  pkgs,
  stateVersion,
  username,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  home = {
    inherit stateVersion;
    inherit username;
    homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

    packages =
      with pkgs;
      [
        cpufetch
        fastfetch
        ipfetch
        onefetch
        micro
      ]
      ++ lib.optionals isLinux [
        ramfetch
      ]
      ++ lib.optionals isDarwin [
        m-cli
      ];
    sessionVariables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  # Workaround home-manager bug
  # - https://github.com/nix-community/home-manager/issues/2033
  news = {
    display = "silent";
    entries = lib.mkForce [ ];
  };

  nix = {
    package = pkgs.nixVersions.latest;
  };

  programs = {
    home-manager.enable = true;
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
      userName = "matthew-reed-holde";
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
