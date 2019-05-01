// HOVERSLAMMER //
@lazyglobal off.

global scriptName is "LANDER".

// SETUP //
clearscreen.
LibSetup().
KUISetup().
KUIKonsole("RUNNING LANDER...").
wait 3.






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
