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

      # 1. Define the overlays in the let block
      overlays = [
        inputs.openconnect-sso.overlays.default
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];

      # 2. Create a global pkgs instance that includes the overlays
      # This is the "Master" package set for all configurations
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      # Everything you want on every machine goes here.
      sharedSystemModules = [
        ./modules/system
        home-manager.nixosModules.home-manager
        inputs.dankMaterialShell.nixosModules.dankMaterialShell

        # # Inline module to configure Home Manager dynamically
        # ({ config, ... }: {
        #   home-manager = {
        #     useGlobalPkgs = true;
        #     useUserPackages = true;
        #     extraSpecialArgs = { inherit inputs; };
        #     # This looks at the 'userSettings' defined in each host file!
        #     users."${config.userSettings.username}" = {
        #       imports = [
        #         ./modules/hm
        #         inputs.dankMaterialShell.homeModules.dankMaterialShell.default
        #       ];
        #     };
        #   };
        # })
      ];

    in {
      nixosConfigurations = {

        home-desktop = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = { inherit inputs; };
          modules = [
	    ./hosts/home-desktop
	  ] ++ sharedSystemModules;
        };

        laptop-vm = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = { inherit inputs; };
          modules = [ 
	    ./hosts/laptop-vm
	  ] ++ sharedSystemModules;
        };
      };

      homeConfigurations = {
        usc-desktop = home-manager.lib.homemanagerconfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ 
	    ./hosts/usc-desktop
	    ./modules/hm
            inputs.dankmaterialshell.homemodules.dankmaterialshell.default
          ];
        };
    };
}

#   description = "RS NixOS & Home Manager Flake";
#
#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11"; 
#     nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
#
#     home-manager = {
#       url = "github:nix-community/home-manager/release-25.11";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#
#     openconnect-sso = {
#       url = "github:ThinkChaos/openconnect-sso/fix/nix-flake";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#
#     dankMaterialShell = {
#       url = "github:AvengeMedia/DankMaterialShell/stable";
#       inputs.nixpkgs.follows = "nixpkgs-unstable";
#     };
#   };
#
#   outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
#     let
#       system = "x86_64-linux";
#
#       overlays = [
#         inputs.openconnect-sso.overlays.default
#         (final: prev: {
#           unstable = import nixpkgs-unstable {
#             inherit system;
#             config.allowUnfree = true;
#           };
#         })
#       ];
#
#       common-nixos-modules = [
#         ./common/configuration.nix
#         inputs.dankMaterialShell.nixosModules.dankMaterialShell
#         home-manager.nixosModules.home-manager
#         {
#           nixpkgs.overlays = overlays;
#           home-manager = {
#             useGlobalPkgs = true;
#             useUserPackages = true;
#             extraSpecialArgs = { inherit inputs; };
#             users.ryan = {
# 	      imports = [
# 	        ./common/home.nix
# 		inputs.dankMaterialShell.homeModules.dankMaterialShell.default
# 	      ];
# 	    };
#           };
#         }
#       ];
#
#     in {
#       nixosConfigurations = {
#         laptop-vm = nixpkgs.lib.nixosSystem {
#           inherit system;
#           specialArgs = { inherit inputs; };
#           modules = common-nixos-modules ++ [ ./hosts/laptop-vm/configuration.nix ];
#         };
#
#         home-desktop = nixpkgs.lib.nixosSystem {
#           inherit system;
#           specialArgs = { inherit inputs; };
#           modules = common-nixos-modules ++ [ ./hosts/home-desktop/configuration.nix ];
#         };
#       };
#
#       homeConfigurations."nix-hm" = home-manager.lib.homeManagerConfiguration {
#         pkgs = import nixpkgs { inherit system overlays; config.allowUnfree = true; };
#         extraSpecialArgs = { inherit inputs; };
#         modules = [ 
#           ./common/home.nix 
#           inputs.dankMaterialShell.homeModules.dankMaterialShell.default
#         ];
#       };
#     };
# }
