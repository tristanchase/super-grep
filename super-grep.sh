#!/usr/bin/env bash

#-----------------------------------
# Usage Section

#<usage>
#//Usage: super-grep [ {-d|--debug} ] [ {-h|--help} ] <pattern>
#//Description: Greps through your home directory for <pattern> and opens the results in vim
#//Examples: super-grep foo; super-grep --debug bar
#//Options:
#//	-d --debug	Enable debug mode
#//	-h --help	Display this help message
#</usage>

#<created>
# Created: 2022-02-27T16:12:40-05:00
# Tristan M. Chase <tristan.m.chase@gmail.com>
#</created>

#<depends>
# Depends on:
#  vim
#</depends>

#-----------------------------------
# TODO Section

#<todo>
# TODO
# * Insert script
# * Clean up stray ;'s
# * Modify command substitution to "$(this_style)"
# * Rename function_name() to function __function_name__ /\w+\(\)
# * Rename $variables to "${_variables}" /\$\w+/s+1 @v vEl,{n
# * Check that _variable="variable definition" (make sure it's in quotes)
# * Update usage, description, and options section
# * Update dependencies section

# DONE

#</todo>

#-----------------------------------
# License Section

#<license>
# Put license here
#</license>

#-----------------------------------
# Runtime Section

#<main>
# Initialize variables
#_temp="file.$$"

# List of temp files to clean up on exit (put last)
#_tempfiles=("${_temp}")

# Put main script here
function __main_script__ {

	# Make sure there is a <pattern> to grep; Print usage and exit if <pattern> is missing
	__needs_arg__

	# Capture the results in an array
	_chooser_array=( "$(grep -rn "${_arg}" ${HOME}/* --exclude-dir={.cache,Dropbox,Music,Pictures,Videos,Wallpapers} 2>/dev/null)" )

	# If <pattern> is not found, warn user and exit
	__arg_not_found__

	# If <pattern> was found, output the results to vim
	printf "%b\n" "${_chooser_array}" | vim -

} #end __main_script__
#</main>

#-----------------------------------
# Local functions

#<functions>

function __arg_not_found__ {
if [[ -z "${_chooser_array:-}" ]]; then
	printf "%b\n" "\"${_arg}\" not found."
	exit 1
fi
}

function __local_cleanup__ {
	:
}

function __needs_arg__ {
if [[ -z "${_arg}" ]]; then
	__usage__
fi
}

#</functions>

#-----------------------------------
# Source helper functions
for _helper_file in functions colors git-prompt; do
	if [[ ! -e ${HOME}/."${_helper_file}".sh ]]; then
		printf "%b\n" "Downloading missing script file "${_helper_file}".sh..."
		sleep 1
		wget -nv -P ${HOME} https://raw.githubusercontent.com/tristanchase/dotfiles/main/"${_helper_file}".sh
		mv ${HOME}/"${_helper_file}".sh ${HOME}/."${_helper_file}".sh
	fi
done

source ${HOME}/.functions.sh

#-----------------------------------
# Get some basic options
# TODO Make this more robust
#<options>
if [[ "${1:-}" =~ (-d|--debug) ]]; then
	__debugger__
elif [[ "${1:-}" =~ (-h|--help) ]]; then
	__usage__
else
	_arg="${1:-}"
fi
#</options>

#-----------------------------------
# Bash settings
# Same as set -euE -o pipefail
#<settings>
#set -o errexit
set -o nounset
#set -o errtrace
set -o pipefail
IFS=$'\n\t'
#</settings>

#-----------------------------------
# Main Script Wrapper
if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
	trap __traperr__ ERR
	trap __ctrl_c__ INT
	trap __cleanup__ EXIT

	__main_script__


fi

exit 0
