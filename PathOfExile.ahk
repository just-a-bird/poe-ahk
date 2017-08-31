global DEBUG := True

global PoETitle := !DEBUG ? "ahk_class POEWindowClass" : "ahk_exe notepad.exe"

#If WinActive(PoETitle)
#SingleInstance Force
SendMode Input

ToggleKeys := True

Characters := []
Characters.Index := 1

Characters.Push(new Character("Lesbophilia", new FlaskDefinitions()))
Characters.Push(new Character("Vyollette", new FlaskDefinitions(1, "", 2345, "")))
Characters.Push(new Character("Revolutionnaire", new FlaskDefinitions(1, 5, 34, 2)))
Characters.Push(new Character("Glacillys", new FlaskDefinitions()))

CornerNotifyCharacter(GetChar())

GetChar(index="") {
    if (index == "") {
        index := Characters.Index
    }
    return Characters[index]
}

NextChar() {
    global Characters
    Characters.Index := Mod(Characters.Index, Characters.Length()) + 1
    c := Characters[Characters.Index]
    c.Reset()
    return c
}

CornerNotifyCharacter(char) {
    CornerNotify(2, "Character Profile", char.Name, "vc hc")
}

SetTimer, CornerNotifyVisibilityLoop, On

CornerNotifyVisibilityLoop:
    isActive := WinActive(PoETitle)
    WinSet, AlwaysOnTop, % isActive ? "On" : "Off", ahk_id %cornernotify_hwnd%
    if (!isActive) {
        WinSet, Bottom,, ahk_id %cornernotify_hwnd%
    }
return

SendCommand(command) {
    Send {Enter}/%command%{Enter}{Enter}{Up}{Up}{Escape}
}

global Characters := []


class Character {
    __New(name := "", flasks := "") {
        if (flasks == "") {
            flasks :=  new FlaskDefinitions()
        }
        this.Name := name
        this.Flasks := flasks
    }
    Reset() {
        this.Flasks.Reset()
    }
    Hotkey_q() {
        this.Flasks.Life.SendRotate()
    }
    Hotkey_w() {
        FlaskGroup.SendPiano(this.Flasks.Utility.Keys . this.Flasks.Speed.Rotate())
    }
    Hotkey_e() {
        this.Flasks.Speed.SendRotate()
    }
    Hotkey_r() {
        this.Flasks.Utility.SendPiano()
    }
    Hotkey_a() {
        this.Flasks.Mana.SendRotate()
    }
}

class FlaskDefinitions {
    __New(life = 1, mana = 5, speed = 234, utility = "") {
        this.Life := new FlaskGroup(life)
        this.Mana := new FlaskGroup(mana)
        this.Speed := new FlaskGroup(speed)
        this.Utility := new FlaskGroup(utility)
    }
    Reset() {
        this.Life.Reset()
        this.Mana.Reset()
        this.Speed.Reset()
        this.Utility.Reset()
    }
    ToString() {
        return "Life: "    . this.Life.ToString() . "`n"
             . "Mana: "    . this.Mana.ToString() . "`n"
             . "Speed: "   . this.Speed.ToString() . "`n"
             . "Utility: " . this.Utility.ToString()
    }
}

class FlaskGroup {
    __New(keys) {
        this.Keys := keys
        this.Index := 0
    }
    Reset() {
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
    ToString() {
        return """" this.Keys """@" this.Index
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

^!c::CornerNotifyCharacter(NextChar())

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

#If ToggleKeys && WinActive(PoETitle)

X::NumpadDot ;Social
G::Numpad0 ;Inventory
C::Numpad2 ;Tree
Z::Numpad3 ;Quest
V::Numpad5 ;Challenge
B::Numpad6 ;Atlas

q::GetChar().Hotkey_q()
w::GetChar().Hotkey_w()
e::GetChar().Hotkey_e()
r::GetChar().Hotkey_r()
a::GetChar().Hotkey_a()

^WheelUp::Left
^WheelDown::Right