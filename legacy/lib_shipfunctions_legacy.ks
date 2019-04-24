// Universal ship functions lib
@LAZYGLOBAL OFF.

FUNCTION cls
{
    CLEARSCREEN.
}

FUNCTION TerminalSetup
{
    CLEARSCREEN.
    SET TERMINAL:WIDTH to 50.
    SET TERMINAL:HEIGHT to 36.
    SET TERMINAL:BRIGHTNESS to 1.0.
    SET TERMINAL:CHARHEIGHT to 12.
    SET TERMINAL:REVERSE to FALSE.
    SET TERMINAL:VISUALBEEP to FALSE.
}

FUNCTION LaunchSetup
{
    SAS OFF.
    RCS OFF.
    GEAR ON.
    SET THROTTLE TO 0.
    LOCK STEERING TO UP + R(0,0,180).
    WAIT 0.5.
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