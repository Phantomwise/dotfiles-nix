# config.nu
#
# Installed by:
# version = "0.104.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# Aliases

	# Directories
	alias ~ = cd ~
	alias .. = cd ..
	alias cdd = cd ~/Sync/dotfiles-nix/nix/
	alias cdm = cd /run/user/1000/gvfs/smb-share:server=192.168.0.10,share=media/
	alias cdp = cd ~/Sync/Personal/home/Projects
	alias cds = cd ~/Sync/
	alias cdy = cd ~/Downloads/yt-dlp/

	# Commands replacement
	alias ll = ls -alh
	alias core-grep = grep
	alias grep = grep --color=auto
	alias core-clamscan = clamscan
	alias clamscan = clamscan -r --log=/tmp/clamscan.txt
	alias clamscan-full = clamscan -r --follow-dir-symlinks --follow-file-symlinks --log=/tmp/clamscan.txt
	alias weather = curl wttr.in
	alias nix-diff = bash -c 'nvd diff $(ls -d /nix/var/nix/profiles/system-*-link | tail -2)'

	# Nix commands
	alias hh = home-manager switch
	# alias rebuild = sudo nixos-rebuild switch
	# alias update = sudo nixos-rebuild switch --upgrade

	# Other
#	alias "path" = "echo $PATH | tr ':' '\n'" # NOTWORKING
