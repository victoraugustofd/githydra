
# Loading source files
. bash-commons

info() {
    if ( $GH_IS_LOG_INFO_ENABLED ); then
        log ${LIGHT_BLUE} "INFO" "$@"
    fi
}

debug() {
    if ( $GH_IS_LOG_DEBUG_ENABLED ); then
        log ${GREEN} "DEBUG" "$@"
    fi
}

warn() {
    if ( $GH_IS_LOG_WARN_ENABLED ); then
        log ${YELLOW} "WARNING" "$@"
    fi
}

error() {
    if ( $GH_IS_LOG_ERROR_ENABLED ); then
        log ${LIGHT_RED} "ERROR" "$@"
    fi
    exit 1
}

fatal() {
    if ( $GH_IS_LOG_FATAL_ENABLED ); then
        log ${RED} "FATAL" "$@"
    fi
    exit 1
}

log() {
    if ( $GH_IS_LOG_ENABLED ); then
        local color=$1; shift
        local level=$1; shift
        local message=$1; shift
    
        echo -en "[${color}$level$NC] $(date +"%Y-%m-%d %H:%M:%S.%3N"): $message" >&2
    fi
}
