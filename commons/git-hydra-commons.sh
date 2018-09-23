
# Loading source file
. git-commons
. git-hydra-logger

# Define Git Hydra Global variables

# Log variables
GH_IS_LOG_INFO_ENABLED=true
GH_IS_LOG_DEBUG_ENABLED=true
GH_IS_LOG_WARN_ENABLED=true
GH_IS_LOG_ERROR_ENABLED=true
GH_IS_LOG_FATAL_ENABLED=true
GH_IS_LOG_ENABLED=true

# Other variables
GH_CONFIG_PREFIX="githydra"
GH_DRAW_HYDRA=true

retrieve_installation_path() {
    echo "/usr/share/"
}

retrieve_hydra_template() {
    local template_name="hydra.json"

    cp $(retrieve_installation_path)"$template_name" .
    hydra_template=$(jq . -c $template_name)
    rm $template_name
}

retrieve_template() {
    retrieve_hydra_key "template.path"
}

retrieve_hydra_branch() {
    local branch_type=$1; shift
    local branch_name=$1

    retrieve_hydra_key "branch.$branch_type.$branch_name"
}

retrieve_hydra_key() {
    local key=$1
    git_do config --get $GH_CONFIG_PREFIX.$key
}

retrieve_hydra_key_regex() {
    local key=$1
    git_do config --get-regexp $GH_CONFIG_PREFIX.$key
}

require_template() {
    if [ -z $(retrieve_template) ]; then
        error "You must specify a template to use git hydra! Run ${GREEN}git hydra config template ${PURPLE}path_to_template$NC to configure it...\n"
    fi
}

retrieve_commands_as_map() {
    jq -c '.commands' <<< $template
}

retrieve_commands_as_json() {
    jq -c '.commands[]' <<< $template
}

retrieve_commands() {
    jq -cr '.commands | map(.name) | join(" ")' <<< $template
}

retrieve_command_actions_as_map() {
    local command=$1

    jq -c --arg COMMAND $command '.commands[] | select(.name == $COMMAND) | .actions' <<< $template
}

retrieve_command_actions_as_json() {
    local command=$1

    jq -c --arg COMMAND $command '.commands[] | select(.name == $COMMAND) | .actions[]' <<< $template
}

retrieve_command_parameters() {
    local command=$1

    jq -c --arg COMMAND $command '.commands[] | select(.name == $COMMAND) | .parameters' <<< $template
}

retrieve_command_action() {
    local command=$1; shift
    local action=$1

    jq -c --arg COMMAND $command --arg ACTION $action '.commands[] | select(.name == $COMMAND) | .actions[] | select(.name == $ACTION)' <<< $template
}

retrieve_action_execution() {
    local command=$1; shift
    local action=$1

    jq -c --arg COMMAND $command --arg ACTION $action '.commands[] | select(.name == $COMMAND) | .actions[] | select(.name == $ACTION) | .execution' <<< $template
}

retrieve_action_execution_do() {
    local command=$1; shift
    local action=$1; shift
    local step=$1

    jq -c --arg COMMAND $command --arg ACTION $action --arg STEP $step '.commands[] | select(.name == $COMMAND) | .actions[] | select(.name == $ACTION) | .execution[] | select(.step == ($STEP | tonumber)) | .do' <<< $template
}

retrieve_action_execution_do_action() {
    local do_json=$1

    jq -r '.action' <<< $do_json
}

retrieve_action_execution_do_parameters() {
    local do_json=$1

    jq -c '.parameters' <<< $do_json
}

retrieve_command_actions() {
    local command=$1

    jq -c --arg COMMAND $command '.commands[] | select(.name == $COMMAND) | .actions | map(.name) | join(" ")' <<< $template
}

validate_command() {
    local command=$1

    if [[ $(retrieve_commands) != *"$command"* ]]; then
        error "Invalid command!\n"
    fi
}

validate_action() {
    local command=$1; shift
    local action=$1

    if [[ $(retrieve_command_actions $command) != *"$action"* ]]; then
        error "Invalid action!\n"
    fi
}

read_template() {
    local template=$1

    jq -c . $template
}

is_tutorial() {
    has_no_parameters $@ || is_command_tutorial $@
}

is_command_tutorial() {
    [[ $1 = "-help" ||
       $1 = "?"     ||
       $1 = "man" ]]
}

call_help() {
    local template=$1; shift
    local xpath=$1"help[]"

    echo -e ${GREEN}
    jq -r --arg XPATH $xpath '($XPATH)' <<< $template
    echo -e $NC
}

hydra_header() {
    echo -e ${GREEN}
    echo " _  _         _"
    echo "| || |_  _ __| |_ _ __ _"
    echo "| __ | || / _\` | '_/ _\` |"
    echo "|_||_|\_, \__,_|_| \__,_|"
    echo -e "      |__/"
    echo -e $NC
}

draw_hydra() {
echo -e ${CYAN}
echo -e "       ./((((/(/"
echo -e "       /((   ,///((//"
echo -e "       ((, ,((("
echo -e "       (((*(((*///*.    ${BLUE} _  _         _${CYAN}"
echo -e "        ((((((((((((/.  ${BLUE}| || |_  _ __| |_ _ __ _${CYAN}"
echo -e "  ./(((* (((((((/  (((( ${BLUE}| __ | || / _\` | '_/ _\` |${CYAN}"
echo -e " ((  /((/  (((((((,     ${BLUE}|_||_|\_, \__,_|_| \__,_|${CYAN}"
echo -e "    ,(((/    ((((((,    ${BLUE}      |__/         ${RED}v0.0.3${CYAN}"
echo -e "   ,((((*.  .,(((((/"
echo -e "   ((((((((((((((((("
echo -e "    ((((((((((((((("
echo -e $NC
}
