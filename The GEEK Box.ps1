Function Generate-Form {

    Add-Type -AssemblyName System.Windows.Forms    
    Add-Type -AssemblyName System.Drawing

        # Build Form
    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "PCTECHGREU Geekzz"
    $Form.Size = New-Object System.Drawing.Size(200,200)
    $Form.StartPosition = "CenterScreen"
    $Form.Topmost = $True

    # Add Button
    $Button = New-Object System.Windows.Forms.Button
    $Button.Location = New-Object System.Drawing.Size(35,35)
    $Button.Size = New-Object System.Drawing.Size(120,23)
    $Button.Text = "Show Geekzww Box"

    $Form.Controls.Add($Button)

    #Add Button event 
    $Button.Add_Click(
        {    
		[System.Windows.Forms.MessageBox]::Show("Hello Geekz." , "PcTechgreu Geekzz APP!")
        }
    )
     
    #Show the Form 
    $form.ShowDialog()| Out-Null 
 
} #End Function 

 #Call the Function 
Generate-Form>