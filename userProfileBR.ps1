# author: Kam Layne <klayne@dsm.net>

$gitHub = "https://github.com/DSM-Technology-Consultants"
$scriptName = $myInvocation.myCommand.name
$path = get-location
$timestamp = get-date -format "yyyyMMddHHmmss"
$transcript = "$path\$timestamp-$scriptName.txt"

start-transcript -path $transcript
write-host "`n$gitHub`n >$scriptName`n"

while ($confirmConfig -notmatch '[Yy][Ee][Ss]') {
  $source = read-host "`nEnter full path of source folder (e.g. C:\Users\jdoe)"
  $target = read-host "Enter full of path target folder (D:\Backups\jdoe)"
  write-host "`nSource: $source" -f yellow
  write-host "Target: $target`n" -f yellow
  $confirmConfig = read-host "Does the following configuration look correct? (Yes/No)" 
  if ($confirmConfig -match '[Qq]') { exit }
}

$logFile = "$path\log_$scriptName.txt"

$folders = @(
  "Desktop"
  "Documents"
  "Downloads"
  "Pictures"
  "Videos"
)

write-host "Robocopy initiated, please wait..."
write-output $logFile | out-file $logFile -force
foreach ($folder in $folders) {
  write-host "Copying $folder from $source to $target..."
  start-process "robocopy.exe" -argumentList "`"$source\$folder`" `"$target\$folder`" /MIR /MT:128 /R:2 /W:1 /LOG+:`"$logFile`"" -wait
}

exit
