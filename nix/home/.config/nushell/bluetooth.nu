# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░ BLUETOOTH ░░░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝


export def mac-speakers [] {
	open /etc/nixos/secrets/MAC/bluetooth/EDIFIER_R1700BT.txt | str trim
}

export def mac-earbuds-black [] {
	open /etc/nixos/secrets/MAC/bluetooth/JBES-A9-Black.txt | str trim
}

export def mac-earbuds-white [] {
	open /etc/nixos/secrets/MAC/bluetooth/JBES-A9-White.txt | str trim
}

export def btcs [] {
	bluetoothctl connect (mac-speakers)
}

export def btds [] {
	bluetoothctl disconnect (mac-speakers)
}

export def btceb [] {
	bluetoothctl connect (mac-earbuds-black)
}

export def btdeb [] {
	bluetoothctl disconnect (mac-earbuds-black)
}

export def btcew [] {
	bluetoothctl connect (mac-earbuds-white)
}

export def btdew [] {
	bluetoothctl disconnect (mac-earbuds-white)
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
