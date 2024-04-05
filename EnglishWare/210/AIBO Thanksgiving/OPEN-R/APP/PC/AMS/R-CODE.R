:1000	// Main:START
GO:1002
:1001	// Main:END
HALT
:1002	// Main:Init
PLAY:ACTION:SIT
WAIT
SET:mycount:0
GO:1014
:1003	// Main:Gobble
PLAY:ACTION+:gobble
WAIT
GO:1011
:1004	// Main:Turkhay
PLAY:ACTION+:turkhay
WAIT
GO:1011
:1005	// Main:Cluck
PLAY:ACTION+:cluck
WAIT
GO:1011
:1006	// Main:Pig
PLAY:ACTION+:piggy
WAIT
GO:1011
:1007	// Main:Makerand
RND:mypick:1:4
:1008	// Main:SelectRand
WAIT:1
IF_1ST:mypick:=:1:1003
IF_1ST:mypick:=:2:1004
IF_1ST:mypick:=:3:1005
GO:1006
:1009	// Main:WaitABit
WAIT:1
ADD:mycount:1
MOD:mycount:300
SET:myheadcount:mycount
MOD:myheadcount:33
:1010	// Main:CheckSensor
WAIT:1
IF_1ST:Head_ON:=:1
IF_OR:Back_ON:=:1
IF_OR:Jaw_ON:=:1
IF_OR:mycount:=:0:1007
IF_1ST:myheadcount:=:0:1012
GO:1014
:1011	// Main:ResetSrs
SET:Head_ON:0
SET:Jaw_ON:0
SET:Back_ON:0
SET:mycount:0
GO:1014
:1012	// Main:MoveHead
RND:hangle:-90:90
PLAY:ACTION:MOVE_HEAD:hangle:0
WAIT
GO:1014
:1013	// Main:ShutDown
PLAY:ACTION:LIE
WAIT
GO:1001
:1014	// Main:CheckBatt
WAIT:1
IF_1ST:Batt_Rest:<=:22:1013
GO:1009
HALT
