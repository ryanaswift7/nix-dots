# This is a Nix module that holds all your *enabled*
# user programs, which will be shared everywhere.
{ pkgs,... }:

{
  # --- All your shared, enabled programs go here ---
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ryan Swift";
	email = "ryanaswift7@gmail.com";
      };
    };
  };

  programs.starship = {
    enable = true;
    package = pkgs.starship;
    enableZshIntegration = true;
  };


  programs.neovim = {
    enable = true;
  };

  programs.firefox.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initContent = ''
        # GENERATE SSH CONFIG FROM TEMPLATE
	# This makes your sensitive IP/port variables available in the current shell session.
	if [ -f "$HOME/.ssh/local_env.sh" ]; then
	    # echo "Sourcing ~/.ssh/local_env.sh..." >&2 # Optional: for debugging/feedback
	    source "$HOME/.ssh/local_env.sh"
	else
	    echo "Warning: ~/.ssh/local_env.sh not found. SSH config might be incomplete." >&2
	fi
	
	# 2. Generate ~/.ssh/config from the template using envsubst
	# This uses the variables set above to fill in the template.
	# Ensure 'envsubst' is installed (e.g., sudo apt install gettext-base on Debian/Ubuntu)
	if [ -f "$HOME/.ssh/config.tmpl" ]; then # Adjust path if your dotfiles are elsewhere
	    # echo "Generating ~/.ssh/config from template..." >&2 # Optional: for debugging/feedback
	    envsubst < "$HOME/.ssh/config.tmpl" > "$HOME/.ssh/config"
	    chmod 600 "$HOME/.ssh/config" # Set correct permissions
	else
	    echo "Error: SSH config template not found at $HOME/.ssh/config.tmpl" >&2
	fi
	
	
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
	alias nors-hd="nixos-rebuild switch --flake /home/ryan/nix-dots#home-desktop"
	alias nhos-hd="nh os switch -H home-desktop"
    '';
  };

  programs.fish = {
    enable = true;
    generateCompletions = true;
  };

  programs.kitty = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
  };

  programs.foot.enable = true;

  programs.dankMaterialShell = {
    enable = true;
  };

  programs.btop.enable = true;

  programs.vscode.enable = true;

  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      ms-vscode-remote.vscode-remote-extensionpack

      ms-python.python
      ms-python.vscode-pylance
      charliermarsh.ruff
      ms-python.debugpy

      ms-toolsai.jupyter
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-slideshow
    ];
    userSettings = {
      "python.languageServer" = "Pylance";

      # 1. Set Ruff as the default formatter
      "[python]" = {
        "editor.defaultFormatter" = "charliermarsh.ruff";
        "editor.formatOnSave" = true;
        
        # 2. Configure Ruff to fix lint errors and sort imports on every save
        "editor.codeActionsOnSave" = {
          "source.fixAll.ruff" = "explicit";
          "source.organizeImports.ruff" = "explicit";
        };
      };

      # 3. Ensure Pylance handles type checking while Ruff handles style
      "python.analysis.typeCheckingMode" = "basic"; 

      # 4. Sync Ruff to the remote machine
      "remote.SSH.defaultExtensions" = [
        "ms-python.python"
        "ms-python.vscode-pylance"
        "charliermarsh.ruff"
        "ms-toolsai.jupyter"
      ];
    };
  };

  programs.mpvpaper.enable = true;


}
