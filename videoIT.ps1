Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Main Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "AI Video Trimmer"
$form.Size = New-Object System.Drawing.Size(500,400)
$form.StartPosition = "CenterScreen"

# Label - Video Path
$labelVideo = New-Object System.Windows.Forms.Label
$labelVideo.Text = "Επιλεγμένο Βίντεο:"
$labelVideo.Location = New-Object System.Drawing.Point(10,20)
$labelVideo.Size = New-Object System.Drawing.Size(120,20)
$form.Controls.Add($labelVideo)

# TextBox - Video Path
$textBoxPath = New-Object System.Windows.Forms.TextBox
$textBoxPath.Location = New-Object System.Drawing.Point(130, 20)
$textBoxPath.Size = New-Object System.Drawing.Size(250,20)
$form.Controls.Add($textBoxPath)

# Button - Browse
$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Text = "Αναζήτηση..."
$buttonBrowse.Location = New-Object System.Drawing.Point(390,18)
$buttonBrowse.Size = New-Object System.Drawing.Size(80,25)
$buttonBrowse.Add_Click({
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.Filter = "Video Files (*.mp4;*.mov;*.avi)|*.mp4;*.mov;*.avi"
    if ($fileDialog.ShowDialog() -eq "OK") {
        $textBoxPath.Text = $fileDialog.FileName
    }
})
$form.Controls.Add($buttonBrowse)

# Label - Start Time
$labelStart = New-Object System.Windows.Forms.Label
$labelStart.Text = "Ώρα Έναρξης (π.χ. 00:00:10):"
$labelStart.Location = New-Object System.Drawing.Point(10,60)
$labelStart.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($labelStart)

# TextBox - Start Time
$textBoxStart = New-Object System.Windows.Forms.TextBox
$textBoxStart.Location = New-Object System.Drawing.Point(220, 60)
$textBoxStart.Size = New-Object System.Drawing.Size(100,20)
$form.Controls.Add($textBoxStart)

# Label - End Time
$labelEnd = New-Object System.Windows.Forms.Label
$labelEnd.Text = "Ώρα Λήξης (π.χ. 00:01:00):"
$labelEnd.Location = New-Object System.Drawing.Point(10,100)
$labelEnd.Size = New-Object System.Drawing.Size(200,20)
$form.Controls.Add($labelEnd)

# TextBox - End Time
$textBoxEnd = New-Object System.Windows.Forms.TextBox
$textBoxEnd.Location = New-Object System.Drawing.Point(220, 100)
$textBoxEnd.Size = New-Object System.Drawing.Size(100,20)
$form.Controls.Add($textBoxEnd)

# Button - Trim Video
$buttonTrim = New-Object System.Windows.Forms.Button
$buttonTrim.Text = "Περικοπή Βίντεο"
$buttonTrim.Location = New-Object System.Drawing.Point(150,150)
$buttonTrim.Size = New-Object System.Drawing.Size(180,30)
$buttonTrim.Add_Click({
    $input = $textBoxPath.Text
    $start = $textBoxStart.Text
    $end = $textBoxEnd.Text
    $output = [System.IO.Path]::ChangeExtension($input, ".trimmed.mp4")

    if (-not (Test-Path $input)) {
        [System.Windows.Forms.MessageBox]::Show("Το αρχείο δεν βρέθηκε.","Σφάλμα")
        return
    }

    $command = "ffmpeg -i `"$input`" -ss $start -to $end -c copy `"$output`" -y"
    Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList "/c $command" -Wait

    [System.Windows.Forms.MessageBox]::Show("Η περικοπή ολοκληρώθηκε.`nΑποθηκεύτηκε ως:`n$output","Ολοκληρώθηκε")
})
$form.Controls.Add($buttonTrim)

# Run the Form
[void]$form.ShowDialog()
