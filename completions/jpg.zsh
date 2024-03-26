#compdef jpg

autoload -U is-at-least

_jpg() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line

    _arguments '1: :_jpg_commands' \
        '*: :->args' \
        && ret=0

    case $state in
        args)
            curcontext="${curcontext%:*}-${words[2]}:"

            local lastarg=${words[${#words}]}
            local recipe

            local cmds; cmds=(
                ${(s: :)$(_call_program commands jpg --summary)}
            )

            # Find first recipe name
            for ((i = 2; i < $#words; i++ )) do
                if [[ ${cmds[(I)${words[i]}]} -gt 0 ]]; then
                    recipe=${words[i]}
                    break
                fi
            done

            if [[ $lastarg = */* ]]; then
                # Arguments contain slash would be recognised as a file
                _arguments -s -S $common '*:: :_files'
            elif [[ $lastarg = *=* ]]; then
                # Arguments contain equal would be recognised as a variable
                _message "value"
            elif [[ $recipe ]]; then
                # Show usage message
                _message "`jpg --show $recipe`"
                # Or complete with other commands
                #_arguments -s -S $common '*:: :_jpg_commands'
            else
                _arguments -s -S $common '*:: :_jpg_commands'
            fi
        ;;
    esac

    return ret
}

(( $+functions[_jpg_commands] )) ||
_jpg_commands() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local variables; variables=(
        ${(s: :)$(_call_program commands jpg --variables)}
    )
    local commands; commands=(
        ${${${(M)"${(f)$(_call_program commands jpg --list)}":#    *}/ ##/}/ ##/:Args: }
    )

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            *) _message 'value' && ret=0 ;;
        esac
    else
        _describe -t variables 'variables' variables -qS "=" && ret=0
        _describe -t commands 'jpg commands' commands "$@"
    fi

}

(( $+functions[_jpg_variables] )) ||
_jpg_variables() {
    [[ $PREFIX = -* ]] && return 1
    integer ret=1
    local variables; variables=(
        ${(s: :)$(_call_program commands jpg --variables)}
    )

    if compset -P '*='; then
        case "${${words[-1]%=*}#*=}" in
            *) _message 'value' && ret=0 ;;
        esac
    else
        _describe -t variables 'variables' variables && ret=0
    fi

    return ret
}

_jpg "$@"
