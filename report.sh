#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 nip
SCRIPT_VERSION="Version: 1.0.0 [2025.11.01]"
SCRIPT_AUTHOR="Authors: nip"

set -e
umask 007

t_path_script="${0}"
t_dir_script="$(dirname "${t_path_script}")"
t_help="$(echo -e "This is script for \ncreation reports of configuration proccess for\nMikroTik products by cheat sheets in this repo\n\
	Usage:\n\
${t_path_script} <subflag>\n\n\
Subflags:\n\
	Option | Long option | SubOption | Meaning\n\
	-r | --ros-version | <major_version> | Major of RouterOS version\n\
	-f | --file | <path_to_file> | Path to report file inside reports dir\n\
	-t | --tree | | Tree of already existed reports\n\
	-d | --debug | | Debug mode - more verbose\n\
	-v | --version | | Print verion info\n\
	-h | --help | | Print help\n\n\
Requirements:\n\
- define Major of RouterOS version
- define Path to report file inside reports dir\n\n\
" | column -ts '|')"

function exit_script {
	set +x
	unset err_stat
	case ${1} in
		err)
			shift
			echo -e "\033[1;33mError!\n${@}\033[0m"
			err_stat="yes"
			;;
		warn)
			shift
			echo -e "\033[1;34mWarn!\n${@}\033[0m"
			;;
		info)
			shift
			echo -e "$@"
			;;
	esac
	for key in "${m_list_of_params}"; do
		unset ${key}
	done
	for key in $( set | awk -F\= '/^m_/ {print $1}' ) ; do
		unset ${key}
	done
	for key in $( set | awk -F\= '/^t_/ {print $1}' ) ; do
		unset ${key}
	done
	if [ -z "${err_stat}" ] ; then
		exit 0
	fi
	if [ -n "${err_stat}" -a "${err_stat}" = "yes" ] ; then
		exit 1
	fi
}

function show_details {
	if [ "${t_debug}" = "yes" ] ; then
		set -x
	fi
	:
}

function check_bin() {
	if [ -n "${1}" ] ; then
		if [ "${t_debug}" == "yes" ] ; then
			echo "${2} found"
		fi
	else
		exit_script err "${2} not found, please install it\nRtfm: ${3}"
	fi
}

function check_prereq {
	check_bin "$(command -v "tree")" "Tree bin" "GNU utils"
	:
}

trap 'exit_script info "\n\n"' SIGINT

if [[ "${@}" == *"--version"* || "${@}" == *"-v"* ]] ; then
	exit_script info "$(realpath ${0})\n${SCRIPT_VERSION}\n${SCRIPT_AUTHOR}\n\nScript description:\n${t_path_script} -h"
fi

function set_params() {
	m_templates_dir="${MIKRO_CS_TEMPLATES_DIR:-templates}"
	m_reports_dir="${MIKRO_CS_REPORTS_DIR:-reports}"
	m_ros_major="${MIKRO_CS_ROS_MAJOR}"
	m_report_file="${MIKRO_CS_REPORT_FILE}"
	:
}

set_params

while [ ! -z "${1}" ]; do
	case "${1}" in
		-r|--ros-version)
			shift
			if [ -z "${1}" ] ; then
				exit_script err "Major of RouterOS version is not defined"
			fi
			if [ ! -e "${t_dir_script}/${m_templates_dir}/${1}.md" ] ; then
				exit_script err "Template for Major of RouterOS not found"
			fi
			m_ros_major="${m_ros_major:-${1}}"
			shift
			;;
		-f|--file)
			shift
			if [ -z "${1}" ] ; then
				exit_script err "The path to the report file is not specified"
			fi
			if [ -e "${t_dir_script}/${m_reports_dir}/${1}" ] ; then
				exit_script err "Smth exists at the define report path"
			fi
			m_report_file="${m_report_file:-${1}}"
			shift
			;;
		-t|--tree)
			shift
			m_tree=True
			;;
		-d|--debug)
			shift
			t_debug="yes"
			;;
		-h|--help)
			exit_script info "${t_help}"
			;;
		*)
			exit_script info "Error flag - ${1}\n\n${t_help}"
			;;
	esac
done

function make_report {
	if [ -n "${m_ros_major}" -a -n "${m_report_file}" ] ; then
		mkdir -p "${t_dir_script}/${m_reports_dir}/$(dirname "${m_report_file}")"
		cp -a "${t_dir_script}/${m_templates_dir}/${m_ros_major}.md" "${t_dir_script}/${m_reports_dir}/${m_report_file}"
	fi
	:
}

function tree_reports {
	if [ ${m_tree} ] ; then
		tree "${t_dir_script}/${m_reports_dir}/" -P "*.md"
	fi
}

show_details
check_prereq

if [[ -z $m_tree && ( -z $m_ros_major || -z $m_report_file ) ]] ; then
	exit_script err "Please specify Major of RouterOS version & Path to report file inside reports dir or Tree flag.\nCheck help with '-h'"
fi

make_report
tree_reports
exit_script
