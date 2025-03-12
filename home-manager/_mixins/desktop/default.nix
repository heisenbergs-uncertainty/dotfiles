{
  config,
  desktop,
  lib,
  pkgs,
  username,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  # import the DE specific configuration and any user specific desktop configuration
  imports =
    [
      ./apps
    ]
    ++ lib.optional (builtins.pathExists (./. + "/${desktop}")) ./${desktop}
    ++ lib.optional (builtins.pathExists (
      ./. + "/${desktop}/${username}/default.nix"
    )) ./${desktop}/${username};

}
