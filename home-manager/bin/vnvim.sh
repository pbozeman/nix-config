#/bin/sh

FILE="$1"
LINE="$2"

export LD_LIBRARY_PATH=""
export NVIM_LISTEN_ADDRESS="/tmp/nvim-vivado.sock"

export FLAGS_assignment_statement_alignment=align
export FLAGS_case_items_alignment=align
export FLAGS_class_member_variable_alignment=align
export FLAGS_column_limit=80
export FLAGS_distribution_items_alignment=align
export FLAGS_enum_assignment_statement_alignment=align
export FLAGS_formal_parameters_alignment=align
export FLAGS_formal_parameters_indentation=wrap
export FLAGS_indentation_spaces=2
export FLAGS_module_net_variable_alignment=align
export FLAGS_named_parameter_alignment=align
export FLAGS_named_port_alignment=align
export FLAGS_port_declarations_alignment=align
export FLAGS_port_declarations_indentation=wrap
export FLAGS_struct_union_members_alignment=align
export FLAGS_try_wrap_long_lines=true
export FLAGS_wrap_end_else_clauses=false
export FLAGS_wrap_spaces=4

if [ -z "$FILE" ]; then
    # If no file is provided, just open Neovim
    nvim --server "$NVIM_LISTEN_ADDRESS" --remote
else
    # Open the specified file
    nvim --server "$NVIM_LISTEN_ADDRESS" --remote "$FILE"

    # If a line number is provided, jump to it
    if [ -n "$LINE" ]; then
        nvim --server "$NVIM_LISTEN_ADDRESS" --remote-send "<Esc>:${LINE}<CR>"
    fi
fi
