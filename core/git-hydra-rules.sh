
. jq-commons
. git-hydra-commons

FILE_PREFIX="git-hydra"

fire_rules() {
    command=$1; shift
    action=$1; shift
    parameters=$@

    info "Retrieving command parameters...\n"
    command_parameters=$(retrieve_command_parameters $command)

    info "Retrieving execution...\n"
    execution=$(retrieve_action_execution $command $action)
    local numberOfExecutions=$(count_elements $execution)

    for i in $(seq 1 $numberOfExecutions); do
        local step=$i
        execution_do=$(retrieve_action_execution_do $command $action $step)
        local action_from_json=$(retrieve_action_execution_do_action $execution_do)
        local action_name=$(translate $action_from_json)

        info "Retrieving action parameters...\n"
        action_parameters=$(retrieve_action_execution_do_parameters $execution_do)

        # Loading action file
        . $FILE_PREFIX-$action_name

        info "Executing method ${GREEN}$action_from_json$NC...\n"
        main $parameters
    done
}

translate() {
    local command=$1

    case $command in
        create_branch)
            echo "checkout"
            ;;
        *)
            echo $command
    esac
}

method_not_functional() {
    warn "This method is not functional yet!\n"
}
