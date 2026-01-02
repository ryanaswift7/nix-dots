{ config, pkgs, lib, inputs, ... }:

# let
#   user = {
#     username = "ryan";
#     homeDirectory = "/home/ryan";
#     dotfileDirectory = "/home/ryan/nix-dots/dotfiles";
#     fullName = "Ryan Swift";
#     email = "ryanaswift7@gmail.com";
#     hostName = "home-desktop";
#     systemStateVersion = "25.05";
#     homeStateVersion = "25.05";
#   };
# in
{
  imports = [ ./hardware-configuration.nix ];

  # this validates the user in the let block
  # userSettings = user;

  systemSuites.workstation = true;
  systemFeatures.nvidia.enable = true;

  # to directly add a new package
  environment.systemPackages = with pkgs; [

  ];


	 home-manager = {
	#    backupFileExtension = "preHM";
	#    useGlobalPkgs = true;
	#    useUserPackages = true;
	#    extraSpecialArgs = { inherit inputs pkgs; };
	#
	   users."${config.userSettings.username}" = { ... }: {
	#      imports = [
	#        ../../modules/hm
	# inputs.dankMaterialShell.homeModules.dankMaterialShell.default
	#      ];
	#
	     # home = {
	#        username = config.userSettings.username;
	#        homeDirectory = config.userSettings.homeDirectory;
	#        stateVersion = config.userSettings.homeStateVersion;
	#
	#        packages = with pkgs; [
	#
	#        ];
	#       };
	#
	#       programs.home-manager.enable = true;
	#
	      homeSuites.workstation = true;
	   };
	 };

  specialisation."LTS".configuration = {
    system.nixos.tags = [ "LTS" ];
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };

  specialisation."GAMING".configuration = {
    system.nixos.tags = [ "GAMING" ];
    systemSuites.gaming = lib.mkForce true;
  };
}
