param (
    [parameter()]
    [System.Management.Automation.PSCredential]
    $Credential
)

# File Location
$output = 'G:\'

Configuration M365TenantEditedConfig
{
    param (
        [parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    if ($null -eq $Credential)
    {
        <# Credentials #>
        $Credscredential = Get-Credential -Message 'Please insert the GlobalAdmin Account' -UserName 'MOD1@contoso.com'
    }
    else
    {
        $CredsCredential = $Credential
    }

    $OrganizationName = $CredsCredential.UserName.Split('@')[1]
    Import-DscResource -ModuleName 'Microsoft365DSC' -ModuleVersion '1.22.216.1'

    Node localhost
    {
        ODSettings 'OneDriveSettings'
        {
            Ensure                                    = 'Present'
            IsSingleInstance                          = 'Yes'
            BlockMacSync                              = $true
            DisableReportProblemDialog                = $true
            ExcludedFileExtensions                    = @("ps1")
            NotificationsInOneDriveForBusinessEnabled = $true
            NotifyOwnersWhenInvitationsAccepted       = $true
            OneDriveForGuestsEnabled                  = $false
            OrphanedPersonalSitesRetentionPeriod      = 60
            Credential                                = $Credscredential
        }

        SPOAccessControlSettings 'ConfigureAccessControlSettings'
        {
            Ensure                                    = 'Present'
            IsSingleInstance                          = 'Yes'
            CommentsOnSitePagesDisabled               = $true
            DisallowInfectedFileDownload              = $false
            DisplayStartASiteOption                   = $false
            ExternalServicesEnabled                   = $false
            SocialBarOnSitePagesDisabled              = $true
            Credential                                = $Credscredential
        }

        SPOSharingSettings 'ConfigureSharingSettings'
        {
            Ensure                                    = 'Present'
            IsSingleInstance                          = 'Yes'
            SharingCapability                         = 'ExistingExternalUserSharingOnly'
            EnableGuestSignInAcceleration             = $false
            SharingDomainRestrictionMode              = 'BlockList'
            SharingBlockedDomainList                  = @('fabrikam.com','xyz.com')
            DefaultSharingLinkType                    = 'Internal'
            FileAnonymousLinkType                     = 'View'
            FolderAnonymousLinkType                   = 'View'
            DefaultLinkPermission                     = 'View'
            ShowPeoplePickerSuggestionsForGuestUsers  = $false
            PreventExternalUsersFromResharing         = $true
            NotifyOwnersWhenItemsReshared             = $true
            Credential                                = $Credscredential
        }

        SPOSite 'M365DemoSite'
        {
            Ensure                                      = 'Present'
            Title                                       = 'M365DSC - Demo'
            Url                                         = 'https://x282t.sharepoint.com/sites/M365DSC'
            Template                                    = 'STS#3'
            TimeZoneId                                  = 13
            LocaleId                                    = 1033
            Owner                                       = "MOD1@$OrganizationName"
            AnonymousLinkExpirationInDays               = 15
            CommentsOnSitePagesDisabled                 = $true
            DisableFlows                                = $true
            Credential                                  = $Credscredential
        }
    }
}

M365TenantEditedConfig -ConfigurationData .\ConfigurationData.psd1 -Credential $Credential -Output ("$output" + 'M365\MOF')
