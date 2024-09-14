#include <Array.au3>

$DirToDecompress = 'Revo Uninstaller Free'
$InstallDir = @ScriptDir&'\'&$DirToDecompress
DirRemove($InstallDir,1)
$ShortcutPath = @DesktopDir&'\'&$DirToDecompress&'.lnk'
$FileToDecompress = @ScriptDir&'\'&FindConfig()

If StringInStr($InstallDir,' ') <> 0 Then
	$InstallDir = '"'&$InstallDir&'"'
EndIf
If StringInStr($FileToDecompress,' ') <> 0 Then
	$FileToDecompress = '"'&$FileToDecompress&'"'
EndIf
ShellExecuteWait(FindCompressor(),'x -y -o'&$InstallDir&' '&$FileToDecompress)
; Tạo shortcut
; If @OSArch = 'X86' Then
	; FileCreateShortcut(@HomeDrive&'\'&$DirToDecompress&'\IDM-Activation-Script-main\IAS.cmd',$ShortcutPath,@HomeDrive&'\'&$DirToDecompress)
; ElseIf @OSArch = 'X64' Then
	; FileCreateShortcut(@HomeDrive&'\'&$DirToDecompress&'\IDM-Activation-Script-main\IAS.cmd',$ShortcutPath,@HomeDrive&'\'&$DirToDecompress)
; EndIf
ShellExecute(@ScriptDir&'\'&$DirToDecompress&'\RevoUninstaller_Portable\RevoUPort.exe','',@ScriptDir&'\'&$DirToDecompress&'\RevoUninstaller_Portable')

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