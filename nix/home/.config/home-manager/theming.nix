{ config, pkgs, ... }:

{

	# Set the GTK theme for GTK2 and GTK3 apps
	gtk = {
		enable = true;

		theme = {
			# https://github.com/EliverLara/Sweet
			name = "Sweet-Dark-v40";
			package = pkgs.sweet;
			};

	};
}
