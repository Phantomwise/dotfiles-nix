{ config, pkgs, ... }:

{

	# Set the GTK theme for GTK2 and GTK3 apps
	gtk = {
		enable = true;

		theme = {
			# Flat Remix
				# https://github.com/daniruiz/flat-remix-gtk/tree/master/themes
				package = pkgs.flat-remix-gtk;
				name = "Flat-Remix-GTK-White-Darkest-Solid";
			# Sweet
				# https://github.com/EliverLara/Sweet
				# package = pkgs.sweet;
				# name = "Sweet-Dark-v40";
			};

		iconTheme = {
			# Material-Black
				# https://github.com/rtlewis88/rtl88-Themes/tree/material-black-COLORS
				# package = pkgs.material-black-colors;
				# name = "Material-Black-Mango-Numix";
				# name = "Material-Black-Mango-Suru";
				# name = "MB-Mango-Suru-GLOW";
			# Sweet
				# https://github.com/EliverLara/Sweet-folders
				package = pkgs.sweet-folders;
				name = "Sweet-Rainbow";
				# name = "Sweet-Blue-Filled";
				# name = "Sweet-Yellow";
				# name = "Sweet-Yellow-Filled";
			};

	};
}
