{
  description = "RS NixOS & Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11"; 
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openconnect-sso = {
      url = "github:ThinkChaos/openconnect-sso/fix/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      overlays = [
        inputs.openconnect-sso.overlays.default
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];

      sharedSystemModules = [
        ./modules/system
        home-manager.nixosModules.home-manager
        inputs.dankMaterialShell.nixosModules.dankMaterialShell
        
        # This block tells NixOS how to handle packages correctly
        {
          nixpkgs.overlays = overlays;
          nixpkgs.config.allowUnfree = true;
        }
      ];

      mkUserSettings = import ./lib/mkUserSettings.nix;

    in {
      nixosConfigurations = {

        home-desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { 
	    inherit inputs;
	    userSettings = mkUserSettings (import ./hosts/home-desktop/identity.nix);
	  };
          modules = [ ./hosts/home-desktop ] ++ sharedSystemModules;
        };

      };

      # homeConfigurations = {
      #   usc-desktop = home-manager.lib.homeManagerConfiguration {
      #     # Standalone HM still needs a manual pkgs instance
      #     pkgs = import nixpkgs { inherit system overlays; config.allowUnfree = true; };
      #     extraSpecialArgs = { inherit inputs; };
      #     modules = [ 
      #       ./hosts/usc-desktop
      #       ./modules/hm
      #       inputs.dankMaterialShell.homeModules.dankMaterialShell.default
      #     ];
      #   };
      # };
    };
}
