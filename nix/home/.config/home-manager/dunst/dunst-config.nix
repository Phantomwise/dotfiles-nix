#░███████████████████████████████████████████████████████████████╗
#░█╔════════════════════════════════════════════════════════════█║
#░█║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
#░█║░░░░░░░░██████╗░██╗░░░██╗███╗░░░██╗███████╗████████╗░░░░░░░░█║
#░█║░░░░░░░░██╔══██╗██║░░░██║████╗░░██║██╔════╝╚══██╔══╝░░░░░░░░█║
#░█║░░░░░░░░██║░░██║██║░░░██║██╔██╗░██║███████╗░░░██║░░░░░░░░░░░█║
#░█║░░░░░░░░██║░░██║██║░░░██║██║╚██╗██║╚════██║░░░██║░░░░░░░░░░░█║
#░█║░░░░░░░░██████╔╝╚██████╔╝██║░╚████║███████║░░░██║░░░░░░░░░░░█║
#░█║░░░░░░░░╚═════╝░░╚═════╝░╚═╝░░╚═══╝╚══════╝░░░╚═╝░░░░░░░░░░░█║
#░█║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░░░░░░░░░░░ Home Manager ░░░░░░░░░░░░░░░░░░░░░░░█║
#░█║░░░░░░░░░░░░░░░░░░░ Dunst configuration ░░░░░░░░░░░░░░░░░░░░█║
#░█║░░░░░░░░░░░░░░░░░░░░░░ by Phantomwise ░░░░░░░░░░░░░░░░░░░░░░█║
#░█║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
#░███████████████████████████████████████████████████████████████║
#░╚══════════════════════════════════════════════════════════════╝

{ config, pkgs, ... }:

{

services.dunst.enable = true;

# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░░ SETTINGS ░░░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝

services.dunst.settings =
	{

	#░███████████████████████████████████████████████████████████████╗
	#░█╔════════════════════════════════════════════════════════════█║
	#░█║░░░░░░░░░░░░░░░░░░░░░░░░░░ GLOBAL ░░░░░░░░░░░░░░░░░░░░░░░░░░█║
	#░███████████████████████████████████████████████████████████████║
	#░╚══════════════════════════════════════════════════════════════╝

	global = {

		#░███████████████████████████████████████████████████████████████╗
		#░█╔════════════════════════════════════════════════════════════█║
		#░█║░░░░░░░░░░░░░░░░░░░░░░░░░ DISPLAY ░░░░░░░░░░░░░░░░░░░░░░░░░░█║
		#░███████████████████████████████████████████████████████████████║
		#░╚══════════════════════════════════════════════════════════════╝

		# Which monitor should the notifications be displayed on.
		monitor = 0;

		# Display notification on focused monitor.  Possible modes are:
		#   mouse: follow mouse pointer
		#   keyboard: follow window with keyboard focus
		#   none: don't follow anything
		#
		# "keyboard" needs a window manager that exports the
		# _NET_ACTIVE_WINDOW property.
		# This should be the case for almost all modern window managers.
		#
		# If this option is set to mouse or keyboard, the monitor option
		# will be ignored.
		follow = "none";

		#░███████████████████████████████████████████████████████████████╗
		#░█╔════════════════════════════════════════════════════════════█║
		#░█║░░░░░░░░░░░░░░░░░░░░░░░░░ GEOMETRY ░░░░░░░░░░░░░░░░░░░░░░░░░█║
		#░███████████████████████████████████████████████████████████████║
		#░╚══════════════════════════════════════════════════════════════╝

		### Geometry ###

		# dynamic width from 0 to 300
		width = "(0, 500)";
		# constant width of 300
		# width = 300;

		# The maximum height of a single notification, excluding the frame.
		height = "(0, 300)";

		# Position the notification in the top right corner
		origin = "top-right";

		# Offset from the origin
		offset = "(150, 150)";

		# Scale factor. It is auto-detected if value is 0.
		scale = 0;

		# Maximum number of notification (0 means no limit)
		notification_limit = 20;

		#░███████████████████████████████████████████████████████████████╗
		#░█╔════════════════════════════════════════════════════════════█║
		#░█║░░░░░░░░░░░░░░░░░░░░░░░ PROGRESS BAR ░░░░░░░░░░░░░░░░░░░░░░░█║
		#░███████████████████████████████████████████████████████████████║
		#░╚══════════════════════════════════════════════════════════════╝

		### Progress bar ###

		# Turn on the progress bar. It appears when a progress hint is passed with
		# for example dunstify -h int:value:12
		progress_bar = true;

		# Set the progress bar height. This includes the frame, so make sure
		# it's at least twice as big as the frame width.
		progress_bar_height = 10;

		# Set the frame width of the progress bar
		progress_bar_frame_width = 1;

		# Set the minimum width for the progress bar
		progress_bar_min_width = 150;

		# Set the maximum width for the progress bar
		progress_bar_max_width = 300;

		# Corner radius for the progress bar. 0 disables rounded corners.
		progress_bar_corner_radius = 0;

		# Define which corners to round when drawing the progress bar. If progress_bar_corner_radius
		# is set to 0 this option will be ignored.
		progress_bar_corners = "all";

		};
	};

}

# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░░░░ END ░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝
