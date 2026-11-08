{
  description = "RS NixOS & Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-25.11";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:duxlabs-dev/dux-shell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      home-manager,
      nixgl,
      ...
    }@inputs:
    flake-utils.lib.eachSystemPassThrough [ "x86_64-linux" ] (
      system:
      let
        # Temporary workaround to keep brave from Nixpkgs 25.11.
        oldPkgs = import inputs.nixpkgs-old {
          inherit system;
          config.allowUnfree = true;
        };

        overlays = [
          (final: prev: {
            brave = oldPkgs.brave;

            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];

        standaloneHmOverlays = overlays ++ [ nixgl.overlay ];

        standaloneHmPkgs = import nixpkgs {
          inherit system;
          overlays = standaloneHmOverlays;
          config.allowUnfree = true;
        };

        sharedSystemModules = [
          ./modules/system
          home-manager.nixosModules.home-manager
          inputs.dankMaterialShell.nixosModules.dank-material-shell

          {
            nixpkgs.overlays = overlays;
            nixpkgs.config.allowUnfree = true;
          }
        ];

        mkUserSettings = import ./lib/mkUserSettings.nix;

        mkStandaloneHome =
          hostPath:
          home-manager.lib.homeManagerConfiguration {
            pkgs = standaloneHmPkgs;

            extraSpecialArgs = {
              inherit inputs;
              userSettings = mkUserSettings (
                import (hostPath + "/identity.nix")
              );
            };

            modules = [ hostPath ];
          };
      in
      {
        nixosConfigurations = {
          home-desktop = nixpkgs.lib.nixosSystem {
            inherit system;

            specialArgs = {
              inherit inputs;
              userSettings = mkUserSettings (
                import ./hosts/home-desktop/identity.nix
              );
            };

            modules = [
              ./hosts/home-desktop
            ] ++ sharedSystemModules;
          };
        };

        homeConfigurations = {
          desktop-vm = mkStandaloneHome ./hosts/desktop-vm;
          usc-desktop = mkStandaloneHome ./hosts/usc-desktop;
        };
      }
    );
}