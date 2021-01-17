Clearscreen.
SetVariables().

copypath("0:/CoastPhase.ks","").
copypath("0:/Landing.ks","").

Set runmode to 1.

until runmode = 0 {

    if runmode = 1 {
        AG2 on.
        RCS on.
        Set ship:control:yaw to -1.
        Wait 6.
        Set runmode to 2.
    }

    if runmode = 2 {
        Set ship:control:neutralize to true.
        Set throttle to 0.1.
        Roll().
        Set steering to heading(270,0).
        Wait 2.
        Set runmode to 3.
    }

    if runmode = 3 {
        Set throttle to 1.
        RCS off.
        until Y > -0.4 {
            Difference().
            SteerX(50).
            PrintValue1().
        }
        Set runmode to 4.
    }

    if runmode = 4 {
        Set throttle to 0.4.
        Until Y > -0.2 {
            Difference().
            SteerX(110).
            PrintValue1().
        }
        Set runmode to 5.
    }

    if runmode = 5 {
        Set throttle to 0.01.
        Until Y > -0.035 {
            Difference().
            SteerX(150).
            PrintValue1().
        }
        Set runmode to 6.
    }

    if runmode = 6 {
        Set throttle to 0.
        Wait 5.
        Brakes on.
        Set runmode to 0.
    }
}

RUN CoastPhase.ks.

function SetVariables {
    Set TargetImpactY to -80.589559.
    Set TargetImpactX to 28.6105.
    
    Set Y to -1.
}

function SteerX {
    Parameter b.
    Set X to TargetImpactX - Addons:TR:Impactpos:lat.
    Set Yw to (270 + x * b).
    Set steering to heading (Yw,0).
}

function Difference {
    Set Y to TargetImpactY - Addons:TR:Impactpos:lng.
}

function Roll {
    Set ship:control:neutralize to false.
    Set ship:control:pitch to -0.4.
    Set ship:control:roll to +1.
    Wait 4.
    Set ship:control:neutralize to true.
}

function PrintValue1 {
    Print "Yw               " + Yw at (2,7).
    Print "Y                " + Y at (2,8).
    Print "Target Y         " + round(Addons:TR:Impactpos:lng, 6) at (2,9).
    Wait 0.01.
}

function PrintValue2 {
    Print "outputX   " + outputX at (2,7).
    Print "outputY   " + outputY at (2,8).
    Print "PY        " + PY at (2,9).
    Print "DY        " + DY at (2,10).
    Print "PX        " + PX at (2,11).
    Print "DX        " + DX at (2,12).
	Print "Y		 " + y  at (2,14).
	Print "X		 " + x  at (2,15).
    Print "Yw        " + Yw at (2,17).
    Print "Ph        " + Ph at (2,18).

    Wait 0.01.
}