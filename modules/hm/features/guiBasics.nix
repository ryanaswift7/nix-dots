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
      kitty.enable = true;
      firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };
    };

    services.udiskie.enable = true;
    services.network-manager-applet.enable = true;

    home.packages = with pkgs; [
      (brave.override {
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
          "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
          "--enable-features=UseMultiPlaneFormatForHardwareVideo"
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
        ];
      })
      (google-chrome.override {
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
          "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
          "--enable-features=UseMultiPlaneFormatForHardwareVideo"
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
        ];
      })

      celluloid
      vlc
      loupe
      cliphist
      wl-clipboard
      xclip
      networkmanager-openconnect
      adw-gtk3
      kdePackages.dolphin
      kdePackages.qt6ct
      nemo
      bitwarden-desktop
    ];
  };
}
