private["_isPackingLocked","_lastPackTime","_exitWith","_deployable","_cursorTarget"];

// set up all these variables
_exitWith = "nil";
_deployable = (_this select 3) select 0;
_cursorTarget = (_this select 3) select 1;
_lastPackTime = _cursorTarget getVariable["lastPackTime",diag_tickTime - 11];
_isPackingLocked = diag_tickTime - _lastPackTime < 10;

// check these conditions to make sure it's okay to start packing, if it's not, we'll get a message back
{
    if(_x select 0) then {
        _exitWith = (_x select 1);
    };
} forEach [
    [!(call fnc_can_do),                               format["You can't pack your %1 right now.",(_deployable call getDeployableDisplay)]],
    [(player getVariable["combattimeout", 0]) >= time, format["Can't pack a %1 while in combat!",(_deployable call getDeployableDisplay)]],
    [_isPackingLocked,                                 format["Someone just tried to pack that %1! Try again in a few seconds.",(_deployable call getDeployableDisplay)]],
    [DZE_PACKING,                                             "You are already packing something!"],
    [DZE_DEPLOYING,                                           "You are already building something!"]
];

// if we got an error message, show it and leave the script
if(_exitWith != "nil") exitWith {
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

// now we're packing it, also make the whole server knows we're packing it, so nobody else can
_cursorTarget setVariable["lastPackTime",diag_tickTime,true];
DZE_PACKING = true;

// do the crafting animation until we either finish it or one of these conditions is broken
_exitWith = [
    ["r_interrupt",                                      format["Packing %1 interrupted!",(_deployable call getDeployableDisplay)]],
    ["(player getVariable['combattimeout', 0]) >= time", format["Can't pack a %1 while in combat!",(_deployable call getDeployableDisplay)]]
] call fnc_bike_crafting_animation;

// if we got an error message, show it and leave the script
if(_exitWith != "nil") exitWith {
    DZE_PACKING = false;
    taskHint [_exitWith, DZE_COLOR_DANGER, "taskFailed"];
};

// give the stuff back and delete the vehicle
if((_deployable call getDeployableKitType) == "CfgWeapons") then {
    player addWeapon (_deployable call getDeployableKitClass);
} else {
    player addMagazine (_deployable call getDeployableKitClass);
};
deleteVehicle _cursorTarget;
player removeAction DZE_ACTION_DEPLOYABLE_PACK;
DZE_ACTION_DEPLOYABLE_PACK = -1;
DZE_PACKING = false;

// congrats!
taskHint [format["You packed your %1 back into your %2.",(_deployable call getDeployableDisplay),(_deployable call getDeployableKitDisplay)], DZE_COLOR_PRIMARY, "taskDone"];