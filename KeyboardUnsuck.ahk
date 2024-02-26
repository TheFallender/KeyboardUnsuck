#NoEnv
#Persistent
#SingleInstance, force
SendMode Input
SetWorkingDir %A_ScriptDir%

; Icons
FileCreateDir, %A_ScriptDir%\icons
FileInstall, .\icons\keyboardUnsuck.ico, %A_ScriptDir%\icons\keyboardUnsuck.ico, 1
FileInstall, .\icons\keyboardUnsuckPaused.ico, %A_ScriptDir%\icons\keyboardUnsuckPaused.ico, 1
FileInstall, .\icons\keyboardUnsuckSuspend.ico, %A_ScriptDir%\icons\keyboardUnsuckSuspend.ico, 1
FileInstall, .\icons\keyboardUnsuckSuspendedAndPaused.ico, %A_ScriptDir%\icons\keyboardUnsuckSuspendedAndPaused.ico, 1

; Define icon paths
mainIcon := A_ScriptDir . "\icons\keyboardUnsuck.ico"
pauseIcon := A_ScriptDir . "\icons\keyboardUnsuckPaused.ico"
suspendIcon := A_ScriptDir . "\icons\keyboardUnsuckSuspend.ico"
suspendedAndPausedIcon := A_ScriptDir . "\icons\keyboardUnsuckSuspendedAndPaused.ico"

; Set initial tray icon
Menu, Tray, Icon, %mainIcon%

; Monitor pause and suspend messages
OnMessage(0x111, "WM_COMMAND")
OnMessage(0x112, "WM_SYSCOMMAND")

; Handler for WM_COMMAND and WM_SYSCOMMAND messages
WM_COMMAND(wParam)
{
    global mainIcon, suspendIcon, pauseIcon, suspendedAndPausedIcon
    if (wParam = 65305) ; WM_SYSCOMMAND, SC_MONITORPOWER
    {
        static suspended := false
        suspended := !suspended
        changed := true
    }
    else if (wParam = 65306) ; WM_COMMAND, ID_FILE_PAUSE
    {
        static paused := false
        paused := !paused
        changed := true
    }

    if (changed) {
        changed := false
        if (paused && suspended) {
            Menu, Tray, Icon, %suspendedAndPausedIcon%,, 1
        } else if (paused) {
            Menu, Tray, Icon, %pauseIcon%,, 1
        } else if (suspended) {
            Menu, Tray, Icon, %suspendIcon%,, 1
        } else {
            Menu, Tray, Icon, %mainIcon%,, 1
        }
    }
}


; Toggle script with hotkey
^+NumpadDiv::
    Suspend,Toggle
    WM_COMMAND(65305)

; ` ` ` ` ` `
SC029::singleKey("SC029", False)

; ~ ~ ~ ~ ~ ~
+SC029::singleKey("SC029", True)

; ° ° ° ° ° °
<^>!SC029::SendRaw, °

; ^ ^ ^ ^ ^ ^
+SC007::singleKey("SC007", True)

; ' ' ' ' ' '
SC028::singleKey("SC028", False)

; " " " " " "
+SC028::singleKey("SC028", True)

singleKey(keyToPress, shiftPress) {
    keyName := GetKeyName(keyToPress)
    ; MsgBox, % Format("Name:`t{}`nVK:`t{:X}`nSC:`t{:X}", name, vk, sc)
    Loop, 2 {
        if (shiftPress) {
            Send +{%keyName%}
        } else {
            Send {%keyName%}
        }
    }
    Send {BackSpace}
}