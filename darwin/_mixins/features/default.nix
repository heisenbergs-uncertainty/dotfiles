{ pkgs, ... }:
{
  imports = [
    ./docker
    ./podman
  ];

  environment.systemPackages = with pkgs; [ ];
}
