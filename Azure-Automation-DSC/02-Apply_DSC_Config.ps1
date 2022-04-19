Clear-Host
Set-Location -Path $PSScriptRoot

if ([string]::IsNullOrEmpty($(Get-AzContext).Account)) {Connect-AzAccount}

#Variable:
$AzAutomationName = 'AutomationDSC'
$AzResourceGroupName = 'AutomationRG'
$AzVMResourceGroup = 'AzureDSC-Demo'
$AzDSCconfigName = 'IISOrgDefaultConfig'
$AzDSCconfig = './IISOrgDefaultConfig.ps1'
$AzVMName = 'IISSRV01'
$AzureVMLocation = 'switzerlandnorth'
$AzNodeConfigName = $AzDSCconfigName + '.' + $AzVMName
$tags = @{Environment='LAB';Scope='Demo';Company='contoso.com'}

Write-Host 'Pushing DSC Configuration in Azure RG Automation' -ForegroundColor Yellow

$ImportParams = @{
    AutomationAccountName = $AzAutomationName
    ResourceGroupName = $AzResourceGroupName
    SourcePath = $AzDSCconfig
    Tags = $tags
    Published = $true
    Force = $true
}

$null = Import-AzAutomationDscConfiguration @ImportParams

# Import DSC file on Azure Automation RG
Get-AzAutomationDscConfiguration `
    -ResourceGroupName $AzResourceGroupName `
    -AutomationAccountName $AzAutomationName

Write-Host "DSC Uploaded in ResourceGroup - $AzResourceGroupName!" -ForegroundColor Green

Start-Sleep -Seconds 10

Write-Host "Compiling DSC $AzNodeConfigName..." -ForegroundColor Yellow

$CompParams = @{
    AutomationAccountName = $AzAutomationName
    ResourceGroupName = $AzResourceGroupName
    ConfigurationName = $AzDSCconfigName
}

$CompilationJob = Start-AzAutomationDscCompilationJob @CompParams

# Wait for the DSC compile
while( $null -eq $CompilationJob.EndTime -and $null -eq $CompilationJob.Exception )
{
    $CompilationJob = $CompilationJob | Get-AzAutomationDscCompilationJob
    Start-Sleep -Seconds 20
}

Write-Host "DSC $AzNodeConfigName Compiled!" -ForegroundColor Green

Start-Sleep -Seconds 5

Write-Host "Assigning DSC Configuration to node - $AzVMName" -ForegroundColor Yellow

# Register MOF to a specific node
Register-AzAutomationDscNode `
    -AzureVMName $AzVMName `
    -NodeConfigurationName $AzNodeConfigName `
    -ConfigurationMode 'ApplyAndAutocorrect' `
    -AzureVMResourceGroup $AzVMResourceGroup `
    -AzureVMLocation $AzureVMLocation `
    -ResourceGroupName $AzResourceGroupName `
    -AutomationAccountName $AzAutomationName

Write-Host "DSC Registered to node - $AzVMName!" -ForegroundColor Green