// GUI LIBRARY //
@lazyglobal off.


function KUISetup
{
    clearscreen.
    set terminal:width to 45.
    set terminal:height to 21.
    set terminal:brightness to 1.0.
    set terminal:charheight to 12.
    set terminal:reverse to false.
    set terminal:visualbeep to false.

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
    print "|-------------------------------------------|".
    print "|KONSOLE>                                   |".
    print "*===========================================*".

    print scriptName at(1,1).
}

function KUIRefreshData
{
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
    print "|-------------------------------------------|" at(0,17).
}


function KUIKonsole
{
    parameter
        string.
    
    KUIclearKonsole().
    print string at(10,18).
}


function KUIclearKonsole
{
    print "|KONSOLE>                                   |" at(0,18).
}


function KUIDataA1
{
    parameter
        data.
    
    print data at(2,4).
}


function KUIDataA2
{
    parameter
        data.
    
    print data at(23,4).
}


function KUIDataB1
{
    parameter
        data.
    
    print data at(2,6).
}


function KUIDataB2
{
    parameter
        data.
    
    print data at(23,6).
}


function KUIDataC1
{
    parameter
        data.
    
    print data at(2,8).
}


function KUIDataC2
{
    parameter
        data.
    
    print data at(23,8).
}


function KUIDataD1
{
    parameter
        data.
    
    print data at(2,10).
}


function KUIDataD2
{
    parameter
        data.
    
    print data at(23,10).
}


function KUIDataE1
{
    parameter
        data.
    
    print data at(2,12).
}


function KUIDataE2
{
    parameter
        data.
    
    print data at(23,12).
}


function KUIDataF1
{
    parameter
        data.
    
    print data at(2,14).
}


function KUIDataF2
{
    parameter
        data.
    
    print data at(23,14).
}


function KUIDataG1
{
    parameter
        data.
    
    print data at(2,16).
}


function KUIDataG2
{
    parameter
        data.
    
    print data at(23,16).
}


function quit
{
    KUIKonsole("PRESS CONTROL-C TO QUIT").
    wait until false.
}
