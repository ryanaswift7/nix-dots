{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.homeFeatures.zsh;
in
{
  options.homeFeatures.zsh = {
    enable = lib.mkEnableOption "Zsh environment with Starship and custom aliases";
  };

  config = lib.mkIf cfg.enable {
    # Packages required for the aliases and scripts below
    home.packages = with pkgs; [
      eza
      gettext # provides envsubst
      tmux
      nh
    ];

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      initContent = ''
        # 1. GENERATE SSH CONFIG FROM TEMPLATE
        if [ -f "$HOME/.ssh/local_env.sh" ]; then
          source "$HOME/.ssh/local_env.sh"
        else
          echo "Warning: ~/.ssh/local_env.sh not found." >&2
        fi

        # 2. Generate ~/.ssh/config from the template using envsubst
        if [ -f "$HOME/.ssh/config.tmpl" ]; then
          ${pkgs.envsubst}/bin/envsubst < "$HOME/.ssh/config.tmpl" > "$HOME/.ssh/config"
          chmod 600 "$HOME/.ssh/config"
        else
          echo "Error: SSH config template not found at $HOME/.ssh/config.tmpl" >&2
        fi

        # Aliases
        alias ll="eza --header --long --all --sort=type --group-directories-first --icons --git"
        alias ".."="cd .."
        alias p="python3"
        alias python="python3"
        alias usc="openconnect-sso -s vpn.usc.edu"
        alias ta="tmux attach-session -t"
        alias gs="git status"
        alias ga="git add ."
        alias gcm="git commit -m"
        alias gp="git push"
        alias v="nvim"
        
        # System Management Aliases
        alias nors-hd="sudo nixos-rebuild switch --flake ${userSettings.homeDirectory}/nix-dots#home-desktop"
        alias nhos-hd="nh os switch -H home-desktop"
      '';
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
