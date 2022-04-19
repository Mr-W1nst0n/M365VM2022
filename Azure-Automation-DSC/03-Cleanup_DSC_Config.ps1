Clear-Host
Set-Location -Path $PSScriptRoot

if ([string]::IsNullOrEmpty($(Get-AzContext).Account)) {Connect-AzAccount}

#Variable:
$AzAutomationName = 'AutomationDSC'
$AzResourceGroupName = 'AutomationRG'
$AzDSCconfigName = 'IISOrgDefaultConfig'
$AzVMName = 'IISSRV01'
$AzNodeConfigName = $AzDSCconfigName + '.' + $AzVMName

$id = (Get-AzAutomationDscNode `
    -ResourceGroupName $AzResourceGroupName `
    -AutomationAccountName $AzAutomationName).Id

Write-Host 'UnregisterDscNode' -ForegroundColor Yellow

Unregister-AzAutomationDscNode `
    -AutomationAccountName $AzAutomationName `
    -ResourceGroupName $AzResourceGroupName `
    -Id $id `
    -Force:$true

Start-Sleep -Seconds 5

Remove-AzAutomationDscNodeConfiguration `
    -AutomationAccountName $AzAutomationName `
    -IgnoreNodeMappings `
    -Name $AzNodeConfigName `
    -ResourceGroupName $AzResourceGroupName `
    -Force:$true

Start-Sleep -Seconds 5

Remove-AzAutomationDscConfiguration `
    -AutomationAccountName $AzAutomationName `
    -Name $AzDSCconfigName `
    -ResourceGroupName $AzResourceGroupName `
    -Force:$true

Write-Host 'Unregistering Process Completed' -ForegroundColor Green