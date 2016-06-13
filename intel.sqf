_randomIntel = {execVM "SPAWN\IntelHint.sqf"};
_hvtIntel= {execVM "SPAWN\BOMBERHINT.sqf"};
_intelType = selectRandom [_randomIntel, _hvtIntel];
_pointRange = [60, 100, 150, 200, 300];

if (intelPoints in _pointRange ) then {
	call _intelType;
	cutText["...You found a piece of intel.  Check your Map!", "PLAIN"];
};