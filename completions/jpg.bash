_jpg() {
    local cur prev words cword
    COMPREPLY=()

    # Modules use "::" as the separator, which is considered a wordbreak character in bash.
    # The _get_comp_words_by_ref function is a hack to allow for exceptions to this rule without
    # modifying the global COMP_WORDBREAKS environment variable.
    if type _get_comp_words_by_ref &>/dev/null; then
        _get_comp_words_by_ref -n : cur prev words cword
    else
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        words=$COMP_WORDS
        cword=$COMP_CWORD
    fi

    case "${prev}" in
        jpg)
            local recipes=$(jpg --summary 2> /dev/null)
            COMPREPLY=( $(compgen -W "${recipes}" -- "${cur}") )
            return 0
            ;;
        config)
            local variables=$(jpg --variables 2> /dev/null; echo '-a')
            COMPREPLY=( $(compgen -W "${variables}" -- "${cur}") )
            return 0
            ;;
        *)
            ;;
    esac
}

# Register the completion function. The -F option specifies that _jpg is a function.
complete -F _jpg jpg
