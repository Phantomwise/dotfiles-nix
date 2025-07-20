{ config, pkgs, lib, ... }:

{
  wayland.windowManager.sway.config.keybindings = {
    # Example keybindings
    "${config.wayland.windowManager.sway.config.modifier}+Return" = "exec kitty";
    "${config.wayland.windowManager.sway.config.modifier}+d" = "exec rofi --show drun";
    # Add your migrated keybindings here...
  };
}
