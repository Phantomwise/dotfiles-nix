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

		iconTheme = {
			# https://github.com/EliverLara/Sweet-folders
			name = "Sweet-Rainbow";
			# name = "Sweet-Blue-Filled";
			# name = "Sweet-Yellow";
			# name = "Sweet-Yellow-Filled";
			package = pkgs.sweet-folders;
			};

	};
}
