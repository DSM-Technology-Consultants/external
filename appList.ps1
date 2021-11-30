# author: Kam Layne <klayne@dsm.net>

$gitHub = "https://github.com/DSM-Technology-Consultants"
$scriptName = $myInvocation.myCommand.name
$path = get-location
$timestamp = get-date -format "yyyyMMddHHmmss"
$transcript = "$path\$timestamp-$scriptName.txt"
$runAsAdministrator = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!($runAsAdministrator)) {
  write-host "You must invoke this script from an elevated PowerShell console" -f yellow
  write-host "Launch 'Windows PowerShell (Admin)' and paste the following command into the console:`n`npowershell -executionPolicy bypass -file `"$path\$scriptName`"`n"
  read-host -prompt "Press any key to continue"
  exit
}

start-transcript -path $transcript
write-host "`n$gitHub`n >$scriptName`n"

get-itemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | select-object displayName, displayVersion, publisher, installDate | out-file "$path\appList.txt" -force

exit
