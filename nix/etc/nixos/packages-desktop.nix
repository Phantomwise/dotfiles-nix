{ config, pkgs, ... }:

{

	environment.systemPackages = with pkgs; [

		blender  # 3D Creation/Animation/Publishing System

	];

}
