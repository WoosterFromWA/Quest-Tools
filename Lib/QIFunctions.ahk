QIFunctions_readINI(iniPath, iniKeys, ini_section)					; Reads keys from defined INI file based on 'iniKeys'
{
	For key, value in iniKeys
	{
		IniRead, valCheck, %iniPath%, %ini_section%, %key%
		if (valCheck = "ERROR") {
			IniWrite, %value%, %iniPath%, %ini_Section%, %key%
			iniKeys[(key)] := value
		} else {
			iniKeys[(key)] := valCheck
		}
	}

	return iniKeys
}

QIFunctions_winTogg()
{
	WinGet, Style, Style

	IfWinNotActive
	{
		If !(Style & 0x10000000)
			WinRestore
		WinActivate
	} else {
		WinMinimize
		WinHide
	}

	return
}

QIFunctions_winShow(WindHide := true)
{
	WinGet, Style, Style

	; MsgBox, %WindHide%

	IfWinNotActive
	{
		If !(Style & 0x10000000)
			WinRestore
		; MsgBox, % "Style: " Style "`n`nDid it work?"
		WinActivate
	} else {
		WinMinimize
		If WindHide
			WinHide
	}

	return
}