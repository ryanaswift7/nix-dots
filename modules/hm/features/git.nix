{ config, lib, pkgs, osConfig, ... }:

let
  cfg = config.homeFeatures.git;
  user = osConfig.userSettings;
in
{
  options.homeFeatures.git.enable = lib.mkEnableOption "Git configuration";
  
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
	  name = user.fullName;
          email = user.email;
	};
	init.defaultBranch = "main";
      };
    };
    programs.gh.enable = true;
  };
}
