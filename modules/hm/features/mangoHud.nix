{ config, lib, pkgs, ... }:

let
  cfg = config.homeFeatures.mangoHud;
in
{
  options.homeFeatures.mangoHud = {
    enable = lib.mkEnableOption "MangoHud performance overlay";
  };

  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true; # Starts with every game automatically
      settings = {
        full = true;
        cpu_temp = true;
        gpu_temp = true;
        fps = true;
        frame_timing = 1;
        font_size = 24;
        position = "top-left";
      };
    };
  };
}
