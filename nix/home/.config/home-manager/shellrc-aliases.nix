{
	# Directories
	"~" = "cd ~";
	".." = "cd ..";
	cdd = "cd ~/Sync/SynologyDrive/dotfiles-nix/nix/";
	cds = "cd ~/Sync/SynologyDrive/";
	cdy = "cd ~/Downloads/yt-dlp/";

	# Commands replacement
	ll = "ls -alh";
	grep = "grep --color=auto";
	"clamscan" = "clamscan -r --log=/tmp/clamscan.txt";
	"clamscan-full" = "clamscan -r --follow-dir-symlinks --follow-file-symlinks --log=/tmp/clamscan.txt";

	# Nix commands
	hh = "home-manager switch";
	rebuild = "sudo nixos-rebuild switch";
	update = "sudo nixos-rebuild switch --upgrade";

	# Other
	"echo $PATH" = "echo $PATH | tr ':' '\n'"; # NOTWORKING
}
