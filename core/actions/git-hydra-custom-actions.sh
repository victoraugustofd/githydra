block_commits() {
    method_not_functional
}

check_branch_date() {
    method_not_functional
}

user_definition() {
    local message=$1

    info "$message"
    read entry

    echo $entry
}