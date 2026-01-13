{ config, lib, pkgs, ... }:

let
  cfg = config.homeFeatures.vscode;
in
{
  options.homeFeatures.vscode = {
    enable = lib.mkEnableOption "VS Code with Python, Jupyter, and Ruff support";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          # Remote Development
          ms-vscode-remote.vscode-remote-extensionpack

          # Python & Linting
          ms-python.python
          ms-python.vscode-pylance
          charliermarsh.ruff
          ms-python.debugpy

          # Jupyter
          ms-toolsai.jupyter
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-slideshow

	  # Copilot
	  github.copilot
	  github.copilot-chat
        ];

        userSettings = {
	  "github.auth.useGitHubCLI" = true;
          "python.languageServer" = "Pylance";
          "python.analysis.typeCheckingMode" = "basic";

          "[python]" = {
            "editor.defaultFormatter" = "charliermarsh.ruff";
            "editor.formatOnSave" = true;
            "editor.codeActionsOnSave" = {
              "source.fixAll.ruff" = "explicit";
              "source.organizeImports.ruff" = "explicit";
            };
          };

          # Sync specific extensions to remote SSH machines automatically
          "remote.SSH.defaultExtensions" = [
            "ms-python.python"
            "ms-python.vscode-pylance"
            "charliermarsh.ruff"
            "ms-toolsai.jupyter"
          ];

	  "github.copilot.editor.enableAutoCompletions" = true;
	  "editor.inlineSuggest.enabled" = true;
        };
      };
    };
  };
}
