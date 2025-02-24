{
  description = "Home Manager Configuration";
  inputs = {
    catppuccin.url = "https://flakehub.com/f/catppuccin/nix/1.2.1.tar.gz";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*";
    home-manager.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2411.714772.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "https://flakehub.com/f/nixos/nixpkgs/0.2411.*";
  };
  outputs =
    { self, ... }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "24.11";
      helper = import ./lib { inherit inputs outputs stateVersion; };
    in
    {
      homeConfigurations = {
        "matthewholden@C002108230" = helper.mkHome {
          username = "matthewholden";
          hostname = "C002108230";
          platform = "aarch64-darwin";
        };
         "linuxUsername@linuxHostname" = helper.mkHome {
          username = "linuxUsername";
          hostname = "linuxHostname";
        };
      };
    };
}
