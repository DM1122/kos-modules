//TEST SCRIPT #3//
clearscreen.
set Kp to 0.01.
set Ki to 0.006.
set Kd to 0.006.
set trgTWR to 1.5.
set pid to pidloop(Kp,Ki,Kd).
set pid:setpoint to trgTWR.

set trgthrottle to 1.
lock throttle to trgthrottle.

stage.

until false {
set P to ship:sensors:pres / 101.324998.		//conversion from kPA to atm
set g to body:mu / (altitude + body:radius)^2.	//grav acceleration (m/s^2)
set Ft to 0.
list engines in englist.
for eng in englist {
	if eng:ignition {
		set Ft to Ft + eng:availablethrustat(P).
	}
}
set maxTWR to Ft / (mass*g).
set currTWR to maxTWR*throttle.

set trgthrottle to trgthrottle + pid:update(time:seconds, currTWR).

print maxTWR at(0,0).
print currTWR at(0,1).
}

///set gforce to (ship:sensors:acc - ship:sensors:grav):mag / g.
///print gforce.


//set trgthrottle to trgthrottle + (0.01 * (1.5 - gforce)).
//lock throttle to trgthrottle.

//