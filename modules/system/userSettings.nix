{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types mkDefault;
  cfg = config.userSettings;
in
{
  options.userSettings = {
    username = mkOption { 
      type = types.str;
      description = "The username for the home profile";
    };

    homeDirectory = mkOption { 
      type = types.str; 
      description = "The home directory for the user";
    };

    dotfileDirectory = mkOption {
      type = types.str;
      description = "The dotfile directory for the user";
    };

    systemStateVersion = mkOption {
      type = types.str;
      description = "The NixOS state version (referencing system-level state)";
    };

    homeStateVersion = mkOption {
      type = types.str;
      description = "The Home Manager state version (referencing user-level state)";
    };

    fullName = mkOption {
      type = types.str;
      description = "The full name of the user (used for git)";
    };

    email = mkOption {
      type = types.str;
      description = "The email address for the user (used for git)";
    };

    hostName = mkOption {
      type = types.str;
      description = "The hostname used for the system";
    };
  };

  config = {
    userSettings = {
      homeDirectory = mkDefault "/home/${cfg.username}";
      dotfileDirectory = mkDefault "${cfg.homeDirectory}/nix-dots/dotfiles";
    };

    assertions = [
      {
        assertion = cfg.username != "";
        message = "userSettings.username is not set!";
      }
      {
        assertion = cfg.fullName != "";
        message = "userSettings.fullName is not set!";
      }
      {
        assertion = cfg.email != "";
        message = "userSettings.email is not set!";
      }
      {
        assertion = cfg.hostName != "";
        message = "userSettings.hostName is not set!";
      }
      {
        assertion = cfg.homeDirectory != "";
        message = "userSettings.homeDirectory is not set!";
      }
      {
        assertion = cfg.dotfileDirectory != "";
        message = "userSettings.dotfileDirectory is not set!";
      }

    ];
  };
}
