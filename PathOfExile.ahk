#IfWinActive ahk_class POEWindowClass
#SingleInstance Force
#Persistent
SendMode Input

ToggleKeys := true

CharNames := ["Lesbophilia", "Vyollette", "Revolutionnaire", "Glacillys"]
CharIndex := 1
InitChar()

Flasks := {Quicksilver: new FlaskGroup("345")}

SetTimer, CornerNotifyVisibilityLoop, 10

CornerNotifyVisibilityLoop:
    WinSet, AlwaysOnTop, % WinActive("ahk_class POEWindowClass") ? "On" : "Off", ahk_id %cornernotify_hwnd%
return

SendCommand(command) {
    Send {Enter}/%command%{Enter}{Enter}{Up}{Up}{Escape}
}

class FlaskDefinitions {
    __New(life = "", mana = "", utility = "", speed = "") {
        this.Life := new FlaskGroup(life)
        this.Mana := new FlaskGroup(mana)
        this.Utility := new FlaskGroup(utility)
        this.Speed := new FlaskGroup(speed)
    }
}

class FlaskGroup {
    __New(keys) {
        this.Keys := keys
        this.Index := 0
    }
    Rotate() {
        this.Index := Mod(this.Index + 1, StrLen(this.Keys))
        return SubStr(this.Keys, this.Index, 1)
    }
    SendRotate() {
        Send % this.Rotate()
    }
    SendPiano(keys := "") {
        if (keys == "") {
            keys := this.Keys
        }
        Loop, Parse, keys
        {
            Send %A_LoopField%
            Random, delay, 10, 50
            Sleep, delay
        }
    }
}

#include CornerNotify.ahk

F1::SendCommand("remaining")
F2::SendCommand("passives")
F3::SendCommand("hideout")
F4::SendCommand("exit")
F5::SendCommand("oos")
F6::SendCommand("itemlevel")
F7::SendCommand("deaths")
!Backspace::SendCommand("cls")

^!x::
SendCommand("reset_xp")
CornerNotify(1, "Exp Per Hour", "Reset", "vc hc")
return

!w::
ThanksMessage := "thanks (☯‿☯✿)"
Send % "^{Enter}" ThanksMessage "{Enter}{Enter}/kick " CharNames[CharIndex] "{Enter}{Enter}/hideout{Enter}"
return

!c::Numpad1 ;Character

LWin::
~Enter::
~^f::
DoToggleKeys()
return

DoToggleKeys() {
    global ToggleKeys
    title := "Toggle Keys"
    ToggleKeys := !ToggleKeys
    message := ToggleKeys ? "Active" : "Suspended"
    if (ToggleKeys) {
         CornerNotify(0, title, message, "vc hc")
    } else {
         CornerNotify_Create(title, message, "vc r")
    }
}

RotateQuicksilver() {
    global QuicksilverKeys, QuicksilverIndex
    return RotateFlask(QuicksilverKeys, QuicksilverIndex)
}

RotateFlask(keys, ByRef index) {
    index := Mod(index + 1, StrLen(keys))
    return SubStr(keys, index, 1)
}

InitChar() {
    global CharIndex, CharNames, Flasks
    name := CharNames[CharIndex]

    life := "1"
    mana := "5"
    speed := "234"
    utility := ""
    
    if (name == "Revolutionnaire") {
        utility := "2"
        speed := "34"
    } else if (name == "Vyollette") {
        speed := "2345"
        mana := speed
        utility := speed
    }
    CornerNotify(2, "Character Name", name, "vc hc")
}

^!c::
    global CharIndex := Mod(CharIndex, CharNames.Length()) + 1
    InitChar()
return


#If ToggleKeys && WinActive("ahk_class POEWindowClass")

X::NumpadDot ;Social
G::Numpad0 ;Inventory
C::Numpad2 ;Tree
Z::Numpad3 ;Quest
V::Numpad5 ;Challenge
B::Numpad6 ;Atlas


q::1 ;DoPiano(12) 

w::
    Flasks.Quicksilver.SendPiano()
/*    if (CharNames[CharIndex] == "Revolutionnaire") {
        DoPiano("2" + RotateQuicksilver())
    } else {
        Send % RotateQuicksilver()
    }
*/
return

e::Flasks.Quicksilver.SendRotate()

a::5
;+XButton1::3
;XButton2::f
;XButton1::d
;+Space::q
^WheelUp::Left
^WheelDown::Right