{ ... }:

{
  home.shellAliases = {
    # don't add a newline at the top of a clear
    clear = "precmd() {precmd() {echo }} && clear && [ -n \"\$TMUX\" ] && tmux clear-history || true";

    # misc shortcuts
    e = "\${EDITOR}";
    c = "clear";
    cm = "clear && make";

    # rebuilds
    darwin-rebuild = "~/src/nix-config/bin/darwin-rebuild";
    home-rebuild = "~/src/nix-config/bin/home-build";

    # ls
    ls = "ls --color=auto -F";
    l = "ls -lh";
    ll = "ls -lh";
    la = "ls -alh";

    # movement
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # tmux
    tm = "tmux";
    tma = "tmux new-session -A -s";
    tmls = "tmux ls";
    tmd = "tmux new-session -A -s dev";

    # utils
    calc = "kalker";
    df = "duf";

    # clang format
    cf = "git -C \"$(git rev-parse --show-toplevel)\" status --porcelain | awk '{print $2}' | grep -E '\\.(h|cpp)$' | sed \"s|^|$(git rev-parse --show-toplevel)/|\" | xargs -r clang-format -i";

    #scc
    scc = "scc --cocomo-project-type embedded";

    # pio
    t = "pio test -e native -f test_native";
    tn = "pio test -e native";
    tv = "pio test -e native -vvv";
    ta = "pio test -e native -e esp32";
    td = "lldb .pio/build/native/program";
    r = "pio run";
    u = "pio run -t upload";
    m = "pio device monitor";
    um = "pio run -t upload && pio device monitor";
    pd = "pio debug --interface=gdb -- -x .pioinit";
    pc = "pio check";

    # git
    g = "git";
    ga = "git add";
    gc = "git commit";
    gca = "git commit --amend";
    gcm = "git commit -m";
    gco = "git checkout";
    gd = "git diff";
    gdc = "git diff --cached";
    gf = "git absorb";
    gfr = "git absorb --and-rebase";
    gl = "git log";
    gr = "git rebase -i --autosquash";
    grs = "git restore --staged";
    gs = "git status";
    gski = "git stash push --keep-index --include-untracked";
    gsi = "git stash push --staged";
    gsp = "git stash pop";

    lazygit = "lazygit -ucd ~/.config/lazygit";

    # Always enable colored `grep` output
    grep = "grep --color=auto";
    fgrep = "fgrep --color=auto";
    egrep = "egrep --color=auto";

    # terraform
    tff = "tf fmt";
    tfp = "tf plan";
    tfa = "tf apply";
    tfd = "tf plan";

    # k8s
    k = "kubecolor";
    hfa = "hf apply";
    hfd = "hf diff";
    hfaa = "hf apply -f helmfile.d/30-home-automation.yaml";

    # remote copy
    rpbcopy = "ssh $(echo $SSH_CLIENT | cut -f1 -d ' ') 'pbcopy'";
    tpbcopy = "tmux show-buffer | rpbcopy";
    rpb = "rpbcopy";
    tpb = "tpbcopy";

    # run and log
    rl = "run_and_log";
    lr = "less_run_log";

    dnc = "rg -U '#.*DNC.*(\n# .*)*'";
    fixme = "rg -U '#.*FIXME.*(\n# .*)*'";
    todo = "rg -U '#.*TODO.*(\n# .*)*'";
    wut = "rg -U '(#.*TODO|#.*FIXME|#.*DNC).*((\n# ).*)*'";

    # search and replace
    srv = "sr_f v";
    srsv = "sr_f sv";

    gtkwave = "command gtkwave --dark";
  };
}
