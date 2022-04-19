Clear-Host
Set-Location -Path $PSScriptRoot

if ([string]::IsNullOrEmpty($(Get-AzContext).Account)) {Connect-AzAccount}

New-AzResourceGroup `
    -Name 'AzureDSC-Demo' `
    -Location 'switzerlandnorth'

Start-Sleep -Seconds 5

New-AzVm `
    -ResourceGroupName 'AzureDSC-Demo' `
    -Name 'IISSRV01' `
    -Location 'switzerlandnorth' `
    -VirtualNetworkName 'DemoVnet' `
    -SubnetName 'DemoSubnet' `
    -SecurityGroupName 'DemoNetworkSecurityGroup' `
    -PublicIpAddressName 'DemoPublicIpAddress' `
    -OpenPorts 80,3389

Start-Sleep -Seconds 5

# Get Public IP Address
Get-AzPublicIpAddress -ResourceGroupName 'AzureDSC-Demo' | Select-Object -Property  'IpAddress'