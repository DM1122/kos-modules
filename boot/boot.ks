// BOOT SEQUENCE //
@lazyglobal off.

wait until ship:unpacked.

clearscreen.
set terminal:width to 45.
set terminal:height to 21.
set terminal:brightness to 1.0.
set terminal:charheight to 12.
set terminal:reverse to false.
set terminal:visualbeep to false.

print "Booting...".
wait 1.

if homeconnection:isconnected = true {
    print "Updating repository...".
    copypath("0:/libs","").
    copypath("0:/mods","").
    print "Update successful!".

} else {
    print "WARNING: No connection to archive".
}

cd("1:/mods").

print "Boot complete".