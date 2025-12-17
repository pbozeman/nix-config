{ ... }:

''
  function run_and_log
    set -l full_command $argv
    set -l timestamp (date "+%Y-%m-%d_%H-%M-%S")
    set -l command_name (basename $argv[1])
    set -l log_file "/tmp/run-log-$command_name-$timestamp.log"

    echo "Log file: $log_file"

    eval $full_command 2>&1 | \
      awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $0; fflush(); }' | \
      tee "$log_file"

    echo "Log file: $log_file"
  end

  function less_run_log
    set -l log_file_prefix "/tmp/run-log-"
    set -l log_file

    if test -n "$argv[1]"
      # If a command is provided, find the most recent log for that command.
      set -l command_name (basename $argv[1])
      set log_file (ls -Art {$log_file_prefix}{$command_name}-* 2>/dev/null | tail -n 1)
    else
      # If no command is provided, find the overall most recent log.
      set log_file (ls -Art {$log_file_prefix}* 2>/dev/null | tail -n 1)
    end

    if test -n "$log_file"
      less -F -N "$log_file"
    else
      echo "No matching run-log files found."
    end
  end

  function hf
    set -l start_dir (pwd)
    while true
      if test -f "helmfile.yaml" -o -d "helmfile.d"
        helmfile $argv
        break
      else
        if test (pwd) = "/"
          echo "No helmfile.yaml or helmfile.d found in any parent directories."
          break
        else
          cd ..
        end
      end
    end
    cd "$start_dir"
  end

  function tf
    set -l start_dir (pwd)
    while true
      if test -d .terraform
        scripts/terraform-sops.sh $argv
        break
      else
        if test (pwd) = "/"
          echo "No .terraform found in any parent directories."
          break
        else
          cd ..
        end
      end
    end
    cd "$start_dir"
  end

  function sr_f
    find . -type f -name "*.$argv[1]" -exec sed -i "s/$argv[2]/$argv[3]/g" {} \;
  end

  function wip
    set -l message "wip"
    if test (count $argv) -gt 0
      set message "$message: $argv"
    end
    git add -A; and git commit --no-verify -m "$message"
  end
''
