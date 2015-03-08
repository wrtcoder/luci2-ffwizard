
setup_olsrbase() {
	local cfg=$1
	uci_set olsrd6 $cfg AllowNoInt "yes"
	uci_set olsrd6 $cfg LinkQualityAlgorithm "etx_ffeth"
	uci_set olsrd6 $cfg FIBMetric "flat"
	uci_set olsrd6 $cfg TcRedundancy "2"
	uci_set olsrd6 $cfg Pollrate "0.025"
}

setup_InterfaceDefaults() {
	local cfg=$1
	uci_set olsrd6 $cfg MidValidityTime "500.0"
	uci_set olsrd6 $cfg TcInterval "2.0"
	uci_set olsrd6 $cfg HnaValidityTime "125.0"
	uci_set olsrd6 $cfg HelloValidityTime "125.0"
	uci_set olsrd6 $cfg TcValidityTime "500.0"
	uci_set olsrd6 $cfg MidInterval "25.0"
	uci_set olsrd6 $cfg HelloInterval "3.0"
	uci_set olsrd6 $cfg HnaInterval "10.0"
}

setup_Plugins() {
	local cfg=$1
	config_get library $cfg library
	case $library in
		*json* )
			uci_set olsrd6 $cfg accept "::1"
			uci_set olsrd6 $cfg ignore "0"
		;;
		*watchdog*)
			uci_set olsrd6 $cfg file "/var/run/olsrd.watchdog.ipv6"
			uci_set olsrd6 $cfg interval "30"
		;;
		*nameservice*)
			uci_set olsrd6 $cfg services_file "/var/etc/services.olsr.ipv6"
			uci_set olsrd6 $cfg latlon_file "/var/run/latlon.js.ipv6"
			uci_set olsrd6 $cfg hosts_file "/tmp/hosts/olsr.ipv6"
			uci_set olsrd6 $cfg suffix ".olsr"
		;;
		*)
			uci_set olsrd6 $cfg ignore "1"
		;;
	esac
}

setup_ether() {
	local cfg=$1
	config_get enabled $cfg enabled "0"
	[ "$enabled" == "0" ] && return
	config_get olsr_mesh $cfg olsr_mesh "0"
	[ "$olsr_mesh" == "0" ] && return
	config_get mesh_ip $cfg mesh_ip "0"
	[ "$mesh_ip" == "0" ] && return
	config_get device $cfg device "0"
	[ "$device" == "0" ] && return
	logger -t "ffwizard_olsrd6_ether" "Setup $cfg"
	uci_add olsrd6 Interface ; iface_sec="$CONFIG_SECTION"
	uci_set olsrd6 "$iface_sec" interface "$device"
	uci_set olsrd6 "$iface_sec" ignore "0"
	# only with LinkQualityAlgorithm=etx_ffeth
	uci_set olsrd6 "$iface_sec" Mode "ether"
	# only with LinkQualityAlgorithm=etx_ff
	#uci_set olsrd6 "$iface_sec" Mode "mesh"
	olsr_enabled=1
}

setup_wifi() {
	local cfg=$1
	config_get enabled $cfg enabled "0"
	[ "$enabled" == "0" ] && return
	config_get olsr_mesh $cfg olsr_mesh "0"
	[ "$olsr_mesh" == "0" ] && return
	config_get mesh_ip $cfg mesh_ip "0"
	[ "$mesh_ip" == "0" ] && return
	config_get device $cfg device "0"
	[ "$device" == "0" ] && return
	logger -t "ffwizard_olsrd6_wifi" "Setup $cfg"
	uci_add olsrd6 Interface ; iface_sec="$CONFIG_SECTION"
	uci_set olsrd6 "$iface_sec" interface "$device"
	uci_set olsrd6 "$iface_sec" ignore "0"
	#Shoud be mesh with LinkQualityAlgorithm=etx_ffeth
	#and LinkQualityAlgorithm=etx_ff
	uci_set olsrd6 "$iface_sec" Mode "mesh"
	olsr_enabled=1
}

remove_section() {
	local cfg=$1
	uci_remove olsrd6 $cfg
}

config_load olsrd6
#Remove wifi ifaces
config_foreach remove_section Interface
#Remove Hna's
config_foreach remove_section Hna6

local olsr_enabled=0
#Setup ether and wifi
config_load ffwizard
config_foreach setup_iface ether
config_foreach setup_wifi wifi

if [ $olsr_enabled == "1" ] ; then
	#Setup olsrd6
	config_load olsrd6
	config_foreach setup_olsrbase olsrd6
	#Setup InterfaceDefaults
	config_foreach setup_InterfaceDefaults InterfaceDefaults
	#Setup Plugin or disable
	config_foreach setup_Plugins LoadPlugin
	uci_commit olsrd6
	/etc/init.d/olsrd6 enable
else
	/sbin/uci revert olsrd6
	/etc/init.d/olsrd6 disable
fi
