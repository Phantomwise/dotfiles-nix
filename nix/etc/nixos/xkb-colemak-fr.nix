{ pkgs, ... }:
let
	colemakFr = pkgs.writeText "cfr" ''
		xkb_symbols "cfr"
		{

			// Pull the standard Colemak US layout
			include "us(colemak)"

			// Enable Right Alt as a level-3 modifier for the accents
			include "level3(ralt_switch)"

			name[Group1] = "Colemak FR";

			// Override keys for accents
			key <LatA> { [ a, A, agrave, Agrave ] };
			key <LatK> { [ e, E, eacute, Eacute ] };
		}
	'';
in
{
	services.xserver.xkb.extraLayouts.cfr = {
		description = "Colemak Accented Layout";
		languages = [ "fra" ];
		symbolsFile = colemakFr;
	};
}

# NB: Not working with Sway
