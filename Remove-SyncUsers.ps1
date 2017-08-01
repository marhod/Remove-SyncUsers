<#
.SYNOPSIS

This script removes all user accounts from an Azure Active Directory if they were created by a Synchronisation Engine. 
.DESCRIPTION

This script removes all user accounts from an Azure Active Directory if they were created by a Synchronisation Engine.  It determines 
if a user was created by Sync by examining the "LastDirSyncTime" property, and if it contains data the user will be deleted from both 
the Azure Active Directory and the Azure Active Directory recycling bin forcibly

It will take approximately 1-3 seconds to run per user account.  Large numbers of accounts will take a significant amount of time. 
.EXAMPLE

Load this file into your PowerShell session and then use it as follows :

import-module msonline
Connect-msolservice
Remove-SyncUsers
#>

Function Remove-SyncUsers {
    $users = get-msoluser -all | ?{$_.LastDirSyncTime -ne $null}
    $date = get-date -Format "hh_mm_ss"
    $logfile = "c:\temp\userremoval" + $date + ".log"
    $errorfile = "c:\temp\errors" + $date + ".log"
    $i = 0

    Foreach ($user in $users) {
        Write-Progress -Activity "Deleting Users" -status "Removing $($user.Userprincipalname) - $i of $($users.count)" -percentComplete ($i / $users.count*100)
        $ev = $null
        "$user.Userprincpalname" | out-file $logfile -append
        Remove-msoluser -userprincipalname $user.userprincipalname -force -errorvariable $ev
        $ev | out-file $logfile -append
        if ($ev -eq $null) {
            Remove-msoluser -userprincipalname $user.userprincipalname -RemoveFromRecycleBin -force
        }
        if ($ev -eq $null) {
            "Removed $($user.userprincpalname)" | out-file $logfile -append
        } else {
            "ERROR REMOVING $($user.userprincpalname)" | out-file $errorfile -append
        }
        $i++
    }
}