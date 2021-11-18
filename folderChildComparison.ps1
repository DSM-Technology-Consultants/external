# author: Kam Layne <klayne@dsm.net>

$gitHub = "https://github.com/DSM-Technology-Consultants"
$scriptName = $myInvocation.myCommand.name

write-host "`n$gitHub`n >$scriptName"

while ($confirmConfig -notmatch '[Yy][Ee][Ss]') {
   $folder1 = read-host "`nEnter full path of the first folder"
   $folder2 = read-host "Enter full path of the second folder"
   write-host "`nFolder 1: $folder1" -f yellow
   write-host "Folder 2 : $folder2`n" -f yellow
   $confirmConfig = read-host "Does the following configuration look correct? (Yes/No)" 
   if ($confirmConfig -match '[Qq]') { exit }
}

write-host "Comparing folders, please wait..."
$reference = (get-childItem "$folder1" -recurse | measure-object | select-object count | out-null)
$difference = (get-childItem "$folder2" -recurse | measure-object | select-object count | out-null)
if ($reference.count -ne $difference.count)  {
   write-host "These folders do not have the same number of children" -f red
} else {
   write-host "These folders have the same number of children." -f green
}

write-host $folder1 = $reference.count -f yellow
write-host $folder2 = $difference.count -f yellow
