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

      common-nixos-modules = [
        ./common/configuration.nix
        inputs.dankMaterialShell.nixosModules.dankMaterialShell
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = overlays;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.ryan = {
	      imports = [
	        ./common/home.nix
		inputs.dankMaterialShell.homeModules.dankMaterialShell.default
	        # inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
	      ];
	    };
          };
        }
      ];

    in {
      nixosConfigurations = {
        laptop-vm = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = common-nixos-modules ++ [ ./hosts/laptop-vm/configuration.nix ];
        };

        home-desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = common-nixos-modules ++ [ ./hosts/home-desktop/configuration.nix ];
        };
      };

      homeConfigurations."nix-hm" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system overlays; config.allowUnfree = true; };
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./common/home.nix 
          inputs.dankMaterialShell.homeModules.dankMaterialShell.default
	  inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
        ];
      };
    };
}
