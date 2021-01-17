Clearscreen.                    //Initial Set Up
RCS on.
Brakes on.
Cosntants_and_variables_Prep().

Until RUNMODE = 0 {

    If RUNMODE = 1 {
        If altitude < 55000 {
            Set RUNMODE to 2.   //Entry Burn Starts
            }
        }

    Else if RUNMODE = 2 {
        SAS off.
        RCS off.
        Set Throttle to 0.82.
        Set kDYaw TO 200000.
        Set RUNMODE to 3.
        }

    Else if RUNMODE = 3 {                   //Yaw Guidance During Entry Burn
        If altitude > 37000 {
            PID_Loop_Yaw_Engine(TargetImpactX, Addons:TR:Impactpos:lat).
            Set outputYaw to Max(-3, Min(-1*preoutputYaw, 3)).
            Set steering to up + r(outputYaw, -8, 180).
            // Set steering to heading( 90 - outputYaw, 85).
            Print_Distance().
            Wait 0.01.
            }
        If Altitude < 50000 and Suit = 0 {
            AG3 on.
            Set Suit to 1.
            }
        If altitude < 37000 {
            Set RUNMODE to 4.
            }
        }
    
    Else if RUNMODE = 4 {
        Set Throttle to 0.                  //End of Entry Burn
        RCS on.
        Set kPYaw to 50.
        Set kDYaw to 1000000.
        AG2 off.
        If altitude < 75000 {
            Set RUNMODE to 5.
            }
        }

    Else if RUNMODE = 5 {                   //GridFins Control
        If ship:altitude > 25000 {
            Adjust_Gains().
            Loop_Pitch_GridFins().
            Set FinalOutputPitch to Max(-10, Min(prePitch, 70)).
            Print "Output: " + round(90 - FinalOutputPitch, 5) + "     " at (3,13).
            PID_Loop_Yaw_GridFins(TargetImpactX, Addons:TR:Impactpos:lat).
            Set outputYaw to Max(-6, Min(preoutputYaw, 2)).
            Set FinalOutputYaw to outputYaw+16.
            Set steering to up + r(FinalOutputYaw, -1*FinalOutputPitch, 180).
            Print_Distance().
            Print "Output: " + round(FinalOutputYaw, 5) + "     " at (3,20).
            Wait 0.01.
            }
        If ship:altitude < 25000 {                  //Increase in P gains (for more accuracy)
            Set AFTS to 0.
            Set OffSetY to 13.
            Set kPPitch to 3500.
            Set kDPitch to 150.
            Set kDYaw to 1500.
            RCS off.
            Set RUNMODE to 6.
            }
        }

    Else if RUNMODE = 6 {
        If ship:altitude > 4150 {   // 4850
            Adjust_Gains().
            Loop_Pitch_GridFins().
            Set FinalOutputPitch to Max(-10, Min((prePitch-5), 70)).
            Print "Output: " + round(90 - FinalOutputPitch, 5) + "     " at (3,13).
            PID_Loop_Yaw_GridFins(TargetImpactX, Addons:TR:Impactpos:lat).
            Set outputYaw to Max(-15, Min(preoutputYaw, 10)).
            Set FinalOutputYaw to outputYaw+16.
            Set steering to up + r(FinalOutputYaw, -1*FinalOutputPitch, 180).
            Print_Distance().
            Print "Output: " + round(FinalOutputYaw, 5) + "     " at (3,20).
            Wait 0.01.
            }
        If ship:altitude < 4150 {                   //Increase in P & D gains (for more accuracy) and Readjusting Target Location
            Set OffSetY to 10.
            Set kPPitch to 3500.
            Set kDPitch to 150.
            Set kDYaw to 150.
            Set TargetImpactY to -80.595516.
            Set TargetImpactX to 28.612839.
            Set RUNMODE to 7.
            }
        }

    Else if RUNMODE = 7 {
        Lock Throttle to idealThrottle.                 //Throttle Control Activated
        If ship:verticalspeed < -175 {
            Adjust_Gains().
            Loop_Pitch_GridFins().
            Set FinalOutputPitch to Max(-10, Min(prePitch, 70)).
            Print "Output: " + round(90 - FinalOutputPitch, 5) + "     " at (3,13).
            PID_Loop_Yaw_GridFins(TargetImpactX, Addons:TR:Impactpos:lat).
            Set outputYaw to Max(-25, Min(preoutputYaw, 15)).
            Set FinalOutputYaw to outputYaw+16.
            Set steering to up + r(FinalOutputYaw, -1*FinalOutputPitch, 180).
            Print_Distance().
            Print "Output: " + round(FinalOutputYaw, 5) + "     " at (3,20).
            Wait 0.01.
            }
        If ship:verticalspeed > -175 {
            Clearscreen.
            Set kDYaw to 150.
            Set kDPitch to 150.
            Set OffSetY to 0.
            Set kPPitch to 180000.
            Set kPYaw to 225000.
            Set RUNMODE to 8.
            }
        }

    Else if RUNMODE = 8 {                   //Final Powered Descent
        If ship:verticalspeed < -80 {
            PID_Loop_Pitch_Engine(TargetImpactY, Addons:TR:Impactpos:lng).
            Set outputPitch to Max(-20, Min(-1*preoutputPitch-10, 20)).
            PID_Loop_Yaw_Engine(TargetImpactX, Addons:TR:Impactpos:lat).
            Set outputYaw to Max(-10, Min(-1*preoutputYaw-5, 10)).
            Set steering to up + r( outputYaw, outputPitch, 180).
            Print_Distance().
            }
        If ship:verticalspeed > -80 {
            Set kDYaw to 200.
            Set kDPitch to 200.
            Set kPPitch to 180000.
            Set kPYaw to 225000.
            Set OffSetY to 0.
            RCS on.
            Set RUNMODE to 9.
            }
        }

    Else if RUNMODE = 9 {                   //Final Powered Descent
        If ship:verticalspeed < -15 {
            PID_Loop_Pitch_Engine(TargetImpactY, Addons:TR:Impactpos:lng).
            Set outputPitch to Max(-10, Min(-1*preoutputPitch-10, 10)).
            PID_Loop_Yaw_Engine(TargetImpactX, Addons:TR:Impactpos:lat).
            Set outputYaw to Max(-8, Min(-1*preoutputYaw-5, 8)).
            Set steering to up + r( outputYaw, outputPitch, 180).
            Print_Distance().
            Deploy_Landing_Legs(-50, -47, -50, -45).                    //Landing Legs Deployement
            }
        If ship:verticalspeed > -15 {
            Set RUNMODE to 10.
            }
        }

    Else if RUNMODE = 10 {
        If ship:verticalspeed < -15 {
            Lock Steering to getVectorSurfaceRetrograde().
            Print_Distance().
            }
        If ship:verticalspeed > -15 {
            Set RUNMODE to 11.
            }
        }

    Else if RUNMODE = 11 {                  //Setting Steering to up
        Set steering to up + r(0, 0, 180).
        If ship:verticalspeed < -5 {
            Print_Distance().
        }
        If ship:verticalspeed > -0.2 {
            Set RUNMODE to 12.
            }
        }

    Else if RUNMODE = 12 {                  //Ending Step
        Set Throttle to 0.
        Wait 1.
        If totaldelta < 10 {
            Print "LZ, the Falcon has landed." at (3,29).
            }
        Wait 10.
        Set RUNMODE to 13.
        }

    Else if RUNMODE = 13 {                  //Resetting
		Brakes off.
		Unlock Throttle.
		Unlock Steering.
		RCS off.
		Set RUNMODE to 0.
    }

Print_MissionTime(150).
name_runmode().
Landing_Legs_Print().
AFTS_Status().
Print_Altitude().
Print "FALCON 9 LANDING CONTROL CENTER" at ( 2, 1).
Print "-------------------------------------" at ( 2, 2).
Print "____________________________________" at ( 3, 7).
}

Clearscreen.
Final_Status(10).

Function Cosntants_and_variables_Prep {

    Set RUNMODE to 1.

    Set TargetImpactY to -80.5991854.
    Set TargetImpactX to 28.6108.
    
    Set kPPitch to 2500.
    Set kIPitch to 0.
    Set kDPitch to 1.
    Set OffSetY to 10.
    Set lastPPitch to 0.
    Set lastTimePitch to 0.
    Set totalPPitch to 0.
    
    Set kPYaw to 75000.
    Set kIYaw to 0.1.
    Set kDYaw to 4.
    Set lastPYaw to 0.
    Set lastTimeYaw to 0.
    Set totalPYaw to 0.

    Set radarOffSet to 43.
    lock trueRadar to alt:radar - radarOffSet.
    lock g to constant:g * body:mass / body:radius^2.
    lock MaxDecel to (ship:availablethrust / ship:mass) - g.
    lock stopDist to ship:verticalspeed^2 / (2 * MaxDecel).
    lock idealThrottle to 1 * (stopDist / trueRadar).
    lock impactTime to trueRadar / abs(ship:verticalspeed).

    Set Leg1 to False.
    Set Leg2 to False.
    Set Leg3 to False.
    Set Leg4 to False.

    Set AFTS to 1.
    Set Suit to 0.
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
    If RUNMODE = 1 {
        Print "RUNMODE:       " + "                 " at ( 3, 3).
        }
    Else if RUNMODE = 2 {
        Print "RUNMODE:       Entry Burn StartUp" + "                   " at ( 3, 3).
        }
    Else if RUNMODE = 3 {
        Print "RUNMODE:       Entry Burn" + "                   " at ( 3, 3).
        }
    Else if RUNMODE = 4 {
        Print "RUNMODE:       Entry Burn ShutDown" + "                  " at ( 3, 3).
        }
    Else if RUNMODE = 5 {
        Print "RUNMODE:       Grid Fins Control" + "                  " at ( 3, 3).
        }
    Else if RUNMODE = 6 {
        Print "RUNMODE:       Grid Fins Control [Final]" + "                 " at ( 3, 3).
        }
    Else if RUNMODE = 7 {
        Print "RUNMODE:       Landing Burn [Aerodynamic Control]" + "                   " at ( 3, 3).
        }
    Else if RUNMODE = 8 {
        Print "RUNMODE:       Landing Burn [Engine Control 1]" + "                    " at ( 3, 3).
        }
    Else if RUNMODE = 9 {
        Print "RUNMODE:       Landing Burn [Retrograde Target]" + "                    " at ( 3, 3).
        }
    Else if RUNMODE = 10 {
        Print "RUNMODE:       Pre-TouchDown" + "                    " at ( 3, 3).
        }
    Else if RUNMODE = 11 {
        Print "RUNMODE:       TouchDown" + "                    " at ( 3, 3).
        }
    Else if RUNMODE = 12 {
        Print "RUNMODE:       Shuting Down" + "                    " at ( 3, 3).
        }
}

Function Loop_Pitch_GridFins {
    Set prePitch to 0.
    Set outputPitch to 0.
    Set nowPitch to time:seconds.

    Set DeltaY to Addons:TR:Impactpos:lng - TargetImpactY.
    Set DPitch to 0.

    If lastTimePitch > 0 {
        Set DPitch to (DeltaY - lastPPitch) / (nowPitch - lastTimePitch).
    }

    Set prePitch to DeltaY * kPPitch + OffSetY + DPitch * kDPitch.

    Print "GridFins Pitch PD" at (3,9).
    Print "P: " + round(DeltaY, 5) at (3,10).
    Print "D: " + round(DPitch, 5) at (3,11).
    Print "PreOutput: " + round(prePitch,5) at (3,12).

    Set lastPPitch to DeltaY.
    Set lastTimePitch to nowPitch.

    Return prePitch.
}

Function PID_Loop_Yaw_GridFins {
    Parameter target.
    Parameter current.

    Set preoutputYaw to 0.
    Set outputYaw to 0.
    Set nowYaw to time:seconds.
    
    Set PYaw to target - current.
    Set IYaw to 0.
    Set DYaw to 0.

    If lastTimeYaw > 0 {
        Set IYaw to totalPYaw + ((PYaw +lastPYaw)/2 * (nowYaw - lastTimeYaw)).
        Set DYaw to (PYaw - lastPYaw) / (nowYaw - lastTimeYaw).
    }

    Set preoutputYaw to PYaw * kPYaw + IYaw * kIYaw + DYaw * kDYaw.

    Print "GridFinsYaw PID" at (3,15).
    Print "P: " + round(PYaw, 5) at (3,16).
    Print "I: " + round(IYaw, 5) at (3,17).
    Print "D: " + round(DYaw, 5) at (3,18).
    Print "PreOutput: " + round(preoutputYaw, 5) at (3,19).

    Set lastPYaw to PYaw.
    Set lastTimeYaw to nowYaw.
    Set totalPYaw to IYaw.

    Return preoutputYaw.
}

Function PID_Loop_Pitch_Engine {
    Parameter target.
    Parameter current.

    Set preoutputPitch to 0.
    Set outputPitch to 0.
    Set nowPitch to time:seconds.
    
    Set PPitch to target - current.
    Set IPitch to 0.
    Set DPitch to 0.

    If lastTimePitch > 0 {
        Set IPitch to totalPPitch + ((PPitch +lastPPitch)/2 * (nowPitch - lastTimePitch)).
        Set DPitch to (PPitch - lastPPitch) / (nowPitch - lastTimePitch).
    }

    Set preoutputPitch to PPitch * kPPitch + IPitch * kIPitch + DPitch * kDPitch.
    Set outputPitch to Max(-7, Min(-1*preoutputPitch, 7)).

    Print "Engine Pitch PID" at (3,9).
    Print "P: " + round(PPitch, 5) at (3,10).
    Print "I: " + round(IPitch, 5) at (3,11).
    Print "D: " + round(DPitch, 5) at (3,12).
    Print "Output: " + round(outputPitch,5) at (3,13).

    Set lastPitch to PPitch.
    Set lastTimePitch to nowPitch.
    Set totalPPitch to IPitch.

    Return outputPitch.
}

Function PID_Loop_Yaw_Engine {
    Parameter target.
    Parameter current.

    Set preoutputYaw to 0.
    Set outputYaw to 0.
    Set nowYaw to time:seconds.
    
    Set PYaw to target - current.
    Set IYaw to 0.
    Set DYaw to 0.

    If lastTimeYaw > 0 {
        Set IYaw to totalPYaw + ((PYaw +lastPYaw)/2 * (nowYaw - lastTimeYaw)).
        Set DYaw to (PYaw - lastPYaw) / (nowYaw - lastTimeYaw).
    }

    Set preoutputYaw to PYaw * kPYaw + IYaw * kIYaw + DYaw * kDYaw.
    Set outputYaw to Max(-7, Min(-1*preoutputYaw, 7)).

    Print "Engine Yaw PID" at (3,15).
    Print "P: " + round(PYaw, 5) at (3,16).
    Print "I: " + round(IYaw, 5) at (3,17).
    Print "D: " + round(DYaw, 5) at (3,18).
    Print "Output: " + round(outputYaw, 5) at (3,19).

    Set lastPYaw to PYaw.
    Set lastTimeYaw to nowYaw.
    Set totalPYaw to IYaw.

    Return outputYaw.
}

Function Throttle_Landing {
    Set preautoThrottle to PID_Loop_Throttle_Landing(125, altitude).
    Set autoThrottle to Max(0.3, Min(preautoThrottle, 1)).
    Set Throttle to autoThrottle.
    Wait 0.001.
}

Function getVectorSurfaceRetrograde {
	Return -1*ship:velocity:surface.
}

Function OnOff {
    RCS on.
    Wait 1.5.
    RCS off.
    Wait 15.
}

Function Adjust_Gains {
    Set kPYaw to (-1/7)*(ship:altitude)+18000.
}

Function Deploy_Landing_Legs {
    Parameter Speed1.
    Parameter Speed2.
    Parameter Speed3.
    Parameter Speed4.

    If ship:verticalspeed > Speed1 and Leg1 = False {
        AG7 on.
        Set Leg1 to True.
        }
    If ship:verticalspeed > Speed2 and Leg2 = False {
        AG8 on.
        Set Leg2 to True.
        }
    If ship:verticalspeed > Speed3 and Leg3 = False {
        AG9 on.
        Set Leg3 to True.
        }
    If ship:verticalspeed > Speed4 and Leg4 = False {
        AG10 on.
        Set Leg4 to True.
        }
}

Function Print_Distance {
    Set deltaY to TargetImpactY - Addons:TR:Impactpos:lng.
    Set deltaX to TargetImpactX-Addons:TR:Impactpos:lat.
    Set mdeltaY to (deltaY/360) * (2*constant:pi*Earth:radius).
    Set mdeltaX to (deltaX/360) * (2*constant:pi*Earth:radius).
    Set totaldelta to sqrt(((mdeltaY)*(mdeltaY)) + ((mdeltaX)*(mdeltaX))).
    Print "Distance" at (3,22).
    Print "Delta Longitude:  " + round(mdeltaY, 2) + "m" + "                                " at (3,23).
    Print "Delta Latitude:   " + round(mdeltaX, 2) + "m" + "                                " at (3,24).
    Print "Total Distance:   " + round(totaldelta, 2) + "m" + "                             " at (3,25).
}

Function Final_Status {
    PARAMETER Required_Accuracy.

    If totaldelta < Required_Accuracy {
        Print "Succesful Landing!!" at ( 3, 8).
        Print "Final Distance:  " + round(totaldelta, 3) + "m" + "                                    " at ( 3, 9).
        }
    Else if totaldelta > Required_Accuracy {
        Print "Unsufficient Accuracy" at (3, 8).
        Print "Final Distance:  " + round(totaldelta, 3) + "m" + "                                    " at ( 3, 9).
    }
}

Function Landing_Legs_Print {
    If Leg1 = True and Leg2 = True and Leg3 = True and Leg4 = True and ship:verticalspeed > -55 {
        Print "Landing Legs Deployed." at (3,27).
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