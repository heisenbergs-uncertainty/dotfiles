{
  lib,
  pkgs,
  username,
  ...
}:
let
  installFor = [ "matthewholden" ];
in
lib.mkIf (lib.elem username installFor) {
  environment.systemPackages = with pkgs; [
    inkscape
    pika
  ];

  homebrew = {
    casks = [
      "shottr"
      "blender"
    ];
  };
}
