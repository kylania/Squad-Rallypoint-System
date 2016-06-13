_randomIntel = {execVM "spawn\intelHint.sqf"};
_hvtIntel= {execVM "spawn\bomberHint.sqf"};
_intelType = selectRandom [_randomIntel, _hvtIntel];
_pointRange = [60, 100, 150, 200, 300];

if (intelPoints in _pointRange ) then {
	call _intelType;
	cutText["Hey! You found a piece of intel. Check your map!", "PLAIN"];
};