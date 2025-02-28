{
  description = "Heisenbergs incredibly uncertain nix-darwin and Home Manager Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nix-darwin, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "24.11";
      helper = import ./lib { inherit inputs outputs stateVersion; };
    in
    {
      # home-manager build --flake $HOME/.config
      # home-manager switch -b backup --flake $HOME/.config
      # nix run nixpkgs#home-manager -- switch -b backup --flake "${HOME}/.config
      homeConfigurations = {
        "matthewholden@C002108230" = helper.mkHome {
          hostname = "C002108230";
          platform = "aarch64-darwin";
          desktop = "aqua";
        };
      };

      #nix run nix-darwin -- switch --flake ~/Zero/nix-config
      #nix build .#darwinConfigurations.{hostname}.config.system.build.toplevel
      darwinConfigurations = {
        C002108230 = helper.mkDarwin {
          hostname = "C002108230";
        };
      };

      packages = helper.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    };
}
