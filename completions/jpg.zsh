#compdef jpg

autoload -U is-at-least

_jpg() {
    typeset -A opt_args
    local context state line

    _arguments -C \
               '1: :->command' \
               '*:: :->args'

    case $state in
        command)
            local jpg_list_output="$(_call_program commands jpg --list 2> /dev/null)"
            local cmds
            {
                read # skip first line
                while read -r line; do
                    # Extract the command name
                    local command_name=$(echo "$line" | awk '{print $1}')
                    # Extract the description (assuming it follows a '#' character)
                    local description=$(echo "$line" | cut -d'#' -f2- | xargs)
                    # Combine the command name and description in the format expected by _describe
                    cmds+=("$command_name":"$description")
                done     
            } <<< "$jpg_list_output"

            _describe -t cmds 'jpg commands' cmds
            ;;
        args)
            case $words[1] in
                config)
                    local variables; variables=("${(s. .)$(jpg --variables 2> /dev/null)}" "-a")
                    _describe -t variables 'jpg config variables' variables
                    ;;
            esac
            ;;
    esac
}

_jpg "$@"
