{ ... }:

''
  run_and_log() {
    local full_command="$*"
    local timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
    local command_name=$(echo "$full_command" | awk '{print $1}' | xargs basename)
    local log_file="/tmp/run-log-$command_name-$timestamp.log"

    echo "Log file: $log_file"

    eval "$full_command" 2>&1 | \
      awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $0; fflush(); }' | \
      tee "$log_file"

    echo "Log file: $log_file"
  }

  less_run_log() {
    local log_file_prefix="/tmp/run-log-"
    local log_file

    if [[ -n "$1" ]]; then
      # If a command is provided, find the most recent log for that command.
      local command_name=$(echo "$1" | xargs basename)
      log_file=$(ls -Art $log_file_prefix$command_name-* 2> /dev/null | tail -n 1)
    else
      # If no command is provided, find the overall most recent log.
      log_file=$(ls -Art $log_file_prefix* 2> /dev/null | tail -n 1)
    fi

    if [[ -n "$log_file" ]]; then
      less -F -N "$log_file"
    else
      echo "No matching run-log files found."
    fi
  }

  # TODO: refactor hf and tf into som common updo function.
  # I tried once, but dealing with aray arguments in bash was too much of a
  # a pita.
  hf() {
    local current_dir=$(pwd)
    while true; do
      if [ -f "helmfile.yaml" ] || [ -d "helmfile.d" ]; then
        helmfile "$@"
        break
      else
        if [ "$(pwd)" = "/" ]; then
          echo "No helmfile.yaml or helmfile.d found in any parent directories."
          break
        else
          cd ..
        fi
      fi
    done
    cd "$current_dir"
  }

  tf() {
    local current_dir=$(pwd)
    while true; do
      if [ -d .terraform ]; then
        scripts/terraform-sops.sh "$@"
        break
      else
        if [ "$(pwd)" = "/" ]; then
          echo "No .terraform found in any parent directories."
          break
        else
          cd ..
        fi
      fi
    done
    cd "$current_dir"
  }

  sr_f() {
    find . -type f -name "*.$1" -exec sed -i "s/$2/$3/g" {} \;
  }

  wip() {
    local message="wip"
    if [ $# -gt 0 ]; then
      message="$message: $*"
    fi
    git add -A && git commit --no-verify -m "$message"
  }
''
