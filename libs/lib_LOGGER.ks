// LOGGER LIBRARY //
@lazyglobal off.

local logFreq is 1.0.
local logPrev is 0.

// when time:seconds - logPrev >= logFreq then { and if logger
//     LogData().
//     preserve.
// }



function LogSetup
{
    if exists("Archive:/logs")
    {
        cd("Archive:/logs").
    } else {
        createdir("Archive:/logs").
        cd("Archive:/logs").
    }

    if exists("log.csv")
    {
        deletepath("log.csv").
    }
}





function LogData
{
    log missiontime + "," + ship:altitude + "," + DistanceDownRange() + "," + trgPitch + "," + ship:sensors:pres + "," + ship:sensors:temp to "log.csv".
    set logPrev to time:seconds.
}