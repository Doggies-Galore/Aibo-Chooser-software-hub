// AIBO Boo
// Part of the AIBO Treats collection

SET:timecount:0                    // reset counter
:1003                              // Lie down	
PLAY:ACTION:LIE
WAIT
:1007                              // wait one frame
WAIT:32
ADD:timecount:1
:1008	                           // check for important times
IF:timecount:=:100:1014            //   time 1/3: look around
IF:timecount:=:200:1014            //   time 2/3: look around
IF:timecount:>=:300:1009           //   time 1.0: play a sequence
IF:Distance:<:400:CALL:2000        // Default boo distance is 400mm.  (0.4m)
                                   // >0.4m may cause problems on ground,
                                   //   as AIBO will BOO too much.
IF:Batt_Rest:<=:22:1015
GO:1007
:1009                              // play a random cute sequence
SET:timecount:0                    //   reset counter
RND:randmtn:0:3
IF:randmtn:=:0:1011
IF:randmtn:=:1:1012
IF:randmtn:=:2:1013
GO:1007
:1011                              // Random sequence #1
PLAY:ACTION+:cat1
WAIT
GO:1007
:1012                              // Random sequence #2
PLAY:ACTION+:tort
WAIT
GO:1007
:1013                              // Random sequence #3
PLAY:ACTION+:wolf
WAIT
GO:1007
:1014                              // Move head around to look
RND:hh:-100:100
PLAY:ACTION:MOVE.HEAD.FAST:hh:0
WAIT:3500
PLAY:ACTION:MOVE.HEAD.FAST:0:0
GO:1007
:1015
PLAY:ACTION:LIE
WAIT
HALT
GO:1015
:2000
RND:boornd:1:2
IF:boornd:=:1:2010
PLAY:ACTION+:boo
WAIT
GO:2020
:2010
PLAY:ACTION+:boo2
WAIT
:2020
RETURN
//  -------------end of main program----------------

