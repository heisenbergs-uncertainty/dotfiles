{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ _1password-cli ];

  homebrew = {
    casks = [ "1password" ];

    masApps = {
      "1Password For Safari" = 1569813296;
    };
  };
}
