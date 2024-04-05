IF Batt_Rest <= 22 THEN
	WAIT
	PLAY:ACTION LIE
	WAIT
	PLAY:ACTION+ low_battery
	WAIT
	HALT
ENDIF

GLOBAL left_paw 0
GLOBAL right_paw 0

CLR SENSORS

ONCALL LFLeg_ON = 1 L_Leg_On
ONCALL RFLeg_ON = 1 R_Leg_On
ONCALL LFLeg_OFF != 0 L_Leg_Off
ONCALL RFLeg_OFF != 0 R_Leg_Off

PLAY:ACTION LIE

SET Seed Sec
PLAY:ACTION+ intro
WAIT
SET start Clock
SET skip 1
GO Mode_Neutral_Loop

//------------------Neutral--------------//
:Mode_Neutral
	WAIT
	SET Head_ON 0
	SET Back_ON 0
	SET moving_tail 0
	SET start Clock
	
	
:Mode_Neutral_Loop
	

	IF Back_ON = 1 THEN
		PLAY:ACTION+ ding
		WAIT
		SET loop_count 0
		SET moving_tail 0
		SET Back_ON 0
		GO Mode_1
	ENDIF
	
	IF Head_ON = 1 THEN
		PLAY:ACTION+ ding
		WAIT
		SET loop_count 0
		SET moving_tail 0
		SET Head_ON 0
		RND select 0:6
		IF select = 1 THEN
			GO Mode_3
		ELSE
			GO Mode_2
		ENDIF
	ENDIF
	
	SET diff Clock
	SUB diff start
	IF diff > 125 THEN	// 2 second
		IF Wait = 0 THEN
			IF moving_tail = 0 THEN
				SET moving_tail 1
				CALL Random_Move_Head
				PLAY:ACTION PALONE.AUTO.TAILH
				PLAY:ACTION PALONE.AUTO.TAILSTOP
			ENDIF
		ENDIF
	ENDIF
	IF Wait = 0 THEN
		IF moving_tail = 1 THEN
			SET moving_tail 0
			IF skip = 0 THEN
				SET moving_tail 0
				PLAY:ACTION+ intro_short
				WAIT
				SET skip 1
			ELSE
				RND select 0:2
				IF select = 0 THEN
					PLAY:ACTION+ intro_short
				ELSE
					PLAY:ACTION+ waiting
				ENDIF
				WAIT
			ENDIF
			SET start Clock
		ENDIF
	ENDIF

GO Mode_Neutral_Loop


//------------------Mode_1--------------//
:Mode_1
	
	PLAY:ACTION+ mode1_intro
	WAIT
	
	SET say_msg 1
	SET start Clock
	SET start_both 0
	SET start_paw_l 0
	SET start_paw_r 0
	
	:Paw_Check
		// Check paws.  
		// paws = 0   -> Both off
		// paws = 1,2 -> One paw on
		// paws = 3   -> Both on
		CALL Double_Check_Paws
		
		IF right_paw = 1 THEN
			SET paws 2
		ELSE
			SET paws 0
		ENDIF
		IF left_paw = 1 THEN
			ADD paws 1
		ENDIF
		
		IF paws = 0 THEN
			SET start_both 0
		ENDIF
		IF paws = 1 THEN
			IF start_paw_l = 0 THEN
				SET start_paw_l Clock
			ENDIF
			SET diff Clock
			SUB diff start_paw_l
			IF diff > 62 THEN
				IF say_msg = 1 THEN
					IF Wait = 0 THEN
						PLAY:ACTION+ one_paw_r
						WAIT
						SET moving_tail 0
						SET start Clock
						SET start_paw_l 0
					ENDIF
				ENDIF
				SET start_both 0
				SET say_msg 0
			ENDIF
		ENDIF
		IF paws = 2 THEN
			IF start_paw_r = 0 THEN
				SET start_paw_r Clock
			ENDIF
			SET diff Clock
			SUB diff start_paw_r
			IF diff > 62 THEN
				IF say_msg = 1 THEN
					IF Wait = 0 THEN
						PLAY:ACTION+ one_paw_l
						WAIT
						SET moving_tail 0
						SET start Clock
						SET start_paw_r 0
					ENDIF
				ENDIF
				SET start_both 0
				SET say_msg 0
			ENDIF
		ENDIF
		IF paws = 3 THEN
			IF start_both = 0 THEN
				SET start_both Clock
			ENDIF
			SET diff Clock
			SUB diff start_both
			IF diff > 62 THEN	// 1 second	
		
				PLAY:ACTION+ ding
				WAIT
				PLAY:ACTION+ feel_energy
				WAIT
				WAIT 100
				
				SET flag 0
				IF right_paw = 1 THEN
					SET flag 1
				ENDIF
				IF left_paw = 1 THEN
					SET flag 1
				ENDIF
				
				IF flag = 1 THEN
					PLAY ACTION+ let_go
					WAIT
					SET loop_count 0
					SET start Clock
					WHILE flag = 1 
						SET diff Clock
						SUB diff start
						IF diff > 93 THEN
							ADD loop_count 1
							IF loop_count > 5 THEN
								SET flag 0
							ENDIF
							PLAY ACTION+ stop_touching
							WAIT
							SET start Clock
						ENDIF
						
						IF right_paw = 0 THEN
							IF left_paw = 0 THEN
								SET flag 0
							ENDIF
						ENDIF
					WEND
					PLAY ACTION+ thank_you
					WAIT
				ENDIF
				
				PLAY ACTION+ paw_in
				WAIT
				
				RND select 0:1
				IF select = 0 THEN
					PLAY:ACTION+ thinking1
				ELSE
					PLAY:ACTION+ thinking2
				ENDIF
				WAIT
				GO Result_1
			ENDIF
		ENDIF

		SET diff Clock
		SUB diff start
		IF diff > 125 THEN	// 2 second
			IF Wait = 0 THEN
				IF moving_tail = 0 THEN
					SET moving_tail 1
					CALL Random_Move_Head
					PLAY:ACTION PALONE.AUTO.TAILH
					PLAY:ACTION PALONE.AUTO.TAILSTOP
				ENDIF
			ENDIF
		ENDIF
		IF Wait = 0 THEN
			IF moving_tail = 1 THEN
				SET moving_tail 0
				
				IF loop_count > 5 THEN
					PLAY ACTION+ paw_in
					WAIT
					GO Mode_Neutral
				ENDIF
			
				ADD loop_count 1
				IF paws = 0 THEN
					PLAY:ACTION+ waiting2
				ENDIF
				IF paws = 1 THEN
					RND select 0:1
					IF select = 0 THEN
						PLAY:ACTION+ one_paw_r
					ELSE
						PLAY:ACTION+ waiting2
					ENDIF
				ENDIF
				IF paws = 2 THEN
					RND select 0:1
					IF select = 0 THEN
						PLAY:ACTION+ one_paw_l
					ELSE
						PLAY:ACTION+ waiting2
					ENDIF
				ENDIF
				WAIT
				SET start Clock
			ENDIF
		ENDIF
		
	GO Paw_Check
	
	:Result_1
		RND select 0:4
		SWITCH select
			CASE 0:PLAY:ACTION+ off_charts	
			CASE 1:PLAY:ACTION+ potential	
			CASE 2:PLAY:ACTION+ dunno		
			CASE 3:PLAY:ACTION+ nope		
			CASE 4:PLAY:ACTION+ floppy
		WAIT
		SET skip 0
GO Mode_Neutral


//------------------Mode_2--------------//
:Mode_2
	
	SET Back_ON 0
	PLAY:ACTION+ mode2_intro
	WAIT
	SET start Clock
	
	:Back_Check
		IF Back_ON = 1 THEN
		
			PLAY:ACTION+ ding
			WAIT
		
			SET Back_ON 0
			RND select 0:1
			IF select = 0 THEN
				PLAY:ACTION+ thinking1
			ELSE
				PLAY:ACTION+ thinking2
			ENDIF
			WAIT
			
			RND select 0:7
			SWITCH select
				CASE 0:PLAY:ACTION+ good_luck	
				CASE 1:PLAY:ACTION+ stay_home	
				CASE 2:PLAY:ACTION+ just_dog	
				CASE 3:PLAY:ACTION+ success		
				CASE 4:PLAY:ACTION+ melt_heart	
				CASE 5:PLAY:ACTION+ foggy		
				CASE 6:PLAY:ACTION+ opposite_sex
				CASE 7:PLAY:ACTION+ get_lucky	
			WAIT
			SET skip 0
			GO Mode_Neutral
		ENDIF
		
		SET diff Clock
		SUB diff start
		IF diff > 125 THEN	// 2 second
			IF Wait = 0 THEN
				IF moving_tail = 0 THEN
					SET moving_tail 1
					CALL Random_Move_Head
					PLAY:ACTION PALONE.AUTO.TAILH
					PLAY:ACTION PALONE.AUTO.TAILSTOP
				ENDIF
			ENDIF
		ENDIF
		IF Wait = 0 THEN
			IF moving_tail = 1 THEN
				SET moving_tail 0
				IF loop_count > 5 THEN
					GO Mode_Neutral
				ENDIF

				ADD loop_count 1
				RND select 0:1
				IF select = 0 THEN
					PLAY:ACTION+ waiting3
				ELSE
					PLAY:ACTION+ mode2_short
				ENDIF
				WAIT
				SET start Clock
			ENDIF
		ENDIF
	
	GO Back_Check
	SET skip 0
GO Mode_Neutral


//------------------Mode_3--------------//
:Mode_3
	
	PLAY:ACTION+ mode3_intro	//paw_up
	WAIT
	
	SET say_msg 1
	SET start Clock
	SET start_both 0
	
	:Paw_Check_3
		CALL Double_Check_Paws
		
		IF right_paw = 1 THEN
			SET paws 2
		ELSE
			SET paws 0
		ENDIF
		IF left_paw = 1 THEN
			ADD paws 1
		ENDIF
		
		IF paws != 3 THEN
			SET start_both 0
		ELSE
			IF start_both = 0 THEN
				SET start_both Clock
			ENDIF
			SET diff Clock
			SUB diff start_both
			IF diff > 62 THEN	// 1 second
				
				PLAY:ACTION+ ding
				WAIT
				PLAY:ACTION+ mode3_paws
				WAIT
				PLAY:ACTION+ gaze_first
				WAIT
				WAIT 100
				
				SET flag 0
				IF right_paw = 1 THEN
					SET flag 1
				ENDIF
				IF left_paw = 1 THEN
					SET flag 1
				ENDIF

				IF flag = 1 THEN
					PLAY ACTION+ let_go2
					WAIT
					SET loop_count 0
					SET start Clock
					WHILE flag = 1 
						SET diff Clock
						SUB diff start
						IF diff > 93 THEN
							ADD loop_count 1
							IF loop_count > 5 THEN
								SET flag 0
							ENDIF
							PLAY ACTION+ stop_touching2
							WAIT
							SET start Clock
						ENDIF

						IF left_paw = 0 THEN
							IF right_paw = 0 THEN
								SET flag 0
							ENDIF
						ENDIF
					WEND
					PLAY ACTION+ thank_you2
					WAIT
				ENDIF

				PLAY ACTION+ paw_down
				WAIT
				PLAY:ACTION+ gaze_last
				WAIT
				SET skip 0
				GO Mode_Neutral
			ENDIF
		ENDIF

		SET diff Clock
		SUB diff start
		IF diff > 125 THEN	// 2 second
			IF Wait = 0 THEN
				IF moving_tail = 0 THEN
					SET moving_tail 1
					CALL Random_Move_Head
					PLAY:ACTION PALONE.AUTO.TAILH
					PLAY:ACTION PALONE.AUTO.TAILSTOP
				ENDIF
			ENDIF
		ENDIF
		IF Wait = 0 THEN
			IF moving_tail = 1 THEN
				SET moving_tail 0
				IF loop_count > 5 THEN
					PLAY ACTION+ paw_down
					WAIT
					GO Mode_Neutral
				ENDIF
				
				ADD loop_count 1
				PLAY:ACTION+ waiting4
				WAIT
				SET start Clock
			ENDIF
		ENDIF
		
	GO Paw_Check_3
	SET skip 0
GO Mode_Neutral

//------------------Random_Move_Head--------------//
:Random_Move_Head
	RND vert -20:20
	RND horiz -30:30
	PLAY:ACTION MOVE_HEAD horiz:vert
	IF Batt_Rest <= 22 THEN
		WAIT
		PLAY:ACTION LIE
		WAIT
		PLAY:ACTION+ low_battery
		WAIT
		HALT
	ENDIF
RETURN

//------------------Double Check Paws--------------//
:Double_Check_Paws
	IF RFLeg_ON = 1 THEN
		SET RFLeg_ON 0
		SET right_paw 1
	ENDIF

	IF RFLeg_OFF != 0 THEN
		SET RFLeg_OFF 0
		SET right_paw 0
	ENDIF

	IF LFLeg_ON = 1 THEN
		SET LFLeg_ON 0
		SET left_paw 1
	ENDIF

	IF LFLeg_OFF != 0 THEN
		SET LFLeg_OFF 0
		SET left_paw 0
	ENDIF
RETURN

//------------------PAW ISR's--------------//
:R_Leg_On
	SET RFLeg_ON 0
	SET right_paw 1
RESUME

:R_Leg_Off
	SET RFLeg_OFF 0
	SET right_paw 0
RESUME

:L_Leg_On
	SET LFLeg_ON 0
	SET left_paw 1
RESUME

:L_Leg_Off
	SET LFLeg_OFF 0
	SET left_paw 0
RESUME
