// Squad Rallypoint System
// Written By Schadler.C
// Updated by kylania

// Usage:
// _null = [_unit] execVM "rally.sqf";
// TODO: funtionize

// Inputs
params [["_unit", objNull], ["_searchRadius", 100]];
if (isNull _unit) exitWith {systemChat "Not a unit"};

//["error", "Not Available!", "Enemies are too close!<br/><br/>Secure the area before deploying a Rallypoint!"] call fn_display_message;
fn_display_message = {
	params["_errorType", "_errorLabel", "_errorText"];
	_textColor = switch (_errorType) do {
		case "error": {'#FF0000'};
		case "info": {'#4DB0E2'};
		default {'#000000'};
	};
	hint parseText format ["<t size='%1' color='%2'>%3</t><br/><br/>%4", _textSize, _textColor, _errorLabel, _errorText];
};

// Variables
_safeZoneMarkerName = "westSafeZone";
_safeZoneDistance = 250;
_friendlySide = west;
_neutralSide = civilian;
_enemySide = east;
_textSize = "1.5";

// Derived variables
_type = typeOf _unit;
_unitPos = _unit modelToWorld [0,2,0];
_srpPos = [_unitPos select 0, _unitPos select 1, ((getPosATL _unit) select 2)];
_safeZone = getMarkerPos _safeZoneMarkerName;
_surface = surfaceNormal _srpPos;

// Check for nearby enemies
_enemyArray = (getPosWorld _unit) nearEntities [["Man", "Car", "Motorcycle", "Tank"], _searchRadius];

	if ({side _x == _enemySide} count _enemyArray > 0) exitWith {
		systemChat "ERROR: Enemy too close";
		["error", "Not Available!", "Enemies are too close!<br/><br/>Secure the area before deploying a Rallypoint!"] call fn_display_message;
	};

// Check for nearby safezone
	if ((_unit distance _safezone) < _safeZoneDistance) exitwith {
		systemChat "ERROR: Within safezone";	
		["error", "Not Available!", "You are too close to main base to deploy a rallypoint!"] call fn_display_message;		
	};

// Check for player in vehicle
	if (vehicle _unit != player) exitwith {
		systemChat "ERROR: Within vehicle";	
		["error", "Not Available!", "You must be on foot to deploy a rallypoint!"] call fn_display_message;				
	};

// Check for Cooldowns
	if (_unit getVariable "SRS_Cooldown") exitWith {
		systemChat "ERROR: On cooldown";		
		["error", "Not Available!", "You must wait 5 minutes after placing a rally to deploy another!"] call fn_display_message;
		_unit setVariable ["SRS_Cooldown", false, true];
	};

	_unit setVariable ["SRS_Cooldown", true, true];
	systemChat "SUCCESS: Respawn!";		

	
/*
// If checks pass
	
	if (true) then {
	
		_passed = 1;
		_units = units group _unit;
		_x = count _units;
		_y = 0;
		_z = _x - 1;
		
		if (_x < 2) exitwith {
		
			_passed=0;
			hint parseText format ["<t size = '1.5' color = '#FF0000'>Not Available!</t><br/><br/>You need at least 2 squad members to place a rally!"];
			
		};
			
		while {_z > -1} do {
			
			if ((_units select _z) distance _unit > 20) then {
				
				_y = _y + 1;
				
			};
				
			if ((_y > _x - 2) and _z == 0) exitwith {
				
				_passed=0;
				hint parseText format ["<t size = '1.5' color = '#FF0000'>Not Available!</t><br/><br/>You need at least one squad member within 20m of you to place a rally!"];
				
			};
				
			_z = _z - 1
		};
			
		if (_passed == 1) then {
		
			if ((_unit == SL1) && (_type == "rhsusf_usmc_marpat_d_squadleader")) then {
				if (!(isNil "rally1")) exitWith {
					
					// Delete Existing Rallypoint
					
						deleteVehicle rally1;
						deleteMarker "rMarker1";
						srp1 call BIS_fnc_removeRespawnPosition;
					
					// Deploy New Rallypoint
					
						r1Cooldown=1;
						rally1 = createVehicle ["Land_TentDome_F", _srpPos, [], 0, "NONE"];
						rally1 setDir ((getDir _unit)-90);
						rally1 setVectorUp _surface;
						rally1 enableSimulation false;
						rally1 addEventHandler ["HandleDamage",{0}];
						
						_rMarker1 = createMarker ["rMarker1", position rally1];
						"rMarker1" setMarkerText "SRP - [Alpha]";
						"rMarker1" setmarkershape "ICON";
						"rMarker1" setMarkerType "mil_start";
						
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Placed!</t><br/><br/>It will be removed after 10 minutes!"];					
						srp1 = [(group _unit), (getPos rally1), "Squad Rally Point [Alpha]"] call bis_fnc_addRespawnPosition;
						
						sleep 300;
						r1Cooldown = 0;
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Available!</t><br/><br/>You Can Deploy It Through Scroll Menu!"];
						
						sleep 300;
						deleteVehicle rally1;
						deleteMarker "rMarker1";
						srp1 call BIS_fnc_removeRespawnPosition;
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Removed!</t><br/><br/>You Can Deploy A New One Through Scroll Menu!"];
					
				};
				
				r1Cooldown=1;
				rally1 = createVehicle ["Land_TentDome_F", _srpPos, [], 0, "NONE"];
				rally1 setDir ((getDir _unit)-90);
				rally1 setVectorUp _surface;
				rally1 enableSimulation false;
				rally1 addEventHandler ["HandleDamage",{0}];
				
				_rMarker1 = createMarker ["rMarker1", position rally1];
				"rMarker1" setMarkerText "SRP - [Alpha]";
				"rMarker1" setmarkershape "ICON";
				"rMarker1" setMarkerType "mil_start";
				
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Placed!</t><br/><br/>It will be removed after 10 minutes!"];
				srp1 = [(group _unit), (getPos rally1), "Squad Rally Point [Alpha]"] call bis_fnc_addRespawnPosition;
				
				sleep 300;
				r1Cooldown = 0;
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Available!</t><br/><br/>You Can Deploy It Through Scroll Menu!"];
				
				sleep 300;
				deleteVehicle rally1;
				deleteMarker "rMarker1";
				srp1 call BIS_fnc_removeRespawnPosition;
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Removed!</t><br/><br/>You Can Deploy A New One Through Scroll Menu!"];
				
			};
			
			if ((_unit == SL2) && (_type == "rhsusf_usmc_marpat_d_squadleader")) then {
				if (!(isNil "rally2")) exitWith {
					
					// Delete Existing Rallypoint
					
						deleteVehicle rally2;
						deleteMarker "rMarker2";
						srp2 call BIS_fnc_removeRespawnPosition;
					
					// Deploy New Rallypoint
					
						r2Cooldown=1;
						rally2 = createVehicle ["Land_TentDome_F", _srpPos, [], 0, "NONE"];
						rally2 setDir ((getDir _unit)-90);
						rally2 setVectorUp _surface;
						rally2 enableSimulation false;
						rally2 addEventHandler ["HandleDamage",{0}];
						
						_rMarker2 = createMarker ["rMarker2", position rally2];
						"rMarker2" setMarkerText "SRP - [Bravo]";
						"rMarker2" setmarkershape "ICON";
						"rMarker2" setMarkerType "mil_start";
						
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Placed!</t><br/><br/>It will be removed after 10 minutes!"];					
						srp2 = [(group _unit), (getPos rally2), "Squad Rally Point [Bravo]"] call bis_fnc_addRespawnPosition;
						
						sleep 300;
						r2Cooldown = 0;
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Available!</t><br/><br/>You Can Deploy It Through Scroll Menu!"];
						
						sleep 300;
						deleteVehicle rally2;
						deleteMarker "rMarker2";
						srp2 call BIS_fnc_removeRespawnPosition;
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Removed!</t><br/><br/>You Can Deploy A New One Through Scroll Menu!"];
					
				};
				
				r2Cooldown=1;
				rally2 = createVehicle ["Land_TentDome_F", _srpPos, [], 0, "NONE"];
				rally2 setDir ((getDir _unit)-90);
				rally2 setVectorUp _surface;
				rally2 enableSimulation false;
				rally2 addEventHandler ["HandleDamage",{0}];
				
				_rMarker2 = createMarker ["rMarker2", position rally2];
				"rMarker2" setMarkerText "SRP - [Bravo]";
				"rMarker2" setmarkershape "ICON";
				"rMarker2" setMarkerType "mil_start";
				
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Placed!</t><br/><br/>It will be removed after 10 minutes!"];
				srp2 = [(group _unit), (getPos rally2), "Squad Rally Point [Bravo]"] call bis_fnc_addRespawnPosition;
				
				sleep 300;
				r2Cooldown = 0;
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Available!</t><br/><br/>You Can Deploy It Through Scroll Menu!"];
				
				sleep 300;
				deleteVehicle rally2;
				deleteMarker "rMarker2";
				srp2 call BIS_fnc_removeRespawnPosition;
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Removed!</t><br/><br/>You Can Deploy A New One Through Scroll Menu!"];
			};	
		
			if ((_unit == SL3) && (_type == "rhsusf_usmc_marpat_d_squadleader")) then {
				if (!(isNil "rally3")) exitWith {
					
					// Delete Existing Rallypoint
					
						deleteVehicle rally3;
						deleteMarker "rMarker3";
						srp3 call BIS_fnc_removeRespawnPosition;
					
					// Deploy New Rallypoint
					
						r3Cooldown=1;
						rally3 = createVehicle ["Land_TentDome_F", _srpPos, [], 0, "NONE"];
						rally3 setDir ((getDir _unit)-90);
						rally3 setVectorUp _surface;
						rally3 enableSimulation false;
						rally3 addEventHandler ["HandleDamage",{0}];
						
						_rMarker3 = createMarker ["rMarker3", position rally3];
						"rMarker3" setMarkerText "SRP - [Charlie]";
						"rMarker3" setmarkershape "ICON";
						"rMarker3" setMarkerType "mil_start";
						
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Placed!</t><br/><br/>It will be removed after 10 minutes!"];					
						srp3 = [(group _unit), (getPos rally3), "Squad Rally Point [Charlie]"] call bis_fnc_addRespawnPosition;
						
						sleep 300;
						r3Cooldown = 0;
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Available!</t><br/><br/>You Can Deploy It Through Scroll Menu!"];
						
						sleep 300;
						deleteVehicle rally3;
						deleteMarker "rMarker3";
						srp3 call BIS_fnc_removeRespawnPosition;
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Removed!</t><br/><br/>You Can Deploy A New One Through Scroll Menu!"];
					
				};
				
				r3Cooldown=1;
				rally3 = createVehicle ["Land_TentDome_F", _srpPos, [], 0, "NONE"];
				rally3 setDir ((getDir _unit)-90);
				rally3 setVectorUp _surface;
				rally3 enableSimulation false;
				rally3 addEventHandler ["HandleDamage",{0}];
				
				_rMarker3 = createMarker ["rMarker3", position rally3];
				"rMarker3" setMarkerText "SRP - [Charlie]";
				"rMarker3" setmarkershape "ICON";
				"rMarker3" setMarkerType "mil_start";
				
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Placed!</t><br/><br/>It will be removed after 10 minutes!"];
				srp3 = [(group _unit), (getPos rally3), "Squad Rally Point [Charlie]"] call bis_fnc_addRespawnPosition;
				
				sleep 300;
				r3Cooldown = 0;
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Available!</t><br/><br/>You Can Deploy It Through Scroll Menu!"];
				
				sleep 300;
				deleteVehicle rally3;
				deleteMarker "rMarker3";
				srp3 call BIS_fnc_removeRespawnPosition;
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Removed!</t><br/><br/>You Can Deploy A New One Through Scroll Menu!"];
		
		};
	
			if ((_unit == SL4) && (_type == "rhsusf_usmc_marpat_d_crewman")) then {
				if (!(isNil "rally4")) exitWith {
					
					// Delete Existing Rallypoint
					
						deleteVehicle rally4;
						deleteMarker "rMarker4";
						srp4 call BIS_fnc_removeRespawnPosition;
					
					// Deploy New Rallypoint
					
						r4Cooldown=1;
						rally4 = createVehicle ["Land_TentDome_F", _srpPos, [], 0, "NONE"];
						rally4 setDir ((getDir _unit)-90);
						rally4 setVectorUp _surface;
						rally4 enableSimulation false;
						rally4 addEventHandler ["HandleDamage",{0}];
						
						_rMarker4 = createMarker ["rMarker4", position rally4];
						"rMarker4" setMarkerText "SRP - [Delta]";
						"rMarker4" setmarkershape "ICON";
						"rMarker4" setMarkerType "mil_start";
						
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Placed!</t><br/><br/>It will be removed after 10 minutes!"];					
						srp4 = [(group _unit), (getPos rally4), "Squad Rally Point [Delta]"] call bis_fnc_addRespawnPosition;
						
						sleep 300;
						r4Cooldown = 0;
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Available!</t><br/><br/>You Can Deploy It Through Scroll Menu!"];
						
						sleep 300;
						deleteVehicle rally4;
						deleteMarker "rMarker4";
						srp4 call BIS_fnc_removeRespawnPosition;
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Removed!</t><br/><br/>You Can Deploy A New One Through Scroll Menu!"];
					
				};
				
				r4Cooldown=1;
				rally4 = createVehicle ["Land_TentDome_F", _srpPos, [], 0, "NONE"];
				rally4 setDir ((getDir _unit)-90);
				rally4 setVectorUp _surface;
				rally4 enableSimulation false;
				rally4 addEventHandler ["HandleDamage",{0}];
				
				_rMarker4 = createMarker ["rMarker4", position rally4];
				"rMarker4" setMarkerText "SRP - [Delta]";
				"rMarker4" setmarkershape "ICON";
				"rMarker4" setMarkerType "mil_start";
				
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Placed!</t><br/><br/>It will be removed after 10 minutes!"];
				srp4 = [(group _unit), (getPos rally4), "Squad Rally Point [Delta]"] call bis_fnc_addRespawnPosition;
				
				sleep 300;
				r4Cooldown = 0;
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Available!</t><br/><br/>You Can Deploy It Through Scroll Menu!"];
				
				sleep 300;
				deleteVehicle rally4;
				deleteMarker "rMarker4";
				srp4 call BIS_fnc_removeRespawnPosition;
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Removed!</t><br/><br/>You Can Deploy A New One Through Scroll Menu!"];
				
			};
		
			if ((_unit == SL5) && (_type == "rhsusf_usmc_marpat_d_helipilot")) then {
				if (!(isNil "rally5")) exitWith {
					
					// Delete Existing Rallypoint
					
						deleteVehicle rally5;
						deleteMarker "rMarker5";
						srp5 call BIS_fnc_removeRespawnPosition;
					
					// Deploy New Rallypoint
					
						r5Cooldown=1;
						rally5 = createVehicle ["Land_TentDome_F", _srpPos, [], 0, "NONE"];
						rally5 setDir ((getDir _unit)-90);
						rally5 setVectorUp _surface;
						rally5 enableSimulation false;
						rally5 addEventHandler ["HandleDamage",{0}];
						
						_rMarker5 = createMarker ["rMarker5", position rally5];
						"rMarker5" setMarkerText "SRP - [Foxtrot]";
						"rMarker5" setmarkershape "ICON";
						"rMarker5" setMarkerType "mil_start";
						
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Placed!</t><br/><br/>It will be removed after 10 minutes!"];					
						srp5 = [(group _unit), (getPos rally5), "Squad Rally Point [Foxtrot]"] call bis_fnc_addRespawnPosition;
						
						sleep 300;
						r5Cooldown = 0;
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Available!</t><br/><br/>You Can Deploy It Through Scroll Menu!"];
						
						sleep 300;
						deleteVehicle rally5;
						deleteMarker "rMarker5";
						srp5 call BIS_fnc_removeRespawnPosition;
						hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Removed!</t><br/><br/>You Can Deploy A New One Through Scroll Menu!"];
					
				};
				
				r5Cooldown=1;
				rally5 = createVehicle ["Land_TentDome_F", _srpPos, [], 0, "NONE"];
				rally5 setDir ((getDir _unit)-90);
				rally5 setVectorUp _surface;
				rally5 enableSimulation false;
				rally5 addEventHandler ["HandleDamage",{0}];
				
				_rMarker5 = createMarker ["rMarker5", position rally5];
				"rMarker5" setMarkerText "SRP - [Foxtrot]";
				"rMarker5" setmarkershape "ICON";
				"rMarker5" setMarkerType "mil_start";
				
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Placed!</t><br/><br/>It will be removed after 10 minutes!"];
				srp5 = [(group _unit), (getPos rally5), "Squad Rally Point [Foxtrot]"] call bis_fnc_addRespawnPosition;
				
				sleep 300;
				r5Cooldown = 0;
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Available!</t><br/><br/>You Can Deploy It Through Scroll Menu!"];
				
				sleep 300;
				deleteVehicle rally5;
				deleteMarker "rMarker5";
				srp5 call BIS_fnc_removeRespawnPosition;
				hint parseText format ["<t size = '1.5' color = '#4DB0E2'>Squad Rally Point Removed!</t><br/><br/>You Can Deploy A New One Through Scroll Menu!"];
				
			};
			
		};
	};
	*/