#include <Array.au3>
#include <_HttpRequest.au3>

$DirToDecompress = 'MemTest64'
$InstallDir = @ScriptDir&'\'&$DirToDecompress
DirRemove($InstallDir,1)
$ShortcutPath = @DesktopDir&'\'&$DirToDecompress&'.lnk'
$FileToDecompress = @ScriptDir&'\MemTest64.exe'
FileDelete(@ScriptDir&'\t.txt')

If FileExists($FileToDecompress) = 0 Then
	SplashTextOn('','Downloading '&$DirToDecompress&'...',200,70)
	$DownloadLink = _HttpRequest(4,'https://www.techpowerup.com/download/techpowerup-memtest64/','id=621&server_id=15','','https://www.techpowerup.com/download/techpowerup-memtest64/')
	FileWrite(@ScriptDir&'\t.txt','[MAIN]'&@CRLF&StringReplace($DownloadLink[0],': ','='))
	InetGet(IniRead(@ScriptDir&'\t.txt','MAIN','Location',''),@ScriptDir&'\MemTest64.exe')
	SplashOff()
EndIf
FileDelete(@ScriptDir&'\t.txt')

If StringInStr($InstallDir,' ') <> 0 Then
	$InstallDir = '"'&$InstallDir&'"'
EndIf
If StringInStr($FileToDecompress,' ') <> 0 Then
	$FileToDecompress = '"'&$FileToDecompress&'"'
EndIf
Do
	Sleep(500)
Until FileExists(@ScriptDir&'\MemTest64.exe') = 1
; SplashTextOn('','Extracting '&$DirToDecompress&'...',200,70)
; ShellExecuteWait(FindCompressor(),'x -y -o'&$InstallDir&' '&$FileToDecompress,'','open',@SW_HIDE)
; SplashOff()
; Tao shortcut
; If @OSArch = 'X86' Then
	; FileCreateShortcut(@HomeDrive&'\'&$DirToDecompress&'\EVKey32.exe',$ShortcutPath,@HomeDrive&'\'&$DirToDecompress)
; ElseIf @OSArch = 'X64' Then
	; FileCreateShortcut(@HomeDrive&'\'&$DirToDecompress&'\EVKey64.exe',$ShortcutPath,@HomeDrive&'\'&$DirToDecompress)
; EndIf
ShellExecute(@ScriptDir&'\MemTest64.exe','',@ScriptDir)
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