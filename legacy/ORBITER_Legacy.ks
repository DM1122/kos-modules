//ORBITER SCRIPT//
set script_title to "ORBITER".
set script_version to "V1.0".

KUIRefresh().
from {local i is 0.} until i = 3 step {set i to i + 1.} do {
	print "Initializing script" at(11,9).
	wait 0.25.
	print "Initializing script." at(11,9).
	wait 0.25.
	print "Initializing script.." at(11,9).
	wait 0.25.
	print "Initializing script..." at(11,9).
	wait 0.25.
	print "                                  " at(5,9).
}


//PRE-FLIGHT CONFIG//
clearscreen.
print "CONSOLE: PRE-FLIGHT CONFIGURATION".
wait 1.

if body:atm:exists and trgorbitheight <= body:atm:height {
	print "ERROR: TARGET ORBIT ALTITUDE WITHIN ATMOSPHERE".
	quit().
}

//LAUNCH//
clearscreen.
print "CONSOLE: RUNNING LAUNCH SEQUENCE".
lock throttle to 1.0.
lock steering to up + r(0,0,180).
wait 2.

clearscreen.
print "CONSOLE: LAUNCH IN T-".
from {local countdown is 3.} until countdown = 0 step {set countdown to countdown - 1.} do {
	print countdown at(21,0).
	wait 1.
}

clearscreen.
hudtext("LAUNCH", 5, 2, 20, red, true).

until ship:maxthrust > 0 {
	stage.
	wait 0.1.
}

//ASCENT//
when maxthrust = 0 then {
	hudtext("STAGING", 5, 2, 20, red, true).
	stage.
	preserve.
}

wait until verticalspeed >= 100.

//GRAVITY TURN//
hudtext("EXECUTING GRAVITY TURN", 5, 2, 20, red, true).

until altitude >= 10000 {
	set trgpitch to (altitude / 10000) * 45.
	lock steering to up + r(0,-trgpitch,-90).
}

until ship:apoapsis >= trgorbitheight {
	lock steering to up + r(0,-45,-90).
}

lock throttle to 0.0.
hudtext("APOAPSIS REACHED", 5, 2, 20, red, true).

lock steering to prograde.
wait until vang(ship:facing:vector, ship:prograde:vector) < 0.1.
print "CONSOLE: LEAVING ATMOSPHERE".

wait until altitude >= body:atm:height.
wait 3.

//ORBITAL INSERTION//
print "CONSOLE: PLOTTING ORBITAL INSERTION BURN".
wait 2.
set maneuver to node(time:seconds+eta:apoapsis, 0, 0, 1000). //auto calculate burn required
add maneuver.
wait 1.

set eIsp to 0.
list engines in englist.
for eng in englist {
	set eIsp to eIsp + eng:maxthrust / maxthrust * eng:isp.
}
set Ve to eIsp * 9.81.
set massfin to mass * constant:e ^ (-1*maneuver:burnvector:mag/Ve).

set initmaxacc to maxthrust / mass.
set finmaxacc to maxthrust / massfin.

set burnduration to maneuver:burnvector:mag / ((initmaxacc + finmaxacc) / 2).
set burndurationhalf to burnduration / 2.

set initburnt to time:seconds + maneuver:eta - burndurationhalf.
set finburnt to time:seconds + maneuver:eta + burndurationhalf.

print "ETA TO NODE = " + round(maneuver:eta) + "s".
wait 1.
print "RADIAL = " + round(maneuver:radialout) + "m/s".
wait 1.
print "NORMAL = " + round(maneuver:normal) + "m/s".
wait 1.
print "PROGRADE = " + round(maneuver:prograde) + "m/s".
wait 1.
print "TOTAL DELTAV = " + round(maneuver:burnvector:mag) + "m/s".
wait 1.
print "BURN DURATION = " + round(burnduration) + "s".
wait 3.

if maneuver:eta - (burndurationhalf + 30) >= 45 {
	print "CONSOLE: READY TO WARP".
	wait 3.
	hudtext("WARPING", 5, 2, 20, red, true).
	warpto(time:seconds + (maneuver:eta - (burndurationhalf + 30))).
	wait until maneuver:eta <= burndurationhalf + 30.
	hudtext("ALIGNING TO VECTOR", 5, 2, 20, red, true).
	lock steering to maneuver:burnvector.
}
else {
	print "CONSOLE: WAITING FOR NODE".
	wait until maneuver:eta <= burndurationhalf + 30.
	hudtext("ALIGNING TO VECTOR", 5, 2, 20, red, true).
	lock steering to maneuver:burnvector.
}

wait until vang(ship:facing:vector, maneuver:burnvector) < 0.1.
print "CONSOLE: READY TO BURN".

wait until time:seconds >= initburnt.
hudtext("BURNING", 5, 2, 20, red, true).
lock throttle to 1.0.

wait until time:seconds >= finburnt.
hudtext("ORBITAL INSERTION COMPLETE", 5, 2, 20, red, true).
lock throttle to 0.0.

lock steering to prograde.
wait until vang(ship:facing:vector, ship:prograde:vector) < 0.1.

//SHUTDOWN//
print "CONSOLE: PROGRAM TERMINATED".
wait 3.
print "CONSOLE: RELEASING CONTROLS".
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
unlock steering.
unlock throttle.
quit().

//FUNCTIONS//
function quit {
wait 2.
print "PRESS CONTROL-C TO QUIT".
wait until false.
}

function KUIRefresh {
clearscreen.
print "*===========================================*".
print "|                                           |".
print "|===========================================|".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|                                           |".
print "|-------------------------------------------|".
print "*===========================================*".
print "<KONSOLE>                                    ".
print script_title at(1,1).
print script_version at(40,1).
}

function KUIclearscreen {
print "|===========================================|" at(0,2).
print "|                                           |" at(0,3).
print "|                                           |" at(0,4).
print "|                                           |" at(0,5).
print "|                                           |" at(0,6).
print "|                                           |" at(0,7).
print "|                                           |" at(0,8).
print "|                                           |" at(0,9).
print "|                                           |" at(0,10).
print "|                                           |" at(0,11).
print "|                                           |" at(0,12).
print "|                                           |" at(0,13).
print "|                                           |" at(0,14).
print "|                                           |" at(0,15).
print "|                                           |" at(0,16).
print "|                                           |" at(0,17).
print "|-------------------------------------------|" at(0,18).
print "*===========================================*" at(0,19).
}

function KUIclearscreenline {
parameter line.
print "|                                           |" at(0,line).
}

function KUIclearkonsole {
}