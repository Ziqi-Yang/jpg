_jpg() {
    local recipes=$(jpg --summary 2> /dev/null)
    COMPREPLY=( $(compgen -W "${recipes}" -- "${cur}") )
}

complete -F _jpg jpg
