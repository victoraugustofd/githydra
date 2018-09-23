
count_elements() {
    local json=$1
    jq 'length' <<< $json
}

convert_result_to_json_data() {
    echo
}
