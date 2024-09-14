#include <Array.au3>

$DirToDecompress = 'WinSetupFromUSB'
$InstallDir = @ScriptDir&'\'&$DirToDecompress
$ShortcutPath = @DesktopDir&'\'&$DirToDecompress&'.lnk'
$FileToDecompress = @ScriptDir&'\'&FindConfig()

If FileExists($FileToDecompress) = 0 Then
	SplashTextOn('','Downloading WinSetupFromUSB...',200,70)
	ShellExecuteWait(FindDownloader(),'http://downloads.winsetupfromusb.com/WinSetupFromUSB-1-10.exe'&' --dir="'&@ScriptDir&'" --force-sequential=true --max-connection-per-server=16 --referer="http://www.winsetupfromusb.com/redirect/"','','open',@SW_HIDE)
	SplashOff()
EndIf

If StringInStr($InstallDir,' ') <> 0 Then
	$InstallDir = '"'&$InstallDir&'"'
EndIf
If StringInStr($FileToDecompress,' ') <> 0 Then
	$FileToDecompress = '"'&$FileToDecompress&'"'
EndIf

SplashTextOn('','Extracting '&$DirToDecompress&'...',200,70)
ShellExecuteWait(FindCompressor(),'x -y -o'&$InstallDir&' '&$FileToDecompress,'','open',@SW_HIDE)
SplashOff()
; Tao shortcut
If @OSArch = 'X86' Then
	ShellExecute(@ScriptDir&'\'&$DirToDecompress&'\WinSetupFromUSB-1-10\WinSetupFromUSB_1-10.exe','',@ScriptDir&'\'&$DirToDecompress&'\WinSetupFromUSB-1-10')
ElseIf @OSArch = 'X64' Then
	ShellExecute(@ScriptDir&'\'&$DirToDecompress&'\WinSetupFromUSB-1-10\WinSetupFromUSB_1-10_x64.exe','',@ScriptDir&'\'&$DirToDecompress&'\WinSetupFromUSB-1-10')
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

Func FindDownloader()
	$SplitDir = StringSplit(@ScriptDir,'\')
	If $SplitDir[$SplitDir[0]-1] = 'Soft' Then
		If FileExists(_ArrayToString($SplitDir,'\',1,$SplitDir[0]-2,'\')&'\Lib\aria2c.exe') = 1 Then
			$DownloaderPath = _ArrayToString($SplitDir,'\',1,$SplitDir[0]-2,'\')&'\Lib\aria2c.exe'
		Else
			$DownloaderPath = False
		EndIf
	Else
		$DownloaderPath = False
	EndIf
	Return $DownloaderPath
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