{
  description = "RS NixOS & Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-vpn.url = "github:NixOS/nixpkgs/nixos-25.11";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openconnect-sso = {
      url = "github:ThinkChaos/openconnect-sso/fix/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs-vpn";
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
        # Keep the VPN client and its dependencies on Nixpkgs 25.11.
        vpnPkgs = import inputs.nixpkgs-vpn {
          inherit system;
          config.allowUnfree = true;

          overlays = [
            inputs.openconnect-sso.overlays.default
          ];
        };

        overlays = [
          (final: prev: {
            openconnect-sso = vpnPkgs.openconnect-sso;
            brave = vpnPkgs.brave;

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