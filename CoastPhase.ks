Clearscreen.

copypath("0:/Landing.ks","").

Initial_Pulse().

Set steering to heading( 90, 87).

until ship:altitude < 110000 and ship:verticalspeed < 0 {
    Onoff().
}

SAS on.

until ship:altitude < 90000 {
    Onoff().
    Set steering to heading( 90, 87).
}

SAS off.

RUN Landing.ks.

function OnOff {
    RCS on.
    Wait 1.
    RCS off.
    Wait 2.
}

function Initial_Pulse{
    RCS on.
    Set ship:control:pitch to +1.
    Wait .25.
    RCS off.
    Set ship:control:neutralize to true.
}