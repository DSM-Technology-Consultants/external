# author: Kam Layne <klayne@dsm.net>

$gitHub = "https://github.com/DSM-Technology-Consultants"
$scriptName = $myInvocation.myCommand.name
$path = get-location
$timestamp = get-date -format "yyyyMMddHHmmss"
$transcript = "$path\$timestamp-$scriptName.txt"

start-transcript -path $transcript
write-host "`n$gitHub`n >$scriptName`n"

if (!(test-path "$env:programFiles\Microsoft Azure Active Directory Connect")) {
  write-host "This server does not have Azure AD Connect installed`nPlease install Azure AD Connect and try again"
  exit
}

import-module adsync

write-host "`n1) A Delta sync only syncs changes since the last sync`n2) An Initial sync performs a full sync of the directory`n" -f yellow
while ($syncType -lt 1 -or $syncType -gt 2) {
  [int]$syncType = read-host "Enter the number of the sync you would like to perform"
}

switch ($syncType) {
  1 { $syncPolicy = "delta" }
  2 { $syncPolicy = "initial" }
}

write-host "Active Directory Sync initiated, please wait..."
if (start-adsyncSyncCycle -policyType $syncPolicy) {
  write-host "Success!" -f green
} else {
  write-host "There was a problem" -f yellow
}

exit
