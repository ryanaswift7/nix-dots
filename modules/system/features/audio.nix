{ config, lib, ... }:

{
  options.systemFeatures.audio.enable = lib.mkEnableOption "Pipewire audio stack";

  config = lib.mkIf config.systemFeatures.audio.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
