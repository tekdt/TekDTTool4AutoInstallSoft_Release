#include <Array.au3>

$DirToDecompress = 'CPU-Z'
$InstallDir = @ScriptDir&'\'&$DirToDecompress
$ShortcutPath = @DesktopDir&'\'&$DirToDecompress&'.lnk'
$FileToDecompress = @ScriptDir&'\'&FindConfig()

If StringInStr($InstallDir,' ') <> 0 Then
	$InstallDir = '"'&$InstallDir&'"'
EndIf
If StringInStr($FileToDecompress,' ') <> 0 Then
	$FileToDecompress = '"'&$FileToDecompress&'"'
EndIf
SplashTextOn('','Extracting...',200,70)
ShellExecuteWait(FindCompressor(),'x -y -o'&$InstallDir&' '&$FileToDecompress,'','open',@SW_HIDE)
SplashOff()
; Tao shortcut
If @OSArch = 'X86' Then
	ShellExecute(@ScriptDir&'\'&$DirToDecompress&'\cpuz_x32.exe','',@ScriptDir&'\'&$DirToDecompress)
ElseIf @OSArch = 'X64' Then
	ShellExecute(@ScriptDir&'\'&$DirToDecompress&'\cpuz_x64.exe','',@ScriptDir&'\'&$DirToDecompress)
EndIf

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