<#
.Synopsis
Form to support drop and drag of files and folders
.DESCRIPTION
This is an advanced function which creates a form to drop and drag files and or folders.
Returned is a string listing of the paths of the selected files or folders.
.PARAMETER formTitle
The title for the form
.PARAMETER Instruction
The instructions to the user, put into a label at top of form
.PARAMETER status 
The text for the status bar
.PARAMETER btnTitle 
The text for the button which returns selected items and closes form
.EXAMPLE
Get-DragAndDrop
Opens form with default values
.EXAMPLE
$files = Get-DragAndDrop -formTitle "Get File Information" -status "Waiting for files"
$files | foreach {get-item $_}
Create for with custom title and status, get file information from results
.Notes
This does not support pipelining, the following fails:
Get-DragAndDrop -formTitle "Get File Information" -status "Waiting for files"| foreach {get-item $_}

Alan Kaplan 8-1-2017
Based on http://www.rlvision.com/blog/a-drag-and-drop-gui-made-with-powershell/
#>

Function Get-DragAndDrop
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$False)]
        [string]
        $formTitle = "Choose File(s)",

        [Parameter(Mandatory=$False)]
        [string]
        $Instructions = "Drag file(s) to box below",
 
        [Parameter(Mandatory=$False)]
        [string]
        $status = "Ready",

        [Parameter(Mandatory=$False)]
        [string]
        $btnTitle = "Continue"
    )

    Add-Type -assemblyname System.Windows.Forms
    Add-Type -assemblyname System.Drawing

    ### Create form ###

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Formtitle
    $form.Size = '400,320'
    $form.StartPosition = "CenterScreen"
    $form.MinimumSize = $form.Size
    $form.MaximizeBox = $False
    $form.Topmost = $True
    $form.AutoSize = $True

    ### Define controls ###

    $button = New-Object System.Windows.Forms.Button
    $button.Location = '300,230'
    $button.Size = '75,23'
    $button.Width = 12
    $button.AutoSize = $True
    $button.AutoSizeMode.GrowAndShrink
    $button.Text = $btnTitle
    $button.DialogResult = [System.Windows.Forms.DialogResult]::OK

    $label = New-Object Windows.Forms.Label
    $label.Location = '5,5'
    $label.AutoSize = $True
    $label.Text = $instructions

    $listBox = New-Object Windows.Forms.ListBox
    $listBox.Location = '5,25'
    $listBox.Height = 200
    $listBox.Width = 380
    $listBox.IntegralHeight = $False
    $listBox.AllowDrop = $True
    
    $statusBar = New-Object System.Windows.Forms.StatusBar
    $statusBar.Text = $Status

    ### Add controls to form ###

    $form.SuspendLayout()
    $form.Controls.Add($button)
    $form.Controls.Add($label)
    $form.Controls.Add($listBox)
    $form.Controls.Add($statusBar)
    $form.ResumeLayout()

    $form.AcceptButton = $button

    ### Write event handlers ###
    $listBox_DragOver = [System.Windows.Forms.DragEventHandler]{
	if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) 
	{
	    $_.Effect = 'Copy'
	}
    Else
	{
	    $_.Effect = 'None'
	}
    }
	
    $listBox_DragDrop = [System.Windows.Forms.DragEventHandler]{
	    foreach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) 
        {
		    $listBox.Items.Add($filename)
	    }
    $statusBar.Text = ("List contains $($listBox.Items.Count) items")
    }

    ### Add events to form ###

    $button.Add_Click($button_Click)
    $listBox.Add_DragOver($listBox_DragOver)
    $listBox.Add_DragDrop($listBox_DragDrop)
    #$form.Add_FormClosed($form_FormClosed)

    #### Show form and return result ###
    $dialogResult = $Form.ShowDialog()
    if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK)
     {
       $form.SuspendLayout()
       [array]$items =  $listbox.Items| sort -CaseSensitive
       if ($items.Count -gt 1){
       $items
       }
       ELSE
       {
       [string]$items[0]
       }
       $Form.Close() | out-null
     }
}

Get-DragAndDrop