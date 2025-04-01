{
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
let
  installFor = [ "matthewholden" ];
  inherit (pkgs.stdenv) isLinux;
  system = builtins.currentSystem;
  pluginList = [
    inputs.nix-jetbrains-plugins.plugins."${
      system
    }".idea-ultimate."2024.3"."com.intellij.plugins.watcher"
  ];
in
lib.mkIf (lib.elem username installFor) {
  home.packages = with pkgs; [
    # jetbrains.aqua
    # jetbrains.clion
    # jetbrains.datagrip
    # jetbrains.dataspell
    # jetbrains.goland
    # jetbrains.idea-ultimate
    # jetbrains.idea-community
    # jetbrains.gateway
    # jetbrains.mps
    # jetbrains.pycharm-professional
    # jetbrains.pycharm-community
    # jetbrains.rust-rover
    # jetbrains.rider
    # jetbrains.writerside
    # jetbrains.webstorm
    jetbrains-mono
    kotlin
  ];

}
