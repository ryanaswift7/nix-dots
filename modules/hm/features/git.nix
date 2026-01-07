{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.homeFeatures.git;
in
{
  options.homeFeatures.git.enable = lib.mkEnableOption "Git configuration";
  
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
	  name = userSettings.fullName;
          email = userSettings.email;
	};
	init.defaultBranch = "main";
      };
    };
    programs.gh.enable = true;
  };
}
