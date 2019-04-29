// ORBITER //
@lazyglobal off.

parameter
    orbDir is 90.      // N=0, E=90, S=180, W=270


global scriptName is "ORBITER".
global debug is true.

local orbAlt is 80000.
local pitchAlt is 35000.


// SETUP //
clearscreen.
LibSetup().
KUISetup().
KUIKonsole("RUNNING ORBITER...").
wait 3.


// LAUNCH //
FlightSetup().

from {local i is 3.} until i = 0 step {set i to i-1.} do {      // launch countdown
  KUIKonsole("LAUNCHING IN " + i).
  wait 0.5.
}

KUIKonsole("LAUNCHING").
until ship:availablethrust > 0 {
	stage.
	wait 0.1.
}


// RUN MODES //
Staging().

local dVData is lexicon().
dvData:add("consumed",0).
dvData:add("gain",0).
dvData:add("loss",0).
dvData:add("eff",0).

local forces is lexicon().
forces:add("Fg",v(0,0,0)).
forces:add("Ft",v(0,0,0)).
forces:add("Fd",v(0,0,0)).
forces:add("Fnet",v(0,0,0)).
forces:add("netAcc",v(0,0,0)).


// Ascent
local prevT is time:seconds.
local prevVel is ship:velocity:surface.

until ship:altitude > pitchAlt
{
    set steering to heading(orbDir, 90 - 90 * (altitude/pitchAlt)).

    UpdateForces().
    
    KUIKonsole("ASCENDING").
    UpdateUIAscent().
}
KUIRefreshData().

// Burn to Apoapsis
local pitchPID is pidloop(1.5, 0.25, 0.5, 0, 90).         // kP, kI, kD, min, max
set pitchPID:setpoint to 0.

until ship:apoapsis >= orbAlt       
{
    local deltaPitchPID is pitchPID:update(time:seconds, ProgradePitch()).
    set steering to heading(orbDir, 0 + deltaPitchPID).
    
    KUIKonsole("BURNING TO APOAPSIS").
    UpdateUIPID().
}
KUIRefreshData().


// Atmospheric Escape
KUIKonsole("CUTTING ENGINES").
set throttle to 0.
lock steering to prograde.
wait until vang(ship:facing:vector, ship:prograde:vector) < 0.25.

until ship:altitude >= body:atm:height
{
    set kuniverse:timewarp:rate to 4.
    KUIKonsole("COASTING").
}

set kuniverse:timewarp:rate to 1.
KUIKonsole("LEAVING ATMOSPHERE").
wait 3.


// Orbital Plot
KUIKonsole("PLOTTING ORBITAL INSERTION BURN").
wait 1.
local dvBurn is CircularizationDV().
local dtBurn is BurnTime(dvBurn).
local node is node(time:seconds+eta:apoapsis, 0, 0, dvBurn).

KUIDataA1("BURN DV: " + round(dvBurn,2) + "m/s").
KUIDataB1("BURN TIME: " + round(dtBurn,2) + "s").
KUIDataB2("HALF BURN TIME: " + round(dtBurn/2,2) + "s").
add node.

wait 2.
KUIKonsole("FACING BURN VECTOR").
lock steering to node:burnvector.
wait until vang(ship:facing:vector, node:burnvector) < 0.25.


if node:eta - (dtBurn/2 + 10) > 5 {
    KUIKonsole("WARPING").
    warpto(time:seconds + (node:eta - (dtBurn/2 + 10))).
    wait until kuniverse:timewarp:warp = 0 and ship:unpacked.
}

KUIKonsole("READY TO BURN").


// Orbital Insertion
until node:eta <= dtBurn / 2
{
    KUIDataC1("COUNTDOWN: " + round((node:eta - dtBurn/2),2) + "s").
}

KUIKonsole("BURNING").
until node:deltav:mag <= 0.1
{
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

function UpdateForces
{
    // sample elapsed time
    local dT is time:seconds - prevT.
    if dT <> 0
    {
        set forces["Fg"] to -1*up:vector * (body:mu * ShipMass() / (ship:altitude+body:radius)^2).        // Fg = GMm/r^2

        local engs is 0.
        set forces["Ft"] to v(0,0,0).       // reset thrust force 
        list engines in engs.
        for eng in engs {
            set forces["Ft"] to forces["Ft"] + (ship:facing:vector * eng:thrust*1000).
        }

        set forces["netAcc"] to (ship:velocity:surface - prevVel) / dt.         // derive net acc from change of velocity over time
        // set forces["netAcc"] to (forces["netAcc"] + ((ship:velocity:surface-prevVel)/dt))/2. 		// averaged to reduce noise
        set forces["Fnet"] to ShipMass() * forces["netAcc"].         // F = ma 

        if ship:status <> "LANDED" or ship:status <> "SPLASHED" or ship:status <> "PRELAUNCH"
        {
		    set forces["Fd"] to forces["Fnet"] - forces["Ft"] - forces["Fg"].
        } else {
            set forces["Fd"] to v(0,0,0).
        }
        

	    // update dv data
        set dvData["consumed"] to dvData["consumed"] +  forces["Ft"]:mag/ShipMass() * dt.      // dv from area under acceleration-time
        set dvData["gain"] to dvData["gain"] + vdot(ship:velocity:orbit:normalized, forces["netAcc"]).        // velocity inputted directly into orbit (?) 
        set dvData["loss"] to dvData["consumed"] - dvData["gain"].
        set dvData["eff"] to dvData["gain"] / dvData["consumed"].
        
        // show vector arrows
	    if debug { DrawVec(). }
    }

    // store current time and velocity for the next time step
    set prevVel to ship:velocity:surface.
    set prevT to time:seconds.
}


function UpdateUIAscent
{
    KUIDataA1("HEADING: " + orbDir + "°").
    KUIDataA2("APOAPSIS: " + round(ship:apoapsis/1000,2) + "km").
    
    KUIDataB1("PITCH: " + round(Pitch(),2) + "°").
    KUIDataB2("TRG PITCH: " + round(0,2) + "°").
    
    KUIDataC1("PROGRADE: " + round(ProgradePitch(),2) + "°").
    KUIDataC2("AOA: " + round(AoA(),2) + "°").
    
    KUIDataE1("DV CONSUMED: " + round(dvData["consumed"],2)).
    KUIDataE2("DV EFF: " + round((100*dvData["eff"]),2) + "%").
    
    KUIDataF1("DV GAIN: " + round(dvData["gain"],2)).
    KUIDataF2("DV LOSS: " + round(dvData["loss"],2)).
}

function UpdateUIPID
{
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

function DrawVec
{
    clearvecdraws().

    vecdraw(v(0,0,0), forces["Fg"]*0.00001, purple, "Fg "+(round(forces["Fg"]:mag/1000))+"kN", 5.0, true, 0.1).
    vecdraw(v(0,0,0), forces["Ft"]*0.00001, green, "Ft "+(round(forces["Ft"]:mag/1000))+"kN", 5.0, true, 0.1).
    vecdraw(v(0,0,0), forces["Fd"]*0.00001, red, "Fd "+(round(forces["Fd"]:mag/1000))+"kN", 5.0, true, 0.1).
    vecdraw(v(0,0,0), forces["Fnet"]*0.00001, blue, "Fnet "+(round(forces["Fnet"]:mag/1000))+"kN", 5.0, true, 0.1).
}
