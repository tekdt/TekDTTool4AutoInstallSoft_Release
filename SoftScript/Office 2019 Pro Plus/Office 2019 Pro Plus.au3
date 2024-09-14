#include <Array.au3>

$DirToDecompress = ''
$InstallDir = @HomeDrive&'\'&$DirToDecompress
$ShortcutPath = @DesktopDir&'\'&$DirToDecompress&'.lnk'
$FileToDecompress = @ScriptDir&'\'&FindConfig()
If @OSArch = 'X86' Then
	$ConfigurationFile = @ScriptDir&'\configuration32.xml'
ElseIf @OSArch = 'X64' Then
	$ConfigurationFile = @ScriptDir&'\configuration64.xml'
EndIf

If StringInStr($InstallDir,' ') <> 0 Then
	$InstallDir = '"'&$InstallDir&'"'
EndIf
If StringInStr($FileToDecompress,' ') <> 0 Then
	$FileToDecompress = "'"&$FileToDecompress&"'"
EndIf
If StringInStr($ConfigurationFile,' ') <> 0 Then
	$ConfigurationFile = '"'&$ConfigurationFile&'"'
EndIf
; ShellExecuteWait(FindCompressor(),'x -y -o'&$InstallDir&' '&$FileToDecompress)
; ; Tao shortcut
; If @OSArch = 'X86' Then
	; FileCreateShortcut(@HomeDrive&'\'&$DirToDecompress&'\EVKey32.exe',$ShortcutPath,@HomeDrive&'\'&$DirToDecompress)
; ElseIf @OSArch = 'X64' Then
	; FileCreateShortcut(@HomeDrive&'\'&$DirToDecompress&'\EVKey64.exe',$ShortcutPath,@HomeDrive&'\'&$DirToDecompress)
; EndIf

$OldDriveList = DriveGetDrive('ALL')
ShellExecuteWait('powershell.exe','Mount-DiskImage -ImagePath '&$FileToDecompress)
$MountedDrive = MountedDrive($OldDriveList)
If $MountedDrive = False Then
	MsgBox(16,'Error','Can not mount drive')
	Exit
EndIf
ShellExecuteWait($MountedDrive&'\Setup.exe','/configure '&$ConfigurationFile,$MountedDrive&'\')
;ShellExecuteWait('powershell.exe','Dismount-DiskImage -ImagePath '&$FileToDecompress)

Func FindCompressor()
	$SplitDir = StringSplit(@ScriptDir,'\')
	If $SplitDir[$SplitDir[0]-1] = 'Soft' Then
		If FileExists(_ArrayToString($SplitDir,'\',1,$SplitDir[0]-2,'\')&'\Lib\7z.exe') = 1 Then
			$CompressorPath = _ArrayToString($SplitDir,'\',1,$SplitDir[0]-2,'\')&'\Lib\7z.exe'
		Else
			$CompressorPath = False
		EndIf
	Else
		$CompressorPath = False
	EndIf
	Return $CompressorPath
EndFunc

Func FindConfig()
	$SplitDir = StringSplit(@ScriptDir,'\')
	$ConfigFilePath = @ScriptDir&'\'&$SplitDir[$SplitDir[0]]&'.ini'
	If FileExists($ConfigFilePath) = 1 Then
		$FileToRun = IniRead($ConfigFilePath,'MAIN','PackageName',0)
		Return $FileToRun
	Else
		Return False
	EndIf
EndFunc

Func MountedDrive($OldDriveList)
	$NewDriveList = DriveGetDrive('ALL')
	For $i = 1 To $NewDriveList[0]
		If _ArraySearch($OldDriveList,$NewDriveList[$i]) = -1 Then Return $NewDriveList[$i]
	Next
	Return False
EndFunc