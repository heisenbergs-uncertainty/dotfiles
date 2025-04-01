{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  imports = [
    ./gitkraken
    ./jetbrains
    ./music
    # ./vscode
  ];
}
