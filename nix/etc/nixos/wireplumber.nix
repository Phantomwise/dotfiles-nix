services.pipewire.wireplumber.extraConfig."98-bluetooth-priority" = {
	"monitor.bluez.rules" = [
		{
			matches = [
				{ "node.name" = "~bluez_output.*"; }
			];
			actions = {
				update-props = {
					"priority.driver" = 2000;
					"priority.session" = 2000;
				};
			};
		}
	];
};