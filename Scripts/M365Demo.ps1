# Getting client credential
$Credential = Get-Credential -Message 'Please insert the GlobalAdmin Account' -UserName 'MOD1@avanadelab.com'

# File Location
$output = 'G:\'

# Selected Componenets
$components = @(

# OneDrive WorkLoad
'ODSettings'

# SharePoint WorkLoad
'SPOAccessControlSettings'
'SPOSharingSettings'
'SPOSite'
'SPOTenantSettings'

# Teams WorkLoad
'TeamsCallingPolicy'
'TeamsClientConfiguration'
'TeamsMessagingPolicy'
'TeamsUpgradeConfiguration'

)

$date = Get-Date -Format 'MM-dd-yyyy'

# Exporting resources using credentials
Export-M365DSCConfiguration -Components $components -Credential $Credential -Path ("$output" + 'M365\BackupTenantConfig-' + "$date")