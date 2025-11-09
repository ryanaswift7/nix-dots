
# /etc/nixos/flake.nix
{
  description = "RS NixOS & Home Manager Flake";

  inputs = {
    # --- Main Channels ---
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # --- Home Manager ---
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # === ADDED ===
    # Add the openconnect-sso flake as an input
    openconnect-sso = {
      url = "github:ThinkChaos/openconnect-sso/fix/nix-flake";
      # Tell it to use our main nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.system.follows = "system";
      # inputs.flake-utils.follows = "utils";
    };
  };

  # Make sure to add `openconnect-sso` to the function arguments
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, openconnect-sso, ... }@inputs:
    let
      system = "x86_64-linux";

      # --- 1. Define the Overlays ---
      unstable-overlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      # === ADDED ===
      # Get the overlay from the flake input
      openconnect-overlay = openconnect-sso.overlays.default;


      # --- 2. Create Overlaid Pkgs for Standalone HM ---
      hm-pkgs = import nixpkgs {
        inherit system;
        
        # === CHANGED ===
        # Add *both* overlays to the list
        overlays = [ unstable-overlay openconnect-overlay ];
        
        config.allowUnfree = true;
      };

    in
    {
      # === OUTPUT 1: NixOS Configuration ===
      nixosConfigurations = {
        nixos-machine = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          modules = [
            # --- 3. Apply the Overlays to NixOS ---
            ({ config, pkgs, ... }: {
              
              # === CHANGED ===
              # Add *both* overlays here as well
              nixpkgs.overlays = [ unstable-overlay openconnect-overlay ];
            
            })

            ./configuration.nix
            home-manager.nixosModules.default
          ];
        };
      };

      # === OUTPUT 2: Standalone Home Manager Configuration ===
      homeManagerConfigurations = {
        nix-hm = home-manager.lib.homeManagerConfiguration {
          # Pass the pkgs set that has both overlays
          pkgs = hm-pkgs; 
          extraSpecialArgs = { inherit inputs; }; 
          modules = [ ./home.nix ];
        };
      };
    };
}

