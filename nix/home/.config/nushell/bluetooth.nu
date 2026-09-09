# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░ BLUETOOTH ░░░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝


export def mac-speakers [] {
	open /etc/nixos/secrets/MAC/bluetooth/EDIFIER_R1700BT.txt | str trim
}

export def mac-earbuds [] {
	open /etc/nixos/secrets/MAC/bluetooth/JBES-A9.txt | str trim
}

export def btcs [] {
	bluetoothctl connect (mac-speakers)
}

export def btds [] {
	bluetoothctl disconnect (mac-speakers)
}

export def btce [] {
	bluetoothctl connect (mac-speakers)
}

export def btde [] {
	bluetoothctl disconnect (mac-speakers)
}


# $env.MAC_EDIFIER_R1700BT = (open /etc/nixos/secrets/MAC/bluetooth/EDIFIER_R1700BT.txt | str trim)
# $env.MAC_JBES-A9 = (open /etc/nixos/secrets/MAC/bluetooth/JBES-A9.txt | str trim)

# def btsc [file: path = "/etc/nixos/secrets/MAC/bluetooth/EDIFIER_R1700BT.txt"] {
# 	bluetoothctl connect $env.MAC_EDIFIER_R1700BT
# }

# def btsd [file: path = "/etc/nixos/secrets/MAC/bluetooth/EDIFIER_R1700BT.txt"] {
# 	bluetoothctl disconnect $env.MAC_EDIFIER_R1700BT
# }

# def btec [file: path = "/etc/nixos/secrets/MAC/bluetooth/JBES-A9.txt"] {
# 	bluetoothctl connect $env.MAC_JBES
# }

# def bted [file: path = "/etc/nixos/secrets/MAC/bluetooth/JBES-A9.txt"] {
# 	bluetoothctl connect $env.MAC_JBES
# }


# ███████████████████████████████████████████████████████████████╗
# ╚══════════════════════════════════════════════════════════════╝
