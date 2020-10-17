﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetControlDelay -1

programName := "Uhaczka by Frostspikee"

Gui, Show, X200 Y200 W300 H300, %programName%
Gui, Add, Button, w133 gSelectCoords, Wybierz pozycję celu
Gui, Add, Text, vTankerPos, x0 y0
Gui, Add, Text,, Hotkey UHa ; The ym option starts a new column of controls.
Gui, Add, Hotkey, vUH_hotkey, F1

Gui, Add, Text,, Hotkeye odpalające uhaczkę.
Loop 5 {
    Gui, Add, Hotkey, vTrigger_htk%A_Index% gTrigger_htk, F2
}

; Load values from store
IniRead, OutputVar, %A_ScriptFullPath%:Stream:$DATA, Options, TankerPos, x0 y0
GuiControl, Text, TankerPos, %OutputVar%
GuiControl, Move, TankerPos, W300
IniRead, OutputVar, %A_ScriptFullPath%:Stream:$DATA, Options, UH_hotkey, 1
GuiControl, Text, UH_hotkey, %OutputVar%

return

GuiClose:
	GuiControlGet, TankerPos ,, TankerPos
	IniWrite, %TankerPos%, %A_ScriptFullPath%:Stream:$DATA, Options, TankerPos
	GuiControlGet, htk ,, UH_hotkey
	IniWrite, %htk%, %A_ScriptFullPath%:Stream:$DATA, Options, UH_hotkey
	ExitApp
return

Trigger_htk:
	num := SubStr(A_GuiControl,A_GuiControl.length - 1)
	If (savedHK%num%) { ;If a hotkey was already saved...
		Hotkey,% savedHK%num%, Uhaczka, Off        ;     turn the old hotkey off
		savedHK := false                    ;     add the word 'OFF' to display in a message.
 	}
	Keys := % %A_GuiControl%
	Hotkey, ~%Keys%, Uhaczka, On
	savedHK%num% := %A_GuiControl%
	WinActivate, Program Manager ; lose focus
return

Uhaczka:
	sleep 25
	GuiControlGet, coords ,, TankerPos
	GuiControlGet, UH_Htk ,, UH_hotkey
	ControlFocus,, Tibia -
	ControlSend,, {%UH_Htk% down}, Tibia -
	ControlClick, %coords%, Tibia -,,Left
return

SelectCoords:
	SetTimer, WatchCursor, 20
	return
return

WatchCursor:
	CoordMode, Mouse, Screen
	MouseGetPos, xpos, ypos
	ToolTip, `Select training dummy position`n`x: %xpos% y: %ypos%`
	
	if (GetKeyState("LButton")) {
		MsgBox, , , %xpos% %ypos%, 0.3
		BlockInput, Mouse
		GuiControl, Text, TankerPos, x%xpos% y%ypos%
		GuiControl, Move, TankerPos, W300
		SetTimer, WatchCursor, Off
		ToolTip
		WinActivate, %programName%
	}
return
