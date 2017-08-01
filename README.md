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
