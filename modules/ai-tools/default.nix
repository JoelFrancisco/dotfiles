{ ... }: {
  flake.homeManagerModules.ai-tools = { pkgs, ... }: {
    home.packages = with pkgs; [
      claude-code
      gh # GitHub CLI (for copilot extension)
    ];

    programs.bash.shellAliases = {
      cy = "claude --dangerously-skip-permissions";
    };

    # OpenCode config
    home.file.".config/opencode/opencode.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      theme = "system";
      autoupdate = false;
    };
  };
}
