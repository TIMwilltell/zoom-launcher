#!/bin/zsh

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"

zoom_env(){
	if [[ "$env" == "test" ]]; then
		MEETING_FILE="./.zoom_meetings_tests" 
	else
		MEETING_FILE="$HOME/.zoom_meetings"
	fi
}

zoom_usage() {
	echo "${BOLD}Usage:${RESET} zoom [-hl] [-a name:id] [-r name] [-s name|id]"
	echo "  ${BOLD}-h help ${RESET}      Display help info"
	echo "  ${BOLD}-a name:id ${RESET}   Add a new meeting with name and ID"
	echo "  ${BOLD}-r name${RESET}       Remove a meeting by name"
	echo "  ${BOLD}-l${RESET}            List all meetings"
	echo "  ${BOLD}-s name|id${RESET}    Open a meeting by name or ID"
}

zoom() {
	zoom_env
	declare -A meetings

	if [ -f "$MEETING_FILE" ]; then 
		source -- "$MEETING_FILE"
	else
		echo "${YELLOW}Warning:${RESET} No meetings file found."
	fi 


	local old=${#meetings}
	local action=""
	local name=""
	local id=""

	while getopts "ha:r:ls:" opt; do 
		case "$opt" in 
			h) action="help" ;;
			a) action="add"; name="${OPTARG%%:*}"; id="${OPTARG##*:}" ;;
			r) action="remove"; name="$OPTARG" ;;
			l) action="list" ;;
			s) action="start"; name="$OPTARG" ;;
			*) zoom_usage; return 1 ;;
		esac 
	done 
	shift "$(($OPTIND -1))"

	case $action in 
		help) 
			zoom_usage
			return 0
			;;
		add)
			if [[ -z "$name" || -z "$id" ]]; then
				echo "${RED}Error:${RESET} Format for meeting name and id => name:id"
				return 1
			fi
			meetings["$name"]="$id"
			{
				echo "meetings=("
				for key value in ${(kv)meetings}; do
					echo " [$key]=\"$value\""
				done 
				echo ")"
			} > "$MEETING_FILE"
			if [[ ${#meetings} == $old ]]; then
				echo "${RED}Error:${RESET} That didn't work"
			else
				echo "${GREEN}Added meeting${RESET} $name ${GREEN}with ID${RESET} $id"
			fi
			return 0
			;;
		remove)
			if [[ -z "$name" ]]; then
				echo "${RED}Error:${RESET} Meeting name to remove required"
				return 1
			fi
			if [[ -n ${meetings[$name]} ]]; then
				read -q "REPLY?Are you sure you want to remove ${name}? (Y/N)" -n 1 -r 
				echo
				if [[ $REPLY =~ ^[Yy]$ ]]; then 
					# meetings=( ${(kv)meetings[(I)^$name]})
					unset "meetings[$name]"
					{
						echo "meetings=("
						for key value in ${(kv)meetings}; do
							echo " [$key]=\"${meetings[$key]}\""
						done 
						echo ")"
					} > "$MEETING_FILE"
					echo "${YELLOW}Removed meeting: $name${RESET}"
				else
					echo "Aborted!"
					return 1
				fi
			else
				echo "${RED}Error:${RESET} Meeting $name does not exist."
			fi
			return 0
			;;
		list)
			if [[ ${#meetings} -eq 0 ]]; then 
				echo "${YELLOW}No meetings saved.${RESET} Use ${GREEN}zoom -a name:id${RESET} to add a meeting."
			else
				echo "${BLUE}${BOLD}Your meetings:${BOLD}${RESET}"
				for key in ${(k)meetings}; do 
					echo " => $key "
				done
			fi
			return 0
			;;
		start)
			meeting_id=${(v)meetings[$name]}
			if [[ -z "$name" ]]; then
				echo "${RED}Error:${RESET} Expects meeting name or ID"
				zoom_usage
				return 1
			fi

			if [[ "$name" =~ ^[0-9]+$ ]]; then
				print "Launching $name..."
				open "zoommtg://zoom.us/join?confno=${name}"
			elif [[ -n "${meetings[$name]}" ]]; then
				print "Launching $name:${meeting_id}..."
				open "zoommtg://zoom.us/join?confno=${meetings[$name]}"
			else
				echo "${RED}Error:${RESET} Meeting, $meeting_name, not found"
				echo "${BLUE}Your Meetings: ${RESET}"
				for key in ${(k)meetings}; do 
					echo " - " $key 
				done 
				return 1
			fi
			;;
		*)
			if [[ -z "$1" ]]; then
				zoom_usage
				return 1
			fi
			;;
	esac 
}
