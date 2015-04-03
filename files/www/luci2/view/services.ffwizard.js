L.ui.view.extend({
	execute: function() {
		var self = this;

		var m = new L.cbi.Map('ffwizard', {
			caption:     L.tr('Freifunk Wizard')
		});

		var s = m.section(L.cbi.TypedSection, 'ffwizard', {
			caption:      L.tr('FF Wizard'),
		});

		s.option(L.cbi.CheckboxValue, 'enabled', {
			caption:     L.tr('Enabled'),
			initial:     0,
			enabled:     '1',
			disabled:    '0',
			optional:    false
		});

		s.option(L.cbi.InputValue, 'hostname', {
			caption:     L.tr('Hostname'),
			datatype:    'hostname',
			optional:    false
		});

		s.option(L.cbi.CheckboxValue, 'vpn', {
			caption:     L.tr('VPN'),
			description: L.tr('Störerhaftung VPN'),
			enabled:     '1',
			disabled:    '0',
			optional:    true
		});

		s.option(L.cbi.CheckboxValue, 'bbvpn', {
			caption:     L.tr('MESH VPN'),
			description: L.tr('MESH VPN für Stäte und Dörfer'),
			enabled:     '1',
			disabled:    '0',
			optional:    true
		});


		var ether_sec = m.section(L.cbi.TypedSection, 'ether', {
			caption:      L.tr('Ether Interface'),
			addremove:    true,
			add_caption:  L.tr('Add Interface …'),
		});

		ether_sec.option(L.cbi.CheckboxValue, 'enabled', {
			caption:     L.tr('Enabled'),
			initial:     0,
			enabled:     '1',
			disabled:    '0',
			optional:    false
		});

		ether_sec.option(L.cbi.InputValue, 'device', {
			caption:     L.tr('Device'),
			description: L.tr('Device Name'),
			optional:    false
		});

		ether_sec.option(L.cbi.CheckboxValue, 'olsr_mesh', {
			caption:     L.tr('Olsr Mesh'),
			description: L.tr('OLSR Mesh Protokol'),
			initial:     1,
			enabled:     '1',
			disabled:    '0',
			optional:    false
		});

		ether_sec.option(L.cbi.CheckboxValue, 'bat_mesh', {
			caption:     L.tr('Batman Mesh'),
			description: L.tr('Batman Mesh Protokol'),
			initial:     0,
			enabled:     '1',
			disabled:    '0',
			optional:    false
		});

		var wifi_sec = m.section(L.cbi.TypedSection, 'wifi', {
			caption:      L.tr('Wifi Interface'),
			addremove:    true,
			add_caption:  L.tr('Add Interface …'),
		});

		wifi_sec.option(L.cbi.CheckboxValue, 'enabled', {
			caption:     L.tr('Enabled'),
			initial:     0,
			enabled:     '1',
			disabled:    '0',
			optional:    false
		});

		wifi_sec.option(L.cbi.InputValue, 'phy_idx', {
			caption:     L.tr('Index'),
			description: L.tr('Wifi Physical Index'),
			optional:    false
		});

		wifi_sec.option(L.cbi.CheckboxValue, 'olsr_mesh', {
			caption:     L.tr('Olsr Mesh'),
			description: L.tr('OLSR Mesh Protokol'),
			initial:     1,
			enabled:     '1',
			disabled:    '0',
			optional:    false
		});

		wifi_sec.option(L.cbi.CheckboxValue, 'bat_mesh', {
			caption:     L.tr('Batman Mesh'),
			description: L.tr('Batman Mesh Protokol'),
			initial:     0,
			enabled:     '1',
			disabled:    '0',
			optional:    false
		});

		return m.insertInto('#map');
	}
});
