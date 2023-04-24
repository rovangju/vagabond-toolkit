#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s inherit_errexit

export AZURE_DEVOPS_ORG_URL="${AZURE_DEVOPS_ORG_URL:-${AZDO_ORG_SERVICE_URL:-https://dev.azure.com/axl-health/}}"
export AZURE_DEVOPS_WORKITEM_PROJECT="${AZURE_DEVOPS_WORKITEM_PROJECT:-axl-iac}"

function az(){
	command az "${@}" --output=json --org="$AZURE_DEVOPS_ORG_URL"
}

function ensure_requirements() {
    fails=()
    for req in az fzf; do
        if ! which "$req" &>/dev/null; then
            fails+=("You must install: $req")
        fi
    done
    for env in AZURE_DEVOPS_EXT_PAT AZURE_DEVOPS_ORG_URL AZURE_DEVOPS_WORKITEM_PROJECT; do
        if ! declare -p "${env}" &>/dev/null; then
            fails+=("You msut set the env var: $env")
        fi
    done
    if [[ ${#fails[@]} -gt 0 ]]; then
        {
            echo "There are fatals with your config:"
            printf -- "- %s\n" "${fails[@]}"
        } >&2
        exit 1
    fi
}

function main() {
    ensure_requirements

    if [[ ${1:-} == "create" ]]; then
        shift
        work_item_id=$(create_new_work_item "${@}")
    else
        work_item_id=$(select_work_item "${@}")
        if [[ $work_item_id == "New" ]]; then
            work_item_id=$(create_new_work_item)
        fi
    fi

    do_work_item_menu "${work_item_id}"
}

function get_work_item_title(){
	local id="${1:?You must pass in an id to query}"
	az boards work-item show --id="$id" | jq -r '.fields["System.Title"]'
}

function create_new_work_item() {
    local title="${*}"
    if [[ $title == "" ]]; then
        read -p "Enter the ticket title: " title
    fi

    description=$(get_user_long_input "Enter the description for: $title")

    read -p "Would you like to make this item a child of another? [y/N] " yn
    if [[ $yn =~ [yY] ]]; then
        parent_id=$(select_work_item)
    fi

    az_args=(
        boards work-item create
        --type=Task
	--project="$AZURE_DEVOPS_WORKITEM_PROJECT"
        --title="$title"
        --description="$description"
    )
    if ! new_id=$(az "${az_args[@]}" | jq -r '.id'); then
        echo >&2 "$new_id"
        fatal "Failed to create work item" >&2
    fi

    if [[ "${parent_id:-}" != "" ]]; then
        if ! result=$(az boards work-item relation add --id "$new_id" --target-id="$parent_id" --relation-type=parent); then
            echo >&2 "$result"
            fatal "Failed to add parent relation" >&2
        fi
    fi

    echo "$new_id"
}

function get_user_long_input() {
    local note="## ${*}"
    {
        echo ""
        echo ""
        echo "## $note"
    } |
        vipe |
        grep -vFe "$note" |
        sed -e 's_$_</br>_'
}

function select_work_item() {
    filter=$(echo "${*}")
    # https://learn.microsoft.com/en-us/cli/azure/boards?view=azure-cli-latest#az-boards-query
    query=$(
        cat <<'EOF'
        Select
            [System.Id],
            [System.Title],
            [System.State]
        From
            WorkItems
        Where
            [System.WorkItemType] = 'Task'
            AND [State] <> 'Closed'
            AND [State] <> 'Removed'
            AND [State] <> 'Done'
        order by 
            [Microsoft.VSTS.Common.Priority] asc,
            [System.CreatedDate] desc
EOF
    )
    query_results=$(az boards query --wiql="$query")

    jq_args=(
        -r
        --arg colorID $'\e[0;36m'
        --arg colorState $'\e[0;32m'
        --arg colorTitle $'\e[0;37m'
        --arg colorReset $'\e[m'
    )

    echo "$query_results" |
        jq "${jq_args[@]}" '
            . + [ {"fields":{
                "System.Id":"New",
                "System.Status":"",
                "System.Title":"Create a New Work Item"
            } }] |
            .[] |
            .fields |
            [
                $colorID + ( .["System.Id"] | tostring ) + $colorReset,
                $colorState + .["System.State"] + $colorReset,
                $colorTitle + .["System.Title"] + $colorReset
            ] | 
            join("|")
        ' |
        column -t -s '|' |
        fzf --ansi --layout=default --select-1 --query="$filter" |
        strip_color_codes |
        awk '{print $1}'
}

function strip_color_codes() {
    sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
}

function do_work_item_menu() {
    local id="$1"
    debug "Going to dispaly work item menu for: $id"

    options=(
        "${open_option:=Open $id in browser...}"
        "${comment_option:=Add a comment to $id...}"
        "${start_option:=Start/Resume/Begin work on $id}"
        "${wait_option:=Move $id into waiting/blocked state...}"
        "${done_option:=Mark $id as done/closed...}"
    )

    choice=$(printf "%s\n" "${options[@]}" | fzf --select-1)
    case "$choice" in
    "$open_option")
        open_in_browser "$id"
        ;;
    "$start_option")
        start_work_on "$id"
	if which watson &>/dev/null; then
		title=$( get_work_item_title "$id" )
		watson start "#$id: $title"
	fi
        ;;
    "$comment_option")
        comment=$(get_user_long_input "Enter your comment for $id")
        commont_on "$id" "$comment"
        ;;
    "${wait_option}")
        pause_work_on "$id"
        ;;
    "${done_option}")
        done_with_work_on "$id"
        ;;
    *)
        fatal "Invalid option selected: $choice"
        ;;
    esac
}

function open_in_browser() {
    open "${AZURE_DEVOPS_ORG_URL%/}/${AZURE_DEVOPS_WORKITEM_PROJECT}/_workitems/edit/$id/"
}

function start_work_on() {
    local id="$1"
    if ! result=$(az boards work-item update --state=Doing --assigned-to="$(get_current_user)" --id="$id"); then
        echo >&2 "$result"
        echo >&2
        fatal "Failed to start work on $id: ${AZURE_DEVOPS_ORG_URL}${AZURE_DEVOPS_WORKITEM_PROJECT}/_workitems/edit/$id"
    fi
    echo >&2 "Started work on $id! ${AZURE_DEVOPS_ORG_URL}${AZURE_DEVOPS_WORKITEM_PROJECT}/_workitems/edit/$id"
}

function pause_work_on() {
    local id="$1"
    read -p "Why are you pausing work on $id? " reason
    if ! result=$(az boards work-item update --state=Waiting --assigned-to="$(get_current_user)" --id="$id" --discussion="$reason"); then
        echo >&2 "$result"
        echo >&2
        fatal "Failed to pause $id: ${AZURE_DEVOPS_ORG_URL}${AZURE_DEVOPS_WORKITEM_PROJECT}/_workitems/edit/$id"
    fi
    echo >&2 "Paused $id! ${AZURE_DEVOPS_ORG_URL}${AZURE_DEVOPS_WORKITEM_PROJECT}/_workitems/edit/$id"
}

function done_with_work_on() {
    local id="$1"
    read -p "Any closing comments for $id? " comments
    if ! result=$(az boards work-item update --state=Done --id="$id" --discussion="$comments"); then
        echo >&2 "$result"
        echo >&2
        fatal "Failed to close $id: ${AZURE_DEVOPS_ORG_URL}${AZURE_DEVOPS_WORKITEM_PROJECT}/_workitems/edit/$id"
    fi
    echo >&2 "Closed $id! ${AZURE_DEVOPS_ORG_URL}${AZURE_DEVOPS_WORKITEM_PROJECT}/_workitems/edit/$id"
}

function commont_on() {
    local id="$1"
    local comment="$2"
    if ! result=$(az boards work-item update --id="$id" --discussion="$comment"); then
        echo >&2 "$result"
        echo >&2
        fatal "Failed to comment on $id: ${AZURE_DEVOPS_ORG_URL}${AZURE_DEVOPS_WORKITEM_PROJECT}/_workitems/edit/$id"
    fi
    echo >&2 "Commented on $id! ${AZURE_DEVOPS_ORG_URL}${AZURE_DEVOPS_WORKITEM_PROJECT}/_workitems/edit/$id"
    echo >&2 "${comment}"
}

function debug() {
    if [[ ${LOG_DEBUG:-false} == true ]]; then
        level=debug log "${@}"
    fi
}

function get_current_user() {
    curl --silent --fail -u :"${AZURE_DEVOPS_EXT_PAT}" "${AZURE_DEVOPS_ORG_URL}/_apis/ConnectionData" |
        jq -r '.authenticatedUser.providerDisplayName'
}

function log() {
    echo >&2 "${level:-INFO}: ${*}"
}

function fatal() {
    echo >&2 "FATAL: ${*}"
    exit 1
}

main "${@}"

