#IfWinActive ahk_class POEWindowClass
#SingleInstance Force
SendMode Input

ToggleKeys := true

CharNames := ["Lesbophilia", "Vyollette", "Revolutionnaire", "Glacillys"]
CharIndex := 1
InitChar()

DoPiano(keys) {
    Loop, Parse, keys
    {
        Send %A_LoopField%
        Random, delay, 10, 50
        Sleep, delay
    }
}

SendCommand(command) {
    Send {Enter}/%command%{Enter}{Enter}{Up}{Up}{Escape}
}

#include CornerNotify.ahk

F1::SendCommand("remaining")
F2::SendCommand("passives")
F3::SendCommand("hideout")
F4::SendCommand("exit")
F5::SendCommand("oos")
F6::SendCommand("itemlevel")
F7::SendCommand("deaths")

^!x::
SendCommand("reset_xp")
CornerNotify(1, "Exp Per Hour", "Reset", "vc hc")
return

!w::
ThanksMessage := "thanks (☯‿☯✿)"
Send % "^{Enter}" ThanksMessage "{Enter}{Enter}/kick " CharNames[CharIndex] "{Enter}{Enter}/hideout{Enter}"
return

!Backspace::SendCommand("cls")
!c::Numpad1 ;Character

LWin::DoToggleKeys()

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
    global QuicksilverIndex, QuicksilverStart, QuicksilverCount
    QuicksilverIndex := Mod(QuicksilverIndex + 1, QuicksilverCount)
    return (QuicksilverIndex + QuicksilverStart)
}

InitChar() {
    global CharIndex, CharNames, QuicksilverIndex, QuicksilverStart, QuicksilverCount
    name := CharNames[CharIndex]
    if (name == "Revolutionnaire") {
        QuicksilverStart := 3
        QuicksilverCount := 2
    } else if (name == "Vyollette") {
        QuicksilverStart := 2
        QuicksilverCount := 4
    } else {
        QuicksilverStart := 2
        QuicksilverCount := 3
    }
    QuicksilverIndex := -1
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
    if (CharNames[CharIndex] == "Revolutionnaire") {
        DoPiano("2" + RotateQuicksilver())
    } else {
        Send % RotateQuicksilver()
    }
return

e::Send % RotateQuicksilver()

a::5
;+XButton1::3
;XButton2::f
;XButton1::d
;+Space::q
^WheelUp::Left
^WheelDown::Right