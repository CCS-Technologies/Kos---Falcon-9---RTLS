SAS off.			//Initial Setup
RCS off.
Set Throttle to 0.
Cosntants_and_variables_Prep().

Clearscreen.

Set RUNMODE to 1.

until RUNMODE = 0 {

	If RUNMODE = 1 {			//LIft Off
		Print "Falcon 9 is in StartUp." at ( 3, 9).
		gimbaltest().
		AG1 On.
		Stage.
		Wait 10.
		Lock steering to UP.
		Set Throttle to .965.
		Wait 4.5.
		Stage.
		Wait 1.
		Set RUNMODE to 2.
		}
	
	Else if RUNMODE = 2 {			//Initial climb
		Lock steering to heading (90,90).
		If ship:Verticalspeed > 5 and Printed1 = False {
			Print "Liftoff of the Falcon 9." + "            " at ( 3, 9).
			Set Printed1 to True.
			}
		If Ship:Verticalspeed > 80 {
			Set RUNMODE to 3.
			}
		}
		
	Else if RUNMODE = 3 {			//First Gravity Turn
		Set targetPitch to max( 35, 90 * (1 - (ALT:RADAR-620)/90000)).
		Lock steering to heading ( 90,targetPitch).
		If Ship:Verticalspeed > 255 {
			Set Throttle TO 0.583.
			Set RUNMODE to 4.
			}
		}
	
	Else if RUNMODE = 4 {		
		Set targetPitch to max( 40, 90 * (1 - (1.1 * ALT:RADAR - 1245) /90000)).
		If SHIP:ALTITUDE > 11187 {
			Set Throttle TO 0.95.
			Set RUNMODE to 5.
			}
		}
	
	Else if RUNMODE = 5 {			//Second Gravity Turn
		Set targetPitch to max( 40, 90 *(1 - ((0.0045 * ALT:RADAR + 130.5)^2) /110000)+15.4).
		Lock steering to heading ( 90,targetPitch).
		If SHIP:ALTITUDE > 60000 {
			Set Throttle to 0.9.
			Set RUNMODE to 6.
			}
		}

	Else if RUNMODE = 6 {
		Set steering to heading(90,40).
		If missiontime > 141 {				//145
			Set RUNMODE to 7.
			}
		}
	
	Else if RUNMODE = 7 {			//Throttle Down
		Set Throttle TO 0.1.	//0.25
		If missiontime > 142 {	//152
			Set RUNMODE to 8.
			}
		}
	
	Else if RUNMODE = 8 {			//MECO +27
		Set Throttle TO 0.
		Wait 1.
		STAGE.
		Set ship:control:neutralize to true.
		UnLock Throttle.
		UnLock Steering.
		Wait 1.
		Set RUNMODE to 0.
		}

Print_MissionTime(0).
name_runmode().
AFTS_Status().
Print_Altitude().
Print "FALCON 9 LAUNCH CONTROL CENTER" at ( 2, 1).
Print "-------------------------------------" at ( 2, 2).
Print "____________________________________" at ( 3, 7).
}

Function Cosntants_and_variables_Prep {
	Set Printed1 to False.
	Set AFTS to 1.
}

Function AFTS_Status{
    If AFTS = 0 {
        Print "AFTS:          " + "Saved" + "          " at ( 3, 6).
        }
    Else if AFTS = 1 {
        Print "AFTS:          " + "On" + "          " at ( 3, 6).
    }
}

Function name_runmode {
	If RUNMODE = 0 {
		Print "RUNMODE:		  " + "				" at ( 3, 3).
	}
    Else if RUNMODE = 1 {
        Print "RUNMODE:       Start Up" + "                 " at ( 3, 3).
        }
    Else if RUNMODE = 2 {
        Print "RUNMODE:       Liftoff" + "                   " at ( 3, 3).
        }
    Else if RUNMODE = 3 {
        Print "RUNMODE:       Pitching Downrange" + "                   " at ( 3, 3).
        }
    Else if RUNMODE = 4 {
        Print "RUNMODE:       Throttle Down" + "                  " at ( 3, 3).
        }
    Else if RUNMODE = 5 {
        Print "RUNMODE:       Gravity Turn" + "                  " at ( 3, 3).
        }
    Else if RUNMODE = 6 {
        Print "RUNMODE:       Throttle Bocket" + "                 " at ( 3, 3).
        }
    Else if RUNMODE = 7 {
        Print "RUNMODE:       Prep for MECO" + "                   " at ( 3, 3).
        }
    Else if RUNMODE = 8 {
        Print "RUNMODE:       MECO" + "                    " at ( 3, 3).
        }
}

Function Print_Altitude {
    If Altitude > 999 {
        Set Thousands to floor(Altitude/1000).
        Set Units to round(Altitude - Thousands*1000).
        If Units > 99 {
            Print "Altitude:      " + Thousands + "," + Units + "m" + "              " at ( 3, 4).
            }
        Else if Units < 99 and Units > 9 {
            Print "Altitude:      " + Thousands + "," + "0" + Units + "m" + "              " at ( 3, 4).
            }
        Else if Units < 9 {
            Print "Altitude:      " + Thousands + "," + "00" + Units + "m" + "              " at ( 3, 4).
            }
        }
    Else if Altitude < 999 {
        Print "Altitude:      " + round(Altitude) + "m" + "             " at ( 3, 4).
        }       
}

Function Print_MissionTime {
    Parameter delay.

	If missiontime+delay < 60 {
        Set Seconds to floor(delay+Missiontime).
        If Seconds < 10 {
            Print "Mission Time:  " + "00:" + "0" + Seconds + "          " at ( 3, 5).
        }
        Else if Seconds = 10 or Seconds {
            Print "Mission Time:  " + "00:" + Seconds + "          " at ( 3, 5).
            }
		}
	Else if missiontime+delay > 60 and missiontime+delay < 120 {
        Set Seconds to floor(delay+missiontime-60).
        If Seconds < 10 {
            Print "Mission Time:  " + "01:" + "0" + Seconds + "          " at ( 3, 5).
            }
        Else if Seconds = 10 or Seconds > 10 {
            Print "Mission Time:  " + "01:" + Seconds + "          " at ( 3, 5).
            }
		}
	Else if missiontime+delay > 120 and missiontime+delay < 180 {
        Set Seconds to floor(delay+Missiontime-120).
        If Seconds < 10 {
            Print "Mission Time:  " + "02:" + "0" + Seconds + "          " at ( 3, 5).
            }
        Else if Seconds = 10 or Seconds > 10 {
            Print "Mission Time:  " + "02:" + Seconds + "          " at ( 3, 5).
            }
		}
	Else if missiontime+delay > 180 and missiontime+delay < 240 {
        Set Seconds to floor(delay+Missiontime-180).
        If Seconds < 10 {
            Print "Mission Time:  " + "03:" + "0" + Seconds + "          " at ( 3, 5).
            }
        Else if Seconds = 10 or Seconds > 10 {
            Print "Mission Time:  " + "03:" + Seconds + "          " at ( 3, 5).
            }
		}
	Else if missiontime+delay > 240 and missiontime+delay < 300 {
        Set Seconds to floor(delay+Missiontime-240).
        If Seconds < 10 {
            Print "Mission Time:  " + "04:" + "0" + Seconds + "          " at ( 3, 5).
            }
        Else if Seconds = 10 or Seconds > 10 {
            Print "Mission Time:  " + "04:" + Seconds + "          " at ( 3, 5).
            }
		}
	Else if missiontime+delay > 300 and missiontime+delay < 360 {
        Set Seconds to floor(delay+Missiontime-300).
        If Seconds < 10 {
            Print "Mission Time:  " + "05:" + "0" + Seconds + "          " at ( 3, 5).
            }
        Else if Seconds = 10 or Seconds > 10 {
            Print "Mission Time:  " + "05:" + Seconds + "          " at ( 3, 5).
            }
		}
	Else if missiontime+delay > 360 and missiontime+delay < 420 {
        Set Seconds to floor(delay+Missiontime-360).
        If Seconds < 10 {
            Print "Mission Time:  " + "06:" + "0" + Seconds + "          " at ( 3, 5).
            }
        Else if Seconds = 10 or Seconds > 10 {
            Print "Mission Time:  " + "06:" + Seconds + "          " at ( 3, 5).
            }
		}
	Else if missiontime+delay > 420 and missiontime+delay < 480 {
        Set Seconds to floor(delay+Missiontime-420).
        If Seconds < 10 {
            Print "Mission Time:  " + "07:" + "0" + Seconds + "          " at ( 3, 5).
            }
        Else if Seconds = 10 or Seconds > 10 {
            Print "Mission Time:  " + "07:" + Seconds + "          " at ( 3, 5).
            }
		}
	Else if missiontime+delay > 480 and missiontime+delay < 540 {
        Set Seconds to floor(delay+Missiontime-480).
        If Seconds < 10 {
            Print "Mission Time:  " + "08:" + "0" + Seconds + "          " at ( 3, 5).
            }
        Else if Seconds = 10 or Seconds > 10 {
            Print "Mission Time:  " + "08:" + Seconds + "          " at ( 3, 5).
            }
		}
	Else if missiontime+delay > 540 and missiontime+delay < 600 {
        Set Seconds to floor(delay+Missiontime-540).
        If Seconds < 10 {
            Print "Mission Time:  " + "09:" + "0" + Seconds + "          " at ( 3, 5).
            }
        Else if Seconds = 10 or Seconds > 10 {
            Print "Mission Time:  " + "09:" + Seconds + "          " at ( 3, 5).
            }
		}
}

Function gimbaltest {
    Set ship:control:pitch to +1.
    Wait 1.
    Set ship:control:neutralize to true.
    Wait 0.01.
    Set ship:control:yaw to +1.
    Wait 1.
    Set ship:control:neutralize to true.
    Wait 0.01.
    Set ship:control:pitch to -1.
    Wait 1.
    Set ship:control:neutralize to true.
    Wait 0.01.
    Set ship:control:yaw to -1.
    Wait 1.
    Set ship:control:neutralize to true.
    Print "Engine gimbal test completed.".
}