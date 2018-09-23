parse_args() {
    # Define user variables
    name=$1; shift
    defined_origin=$1

    # Define command parameters
    useCommandAsPrefix=$(jq -r '.useCommandAsPrefix' <<< $command_parameters)

    # Define action parameters
    pattern=$(jq -r '.pattern' <<< $action_parameters)
    origin=$(jq -r '.origin' <<< $action_parameters)
    restrictOrigin=$(jq -r '.restrictOrigin' <<< $action_parameters)
}

main() {
    parse_args $@

    if [[ -n $pattern && ! $name =~ $pattern ]]; then
        warn "Use this name pattern: $pattern\n"
        error "Invalid name! Please enter a valid branch name!\n"
    else
        local branch_name=$name

        if [ $useCommandAsPrefix = true ]; then
            branch_name=$command/$branch_name
        fi

        if [[ $origin == "#user_definition" && -z $defined_origin ]]; then
            defined_origin=$(user_definition "Inform the origin branch: ")
        fi

        if [ -z $(retrieve_hydra_branch $restrictOrigin $defined_origin) ]; then
            error "Invalid origin! Please inform a branch of the type ${GREEN}$restrictOrigin$NC\n"
        fi

        if [ -n $defined_origin ]; then
            info "Creating a ${GREEN}$command$NC branch (${PURPLE}$branch_name$NC), based on ${PURPLE}$defined_origin$NC\n"
            git_do checkout -b $branch_name $defined_origin
        fi
    fi
}