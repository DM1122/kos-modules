// ORBITER //
@lazyglobal off.

parameter
    orbitDir.      // N=0, E=90, S=180, W=270


global scriptName is "ORBITER".


// SETUP //
clearscreen.
LibSetup().
KUISetup().
KUIKonsole("RUNNING ORBITER...").
wait 3.


// LAUNCH //
FlightSetup().

FROM {local i is 3.} UNTIL i = 0 STEP {set i to i-1.} DO {      // launch countdown
  KUIKonsole("LAUNCHING IN " + i).
  wait 1.
}

KUIKonsole("LAUNCHING").
until ship:maxthrust > 0 {
	stage.
	wait 0.1.
}
wait 1.


// ASCENT //
when ship:maxthrust = 0 then {
	KUIKonsole("STAGING").
    until ship:maxthrust > 0 {
        stage.
        wait 0.1.
    }
	preserve.
}

KUIKonsole("EXECUTING GRAVITY TURN").       // gravity turn
until altitude >= 10000 {
    local trgPitch is 90 - 45 * (altitude / 10000).         // target pitch at altitude

    // if AoA() <= 5 {
    //     lock steering to heading(orbitDir, trgPitch).
    // } else {
    //     lock steering to heading(orbitDir, ProgradePitch()-5).
    // }
    lock steering to heading(orbitDir, trgPitch).

    KUIDataA1("HEADING: " + round(orbitDir,1) + "°").
    KUIDataB1("PITCH: " + round(Pitch(),2) + "°").
    KUIDataB2("TRG PITCH: " + round(trgPitch,2) + "°").
    KUIDataC1("PROGRADE: " + round(ProgradePitch(),2) + "°").
    KUIDataC2("AOA: " + round(AoA(),2) + "°").
}

KUIRefreshData().
KUIKonsole("BURNING TO APOAPSIS").

until ship:apoapsis >= 80000 {

    local pitchPID is pidloop(1, 0, 0, 0, 45).         // kP, kI, kD, min, max
    set pitchPID:setpoint to 45.
    

    local deltaPitchPID is pitchPID:update(time:seconds, ProgradePitch()).

    lock steering to heading(orbitDir, 45 + deltaPitchPID).


    KUIDataA1("APOAPSIS: " + round(ship:apoapsis/1000,2) + "km").

    KUIDataB1("PITCH: " + round(Pitch(),2) + "°").
    KUIDataB2("PROGRADE: " + round(ProgradePitch(),2) + "°").

    KUIDataC1("ERROR: " + round(pitchPID:error,2)).
    KUIDataC2("SUM ERROR: " + round(pitchPID:errorsum,2)).      // not working (?)
    
    KUIDataD1("P: " + round(pitchPID:pterm,2)).
    KUIDataD2("KP: " + pitchPID:kp).

    KUIDataE1("I: " + round(pitchPID:iterm,2)).
    KUIDataE2("KI: " + pitchPID:ki).

    KUIDataF1("D: " + round(pitchPID:dterm,2)).
    KUIDataF2("KD: " + pitchPID:kd).

    KUIDataG1("PID CORRECTION: " + round(pitchPID:output,2)).
}

KUIKonsole("CUTTING ENGINES").
lock throttle to 0.
lock steering to prograde.
wait 3.

until altitude >= body:atm:height {
    set kuniverse:timewarp:rate to 4.
    KUIKonsole("WARPING").
}
set kuniverse:timewarp:rate to 1.
wait until kuniverse:timewarp:issettled.
KUIKonsole("LEAVING ATMOSPHERE").
wait 3.


// ORBITAL INSERTION //
KUIRefreshData().
KUIKonsole("PLOTTING ORBITAL INSERTION BURN").
wait 1.

local dvBurn is CircularizationDV().
local dtBurn is BurnTime(dvBurn).
local node is node(time:seconds+eta:apoapsis, 0, 0, dvBurn).

KUIDataA1("BURN DV: " + round(dvBurn,2) + "m/s").
KUIDataB1("BURN TIME: " + round(dtBurn,2) + "s").
KUIDataB2("HALF BURN TIME: " + round(dtBurn/2,2) + "s").
add node.

wait 3.
KUIKonsole("FACING BURN VECTOR").
lock steering to node:burnvector.
wait until vang(ship:facing:vector, node:burnvector) < 0.25.


if node:eta - (dtBurn/2 + 10) > 5 {
    KUIKonsole("WARPING").
    warpto(time:seconds + (node:eta - (dtBurn/2 + 10))).
    wait until kuniverse:timewarp:warp = 0 and ship:unpacked.
}

KUIKonsole("READY TO BURN").

until node:eta <= dtBurn / 2 {
    KUIDataC1("COUNTDOWN: " + round((node:eta - dtBurn/2),2) + "s").
}

KUIKonsole("BURNING").
until node:deltav:mag <= 0.1 {
    local trgThrot is min(node:deltav:mag/MaxAcc(), 1).
    lock throttle to trgThrot.

    KUIDataC2("THROTTLE: " + round(trgThrot*100,2) + "%").
}

KUIKonsole("ORBITAL INSERTION COMPLETE").
lock throttle to 0.
lock steering to prograde.
wait until vang(ship:facing:vector, ship:prograde:vector) < 0.25.
remove node.
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


// function DeltaVStage
// {
//     parameter
//         stage.
    
//     local stages is stagescount
//     for stage in stagescount
//     {
//         DeltaVStage(stage)
//     }
// }
