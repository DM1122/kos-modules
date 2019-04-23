//KOMANDR SCRIPT//
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
print "Welcome to KOMANDR" at(14,9).
print "Kerbal Operating Machine" at(10,11).
print "And Nexus Driver Repository" at(9,12).
wait 3.
print ">Press any key to continue...".
set key to terminal:input:getchar().

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
set modules_iterator to modules:iterator.
printModules().

wait 0.5.
print ">Please select a module to run from the list".
wait 0.5.
print ">Use the Up/Down arrow keys to navigate".
wait 0.5.
print ">Use the PgUp/PgDown to switch pages".
wait 0.5.
print ">Press Enter to make a selection".
wait 0.5.

set selection_placeholders_posX to list(8,8,8,8,8,8).
set selection_placeholders_posY to list(5,7,9,11,13,15).
set selection_placeholders_index to 0.
print ">" at(selection_placeholders_posX[selection_placeholders_index],selection_placeholders_posY[selection_placeholders_index]).

set selection_done to false.
until selection_done {
set key to terminal:input:getchar().
	if key = terminal:input:downcursorone and selection_placeholders_index + (kui_pgcurrent * kui_modulelimitperpg - kui_modulelimitperpg) < modules_maxindex and selection_placeholders_index < kui_modulelimitperpg - 1 {
		print " " at(selection_placeholders_posX[selection_placeholders_index],selection_placeholders_posY[selection_placeholders_index]).
		set selection_placeholders_index to selection_placeholders_index + 1.
	}
	if key = terminal:input:upcursorone and selection_placeholders_index > 0 {
		print " " at(selection_placeholders_posX[selection_placeholders_index],selection_placeholders_posY[selection_placeholders_index]).
		set selection_placeholders_index to selection_placeholders_index - 1.
	}
	if key = terminal:input:pagedowncursor and kui_pgcurrent < kui_pgtotal {
		set kui_pgcurrent to kui_pgcurrent + 1.
		KUIclearscreen().
		printModules().
		print "Installed Modules(" + modules:length + "):" at(1,3).
		print "Pg" + kui_pgcurrent + "/" + kui_pgtotal at(38,18).	
		set selection_placeholders_index to 0.
	}
	if key = terminal:input:pageupcursor and kui_pgcurrent > 1 {
		set kui_pgcurrent to kui_pgcurrent - 1.
		KUIclearscreen().
		printModules().
		print "Installed Modules(" + modules:length + "):" at(1,3).
		print "Pg" + kui_pgcurrent + "/" + kui_pgtotal at(38,18).
		set selection_placeholders_index to 0.
	}
	if key = terminal:input:enter {
		set selection_done to true.
	}
set modules_selection to selection_placeholders_index + (kui_pgcurrent * kui_modulelimitperpg - kui_modulelimitperpg).
print ">" at(selection_placeholders_posX[selection_placeholders_index],selection_placeholders_posY[selection_placeholders_index]).
}

runpath(modules[modules_selection]).

//FUNCTIONS//
function printModules {
modules_iterator:reset().
	for i in range(0,kui_pgcurrent * kui_modulelimitperpg - kui_modulelimitperpg) {
		modules_iterator:next().
	}
	for i in range(0,kui_modulelimitperpg) {
		modules_iterator:next().
		if not modules_iterator:atend {
			print modules[modules_iterator:index] at(modules_placeholders_posX[modules_iterator:index - (kui_pgcurrent * kui_modulelimitperpg - kui_modulelimitperpg)], modules_placeholders_posY[modules_iterator:index - (kui_pgcurrent * kui_modulelimitperpg - kui_modulelimitperpg)]).
		}
	}
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