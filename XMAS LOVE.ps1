$Question = $host.ui.PromptForChoice(
    "Window Title", "Do You Like XMAS?",(
        [System.Management.Automation.Host.ChoiceDescription[]](
            (New-Object System.Management.Automation.Host.ChoiceDescription "&YES","NO"),
            (New-Object System.Management.Automation.Host.ChoiceDescription "&YES","NO"),
        )
    ), 0
) 
switch($Question){
    0 {Write-Host "YES"}
    1 {Write-Host "NO"}
}