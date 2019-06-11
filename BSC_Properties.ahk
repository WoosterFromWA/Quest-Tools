; Define INI file location
pathINI = %A_AppData%\Quest Integration\QI Tools.ini

; Section of INI file for 3CX
iniSection = BasicShortcuts

; Initialize iniProps
iniProps := {}

; Properties from INI file with their defaults
iniProps["numLockOn"] := 0

iniProps := QIFunctions_readINI(pathINI, iniProps, iniSection)

numLockOn := iniProps["numLockOn"]