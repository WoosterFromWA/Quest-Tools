#SingleInstance, force
Menu, Tray, Icon, images\red_q_on_blue_bkgd.ico
Menu, Tray, Tip, Window Wizard

SetTitleMatchMode 2
DetectHiddenWindows, On

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Initialization ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Define INI file location
pathINI = %A_AppData%\Quest Integration\QI Tools.ini

; Section of INI file for 3CX
iniSection = WindowWizard

; Initialize iniProps
iniProps := {}

; Properties from INI file with their defaults
iniProps["SlackHide"] := true
iniProps["OutlookHide"] := true
iniProps["TeamsHide"] := true
iniProps["3cxHide"] := true

iniProps := QIFunctions_readINI(pathINI, iniProps, iniSection)

TeamsHide := iniProps["TeamsHide"]
SlackHide := iniProps["SlackHide"]
OutlookHide := iniProps["TeamsHide"]
3cxHide := iniProps["3cxHide"]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Main Code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

F6::
IfWinExist, - Outlook
{
	QIFunctions_winShow(OutlookHide)
} else {
	run Outlook.exe
}
return

F9::
IfWinExist, | Microsoft Teams
{
	QIFunctions_winShow(TeamsHide)
} else {
	; run "C:\Users\karl\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Teams.lnk"
	run "C:\Users\karl\AppData\Local\Microsoft\Teams\Update.exe" --processStart "Teams.exe"
}
return

F7::
IfWinExist, 3CX -
{
	QIFunctions_winShow(3cxHide)
} else {
	run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\3CXPhone for Windows\3CXPhone for Windows.lnk"
}
return

F8::
IfWinExist, Slack |
{
	QIFunctions_winShow(SlackHide)
} else {
	run Slack.exe
}
return

^!p::gotoChannel("DE{space}-{space}TS")					; Direct access to DE - TS "general" channel

^!l::gotoChannel("Lunch")								; Direct access to DE - TS "lunch" channel

^!1::													; Opens "Activities"
error := activateTeams()
if !error
{
	SendInput, ^1
} else {
	errorHandler("teams", error)
}
return

^!2::													; Opens "Chat"
error := activateTeams()
if !error
{
	SendInput, ^2
} else {
	errorHandler("teams", error)
}
return

^!3::													; Opens "Teams"
error := activateTeams()
if !error
{
	SendInput, ^3
} else {
	errorHandler("teams", error)
}
return

gotoChannel(channel)
{
	error := activateTeams()
	if !error
	{
		Send, ^e
		Sleep, 50
		Send, /
		Sleep, 100
		Send, goto
		Sleep, 100
		Send, {space}
		Sleep, 400
		Send, %channel%
		Sleep, 200
		Send, {tab}{enter}
	} else {
		errorHandler("teams", error)
	}
}

activateTeams()
{
	if WinExist("| Microsoft Teams")		; Check to make sure Teams is running
	{
		WinGet, Style, Style
		If !(Style & 0x10000000)
			WinRestore
		WinActivate
		WinActivate 						; Not sure why this has to be sent twice, seems to be related to virtual desktops
		WinWaitActive, , , 1				; Make sure window got activated within 1 second
		If ErrorLevel 						; Run if window did not activate within timeout value
		{
			return 1
		}	
		return 0
		
	} else {
		return 2
	}
}

errorHandler(errorSource, errorNo)
{
	if errorSource = teams
	{
		if errorNo = 1
			MsgBox, 8208, Error, "Teams timed out, try again."
		else if (errorNo = 2)
			MsgBox, 8208, Error, "Didn't find Teams, try again."
		else
			MsgBox, 8208, Error, "Unspecified error."
	}
}