{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$username$hostname$localip$shlvl$directory$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$nix_shell$conda$meson$spack$memory_usage$cmd_duration$line_break$jobs$battery$time$status$os$container$shell$character";
      battery = {
        full_symbol = "";
        charging_symbol = "⚡";
        discharging_symbol = "󰁽 ";
        unknown_symbol = "󰁽 ";
        display = [
          {
            threshold = 30;
            style = "bold red";
          }
        ];
      };

      username = {
        show_always = true;
        style_user = "fg:#8E9AAF";
        format = "[$user]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "fg:#CBC0D3";
        ssh_symbol = "";
        format = "[@$hostname]($style)";
      };

      directory = {
        style = "bold fg:#DEE2FF";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      nix_shell = {
        style = "fg:#DEE2FF";
        symbol = "❄️";
        format = " $symbol($style)";
        #format = "\\[[$symbol$state(\($name\))]($style)\\]";
      };

      git_branch = {
        style = "fg:#FEEAFA";
        format = "[$symbol$branch]($style)";
      };

      git_status = {
        conflicted = "[=](bold red)";
        ahead = "[󰁝](bold)";
        behind = "[󰁅](bold yellow)";
        diverged = "[󰹺](bold red)";
        untracked = "[](bold red)";
        stashed = "[](bold)";
        modified = "[󰇂](bold yellow)";
        staged = "[󰐕](bold green)";
        deleted = "[x](bold)";
        style = "bold";
        format = "( [\\[$all_status$ahead_behind\\]]($style))";
      };

      os.format = "\\[[$symbol]($style)\\]";

      cmd_duration = {
        disabled = true;
        min_time = 10000;
        format = "\\[[⏱ $duration]($style)\\]";
      };
    };
  };
}
