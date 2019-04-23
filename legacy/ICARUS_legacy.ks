// ICARUS SCRIPT
@LAZYGLOBAL OFF.

PARAMETER
    alt_trg,
    alt_drop.

LOCAL ship_height is 9.9.
LOCAL log_freq is 0.1.
LOCAL log_prev is 0.
LOCAL pid is 0.
LOCAL pid_kp is 0.2.
LOCAL pid_ki is 0.02.
LOCAL pid_kd is 1.332.
LOCAL pid_cnfg is 0.
LOCAL throt_trg is 0.
LibSetup().

TerminalSetup().
PRINT "RUNNING ICARUS...".
LaunchSetup().
ResetRadar(ship_height).
STAGE.

IF (alt_drop > 0)
{
    Climb(alt_drop, 1.5).
}
cls().

ResetTimer().
SET pid to PID_init(pid_kp, pid_ki, pid_kd, pid_cnfg).       // Kp, Ki, Kd, cnfg
UNTIL Timer() >= 30
{
    SET throt_trg to PID_loop(pid, alt_trg, Radarr()).
    SET THROTTLE to MAX(0, MIN(throt_trg, 1)).
    
    DisplayPID().
    LogData().
}



PRINT "PROGRAM COMPLETE".
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
UNLOCK THROTTLE.
UNLOCK STEERING.
WAIT UNTIL FALSE.

FUNCTION LibSetup
{
    CD("Archive:/libs").
    RUNONCEPATH("lib_shipfunctions").
    RUNONCEPATH("lib_PID").

    CD("Archive:/logs").
    IF EXISTS("pidtest.csv")
    {
        DELETEPATH("pidtest.csv").
    }
}

FUNCTION DisplayPID 
{
    PRINT "CONFIGURATION: " + pid[0] AT (1,0).
    PRINT "SETPOINT: " + alt_trg + "m" AT(1,1).
    PRINT "ALTITUDE: " + ROUND(Radarr()) + "m" AT(1,2).
    PRINT "ERROR: " + ROUND(pid[1]) + "m" AT(1,3).
    PRINT "P: " + ROUND(pid[3],3) AT(1,4).
    PRINT "I: " + ROUND(pid[4],3) AT(1,5).
    PRINT "D: " + ROUND(pid[5],3) AT(1,6).
    PRINT "U: " + ROUND(pid[10],3) AT(1,7).
    PRINT "THROTTLE: " + ROUND(THROTTLE * 100) + "%" AT(1,8).
    PRINT "ELAPSED TIME: " + ROUND(Timer()) + "s" AT(1,9).
}

FUNCTION LogData
{
    IF TIME:SECONDS - log_prev > log_freq
    {
        //LOG Timer() + "," + alt_trg + "," + Radarr() + "," + pid[1] + "," + pid[10] + ","  + (THROTTLE * 100) TO "pidtest.csv".
        LOG Timer() + "," + Radarr() + "," + THROTTLE TO "pidtest.csv".   // system id
        SET log_prev TO TIME:SECONDS.
   }
}

FUNCTION ResetOuput
{
    WHEN Timer() > 0 AND Timer() < 0.25 THEN        // ugly; needs proper fix
    {
        SET pid[10] to 0.
    }
}