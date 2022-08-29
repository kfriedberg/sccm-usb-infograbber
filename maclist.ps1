$prefix = "PREFIX-"
start-sleep -s 5
$mac = get-wmiobject win32_networkadapter | where netconnectionstatus -eq 2 | select -first 1 -expand macaddress
$mac = $mac.tolower()
$serial = get-wmiobject win32_bios | select -expand SerialNumber
$smbiosguid = get-wmiobject win32_computersystemproduct | select -expand UUID

$line = "$prefix$serial,$smbiosguid,$mac"
$line | add-content ${env:USBDRIVE}:\maclist.csv
