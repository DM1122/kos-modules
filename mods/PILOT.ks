// PILOT //
@lazyglobal off.

global scriptName is "PILOT".


// SETUP //
clearscreen.
LibSetup().
KUISetup().
KUIKonsole("RUNNING PILOT...").
wait 3.

until false
{


    KUIDataA1("PITCH: " + round(Pitch(),2) + "°").
    KUIDataA2("PROGRADE: " + round(ProgradePitch(),2) + "°").

    KUIDataB1("AOA: " + round(AoA(),2) + "°").

    KUIDataC1("ROLL: " + round(Roll(),2) + "°").

}


KUIKonsole("HOLDING PROGRADE").


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