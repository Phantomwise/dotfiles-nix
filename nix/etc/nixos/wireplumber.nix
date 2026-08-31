let
	devices         = import ./var/ip.nix;
	EDIFIER_R1700BT = builtins.replaceStrings [":"] ["_"] devices.EDIFIER_R1700BT;
	JBES_A9         = builtins.replaceStrings [":"] ["_"] devices.JBES_A9;
in

{
	services.pipewire.wireplumber.extraConfig =
	{

		"98-bluetooth-priority" =
		{
			"monitor.bluez.rules" =
			[
				{
					matches =
					[
						{ "node.name" = "~bluez_output.*"; }
					];
					actions = {
						update-props =
						{
							"priority.driver" = 2000;
							"priority.session" = 2000;
						};
					};
				}
			];
		};

		"98-earbuds-volume" =
		{
			"monitor.bluez.rules" =
			[
				{
					matches = [ { "node.name" = "bluez_output.${JBES_A9}.1"; } ];
					actions.update-props = { "node.volume" = 0.2; };
				}
			];
		};

		"98-speakers-volume" =
		{
			"monitor.bluez.rules" =
			[
				{
					matches = [ { "node.name" = "bluez_output.${EDIFIER_R1700BT}.1"; } ];
					actions.update-props = { "node.volume" = 0.5; };
				}
			];
		};

	};
}
