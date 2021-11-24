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

[string]$samAccountName = read-host "Enter JUST the username"
[int]$days = read-host "Enter the number of days you would like to retrieve logs for"

$results = "$path\results_$scriptName.txt"

$filter = @{
  logName = "Security"
  id = "4625"
  startTime = [datetime]::today.addDays(-$days)
  endTime = [datetime]::now
}

if ($hasEvents = get-winEvent -filterHashTable $filter | where-object message -match $samAccountName) {
  write-output $results | out-file $results -force
  $events = $hasEvents | select-object timeCreated, message
  foreach ($event in $events) {
    @(
      $event.timeCreated
      $event | select-object -expand message
      "-"*80
    ) | out-file $results -force -append
  }
} else {
  write-output "No failed logon events for $samAccountName could be found. Please check the spelling and/or try a different username." | out-file $results
  exit
}

start-process notepad.exe -argumentList $results

exit
