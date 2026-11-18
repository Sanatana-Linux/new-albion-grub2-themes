#!/usr/bin/env bash

# Exit Immediately if a command fails
set -o errexit

# Set the directory of the current script as a variable
readonly REPO_DIR="$(dirname "$(readlink -m "${0}")")"

# Source the core.sh file
source "${REPO_DIR}/core.sh"

# Usage message
usage() {
	cat <<EOF

Usage: $0 [OPTION]...

OPTIONS:
  -t, --theme     Background theme variant(s) [yerba-buena|fog|580W|golden-gate] (default is yerba-buena)
  -p, --type      Theme style variant(s)      [window|float|sharp|blur] (default is window)
  -i, --side      Picture display side        [left|right] (default is left)
  -c, --color     Background color variant(s) [dark] (default is dark)
  -s, --screen    Screen display variant(s)   [1080p|2k|4k] (default is 1080p)
  -l, --logo      Show a logo on picture      [default|system] (default: a mountain logo)

  -h, --help      Show this help

EOF
}

# Generate a theme image
# Arguments:
#   $1 - Destination directory for the generated theme
#   $2 - Background theme variant
#   $3 - Theme style variant
#   $4 - Picture display side
#   $5 - Background color variant
#   $6 - Screen display variant
generate() {
	local dest="${1}"
	local theme="${2}"
	local type="${3}"
	local side="${4}"
	local color="${5}"
	local screen="${6}"

	# Create the destination directory if it does not exist
	if [[ ! -d "${dest}" ]]; then
		echo -e "\nDestination directory does not exist. Let's make a new one..."
		mkdir -p "${dest}"
	fi

	# Create the theme directory if it does not exist
	local THEME_DIR="${dest}/${THEME_NAME}-${theme}-${type}-${side}-${color}-${screen}"
	if [[ ! -d "${THEME_DIR}" ]]; then
		echo -e "\nTheme directory does not exist. Let's make a new one..."
		mkdir -p "${THEME_DIR}"
	fi

	# Copy the files to the theme directory
	copy_files "${THEME_DIR}"

	# Inform the user that the task is finished
	prompt -s "\n Finished ..."
}

# Parse the command line arguments
while [[ $# -gt 0 ]]; do
	case "${1}" in
	# Destination directory for the generated theme
	-d | --dest)
		dest="${2}"
		shift 2
		;;
	# Background theme variant
	-t | --theme)
		shift
		for theme in "${@}"; do
			case "${theme}" in
			yerba-buena)
				themes+=("${THEME_VARIANTS[0]}")
				shift
				;;
			fog)
				themes+=("${THEME_VARIANTS[1]}")
				shift
				;;
			580W)
				themes+=("${THEME_VARIANTS[2]}")
				shift
				;;
			golden-gate)
				themes+=("${THEME_VARIANTS[3]}")
				shift
				;;
			-*)
				break
				;;
			*)
				prompt -e "ERROR: Unrecognized theme variant '$1'."
				prompt -i "Try '$0 --help' for more information."
				exit 1
				;;
			esac
		done
		;;
	# Theme style variant
	-p | --type)
		shift
		for type in "${@}"; do
			case "${type}" in
			window)
				types+=("${TYPE_VARIANTS[0]}")
				shift
				;;
			float)
				types+=("${TYPE_VARIANTS[1]}")
				shift
				;;
			sharp)
				types+=("${TYPE_VARIANTS[2]}")
				shift
				;;
			blur)
				types+=("${TYPE_VARIANTS[3]}")
				shift
				;;
			-*)
				break
				;;
			*)
				prompt -e "ERROR: Unrecognized type variant '$1'."
				prompt -i "Try '$0 --help' for more information."
				exit 1
				;;
			esac
		done
		;;
	# Picture display side
	-i | --side)
		shift
		for side in "${@}"; do
			case "${side}" in
			left)
				sides+=("${SIDE_VARIANTS[0]}")
				shift
				;;
			right)
				sides+=("${SIDE_VARIANTS[1]}")
				shift
				;;
			-*)
				break
				;;
			*)
				prompt -e "ERROR: Unrecognized side variant '$1'."
				prompt -i "Try '$0 --help' for more information."
				exit 1
				;;
			esac
		done
		;;
	# Background color variant
	-c | --color)
		shift
		for color in "${@}"; do
			case "${color}" in
			dark)
				colors+=("${COLOR_VARIANTS[0]}")
				shift
				;;
			-*)
				break
				;;
			*)
				prompt -e "ERROR: Unrecognized color variant '$1'."
				prompt -i "Try '$0 --help' for more information."
				exit 1
				;;
			esac
		done
		;;
	# Screen display variant
	-s | --screen)
		shift
		for screen in "${@}"; do
			case "${screen}" in
			1080p)
				screens+=("${SCREEN_VARIANTS[0]}")
				shift
				;;
			2k)
				screens+=("${SCREEN_VARIANTS[1]}")
				shift
				;;
			4k)
				screens+=("${SCREEN_VARIANTS[2]}")
				shift
				;;
			-*)
				break
				;;
			*)
				prompt -e "ERROR: Unrecognized screen variant '$1'."
				prompt -i "Try '$0 --help' for more information."
				exit 1
				;;
			esac
		done
		;;
	# Show a logo on the picture
	-l | --logo)
		shift
		for logo in "${@}"; do
			case "${logo}" in
			default)
				logoicon="Default"
				shift
				;;
			system)
				logoicon="$(lsb_release -i | cut -d ' ' -f 2 | cut -d '	' -f 2)"
				shift
				;;
			-*)
				break
				;;
			*)
				prompt -e "ERROR: Unrecognized logo variant '$1'."
				prompt -i "Try '$0 --help' for more information."
				exit 1
				;;
			esac
		done
		;;
	# Show the help message
	-h | --help)
		usage
		exit 0
		;;
	# Unrecognized options
	*)
		prompt -e "ERROR: Unrecognized installation option '$1'."
		prompt -i "Try '$0 --help' for more information."
		exit 1
		;;
	esac
done

# Generate the theme images
for theme in "${themes[@]-${THEME_VARIANTS[0]}}"; do
	for type in "${types[@]-${TYPE_VARIANTS[0]}}"; do
		for side in "${sides[@]-${SIDE_VARIANTS[0]}}"; do
			for color in "${colors[@]-${COLOR_VARIANTS[0]}}"; do
				for screen in "${screens[@]-${SCREEN_VARIANTS[0]}}"; do
					generate "${dest:-$REPO_DIR}" "${theme}" "${type}" "${side}" "${color}" "${screen}"
				done
			done
		done
	done
done

exit 0
