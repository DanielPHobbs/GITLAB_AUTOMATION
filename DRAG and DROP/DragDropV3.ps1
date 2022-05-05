#------------------------------------------------------------------------
# Source File Information (DO NOT MODIFY)
# Source ID: e19c4413-5799-48c7-96e4-59eb777fa777
# Source File: ..\..\..\Documents\SAPIEN\Files\formDragAndDrop.psf
#------------------------------------------------------------------------
#region File Recovery Data (DO NOT MODIFY)
<#RecoveryData:
OwgAAB+LCAAAAAAABAC9lmFvmzAQhr9P2n+w/BklUEKzVICUJas0bWurJdr2bTJwZN6MHdkmCfv1
s4FUzUgXVrUREgL8vtw95ztE+BlSsQFZzYkmyFwoKniEL3D8+hVC4a2kK8oJu6YMbkgBcS5kMZdk
NeXZXIr1YK3ycNhRNd7kJ6Qa6WoNEV5USkMx+Ep5JrZqcG1e05wddGzJQV/aVEYD1x4OmpVMlxIi
DqWWhDnorkwYTT9AtRS/gEfJeEyCNLj0Jv4I3DcTjLhJJcI2Yw+j9AdlmTQ6PBNcS8FUg2gSvTMg
IHXVGmaMAtcL+htwHHiXDrrwgnC4Fz1isti4ro53UruEncax5exKTxfNut+K3YvXTe+03WjSbPS/
CtglnDImtrUtXsoSOphdx0eREm3yxrHnO8jze1g+GTDKKIfeQZpNOgTrYWtaYTTxTGITt4dhSZL3
PIMdjnup63awRTVtp1BmcltBhq6OWd9tjKb1WYimxodE3/cL4bCWP+6+NfN+1G0XDt1myOvObEb7
4GaqFBSmpUDtte2TKi5UKiSjyTO0ZTi8f+vfUZpBOEeMZx+20xHtd/k8gSTZUr56SizXz4N8nHte
FrjEJ6djfSvYeZioNG0qZLUAuaEpPGnL/ptuJiScBa+lMp8Jg/YCbPe3zWyHw4c/C/EfGGeoJTsI
AAA=#>
#endregion

<#
    .NOTES
    --------------------------------------------------------------------------------
     Code generated by:  SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.99
     Generated on:       15-1-2016 12:05
     Generated by:        
     Organization:        
    --------------------------------------------------------------------------------
    .DESCRIPTION
        GUI script generated by PowerShell Studio 2015
#>
#----------------------------------------------
#region Application Functions
#----------------------------------------------

#endregion Application Functions

#----------------------------------------------
# Generated Form Function
#----------------------------------------------
function Call-formDragAndDrop_psf {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.ServiceProcess, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$form1 = New-Object 'System.Windows.Forms.Form'
	$txtDragandDrop = New-Object 'System.Windows.Forms.TextBox'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	
	$txtDragandDrop_DragOver=[System.Windows.Forms.DragEventHandler]{
	    #Event Argument: $_ = [System.Windows.Forms.DragEventArgs]
	    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop))
	    {
	        $_.Effect = 'Copy'
	    }
	    else
	    {
	        $_.Effect = 'None'
	    }
	}
	
	$txtDragandDrop_DragDrop=[System.Windows.Forms.DragEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.DragEventArgs]
	    
	    [string[]] $files = [string[]]$_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
	    if ($files)
	    {
	        $txtDragandDrop.Text = $files[0]
	    }
	    
	}
	
	
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$form1.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$txtDragandDrop.remove_DragDrop($txtDragandDrop_DragDrop)
			$txtDragandDrop.remove_DragOver($txtDragandDrop_DragOver)
			$form1.remove_Load($Form_StateCorrection_Load)
			$form1.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch [Exception]
		{ }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$form1.SuspendLayout()
	#
	# form1
	#
	$form1.Controls.Add($txtDragandDrop)
	$form1.ClientSize = '516, 215'
	$form1.Name = 'form1'
	$form1.Text = 'Form'
	#
	# txtDragandDrop
	#
	$txtDragandDrop.AllowDrop = $True
	$txtDragandDrop.Location = '13, 13'
	$txtDragandDrop.Multiline = $True
	$txtDragandDrop.Name = 'txtDragandDrop'
	$txtDragandDrop.Size = '491, 190'
	$txtDragandDrop.TabIndex = 0
	$txtDragandDrop.Text = 'Contents dragged :'
	$txtDragandDrop.add_DragDrop($txtDragandDrop_DragDrop)
	$txtDragandDrop.add_DragOver($txtDragandDrop_DragOver)
	$form1.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $form1.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$form1.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$form1.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	return $form1.ShowDialog()

} #End Function

#Call the form
Call-formDragAndDrop_psf | Out-Null