#include <Array.au3>

$DirToDecompress = 'Antares SQL'
$InstallDir1 = @ScriptDir&'\'&$DirToDecompress
$InstallDir2 = @ProgramFilesDir&'\'&$DirToDecompress
$ShortcutPath = @DesktopDir&'\'&$DirToDecompress&'.lnk'
$FileToDecompress1 = @ScriptDir&'\'&FindConfig()
$FileToDecompress2 = @ScriptDir&'\'&$DirToDecompress&'\$PLUGINSDIR\app-64.7z'

If StringInStr($InstallDir1,' ') <> 0 Then
	$InstallDir1 = '"'&$InstallDir1&'"'
EndIf
If StringInStr($InstallDir2,' ') <> 0 Then
	$InstallDir2 = '"'&$InstallDir2&'"'
EndIf
If StringInStr($FileToDecompress1,' ') <> 0 Then
	$FileToDecompress1 = '"'&$FileToDecompress1&'"'
EndIf
If StringInStr($FileToDecompress2,' ') <> 0 Then
	$FileToDecompress2 = '"'&$FileToDecompress2&'"'
EndIf
SplashTextOn('','Extracting '&$DirToDecompress&'...',200,70)
ShellExecuteWait(FindCompressor(),'x -y -o'&$InstallDir1&' '&$FileToDecompress1,'','open',@SW_HIDE)
ShellExecuteWait(FindCompressor(),'x -y -o'&$InstallDir2&' '&$FileToDecompress2,'','open',@SW_HIDE)
SplashOff()
; Tao shortcut
; If @OSArch = 'X86' Then
	; FileCreateShortcut(@HomeDrive&'\'&$DirToDecompress&'\EVKey32.exe',$ShortcutPath,@HomeDrive&'\'&$DirToDecompress)
; ElseIf @OSArch = 'X64' Then
	; FileCreateShortcut(@HomeDrive&'\'&$DirToDecompress&'\EVKey64.exe',$ShortcutPath,@HomeDrive&'\'&$DirToDecompress)
; EndIf
FileCreateShortcut(@ProgramFilesDir&'\'&$DirToDecompress&'\Antares.exe',$ShortcutPath,@ProgramFilesDir&'\'&$DirToDecompress)
;ShellExecute(@ScriptDir&'\'&$DirToDecompress&'\DbGate.exe','',@ScriptDir&'\'&$DirToDecompress)
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