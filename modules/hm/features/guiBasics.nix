{ config, lib, pkgs, ... }:

let
  cfg = config.homeFeatures.guiBasics;
in
{
  options.homeFeatures.guiBasics = {
    enable = lib.mkEnableOption "basic GUI applications (Firefox, Kitty, btop, udiskie)";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      btop.enable = true;
      firefox.enable = true;
      kitty.enable = true;
    };

    services.udiskie.enable = true;

    home.packages = with pkgs; [
      (brave.override {
        commandLineArgs = [
          "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
          "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
          "--enable-features=UseMultiPlaneFormatForHardwareVideo"
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
        ];
      })
      (google-chrome.override {
        commandLineArgs = [
          "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
          "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
          "--enable-features=UseMultiPlaneFormatForHardwareVideo"
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
        ];
      })

      celluloid
      vlc
      imv
      cliphist
      wl-clipboard
      xclip
      networkmanager-openconnect
      kdePackages.dolphin
    ];
  };
}
