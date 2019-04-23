// FLIGHT LIBRARY //
@lazyglobal off.


function FlightSetup
{
    sas off.
    rcs off.
    gear on.
    lock throttle to 1.
    lock steering to up + r(0,0,180).
    
    global alt_init is altitude.
    global coord_init is ship:geoposition.
}


FUNCTION ResetRadar
{
    PARAMETER
        offset.

    GLOBAL radar_init is 0.
    GLOBAL radar_offset is offset.

    SET radar_init to ALTITUDE - radar_offset.
}


FUNCTION Radarr
{
    LOCAL radar is 0.
    LOCAL radar_offset_cur is 0.

    SET radar_offset_cur to ALTITUDE - radar_offset.
    SET radar to radar_offset_cur - radar_init.
    RETURN radar.
}


FUNCTION RadarAp
{
    LOCAL radar_ap is 0.

    SET radar_ap to APOAPSIS - 77.4.
    RETURN radar_ap.
}


FUNCTION Climb
{
    PARAMETER
        alt_trg,
        twr_trg.
    
    UNTIL RadarAp() >= alt_trg
    {
        SET THROTTLE to (twr_trg * SHIP:MASS * 9.802) / SHIP:AVAILABLETHRUST.
    }
    SET THROTTLE to 0.
    WAIT UNTIL Radarr() >= RadarAp().
}


FUNCTION ResetTimer
{
    GLOBAL t_init is TIME:SECONDS.
}


FUNCTION Timer
{
    LOCAL t_elapsed is 0.

    SET t_elapsed to TIME:SECONDS - t_init.
    RETURN t_elapsed.
}


function DistanceDownRange
{
    local coord is ship:geoposition.

    local coord_lat is coord:lat*constant:DegtoRad.
    local coord_lng is coord:lng*constant:DegtoRad.

    local coord_init_lat is coord_init:lat*constant:DegtoRad.
    local coord_init_lng is coord_init:lng*constant:DegtoRad.

    local angle is arccos( sin(coord_init_lat)*sin(coord_lat) + cos(coord_init_lat)*cos(coord_lat)*cos(coord_lng - coord_init_lng) ). // orthodromic distance

    local distance is angle*(alt_init+body:radius).   // l = θr

    return distance.
}


function CircularizationDV
{
    local u is body:mu.     // standard gravitational parameter u = GM
    local br is body:radius.        // body radius
    local ro is br + ship:orbit:apoapsis.       // orbital radius
    local eo is ship:orbit:eccentricity.     // orbital eccentricity
    local ao is ship:orbit:semimajoraxis.       // orbital semi-major axis

    local va is sqrt( (u*(1-eo)) / (ao*(1+eo)) ).    // velocity at apoapsis; might replace w/ vis via equation
    local vo is sqrt(u / ro).        // required orbital velocity

    local dv is vo - va.

    // print "u: " + u.
    // print "br: " + br.
    // print "ro: " + ro.
    // print "ecc: " + eo.
    // print "axis: " + ao.
    // print "vel @ap: " + va.
    // print "vel req: " + vo.
    // print "dv: " + dv.
    
    return dv.
}

function BurnTime
{
    parameter
        dv.

    local m_init is ship:mass.      // initial mass
    local acc_init is ship:maxthrust / m_init.        // initial accel = F / m0

    local eIsp is 0.        // effective Isp; considers multiple engines
    local englist is 0.
    list engines in englist.
    for eng in englist
    {
        set eIsp to eIsp + eng:maxthrust / ship:maxthrust * eng:isp.
    }

    local ve is eIsp * constant:g0.     // exhaust velocity

    local m_fin is m_init * constant:e ^(-1*dv / ve).       // final mass derived from rearranged rocket eqn

    local acc_fin is ship:maxthrust / m_fin.       // final accel = F / m1

    local dt is dv / ((acc_init + acc_fin) / 2).        // burn time is calculated from avg accel

    // print "burn time: " + dt.
    return dt.
}

function FlightShutdown
{
    KUIKonsole("RELEASING CONTROLS").
    set ship:control:pilotmainthrottle to 0.
    unlock steering.
    unlock throttle.
    cd("1:/mods").
    wait 2.
    quit().
}

function MaxAcc         // returns a ship's maximum current acceleration
{
    local accMax is ship:maxthrust/ship:mass.       // a = F/m

    return accMax.
}

function Pitch      // vessel pitch to horizon
{
    local angle is 90 - vang(ship:up:vector, ship:facing:vector).       
    
    return angle.
}

function ProgradePitch      // surface prograde pitch to horzion
{
    local proAngle is 90 - vang(ship:up:vector, ship:srfprograde:vector).

    return proAngle.
}

function AoA        // angle of attack
{
    local delta is ProgradePitch() - Pitch().

    return delta.
}
