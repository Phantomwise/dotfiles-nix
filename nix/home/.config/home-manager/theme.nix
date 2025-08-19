{ config, pkgs, ... }:

{

	# Set the GTK theme for GTK2 and GTK3 apps
	gtk = {
		enable = true;

		theme = {
			# Flat Remix
			# https://github.com/daniruiz/flat-remix-gtk/tree/master/themes
			name = "Flat-Remix-GTK-White-Darkest-Solid";
			package = pkgs.flat-remix-gtk;
			# https://github.com/EliverLara/Sweet
			# name = "Sweet-Dark-v40";
			# package = pkgs.sweet;
			};

		iconTheme = {
			# Material-Black
			# https://github.com/rtlewis88/rtl88-Themes/tree/material-black-COLORS
			# name = "Material-Black-Mango-Numix";
			# name = "Material-Black-Mango-Suru";
			# name = "MB-Mango-Suru-GLOW";
			# package = pkgs.material-black-colors;
			# https://github.com/EliverLara/Sweet-folders
			name = "Sweet-Rainbow";
			# name = "Sweet-Blue-Filled";
			# name = "Sweet-Yellow";
			# name = "Sweet-Yellow-Filled";
			package = pkgs.sweet-folders;
			};

	};
}
