#include <Array.au3>
#include <File.au3>

FileInstall("D:\TekDTTool4AutoInstallSoft\ModScript\Full Vietnamese Font Pack\FontReg.exe",@ScriptDir&'\FontReg.exe',1)
$DirToDecompress = 'Full Vietnamese Font Pack'
$InstallDir = @ScriptDir&'\'&$DirToDecompress
DirCreate($InstallDir)
FileMove(@ScriptDir&'\FontReg.exe',$InstallDir,1)
$ShortcutPath = @ScriptDir&'\'&$DirToDecompress&'.lnk'
$FileToDecompress = @ScriptDir&'\*.zip'

If StringInStr($InstallDir,' ') <> 0 Then
	$InstallDir = '"'&$InstallDir&'"'
EndIf
If StringInStr($FileToDecompress,' ') <> 0 Then
	$FileToDecompress = '"'&$FileToDecompress&'"'
EndIf
; ShellExecuteWait(FindCompressor(),'x -y -o'&$InstallDir&' '&$FileToDecompress)
$FirstZip = _FileListToArray(@ScriptDir&'\'&$DirToDecompress,'*.zip',1)
ShellExecuteWait(FindCompressor(),'e -y -o'&$InstallDir&' '&$FileToDecompress,@ScriptDir,'open',@SW_HIDE)
$SecondZip = _FileListToArray(@ScriptDir&'\'&$DirToDecompress,'*.zip',1)
For $i = 1 To $SecondZip[0]
	If _ArraySearch($FirstZip,$SecondZip[$i]) = -1 Then
		ShellExecuteWait(FindCompressor(),'e -y -o'&$InstallDir&' "'&@ScriptDir&'\'&$DirToDecompress&'\'&$SecondZip[$i]&'"',@ScriptDir,'open',@SW_HIDE)
	EndIf
Next
$ThirdZip = _FileListToArray(@ScriptDir&'\'&$DirToDecompress,'*.zip',1)
For $i = 1 To $ThirdZip[0]
	If _ArraySearch($SecondZip,$ThirdZip[$i]) = -1 Then
		ShellExecuteWait(FindCompressor(),'e -y -o'&$InstallDir&' "'&@ScriptDir&'\'&$DirToDecompress&'\'&$ThirdZip[$i]&'"',@ScriptDir,'open',@SW_HIDE)
	EndIf
Next
ShellExecuteWait(@ScriptDir&'\Full Vietnamese Font Pack\FontReg.exe','/copy',@ScriptDir,'open',@SW_HIDE)
DirRemove(@ScriptDir&'\'&$DirToDecompress,1)
; Tao shortcut
; If @OSArch = 'X86' Then
	; FileCreateShortcut(@HomeDrive&'\'&$DirToDecompress&'\EVKey32.exe',$ShortcutPath,@HomeDrive&'\'&$DirToDecompress)
; ElseIf @OSArch = 'X64' Then
	; FileCreateShortcut(@HomeDrive&'\'&$DirToDecompress&'\EVKey64.exe',$ShortcutPath,@HomeDrive&'\'&$DirToDecompress)
; EndIf

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