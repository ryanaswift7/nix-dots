{ config, lib, pkgs, inputs, ... }:

let
  # Shorthand to access our custom settings defined in the host file
  user = config.userSettings;
in
{
  # 1. NixOS-level configuration for Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    # 2. This is the logic you had, now wrapped to target the specific user
    users."${user.username}" = { ... }: {
      # We can import other HM-specific files here (like your suites)
      imports = [
        ./suites.nix
        inputs.dankMaterialShell.homeModules.dankMaterialShell.default
      ];

      home = {
        username = user.username;
        homeDirectory = user.homeDirectory;
        stateVersion = user.homeStateVersion;

        packages = with pkgs; [
          curl
          unzip
          zip
          ripgrep
          # Add any other shared user-packages here
        ];
      };

      # Allow Home Manager to manage itself
      programs.home-manager.enable = true;
    };
  };
}
# { config, lib, pkgs, osConfig, ... }:
#
# let
#   user = osConfig.userSettings;
# in
# {
#   home = {
#     username = user.username;
#     homeDirectory = user.homeDirectory;
#     stateVersion = user.stateVersion;
#
#     # Basic packages that don't need their own feature module
#     packages = with pkgs; [
#       curl
#       unzip
#       zip
#       ripgrep
#     ];
#   };  		
#   programs.home-manager.enable = true;
# }
