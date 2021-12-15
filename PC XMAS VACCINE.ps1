[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$xamlCode = @'
<Window
xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
Title="PC TECH GR EU GEEKS GUI" WindowStartupLocation="CenterScreen">
    <Grid Margin="0,5,0,0">
        <Grid.RowDefinitions>
            <RowDefinition Height="auto"/>
            <RowDefinition Height="auto"/>
            <RowDefinition Height="auto"/>
        </Grid.RowDefinitions>
            <Label Grid.Row="0" Content="Hello World HELLO PC GEEKS XMAS VACCINE PC!!!!!"/>
            <ComboBox Grid.Row="1" Name="PCtCB"/>
            <Button Grid.Row="2" Name="PCBtn" Content="Test"/>
    </Grid>
</Window>
'@
$reader = (New-Object System.Xml.XmlNodeReader $xamlCode)
$GUI = [Windows.Markup.XamlReader]::Load($reader)
$xamlCode.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name ($_.Name) -Value $GUI.FindName($_.Name) }
$testCB.ItemsSource = "Option 1", "Option 2", "Option 3!!"
$testBtn.Add_Click({
    Write-Host $testCB.Text
})
$GUI.ShowDialog() | out-null
