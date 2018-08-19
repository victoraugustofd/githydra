
# Loading Hydra rules script
. git-hydra-rules

_git_hydra() {
    case $prev in
        hydra)
            __gitcomp "$(retrieve_commands /d/desktop/hydra.json)"
            ;;
        *)
            __gitcomp "$(retrieve_actions $prev /d/desktop/hydra.json)"
    esac
}
