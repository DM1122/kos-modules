//DUOROVER CONTROLLER SCRIPT//
set scriptversion to "ALPHA V1.2".

//BOOTUP//
clearscreen.

set terminal:width to 50.
set terminal:height to 36.
set terminal:reverse to false.
set terminal:visualbeep to false.
set terminal:brightness to 1.0.
set terminal:charwidth to 8.
set terminal:charheight to 8.

print "DUOROVER [" + scriptversion + "]".
wait 1.
clearscreen.
from {local i is 0.} until i = 3 step {set i to i+1.} do {
	print "DUOROVER [" + scriptversion + "]".
	print "Initializing script".
	wait 0.25.
	clearscreen.
	print "DUOROVER [" + scriptversion + "]".
	print "Initializing script.".
	wait 0.25.
	clearscreen.
	print "DUOROVER [" + scriptversion + "]".
	print "Initializing script..".
	wait 0.25.
	clearscreen.
	print "DUOROVER [" + scriptversion + "]".
	print "Initializing script...".
	wait 0.25.
	clearscreen.
}

//CONFIGURATION//
clearscreen.
print "CONSOLE: SCANNING INSTALLED MODULES".
wait 1.
list parts in partlist.
for part in partlist {
	print ">:" + part:name + "		" + part:uid.
	set h to highlight(part, rgb(0,255,0)).
	set h:enabled to true.
	wait 0.1.
	set h:enabled to false.
}
wait 2.

set boosters to ship:partstagged("Booster").
set boostercount to 0.
for booster in boosters {
	set boostercount to boostercount + 1.
}

if boostercount > 0 {
	clearscreen.
	print "CONSOLE: VERTICAL BOOSTER MODULE(S) DETECTED".
		for booster in boosters {
			set h to highlight(booster, rgb(0,0,255)).
			set h:enabled to true.
			wait 0.2.
		}
	wait 1.
	print ">:Please configure boost key...".
	set boostkey to terminal:input:getchar().
		for booster in boosters {.
			set h:enabled to false.
		}
}



set roverheight to alt:radar. //height profile

//MAIN LOOP//
until false {
flightassist().
when 



}

//FUNCTIONS//
function flightassist {
	if alt:radar > roverheight + 5 {
		print "CONSOLE: ENGAGING FLIGHTASSIST".
		rcs on.
		set sasmode to "stabilityassist".
		until alt:radar <= roverheight {
		//something here
		}
		print "CONSOLE: FLIGHTASSIST DISENGAGED".
		rcs off.
		set sasmode to "radialout".
	}
}

function quit {
wait 2.
print "PRESS CONTROL-C TO QUIT".
wait until false.
}