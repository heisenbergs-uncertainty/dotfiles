{
  description = "Heisenbergs incredibly uncertain nix-darwin and Home Manager Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    catppuccin.url = "github:catppuccin/nix";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*";
    catppuccin-vsc.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    nixos-needsreboot.url = "https://flakehub.com/f/wimpysworld/nixos-needsreboot/0.2.5.tar.gz";
    nixos-needsreboot.inputs.nixpkgs.follows = "nixpkgs";

    ngrok.url = "github:ngrok/ngrok-nix";

    mac-app-util.url = "github:hraban/mac-app-util"; # Fixes .app not showing in spotlight/alfred

  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      ...
    }@inputs:
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
          username = "matthewholden";
          hostname = "C002108230";
          platform = "aarch64-darwin";
          desktop = "aqua";
        };
      };

      #nix run nix-darwin -- switch --flake ~/Zero/nix-config
      #nix build .#darwinConfigurations.{hostname}.config.system.build.toplevel
      darwinConfigurations = {
        C002108230 = helper.mkDarwin {
          username = "matthewholden";
          hostname = "C002108230";
        };
      };

      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Custom packages; acessible via 'nix build', 'nix shell', etc
      packages = helper.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for .nix files, available via 'nix fmt'
      formatter = helper.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
