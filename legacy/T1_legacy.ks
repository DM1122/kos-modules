//TEST SCRIPT #1//
set script_title to "KOMANDR".
set script_version to "V1.0".

clearscreen.
switch to 0.
set terminal:width to 45.
set terminal:height to 35.
set terminal:reverse to false.
set terminal:visualbeep to false.
set terminal:brightness to 1.0.
set terminal:charwidth to 8.
set terminal:charheight to 8.

cd("0:/modules").
list files in modules.
set modules_maxindex to modules:length - 1.

set kui_pgcurrent to 1.
set kui_modulelimitperpg to 6.
set kui_pgtotal to ceiling(modules:length / kui_modulelimitperpg).
KUIRefresh().

from {local i is 0.} until i = 3 step {set i to i + 1.} do {
	print "Searching for installed modules" at(5,9).
	wait 0.25.
	print "Searching for installed modules." at(5,9).
	wait 0.25.
	print "Searching for installed modules.." at(5,9).
	wait 0.25.
	print "Searching for installed modules..." at(5,9).
	wait 0.25.
	print "                                  " at(5,9).
}
print "Installed Modules(" + modules:length + "):" at(1,3).
print "Pg" + kui_pgcurrent + "/" + kui_pgtotal at(38,18).

set modules_placeholders_posX to list(10,10,10,10,10,10).
set modules_placeholders_posY to list(5,7,9,11,13,15).
modules:iterator:reset().
print modules:iterator:index.
for i in range(-1,kui_pgcurrent * kui_modulelimitperpg - kui_modulelimitperpg + 1) {
	modules:iterator:next().
}
print modules:iterator:index.
for i in range(0,kui_modulelimitperpg + 1) {
	print modules:iterator:index.
	print modules[modules:iterator:index] at(modules_placeholders_posX[modules:iterator:index], modules_placeholders_posY[modules:iterator:index]).
	
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
//function atmosthrottle {
//set R to 287.058.		//specific gas constant
//set T to ship:sensors:temp.		//ambient temp
//set c to sqrt(1.4*R*T).		//speed of sound
//set M to airspeed / c. //Mach#
//
//set trgthrottle to trgthrottle + (10000 * (1.0 - M)).
//lock throttle to trgthrottle.
//
//	if trgthrottle > 1.0 {		//conditional necessary for upper and lower boundaries
//		set trgthrottle to 1.0.
//	}
//	if trgthrottle < 0.0 {
//		set trgthrottle to 0.0.
//	}
//}


//set orbitv to sqrt((constant:g * 5.2915793 * 10 ^ 22) / (trgorbitheight + 600000)).

//Tsiolkovsky rocket equation
//
// deltaV = Ve*Ln(mass/massfin)
//
//deltaV -> change from initmaxacc to finmaxacc
//Ve -> effective exhaust velocity (Ve = eIsp*9.82)
//Ln -> natural Log

//function bootupTone{
//set V0 to getvoice(0).
//set V0:volume to 1.0.
//set V0:wave to "square".
//set V0:attack to 0.0.
//set V0:decay to 0.0.
//set V0:sustain to 1.0.
//set V0:release to 0.1.
//	V0:play(
//		list(
//			note("C4", 0.25, 0.5),
//			note("D4", 0.25, 0.5),
//			note("E5", 0.25, 0.75)
//		)
//	).
//}

//USER FUNCTIONS//


//function smarthrottle {	//uses gforce rather than terminal velocity
//set g to body:mu / body:radius ^ 2.
//set accvec to ship:sensors:acc - ship:sensors:grav.
//set gforce to accvec:mag / g.
//
//set trgthrottle to trgthrottle + (0.01 * (1.5 - gforce)).
//lock throttle to trgthrottle.
//}


//	if altitude < body:atm:height {
//		if ship:velocity > termvelocity {
//			set trgthrottle to trgthrottle - 0.01.
//		}
//		if ship:velocity < ship:termvelocity {
//			set trgthrottle to trgthrottle + 0.01.
//			lock throttle to trgthrottle.
//		}
//	}
//	else {
//		lock throttle to 1.0.
//	}
//}


//function smarthrottle { //not valid using terminal velocity
//set P to ship:sensors:pres * (1.01325*10^5). //atmos pressure in (PA)
//set p to P / (ship:sensors:temp*287.05). //atmos density (kg/m3)
//set g to body:mu / body:radius ^ 2. //grav acceleration (m/s^2)
//set A to A. //projected area (must be a parameter)
//set Cd to 0.2. //average drag coefficient
//
//lock termvelocity to sqrt((2*(mass*1000)*g) / (p*A*Cd)).
//print termvelocity.
//}