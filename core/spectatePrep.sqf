#define MESSAGE "You are dead.\nEntering spectator mode..."

if (time > spectateTempFix + 1) then {

	titleText [MESSAGE, "BLACK", 0.2];

	waitUntil {sleep 0.2; alive player};

	if (respawnTickets > 0) then {
		
		_respawnName = toLower(format ["fw_%1_respawn", side player]);
		_respawnPoint = missionNamespace getVariable [_respawnName, objNull];

		if (!isNull(_respawnPoint)) then {
		
			player setPos getPosATL _respawnPoint;
			
		};
		
		respawnTickets = respawnTickets - 1;
		
		_text = "respawns left";
		
		if (respawnTickets == 1) then {
			
			_text = "respawn left";
			
		};
		
		cutText [format ['%1 %2', respawnTickets, _text], 'PLAIN DOWN'];
		
	} else {

		player setVariable ["frameworkDead", true, true]; //Tells the framework the player is dead

		player setPos [0, 0, 0];
		[player] join grpNull;

		player setCaptive true;
		player addEventHandler ["HandleDamage", {false}];

		removeHeadgear player;
		removeGoggles player;
		removeVest player;
		removeBackpack player;
		removeUniform player;
		removeAllWeapons player;
		removeAllAssignedItems player;
		
		player addWeapon "itemMap";
		
		if (!spectating) then {
			
			[true] call acre_api_fnc_setSpectator;
			[_this select 0] call FNC_SPECTATE;
			
			
		} else {
		
			titleText [MESSAGE, "BLACK IN", 0.2];
		
		};
	};
} else {
	
	diag_log "Olsen framework warning: double killed event caught."
	
};