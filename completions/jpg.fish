# subcommand reference: https://github.com/fish-shell/fish-shell/blob/master/share/completions/zig.fish
# use `functions` to view the definition of one function like `__fish_use_subcommand`

function __fish_jpg_complete_recipes
    jpg --list 2> /dev/null | tail -n +2 | awk '{
    command = $1;
    args = $0;
    desc = "";
    delim = "";
    sub(/^[[:space:]]*[^[:space:]]*/, "", args);
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", args);

    if (match(args, /#.*/)) {
    desc = substr(args, RSTART+2, RLENGTH);
    args = substr(args, 0, RSTART-1);
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", args);
    }

    gsub(/\+|=[`\'"][^`\'"]*[`\'"]/, "", args);
    gsub(/ /, ",", args);

    if (args != ""){
    args = "Args: " args;
    }

    if (args != "" && desc != "") {
    delim = "; ";
    }

    print command "\t" args delim desc
    }'
end

function __fish_jpg_complete_config_variables
    echo '-a'
    jpg --variables 2> /dev/null | tr ' ' '\n'
end


# No file completion
complete -c jpg -f

# complete recipes
complete -c jpg -n '__fish_use_subcommand' -a '(__fish_jpg_complete_recipes)'

# Parameters common to some subcommands
complete -c jpg -n '__fish_seen_subcommand_from config && __fish_prev_arg_in config' -a "(__fish_jpg_complete_config_variables)"
