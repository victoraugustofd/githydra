
main() {
    origin=$(jq -r '.origin' <<< $execution_do)

    #if [ -n $origin ]; then
    #    origin_merge $@
    #else
    destination_merge $@
    #fi
}

origin_merge() {
    local branch_name=""
    local defined_origin=$1
    local origin=$(jq -r '.origin' <<< $execution_do)
    local useCommandAsName=$(jq -r '.useCommandAsName' <<< $execution_do)
    local restrictOrigin=$(jq -r '.restrictOrigin' <<< $execution_do)

    if [ -z $useCommandAsName ]; then
        branch_name=$command
    fi

    if [[ $origin == "#user_definition" && -z $defined_origin ]]; then
        defined_origin=$(user_definition "Inform the origin branch: ")
    fi

    if [ -n $restrictOrigin ]; then
        if [ -z $(retrieve_hydra_branch $restrictOrigin $defined_origin) ]; then
            error "Invalid origin! Please inform a branch of the type ${GREEN}$restrictOrigin$NC\n"
        fi
    fi

    info "Merging ${PURPLE}$defined_origin$NC into ${PURPLE}$branch_name$NC...\n"
    info "Checking out ${PURPLE}$branch_name$NC...\n"
    git_do checkout $branch_name
    info "Updating it...\n"
    git_do pull
    info "Executing merge...\n"
    git_do merge $defined_origin
}

destination_merge() {
    # Define user variables
    local name=$1; shift
    local defined_destination=$1

    # Define command parameters
    local useCommandAsPrefix=$(jq -r '.useCommandAsPrefix' <<< $command_parameters)

    # Define action parameters
    local destination=$(jq -r '.destination' <<< $action_parameters)
    local restrictDestination=$(jq -r '.restrictDestination' <<< $action_parameters)
    local delete=$(jq -r '.delete' <<< $action_parameters)

    local branch_name=$name

    if [ $useCommandAsPrefix = true ]; then
        branch_name=$command/$branch_name
    fi

    if [[ ${destination[*]} == *"#user_definition"* && -z $defined_destination ]]; then
        defined_destination=$(user_definition "Inform the destination branch: ")
        destination[0]=$defined_destination
    fi

    if [ -n $restrictDestination ]; then
        if [ -z $(retrieve_hydra_branch $restrictDestination $defined_destination) ]; then
            error "Invalid destination! Please inform a branch of the type ${GREEN}$restrictDestination$NC\n"
        fi
    fi

    for branch in $destination; do
        info "Merging ${PURPLE}$branch_name$NC into ${PURPLE}$branch$NC...\n"
        info "Checking out ${PURPLE}$branch$NC...\n"
        git_do checkout $branch
        info "Updating it...\n"
        git_do pull
        info "Executing merge...\n"
        git_do merge $branch_name
    done

    if [ $delete = true ]; then
        info "Deleting ${GREEN}local$NC branch ${PURPLE}$branch_name$NC...\n"
        git_do branch -D $branch_name
    fi
}