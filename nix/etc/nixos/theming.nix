{ config, pkgs, ... }:

{

	environment.systemPackages = with pkgs; [
		# GTK Themes
		adwaita-dark   # Example GTK theme, replace with your favorite
		arc-theme      # Optional: install more themes
		# QT Themes
		# Icon Themes
		material-black-colors   # Material Black Colors icons
	];

	# Set the GTK theme for GTK2 and GTK3 apps
	gtk = {
		enable = true;
		theme = {
			# https://github.com/EliverLara/Sweet
			name = "Sweet-Dark-v40";
			package = pkgs.sweet;
			};
		# theme = "Adwaita-dark";   # name of the theme folder
		# iconTheme = "Papirus-Dark";  # optional
		# cursorTheme = "Breeze";      # optional
	};

}
