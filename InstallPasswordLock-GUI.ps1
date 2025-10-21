# ============================================
# Install Password Lock Tool - GUI Version (FIXED)
# Windows Forms Interface - Emoji Removed for Compatibility
# ============================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Memastikan script dijalankan sebagai Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    [System.Windows.Forms.MessageBox]::Show(
        "Tool ini harus dijalankan sebagai Administrator!`n`nKlik kanan pada file dan pilih 'Run as Administrator'",
        "Memerlukan Hak Administrator",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    exit
}

# ============================================
# FUNGSI-FUNGSI UTAMA
# ============================================

function Enable-InstallLock {
    try {
        # Set UAC to maximum
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 2 -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorUser" -Value 3 -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 1 -Force
        
        # Disable MSI for non-admin
        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Installer" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer" -Name "DisableMSI" -Value 1 -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer" -Name "AlwaysInstallElevated" -Value 0 -Force
        
        [System.Windows.Forms.MessageBox]::Show(
            "Kunci Instalasi berhasil DIAKTIFKAN!`n`nUser biasa sekarang memerlukan password Administrator untuk install aplikasi.`n`nPerubahan akan berlaku setelah restart atau logout.",
            "Sukses",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
        Update-StatusDisplay
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Error: $_",
            "Gagal",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
}

function Disable-InstallLock {
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 5 -Force
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorUser" -Value 3 -Force
        
        if (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer") {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer" -Name "DisableMSI" -Value 0 -Force
        }
        
        [System.Windows.Forms.MessageBox]::Show(
            "Kunci Instalasi berhasil DINONAKTIFKAN!`n`nSistem kembali ke pengaturan normal.",
            "Sukses",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
        Update-StatusDisplay
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Error: $_",
            "Gagal",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
}

function New-AdminAccount {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Buat Akun Administrator Baru"
    $form.Size = New-Object System.Drawing.Size(450, 400)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(240, 244, 248)
    
    # Header Panel
    $headerPanel = New-Object System.Windows.Forms.Panel
    $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
    $headerPanel.Size = New-Object System.Drawing.Size(450, 60)
    $headerPanel.BackColor = [System.Drawing.Color]::FromArgb(52, 152, 219)
    $form.Controls.Add($headerPanel)
    
    $headerLabel = New-Object System.Windows.Forms.Label
    $headerLabel.Location = New-Object System.Drawing.Point(15, 15)
    $headerLabel.Size = New-Object System.Drawing.Size(410, 35)
    $headerLabel.Text = "Buat Akun Administrator Baru"
    $headerLabel.Font = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
    $headerLabel.ForeColor = [System.Drawing.Color]::White
    $headerPanel.Controls.Add($headerLabel)
    
    # Username Label & TextBox
    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Location = New-Object System.Drawing.Point(30, 80)
    $labelUser.Size = New-Object System.Drawing.Size(380, 22)
    $labelUser.Text = "Nama User Baru:"
    $labelUser.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $labelUser.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
    $form.Controls.Add($labelUser)
    
    $textUsername = New-Object System.Windows.Forms.TextBox
    $textUsername.Location = New-Object System.Drawing.Point(30, 105)
    $textUsername.Size = New-Object System.Drawing.Size(375, 30)
    $textUsername.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $textUsername.BorderStyle = 'FixedSingle'
    $form.Controls.Add($textUsername)
    
    # Password Label & TextBox
    $labelPass = New-Object System.Windows.Forms.Label
    $labelPass.Location = New-Object System.Drawing.Point(30, 145)
    $labelPass.Size = New-Object System.Drawing.Size(380, 22)
    $labelPass.Text = "Password:"
    $labelPass.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $labelPass.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
    $form.Controls.Add($labelPass)
    
    $textPassword = New-Object System.Windows.Forms.TextBox
    $textPassword.Location = New-Object System.Drawing.Point(30, 170)
    $textPassword.Size = New-Object System.Drawing.Size(375, 30)
    $textPassword.PasswordChar = '*'
    $textPassword.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $textPassword.BorderStyle = 'FixedSingle'
    $form.Controls.Add($textPassword)
    
    # Confirm Password Label & TextBox
    $labelConfirm = New-Object System.Windows.Forms.Label
    $labelConfirm.Location = New-Object System.Drawing.Point(30, 210)
    $labelConfirm.Size = New-Object System.Drawing.Size(380, 22)
    $labelConfirm.Text = "Konfirmasi Password:"
    $labelConfirm.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $labelConfirm.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
    $form.Controls.Add($labelConfirm)
    
    $textConfirm = New-Object System.Windows.Forms.TextBox
    $textConfirm.Location = New-Object System.Drawing.Point(30, 235)
    $textConfirm.Size = New-Object System.Drawing.Size(375, 30)
    $textConfirm.PasswordChar = '*'
    $textConfirm.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $textConfirm.BorderStyle = 'FixedSingle'
    $form.Controls.Add($textConfirm)
    
    # Buttons Panel
    $buttonPanel = New-Object System.Windows.Forms.Panel
    $buttonPanel.Location = New-Object System.Drawing.Point(30, 290)
    $buttonPanel.Size = New-Object System.Drawing.Size(375, 45)
    $form.Controls.Add($buttonPanel)
    
    # Button Buat
    $btnCreate = New-Object System.Windows.Forms.Button
    $btnCreate.Location = New-Object System.Drawing.Point(0, 0)
    $btnCreate.Size = New-Object System.Drawing.Size(180, 40)
    $btnCreate.Text = "[OK] BUAT"
    $btnCreate.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnCreate.ForeColor = [System.Drawing.Color]::White
    $btnCreate.BackColor = [System.Drawing.Color]::FromArgb(46, 204, 113)
    $btnCreate.FlatStyle = 'Flat'
    $btnCreate.FlatAppearance.BorderSize = 0
    $btnCreate.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(39, 174, 96)
    $btnCreate.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnCreate.Add_Click({
        $username = $textUsername.Text.Trim()
        $password = $textPassword.Text
        $confirm = $textConfirm.Text
        
        if ([string]::IsNullOrWhiteSpace($username)) {
            [System.Windows.Forms.MessageBox]::Show("Nama user tidak boleh kosong!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        
        if ($password -ne $confirm) {
            [System.Windows.Forms.MessageBox]::Show("Password tidak cocok!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        
        if ($password.Length -lt 4) {
            [System.Windows.Forms.MessageBox]::Show("Password minimal 4 karakter!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        
        try {
            $userExists = Get-LocalUser | Where-Object { $_.Name -eq $username }
            if ($userExists) {
                [System.Windows.Forms.MessageBox]::Show("User '$username' sudah ada!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
                return
            }
            
            $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
            New-LocalUser -Name $username -Password $securePassword -FullName $username -Description "Administrator Account" -PasswordNeverExpires -ErrorAction Stop | Out-Null
            Add-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction Stop
            
            [System.Windows.Forms.MessageBox]::Show("User '$username' berhasil dibuat sebagai Administrator!", "Sukses", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $form.Close()
            Update-StatusDisplay
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error membuat user: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })
    $buttonPanel.Controls.Add($btnCreate)
    
    # Button Batal
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(195, 0)
    $btnCancel.Size = New-Object System.Drawing.Size(180, 40)
    $btnCancel.Text = "[X] BATAL"
    $btnCancel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnCancel.ForeColor = [System.Drawing.Color]::White
    $btnCancel.BackColor = [System.Drawing.Color]::FromArgb(231, 76, 60)
    $btnCancel.FlatStyle = 'Flat'
    $btnCancel.FlatAppearance.BorderSize = 0
    $btnCancel.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(192, 57, 43)
    $btnCancel.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnCancel.Add_Click({ $form.Close() })
    $buttonPanel.Controls.Add($btnCancel)
    
    $form.ShowDialog()
}

function Enable-BuiltInAdmin {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Aktifkan Administrator Built-in"
    $form.Size = New-Object System.Drawing.Size(450, 320)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(240, 244, 248)
    
    # Header Panel
    $headerPanel = New-Object System.Windows.Forms.Panel
    $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
    $headerPanel.Size = New-Object System.Drawing.Size(450, 60)
    $headerPanel.BackColor = [System.Drawing.Color]::FromArgb(41, 128, 185)
    $form.Controls.Add($headerPanel)
    
    $labelInfo = New-Object System.Windows.Forms.Label
    $labelInfo.Location = New-Object System.Drawing.Point(15, 10)
    $labelInfo.Size = New-Object System.Drawing.Size(410, 45)
    $labelInfo.Text = "Aktifkan akun 'Administrator' built-in Windows`ndan set password baru"
    $labelInfo.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $labelInfo.ForeColor = [System.Drawing.Color]::White
    $headerPanel.Controls.Add($labelInfo)
    
    # Password Label & TextBox
    $labelPass = New-Object System.Windows.Forms.Label
    $labelPass.Location = New-Object System.Drawing.Point(30, 80)
    $labelPass.Size = New-Object System.Drawing.Size(380, 22)
    $labelPass.Text = "Password Baru:"
    $labelPass.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $labelPass.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
    $form.Controls.Add($labelPass)
    
    $textPassword = New-Object System.Windows.Forms.TextBox
    $textPassword.Location = New-Object System.Drawing.Point(30, 105)
    $textPassword.Size = New-Object System.Drawing.Size(375, 30)
    $textPassword.PasswordChar = '*'
    $textPassword.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $textPassword.BorderStyle = 'FixedSingle'
    $form.Controls.Add($textPassword)
    
    # Confirm Password
    $labelConfirm = New-Object System.Windows.Forms.Label
    $labelConfirm.Location = New-Object System.Drawing.Point(30, 145)
    $labelConfirm.Size = New-Object System.Drawing.Size(380, 22)
    $labelConfirm.Text = "Konfirmasi Password:"
    $labelConfirm.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $labelConfirm.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
    $form.Controls.Add($labelConfirm)
    
    $textConfirm = New-Object System.Windows.Forms.TextBox
    $textConfirm.Location = New-Object System.Drawing.Point(30, 170)
    $textConfirm.Size = New-Object System.Drawing.Size(375, 30)
    $textConfirm.PasswordChar = '*'
    $textConfirm.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $textConfirm.BorderStyle = 'FixedSingle'
    $form.Controls.Add($textConfirm)
    
    # Buttons Panel
    $buttonPanel = New-Object System.Windows.Forms.Panel
    $buttonPanel.Location = New-Object System.Drawing.Point(30, 220)
    $buttonPanel.Size = New-Object System.Drawing.Size(375, 45)
    $form.Controls.Add($buttonPanel)
    
    # Button Aktifkan
    $btnActivate = New-Object System.Windows.Forms.Button
    $btnActivate.Location = New-Object System.Drawing.Point(0, 0)
    $btnActivate.Size = New-Object System.Drawing.Size(180, 40)
    $btnActivate.Text = "[OK] AKTIFKAN"
    $btnActivate.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnActivate.ForeColor = [System.Drawing.Color]::White
    $btnActivate.BackColor = [System.Drawing.Color]::FromArgb(46, 204, 113)
    $btnActivate.FlatStyle = 'Flat'
    $btnActivate.FlatAppearance.BorderSize = 0
    $btnActivate.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(39, 174, 96)
    $btnActivate.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnActivate.Add_Click({
        $password = $textPassword.Text
        $confirm = $textConfirm.Text
        
        if ($password -ne $confirm) {
            [System.Windows.Forms.MessageBox]::Show("Password tidak cocok!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        
        if ($password.Length -lt 1) {
            [System.Windows.Forms.MessageBox]::Show("Password tidak boleh kosong!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        
        try {
            Enable-LocalUser -Name "Administrator" -ErrorAction Stop
            
            if ($password.Length -gt 0) {
                $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
                Set-LocalUser -Name "Administrator" -Password $securePassword
            }
            
            [System.Windows.Forms.MessageBox]::Show("Administrator built-in berhasil diaktifkan dan password telah diatur!", "Sukses", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $form.Close()
            Update-StatusDisplay
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error: $_`n`nKemungkinan akun Administrator sudah aktif atau nama berbeda di sistem Anda.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })
    $buttonPanel.Controls.Add($btnActivate)
    
    # Button Batal
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(195, 0)
    $btnCancel.Size = New-Object System.Drawing.Size(180, 40)
    $btnCancel.Text = "[X] BATAL"
    $btnCancel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnCancel.ForeColor = [System.Drawing.Color]::White
    $btnCancel.BackColor = [System.Drawing.Color]::FromArgb(231, 76, 60)
    $btnCancel.FlatStyle = 'Flat'
    $btnCancel.FlatAppearance.BorderSize = 0
    $btnCancel.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(192, 57, 43)
    $btnCancel.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnCancel.Add_Click({ $form.Close() })
    $buttonPanel.Controls.Add($btnCancel)
    
    $form.ShowDialog()
}

function Set-UserPassword {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Ubah Password User"
    $form.Size = New-Object System.Drawing.Size(450, 390)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(240, 244, 248)
    
    # Header Panel
    $headerPanel = New-Object System.Windows.Forms.Panel
    $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
    $headerPanel.Size = New-Object System.Drawing.Size(450, 60)
    $headerPanel.BackColor = [System.Drawing.Color]::FromArgb(155, 89, 182)
    $form.Controls.Add($headerPanel)
    
    $headerLabel = New-Object System.Windows.Forms.Label
    $headerLabel.Location = New-Object System.Drawing.Point(15, 15)
    $headerLabel.Size = New-Object System.Drawing.Size(410, 35)
    $headerLabel.Text = "Ubah Password User"
    $headerLabel.Font = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
    $headerLabel.ForeColor = [System.Drawing.Color]::White
    $headerPanel.Controls.Add($headerLabel)
    
    # User ComboBox
    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Location = New-Object System.Drawing.Point(30, 80)
    $labelUser.Size = New-Object System.Drawing.Size(380, 22)
    $labelUser.Text = "Pilih User:"
    $labelUser.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $labelUser.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
    $form.Controls.Add($labelUser)
    
    $comboUsers = New-Object System.Windows.Forms.ComboBox
    $comboUsers.Location = New-Object System.Drawing.Point(30, 105)
    $comboUsers.Size = New-Object System.Drawing.Size(375, 30)
    $comboUsers.DropDownStyle = 'DropDownList'
    $comboUsers.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $comboUsers.FlatStyle = 'Flat'
    
    $users = Get-LocalUser | Where-Object { $_.Enabled -eq $true }
    foreach ($user in $users) {
        $comboUsers.Items.Add($user.Name) | Out-Null
    }
    if ($comboUsers.Items.Count -gt 0) {
        $comboUsers.SelectedIndex = 0
    }
    $form.Controls.Add($comboUsers)
    
    # Password
    $labelPass = New-Object System.Windows.Forms.Label
    $labelPass.Location = New-Object System.Drawing.Point(30, 150)
    $labelPass.Size = New-Object System.Drawing.Size(380, 22)
    $labelPass.Text = "Password Baru:"
    $labelPass.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $labelPass.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
    $form.Controls.Add($labelPass)
    
    $textPassword = New-Object System.Windows.Forms.TextBox
    $textPassword.Location = New-Object System.Drawing.Point(30, 175)
    $textPassword.Size = New-Object System.Drawing.Size(375, 30)
    $textPassword.PasswordChar = '*'
    $textPassword.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $textPassword.BorderStyle = 'FixedSingle'
    $form.Controls.Add($textPassword)
    
    # Confirm Password
    $labelConfirm = New-Object System.Windows.Forms.Label
    $labelConfirm.Location = New-Object System.Drawing.Point(30, 215)
    $labelConfirm.Size = New-Object System.Drawing.Size(380, 22)
    $labelConfirm.Text = "Konfirmasi Password:"
    $labelConfirm.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $labelConfirm.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
    $form.Controls.Add($labelConfirm)
    
    $textConfirm = New-Object System.Windows.Forms.TextBox
    $textConfirm.Location = New-Object System.Drawing.Point(30, 240)
    $textConfirm.Size = New-Object System.Drawing.Size(375, 30)
    $textConfirm.PasswordChar = '*'
    $textConfirm.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $textConfirm.BorderStyle = 'FixedSingle'
    $form.Controls.Add($textConfirm)
    
    # Buttons Panel
    $buttonPanel = New-Object System.Windows.Forms.Panel
    $buttonPanel.Location = New-Object System.Drawing.Point(30, 290)
    $buttonPanel.Size = New-Object System.Drawing.Size(375, 45)
    $form.Controls.Add($buttonPanel)
    
    # Buttons
    $btnChange = New-Object System.Windows.Forms.Button
    $btnChange.Location = New-Object System.Drawing.Point(0, 0)
    $btnChange.Size = New-Object System.Drawing.Size(180, 40)
    $btnChange.Text = "[OK] UBAH"
    $btnChange.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnChange.ForeColor = [System.Drawing.Color]::White
    $btnChange.BackColor = [System.Drawing.Color]::FromArgb(46, 204, 113)
    $btnChange.FlatStyle = 'Flat'
    $btnChange.FlatAppearance.BorderSize = 0
    $btnChange.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(39, 174, 96)
    $btnChange.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnChange.Add_Click({
        $username = $comboUsers.SelectedItem
        $password = $textPassword.Text
        $confirm = $textConfirm.Text
        
        if ($password -ne $confirm) {
            [System.Windows.Forms.MessageBox]::Show("Password tidak cocok!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        
        if ($password.Length -lt 4) {
            [System.Windows.Forms.MessageBox]::Show("Password minimal 4 karakter!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        
        try {
            $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
            Set-LocalUser -Name $username -Password $securePassword -ErrorAction Stop
            
            [System.Windows.Forms.MessageBox]::Show("Password untuk user '$username' berhasil diubah!", "Sukses", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $form.Close()
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })
    $buttonPanel.Controls.Add($btnChange)
    
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(195, 0)
    $btnCancel.Size = New-Object System.Drawing.Size(180, 40)
    $btnCancel.Text = "[X] BATAL"
    $btnCancel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnCancel.ForeColor = [System.Drawing.Color]::White
    $btnCancel.BackColor = [System.Drawing.Color]::FromArgb(231, 76, 60)
    $btnCancel.FlatStyle = 'Flat'
    $btnCancel.FlatAppearance.BorderSize = 0
    $btnCancel.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(192, 57, 43)
    $btnCancel.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnCancel.Add_Click({ $form.Close() })
    $buttonPanel.Controls.Add($btnCancel)
    
    $form.ShowDialog()
}

function Update-StatusDisplay {
    $statusText.Text = Get-SecurityStatus
}

function Get-SecurityStatus {
    $status = ""
    
    # Check UAC
    $uacLevel = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -ErrorAction SilentlyContinue
    $status += "=== STATUS UAC ===`r`n"
    if ($uacLevel.ConsentPromptBehaviorAdmin -eq 2) {
        $status += "[OK] UAC: AKTIF (Level Maksimum)`r`n"
        $status += "[OK] Kunci Instalasi: AKTIF`r`n"
    } else {
        $status += "[ ] UAC: Level Normal`r`n"
        $status += "[ ] Kunci Instalasi: Tidak Aktif`r`n"
    }
    
    # Check MSI
    $msiRestriction = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer" -Name "DisableMSI" -ErrorAction SilentlyContinue
    $status += "`r`n=== INSTALASI MSI ===`r`n"
    if ($msiRestriction.DisableMSI -eq 1) {
        $status += "[OK] Dikunci untuk Non-Admin`r`n"
    } else {
        $status += "[ ] Tidak Dikunci`r`n"
    }
    
    # List Administrators
    $status += "`r`n=== DAFTAR ADMINISTRATOR ===`r`n"
    $admins = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue
    foreach ($admin in $admins) {
        $userName = $admin.Name.Split('\')[-1]
        $userObj = Get-LocalUser -Name $userName -ErrorAction SilentlyContinue
        if ($userObj) {
            $userStatus = if ($userObj.Enabled) { "Aktif" } else { "Nonaktif" }
            $status += " - $userName ($userStatus)`r`n"
        } else {
            $status += " - $userName`r`n"
        }
    }
    
    return $status
}

# ============================================
# MAIN GUI FORM
# ============================================

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = "Install Password Lock and User Management Tool"
$mainForm.Size = New-Object System.Drawing.Size(800, 600)
$mainForm.StartPosition = "CenterScreen"
$mainForm.FormBorderStyle = 'FixedDialog'
$mainForm.MaximizeBox = $false
$mainForm.BackColor = [System.Drawing.Color]::FromArgb(236, 240, 241)

# Header Panel with Gradient Effect
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Location = New-Object System.Drawing.Point(0, 0)
$headerPanel.Size = New-Object System.Drawing.Size(800, 80)
$headerPanel.BackColor = [System.Drawing.Color]::FromArgb(44, 62, 80)
$mainForm.Controls.Add($headerPanel)

# Title
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.Size = New-Object System.Drawing.Size(760, 35)
$titleLabel.Text = "[LOCK] INSTALL PASSWORD LOCK - USER MANAGEMENT TOOL"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::White
$titleLabel.TextAlign = 'MiddleCenter'
$headerPanel.Controls.Add($titleLabel)

# Subtitle
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Location = New-Object System.Drawing.Point(20, 50)
$subtitleLabel.Size = New-Object System.Drawing.Size(760, 22)
$subtitleLabel.Text = "Mengunci Instalasi Software dan Manajemen Akun Administrator"
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$subtitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(189, 195, 199)
$subtitleLabel.TextAlign = 'MiddleCenter'
$headerPanel.Controls.Add($subtitleLabel)

# Panel Buttons
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Location = New-Object System.Drawing.Point(25, 95)
$buttonPanel.Size = New-Object System.Drawing.Size(360, 460)
$buttonPanel.BackColor = [System.Drawing.Color]::White
$buttonPanel.BorderStyle = 'None'
$mainForm.Controls.Add($buttonPanel)

# Panel Title
$panelTitle = New-Object System.Windows.Forms.Label
$panelTitle.Location = New-Object System.Drawing.Point(15, 15)
$panelTitle.Size = New-Object System.Drawing.Size(330, 30)
$panelTitle.Text = "[MENU] MENU UTAMA"
$panelTitle.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$panelTitle.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$buttonPanel.Controls.Add($panelTitle)

# Button 1: Aktifkan Kunci
$btn1 = New-Object System.Windows.Forms.Button
$btn1.Location = New-Object System.Drawing.Point(15, 55)
$btn1.Size = New-Object System.Drawing.Size(330, 55)
$btn1.Text = "[LOCK] AKTIFKAN KUNCI INSTALASI"
$btn1.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btn1.ForeColor = [System.Drawing.Color]::White
$btn1.BackColor = [System.Drawing.Color]::FromArgb(46, 204, 113)
$btn1.FlatStyle = 'Flat'
$btn1.FlatAppearance.BorderSize = 0
$btn1.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(39, 174, 96)
$btn1.Cursor = [System.Windows.Forms.Cursors]::Hand
$btn1.Add_Click({ Enable-InstallLock })
$buttonPanel.Controls.Add($btn1)

# Button 2: Nonaktifkan Kunci
$btn2 = New-Object System.Windows.Forms.Button
$btn2.Location = New-Object System.Drawing.Point(15, 120)
$btn2.Size = New-Object System.Drawing.Size(330, 55)
$btn2.Text = "[UNLOCK] NONAKTIFKAN KUNCI INSTALASI"
$btn2.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btn2.ForeColor = [System.Drawing.Color]::White
$btn2.BackColor = [System.Drawing.Color]::FromArgb(231, 76, 60)
$btn2.FlatStyle = 'Flat'
$btn2.FlatAppearance.BorderSize = 0
$btn2.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(192, 57, 43)
$btn2.Cursor = [System.Windows.Forms.Cursors]::Hand
$btn2.Add_Click({ Disable-InstallLock })
$buttonPanel.Controls.Add($btn2)

# Button 3: Buat Admin Baru
$btn3 = New-Object System.Windows.Forms.Button
$btn3.Location = New-Object System.Drawing.Point(15, 185)
$btn3.Size = New-Object System.Drawing.Size(330, 55)
$btn3.Text = "[USER] BUAT AKUN ADMINISTRATOR BARU"
$btn3.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btn3.ForeColor = [System.Drawing.Color]::White
$btn3.BackColor = [System.Drawing.Color]::FromArgb(52, 152, 219)
$btn3.FlatStyle = 'Flat'
$btn3.FlatAppearance.BorderSize = 0
$btn3.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(41, 128, 185)
$btn3.Cursor = [System.Windows.Forms.Cursors]::Hand
$btn3.Add_Click({ New-AdminAccount })
$buttonPanel.Controls.Add($btn3)

# Button 4: Aktifkan Admin Built-in
$btn4 = New-Object System.Windows.Forms.Button
$btn4.Location = New-Object System.Drawing.Point(15, 250)
$btn4.Size = New-Object System.Drawing.Size(330, 55)
$btn4.Text = "[ADMIN] AKTIFKAN ADMINISTRATOR BUILT-IN"
$btn4.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btn4.ForeColor = [System.Drawing.Color]::White
$btn4.BackColor = [System.Drawing.Color]::FromArgb(243, 156, 18)
$btn4.FlatStyle = 'Flat'
$btn4.FlatAppearance.BorderSize = 0
$btn4.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(211, 136, 16)
$btn4.Cursor = [System.Windows.Forms.Cursors]::Hand
$btn4.Add_Click({ Enable-BuiltInAdmin })
$buttonPanel.Controls.Add($btn4)

# Button 5: Ubah Password
$btn5 = New-Object System.Windows.Forms.Button
$btn5.Location = New-Object System.Drawing.Point(15, 315)
$btn5.Size = New-Object System.Drawing.Size(330, 55)
$btn5.Text = "[PASS] UBAH PASSWORD USER"
$btn5.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btn5.ForeColor = [System.Drawing.Color]::White
$btn5.BackColor = [System.Drawing.Color]::FromArgb(155, 89, 182)
$btn5.FlatStyle = 'Flat'
$btn5.FlatAppearance.BorderSize = 0
$btn5.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(142, 68, 173)
$btn5.Cursor = [System.Windows.Forms.Cursors]::Hand
$btn5.Add_Click({ Set-UserPassword })
$buttonPanel.Controls.Add($btn5)

# Button 6: Refresh Status
$btn6 = New-Object System.Windows.Forms.Button
$btn6.Location = New-Object System.Drawing.Point(15, 380)
$btn6.Size = New-Object System.Drawing.Size(330, 45)
$btn6.Text = "[REFRESH] REFRESH STATUS"
$btn6.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btn6.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$btn6.BackColor = [System.Drawing.Color]::FromArgb(236, 240, 241)
$btn6.FlatStyle = 'Flat'
$btn6.FlatAppearance.BorderSize = 1
$btn6.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(189, 195, 199)
$btn6.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(189, 195, 199)
$btn6.Cursor = [System.Windows.Forms.Cursors]::Hand
$btn6.Add_Click({ Update-StatusDisplay })
$buttonPanel.Controls.Add($btn6)

# Panel Status
$statusPanel = New-Object System.Windows.Forms.Panel
$statusPanel.Location = New-Object System.Drawing.Point(400, 95)
$statusPanel.Size = New-Object System.Drawing.Size(375, 460)
$statusPanel.BackColor = [System.Drawing.Color]::White
$statusPanel.BorderStyle = 'None'
$mainForm.Controls.Add($statusPanel)

# Status Title
$statusTitleLabel = New-Object System.Windows.Forms.Label
$statusTitleLabel.Location = New-Object System.Drawing.Point(15, 15)
$statusTitleLabel.Size = New-Object System.Drawing.Size(345, 30)
$statusTitleLabel.Text = "[STATUS] STATUS KEAMANAN SISTEM"
$statusTitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$statusTitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$statusPanel.Controls.Add($statusTitleLabel)

# Status TextBox
$statusText = New-Object System.Windows.Forms.TextBox
$statusText.Location = New-Object System.Drawing.Point(15, 55)
$statusText.Size = New-Object System.Drawing.Size(345, 385)
$statusText.Multiline = $true
$statusText.ScrollBars = 'Vertical'
$statusText.ReadOnly = $true
$statusText.Font = New-Object System.Drawing.Font("Consolas", 9)
$statusText.BackColor = [System.Drawing.Color]::FromArgb(250, 250, 250)
$statusText.BorderStyle = 'FixedSingle'
$statusText.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
$statusPanel.Controls.Add($statusText)

# Initial status load
Update-StatusDisplay

# Show Form
[void]$mainForm.ShowDialog()