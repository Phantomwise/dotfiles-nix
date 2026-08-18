# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░░ ALIASES ░░░░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝


# Directories
export alias ~    = cd ~
export alias ..   = cd ..
export alias cdc  = cd ~/Sync/dotfiles-nix/nix/
export alias cdd  = cd ~/Sync/dotfiles-nix/nix/
export alias cddc = cd ~/Sync/Personal/home/Documents
export alias cddl = cd ~/Sync/Personal/home/Download
export alias cdg  = cd ~/Sync/Personal/home/Git
export alias cdm  = cd /run/user/1000/gvfs/smb-share:server=192.168.1.79,share=media/
export alias cdp  = cd ~/Sync/Personal/home/Projects
export alias cdpi  = cd ~/Sync/Personal/home/Pictures
export alias cds  = cd ~/Sync/
export alias cdv  = cd ~/Sync/Personal/home/Videos
export alias cdy  = cd ~/Downloads/yt-dlp/

# Commands replacement
export alias ll            = ls -alh
export alias core-grep     = grep
export alias grep          = grep --color=auto
export alias core-clamscan = clamscan
export alias clamscan      = clamscan -r --log=/tmp/clamscan.txt
export alias clamscan-full = clamscan -r --follow-dir-symlinks --follow-file-symlinks --log=/tmp/clamscan.txt
export alias weather       = curl wttr.in
export alias nix-diff      = bash -c 'nvd diff $(ls -d /nix/var/nix/profiles/system-*-link | tail -2)'

# Nix commands
export alias hh = home-manager switch
# alias rebuild = sudo nixos-rebuild switch
# alias update = sudo nixos-rebuild switch --upgrade


# ███████████████████████████████████████████████████████████████╗
# ╚══════════════════════════════════════════════════════════════╝
