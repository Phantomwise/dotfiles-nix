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
		offset = "(50, 50)";

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

		#░███████████████████████████████████████████████████████████████╗
		#░█╔════════════════════════════════════════════════════════════█║
		#░█║░░░░░░░░░░░░░░░░░░░░░░░░░░ OTHER ░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
		#░███████████████████████████████████████████████████████████████║
		#░╚══════════════════════════════════════════════════════════════╝

		# Corner radius for the icon image.
		icon_corner_radius = 0;

		# Define which corners to round when drawing the icon image. If icon_corner_radius
		# is set to 0 this option will be ignored.
		icon_corners = "all";

		# Show how many messages are currently hidden (because of
		# notification_limit).
		indicate_hidden = "yes"; # TO TEST

		# The transparency of the window.  Range: [0; 100].
		# This option will only work if a compositing window manager is
		# present (e.g. xcompmgr, compiz, etc.). (X11 only)
		transparency = 0;

		# Draw a line of "separator_height" pixel height between two
		# notifications.
		# Set to 0 to disable.
		# If gap_size is greater than 0, this setting will be ignored.
		separator_height = 2;

		# Padding between text and separator.
		padding = 8;

		# Horizontal padding.
		horizontal_padding = 8;

		# Padding between text and icon.
		text_icon_padding = 0;

		# Defines width in pixels of frame around the notification window.
		# Set to 0 to disable.
		frame_width = 3;

		# Defines color of the frame around the notification window.
		frame_color = "#ffffff";

		# Size of gap to display between notifications - requires a compositor.
		# If value is greater than 0, separator_height will be ignored and a border
		# of size frame_width will be drawn around each notification instead.
		# Click events on gaps do not currently propagate to applications below.
		gap_size = 0;

		# Define a color for the separator.
		# possible values are:
		#  * auto: dunst tries to find a color fitting to the background;
		#  * foreground: use the same color as the foreground;
		#  * frame: use the same color as the frame;
		#  * anything else will be interpreted as a X color.
		separator_color = "frame";

		# Sort type.
		# possible values are:
		#  * id: sort by id
		#  * urgency_ascending: sort by urgency (low then normal then critical)
		#  * urgency_descending: sort by urgency (critical then normal then low)
		#  * update: sort by update (most recent always at the top)
		sort = "yes"; # TO TEST

		# Don't remove messages, if the user is idle (no mouse or keyboard input)
		# for longer than idle_threshold seconds.
		# Set to 0 to disable.
		# A client can set the 'transient' hint to bypass this. See the rules
		# section for how to disable this if necessary
		# idle_threshold = 120

		};
	};

}

# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░░░░ END ░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝
