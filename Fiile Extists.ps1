$FileName = (Get-Date).tostring("dd-MM-yyyy")
$FolderPath="C:\Desktop"
$Path = $FolderPath+"\"+ $FileName+".txt"
if (!(Test-Path $Path))
{
New-Item -itemType File -Path $FolderPath -Name ($FileName + ".txt")
}
else
{
Write-Host "File Exists"
}