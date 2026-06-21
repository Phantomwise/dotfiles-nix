{ config, pkgs, ... }:

{

	environment.systemPackages = with pkgs; [

		blender  # 3D Creation/Animation/Publishing System
		obs-studio  # Free and open source software for video recording and live streaming

	];

}
