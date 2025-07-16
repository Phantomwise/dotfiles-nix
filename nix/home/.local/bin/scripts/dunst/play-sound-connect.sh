#!/usr/bin/env bash

# Path to the sound file
SOUND_FILE="/usr/share/sounds/phantomwise/connect.wav"

# Play the sound with pw-play (pipewire)
pw-play "$SOUND_FILE"
