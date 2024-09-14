#include <Array.au3>

$DirToDecompress = 'HWiNFO'
$InstallDir = @ScriptDir&'\'&$DirToDecompress
DirRemove($InstallDir,1)
$ShortcutPath = @DesktopDir&'\'&$DirToDecompress&'.lnk'
$FileToDecompress = @ScriptDir&'\'&FindConfig()

If FileExists($FileToDecompress) = 0 Then
	SplashTextOn('','Downloading '&$DirToDecompress&'...',200,70)
	ShellExecuteWait(FindDownloader(),'https://www.hwinfo.com/files/hwi_800.zip'&' --dir="'&@ScriptDir&'" --force-sequential=true --max-connection-per-server=16 --referer="https://www.hwinfo.com/download/"','','open',@SW_HIDE)
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

If @OSArch = 'X86' Then
	ShellExecute(@ScriptDir&'\'&$DirToDecompress&'\HWiNFO32.exe','',@ScriptDir&'\'&$DirToDecompress)
ElseIf @OSArch = 'X64' Then
	ShellExecute(@ScriptDir&'\'&$DirToDecompress&'\HWiNFO64.exe','',@ScriptDir&'\'&$DirToDecompress)
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