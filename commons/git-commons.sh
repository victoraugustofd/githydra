
# Loadin source files
. bash-commons

git_do() {
    git $@
}

require_git_repo () {
    test "$(git_do "rev-parse --is-inside-work-tree" 2>/dev/null)" = true || {
        fatal "git hydra cannot be used without a git repository.\n"
    }
}

create_branch_old() {
    branch_name=$1
    origin_branch=$2
    command="checkout -b $branch_name"

    if [ -z $origin_branch ]; then
        command="$command $origin_branch"
    fi

    git_do $command
}

retrieve_current_branch() {
    git_do "rev-parse --abbrev-ref HEAD"
}
