<#
.SYNOPSIS
    Installs RSAT features for any corresponding installed Windows Features
.DESCRIPTION
    Installs Remote System Administration Tools (RSAT) for any corresponding installed Windows Features that do not have those RSAT tools already installed
.EXAMPLE
    .\Install-RsatForInstalledFeatures.ps1
.INPUTS
    None
.OUTPUTS
    Microsoft.Windows.ServerManager.Commands.FeatureOperationResult

        FeatureOperationResult object
.NOTES
    Author: Craig Forrester <cf@craigforrester.com>
    Version: 1.0
#>
$features = Get-WindowsFeature

$features_installed = $features | Where-Object {($_.Installed -eq $true)}

$non_rsat_features_installed = $features_installed | Where-Object {$_.Name -notmatch "RSAT"}

# $rsat_features_installed = $features_installed | Where-Object {$_.Name -match "RSAT"}

$features_needing_rsat_installed = $non_rsat_features_installed.Name | ForEach-Object { Get-WindowsFeature -Name *$_* | Where-Object {($_.Name -imatch 'RSAT') -and ($_.Installed -ne $true)} }

Add-WindowsFeature -Name $features_needing_rsat_installed.Name -IncludeAllSubFeature
