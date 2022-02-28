#!/bin/bash
#Modified from https://accounts.klei.com/assets/gamesetup/linux/run_dedicated_servers.sh

steamcmd_dir="$HOME/steamcmd"
install_dir="$HOME/Steam/steamapps/common/Don't Starve Together Dedicated Server"
if [ ! -n "$CLUSTER_NAME" ];then
	cluster_name="MyDediServer"
else
	cluster_name=$CLUSTER_NAME
fi
dontstarve_dir="$HOME/.klei/DoNotStarveTogether"

function fail()
{
	echo Error: "$@" >&2
	exit 1
}

function check_for_file()
{
	if [ ! -e "$1" ]; then
		fail "Missing file: $1"
	fi
}

cd "$steamcmd_dir" || fail "Missing $steamcmd_dir directory!"

check_for_file "steamcmd.sh"
check_for_file "$dontstarve_dir/$cluster_name/cluster.ini"
check_for_file "$dontstarve_dir/$cluster_name/cluster_token.txt"
check_for_file "$dontstarve_dir/$cluster_name/Master/server.ini"
check_for_file "$dontstarve_dir/$cluster_name/Caves/server.ini"

./steamcmd.sh +force_install_dir "$install_dir" +login anonymous +app_update 343050 validate +quit

if [ -e "$dontstarve_dir/$cluster_name/Master/modoverrides.lua" ]; then
	modlist=($(cat "$dontstarve_dir/$cluster_name/Master/modoverrides.lua" | grep -o "\[\"workshop-[0-9]*\"\]="))
	for mod in ${modlist[*]}; do echo "ServerModSetup("${mod: 1: 0-2}")">>"$install_dir/mods/dedicated_server_mods_setup.lua"; done
fi

if [ -e "$dontstarve_dir/$cluster_name/Caves/modoverrides.lua" ]; then
	modlist=($(cat "$dontstarve_dir/$cluster_name/Caves/modoverrides.lua" | grep -o "\[\"workshop-[0-9]*\"\]="))
	for mod in ${modlist[*]}; do echo "ServerModSetup("${mod: 1: 0-2}")">>"$install_dir/mods/dedicated_server_mods_setup.lua"; done
fi

check_for_file "$install_dir/bin64"

cd "$install_dir/bin64" || fail

run_shared=(./dontstarve_dedicated_server_nullrenderer_x64)
run_shared+=(-console)
run_shared+=(-cluster "$cluster_name")
run_shared+=(-monitor_parent_process $$)

nohup "${run_shared[@]}" -shard Caves >> /dev/null 2>&1 &
nohup "${run_shared[@]}" -shard Master >> /dev/null 2>&1