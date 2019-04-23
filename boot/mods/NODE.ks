// MANEUVER NODE EXCECUTIONER //
@lazyglobal off.

global scriptName is "NODE".

// SETUP //
clearscreen.
LibSetup().
KUISetup().
KUIKonsole("RUNNING NODE...").
wait 3.

local node is nextnode.
local dvBurn is node:deltav:mag.
local dtBurn is BurnTime(dvBurn).

KUIKonsole("MANEUVER INFO ACQUIRED").
KUIDataA1("BURN DV: " + round(dvBurn,2) + "m/s").
KUIDataB1("BURN TIME: " + round(dtBurn,2) + "s").
KUIDataB2("HALF BURN TIME: " + round(dtBurn/2,2) + "s").
wait 3.

// MANEUVER //
KUIKonsole("FACING BURN VECTOR").
lock steering to node:burnvector.
wait until vang(ship:facing:vector, node:burnvector) < 0.25.

KUIKonsole("WARPING").
warpto(time:seconds + (node:eta - (dtBurn/2 + 10))).
wait until kuniverse:timewarp:warp = 0 and ship:unpacked.
KUIKonsole("READY TO BURN").

until node:eta <= dtBurn / 2 {
    KUIDataC1("COUNTDOWN: " + round((node:eta - dtBurn/2),2) + "s").
}

when ship:maxthrust = 0 then {
	KUIKonsole("STAGING").
    until ship:maxthrust > 0 {
        stage.
        wait 0.1.
    }
	preserve.
}

KUIKonsole("BURNING").
KUIclearln(8).
until node:deltav:mag <= 0.1 {
    // throttle is 100% until there is less than 1 second of time left to burn
    // when there is less than 1 second - decrease the throttle linearly
    local trgThrot is min(node:deltav:mag/MaxAcc(), 1).
    lock throttle to trgThrot.

    KUIDataC1("THROTTLE: " + round(trgThrot*100,2) + "%").
}

KUIKonsole("MANEUVER COMPLETE").
lock throttle to 0.
lock steering to prograde.
wait until vang(ship:facing:vector, ship:prograde:vector) < 0.25.
wait 3.

FlightShutdown().


// FUNCTIONS //
function LibSetup
{
    cd("1:/libs").
    local libs is 0.
    list files in libs.
    for lib in libs
    {
        runoncepath(lib).
        print lib + " successfully added!".
        wait 0.1.
    }
}



