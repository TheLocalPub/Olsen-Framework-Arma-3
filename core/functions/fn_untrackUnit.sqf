/*
 * Author: Olsen
 *
 * Stop tracking of unit by framework.
 *
 * Arguments:
 * 0: unit <object>
 *
 * Return Value:
 * nothing
 *
 * Public: No
 */

#include "script_component.hpp"

params ["_unit", ["_forcedSide", sideEmpty, [sideEmpty]]];

TRACE_2("untrackUnit",_unit,_forced);
private _forced = _forcedSide isNotEqualTo sideEmpty;

if (GETVAR(_unit,Tracked,false) || {_forced}) then {
	GVAR(Teams) apply {
		_x params ["", "_side", "_type", "_total", "_current"];
		if (
            (
                (GETVAR(_unit,Side,sideUnknown)) isEqualto _side ||
                {_forced && {_forcedSide isEqualto _side}}
            ) &&
            {
                (isPlayer _unit && {_type != "ai"} )||
                {!isPlayer _unit && {_type == "ai"}}
            }
        ) exitWith {
			if (
                _forced ||
                {_unit call FUNC(isAlive)}
            ) then {
                private _newCurrent = _current - 1;
                private _newTotal = _total - 1;
                TRACE_3("Setting new alive count",_unit,_newTotal,_newCurrent);
                _x set [3, _newTotal];
                _x set [4, _newCurrent];
			};
		};
	};
	_unit setVariable [QGVAR(Side), nil];
	_unit setVariable [QGVAR(Tracked), nil];
};
