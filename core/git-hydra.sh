#!/bin/bash

# Loading Hydra commons script
. git-hydra-rules
. git-hydra-commons

usage() {
    echo
}

main() {
    if ( $GH_DRAW_HYDRA ); then
        draw_hydra
    fi

    if is_tutorial $@; then
        retrieve_hydra_template
        call_help "$hydra_template" "."
    else
        require_git_repo
        require_template

        local parameters=$@
        local command=$1; shift
        local action=$1; shift
        local template_path=$(retrieve_template)
        local template_name=$(basename $template_path)

        cp $template_path .
        template=$(read_template $template_name)
        rm $template_name

        info "Validating command...\n"
        validate_command $command
        info "Validating action...\n"
        validate_action $command $action

        info "Firing rules...\n"
        fire_rules $parameters
    fi
}

main $@
