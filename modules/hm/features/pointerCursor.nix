{ config, lib, pkgs, ... }:

let
  cfg = config.homeFeatures.pointerCursor;
in
{
  options.homeFeatures.pointerCursor = {
    enable = lib.mkEnableOption "custom pointer cursor configuration";
    
    name = lib.mkOption {
      type = lib.types.str;
      default = "Adwaita";
      description = "The name of the cursor theme.";
    };

    size = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "The size of the cursor.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.adwaita-icon-theme;
      description = "The package providing the cursor theme.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      inherit (cfg) name size package;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
