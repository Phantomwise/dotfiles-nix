{
	# Directories
	"~" = "cd ~";
	".." = "cd ..";
	cdd = "cd ~/Sync/dotfiles-nix/nix/";
	cdp = "cd ~/Sync/Personal/home/Projects";
	cds = "cd ~/Sync/";
	cdy = "cd ~/Downloads/yt-dlp/";

	# Commands replacement
	ll = "ls -alh";
	grep = "grep --color=auto";
	"clamscan" = "clamscan -r --log=/tmp/clamscan.txt";
	"clamscan-full" = "clamscan -r --follow-dir-symlinks --follow-file-symlinks --log=/tmp/clamscan.txt";
	weather = "curl wttr.in";
	nmtui="NEWT_COLORS='root=black,black;window=black,black;border=white,black;listbox=white,black;label=blue,black;checkbox=red,black;title=green,black;button=white,red;actsellistbox=white,red;actlistbox=white,gray;compactbutton=white,gray;actcheckbox=white,blue;entry=lightgray,black;textbox=blue,black' nmtui";
	# export NEWT_COLORS='root=black,black;window=black,black;border=white,black;listbox=white,black;label=blue,black;checkbox=red,black;title=green,black;button=white,red;actsellistbox=white,red;actlistbox=white,gray;compactbutton=white,gray;actcheckbox=white,blue;entry=lightgray,black;textbox=blue,black'

	# Nix commands
	hh = "home-manager switch";
	rebuild = "sudo nixos-rebuild switch";
	update = "sudo nixos-rebuild switch --upgrade";

	# Other
	"path" = "echo $PATH | tr ':' '\n'"; # NOTWORKING
}
