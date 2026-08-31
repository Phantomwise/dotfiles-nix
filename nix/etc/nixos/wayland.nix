{ config, lib, pkgs, ... }:

{

	xdg.portal = {
		enable = true;
		wlr.enable = true;
		# gtk portal needed to make firefox happy
		# extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.kdePackages.xdg-desktop-portal-kde ];
		config = {
			common = {
				default = [ "gtk" ];
			};
				sway = {
					"org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
			};
		};
		# gtkUsePortal = true;
			# error:
			# The option definition `xdg.portal.gtkUsePortal' in `/home/phantomwise/SynologyDrive/dotfiles-nix/nix/etc/nixos/configuration.nix' no longer has any effect; please remove it.
			# This option has been removed due to being unsupported and discouraged by the GTK developers.
	};

}
