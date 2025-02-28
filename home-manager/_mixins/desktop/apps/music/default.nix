{
  lib,
  pkgs,
  username,
  ...
}:
let
  installFor = [ "matthewholden" ];
  inherit (pkgs.stdenv) isDarwin isLinux;
in
lib.mkIf (builtins.elem username installFor) {
  home.packages = with pkgs; [
    youtube-music
  ] ++ lib.optionals isLinux [
    cider
  ];
}
