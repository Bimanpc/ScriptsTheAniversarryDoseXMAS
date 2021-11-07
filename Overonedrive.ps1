Function Get-OneDriveStats {
  <#
    .SYNOPSIS
        Get the mailbox size and Disk Space
  #>
  process {
    $oneDrives = Get-PnPTenantSite -IncludeOneDriveSites -Filter "Url -like '-my.sharepoint.com/personal/'" -Detailed | Select Title,Owner,StorageQuota,StorageQuotaWarningLevel,StorageUsageCurrent,LastContentModifiedDate,Status
    $i = 0

    $oneDrives | ForEach {
  
      [pscustomobject]@{
        "Display Name" = $_.Title
        "Owner" = $_.Owner
        "Onedrive Size (GB)" = ConvertTo-Gb -size $_.StorageUsageCurrent
        "Storage Warning.. (GB)" = ConvertTo-Gb -size $_.StorageQuotaWarningLevel
        "Storage Space. (GB)" = ConvertTo-Gb -size $_.StorageQuota
        "Last Used Date" = $_.LastContentModifiedDate
        "Status" = $_.Status
      }

      $currentUser = $_.Title
      Write-Progress -Activity "Collecting OneDrive Sizes" -Status "Current Count: $i" -PercentComplete (($i / $oneDrives.Count) * 100) -CurrentOperation "Processing OneDrive: $currentUser"
      $i++;
    }
  }
}