// MANEUVER NODE EXCECUTIONER //
@lazyglobal off.

global scriptName is "NODE".


// SETUP //
clearscreen.
LibSetup().
KUISetup().
KUIKonsole("RUNNING NODE...").
wait 3.


// PLOT //
local node is nextnode.
local dvBurn is node:deltav:mag.
local dtBurn is BurnTime(dvBurn).

KUIKonsole("MANEUVER INFO ACQUIRED").
KUIDataA1("BURN DV: " + round(dvBurn,2) + "m/s").
KUIDataB1("BURN TIME: " + round(dtBurn,2) + "s").
KUIDataB2("HALF BURN TIME: " + round(dtBurn/2,2) + "s").
wait 3.


// PREPARATION //
KUIKonsole("FACING BURN VECTOR").
lock steering to node:burnvector.
wait until vang(ship:facing:vector, node:burnvector) < 0.25.

if node:eta - (dtBurn/2 + 20) > 5 {
    KUIKonsole("WARPING").
    warpto(time:seconds + (node:eta - (dtBurn/2 + 20))).
    wait until kuniverse:timewarp:warp = 0 and ship:unpacked.
}

KUIKonsole("READY TO BURN").


// EXECUTION //
until node:eta <= dtBurn / 2
{
    KUIDataC1("COUNTDOWN: " + round((node:eta - dtBurn/2),2) + "s").
}

Staging().
KUIKonsole("BURNING").

local trgThrot is 0.
until node:deltav:mag <= 0.1
{
    if MaxAcc() <> 0
    {
        set trgThrot to min(node:deltav:mag/MaxAcc(), 1).
    }
    
    lock throttle to trgThrot.

    KUIDataC1("THROTTLE: " + round(trgThrot*100,2) + "%").
}

KUIKonsole("MANEUVER COMPLETE").

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



