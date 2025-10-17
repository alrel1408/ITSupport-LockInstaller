# ============================================
# Install Password Lock Tool - GUI Version
# Windows Forms Interface
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
    $form.Size = New-Object System.Drawing.Size(400, 250)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    
    # Username Label & TextBox
    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Location = New-Object System.Drawing.Point(20, 20)
    $labelUser.Size = New-Object System.Drawing.Size(350, 20)
    $labelUser.Text = "Nama User Baru:"
    $form.Controls.Add($labelUser)
    
    $textUsername = New-Object System.Windows.Forms.TextBox
    $textUsername.Location = New-Object System.Drawing.Point(20, 45)
    $textUsername.Size = New-Object System.Drawing.Size(340, 25)
    $form.Controls.Add($textUsername)
    
    # Password Label & TextBox
    $labelPass = New-Object System.Windows.Forms.Label
    $labelPass.Location = New-Object System.Drawing.Point(20, 80)
    $labelPass.Size = New-Object System.Drawing.Size(350, 20)
    $labelPass.Text = "Password:"
    $form.Controls.Add($labelPass)
    
    $textPassword = New-Object System.Windows.Forms.TextBox
    $textPassword.Location = New-Object System.Drawing.Point(20, 105)
    $textPassword.Size = New-Object System.Drawing.Size(340, 25)
    $textPassword.PasswordChar = '*'
    $form.Controls.Add($textPassword)
    
    # Confirm Password Label & TextBox
    $labelConfirm = New-Object System.Windows.Forms.Label
    $labelConfirm.Location = New-Object System.Drawing.Point(20, 140)
    $labelConfirm.Size = New-Object System.Drawing.Size(350, 20)
    $labelConfirm.Text = "Konfirmasi Password:"
    $form.Controls.Add($labelConfirm)
    
    $textConfirm = New-Object System.Windows.Forms.TextBox
    $textConfirm.Location = New-Object System.Drawing.Point(20, 165)
    $textConfirm.Size = New-Object System.Drawing.Size(340, 25)
    $textConfirm.PasswordChar = '*'
    $form.Controls.Add($textConfirm)
    
    # Button Buat
    $btnCreate = New-Object System.Windows.Forms.Button
    $btnCreate.Location = New-Object System.Drawing.Point(180, 200)
    $btnCreate.Size = New-Object System.Drawing.Size(90, 30)
    $btnCreate.Text = "Buat"
    $btnCreate.BackColor = [System.Drawing.Color]::LightGreen
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
    $form.Controls.Add($btnCreate)
    
    # Button Batal
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(280, 200)
    $btnCancel.Size = New-Object System.Drawing.Size(80, 30)
    $btnCancel.Text = "Batal"
    $btnCancel.Add_Click({ $form.Close() })
    $form.Controls.Add($btnCancel)
    
    $form.ShowDialog()
}

function Enable-BuiltInAdmin {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Aktifkan Administrator Built-in"
    $form.Size = New-Object System.Drawing.Size(400, 220)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    
    $labelInfo = New-Object System.Windows.Forms.Label
    $labelInfo.Location = New-Object System.Drawing.Point(20, 20)
    $labelInfo.Size = New-Object System.Drawing.Size(350, 40)
    $labelInfo.Text = "Aktifkan akun 'Administrator' built-in Windows dan set password baru:"
    $form.Controls.Add($labelInfo)
    
    # Password Label & TextBox
    $labelPass = New-Object System.Windows.Forms.Label
    $labelPass.Location = New-Object System.Drawing.Point(20, 70)
    $labelPass.Size = New-Object System.Drawing.Size(350, 20)
    $labelPass.Text = "Password Baru:"
    $form.Controls.Add($labelPass)
    
    $textPassword = New-Object System.Windows.Forms.TextBox
    $textPassword.Location = New-Object System.Drawing.Point(20, 95)
    $textPassword.Size = New-Object System.Drawing.Size(340, 25)
    $textPassword.PasswordChar = '*'
    $form.Controls.Add($textPassword)
    
    # Confirm Password
    $labelConfirm = New-Object System.Windows.Forms.Label
    $labelConfirm.Location = New-Object System.Drawing.Point(20, 130)
    $labelConfirm.Size = New-Object System.Drawing.Size(350, 20)
    $labelConfirm.Text = "Konfirmasi Password:"
    $form.Controls.Add($labelConfirm)
    
    $textConfirm = New-Object System.Windows.Forms.TextBox
    $textConfirm.Location = New-Object System.Drawing.Point(20, 155)
    $textConfirm.Size = New-Object System.Drawing.Size(340, 25)
    $textConfirm.PasswordChar = '*'
    $form.Controls.Add($textConfirm)
    
    # Button
    $btnActivate = New-Object System.Windows.Forms.Button
    $btnActivate.Location = New-Object System.Drawing.Point(180, 190)
    $btnActivate.Size = New-Object System.Drawing.Size(90, 25)
    $btnActivate.Text = "Aktifkan"
    $btnActivate.BackColor = [System.Drawing.Color]::LightGreen
    $btnActivate.Add_Click({
        $password = $textPassword.Text
        $confirm = $textConfirm.Text
        
        if ($password -ne $confirm) {
            [System.Windows.Forms.MessageBox]::Show("Password tidak cocok!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
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
    $form.Controls.Add($btnActivate)
    
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(280, 190)
    $btnCancel.Size = New-Object System.Drawing.Size(80, 25)
    $btnCancel.Text = "Batal"
    $btnCancel.Add_Click({ $form.Close() })
    $form.Controls.Add($btnCancel)
    
    $form.ShowDialog()
}

function Set-UserPassword {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Ubah Password User"
    $form.Size = New-Object System.Drawing.Size(400, 250)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    
    # User ComboBox
    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Location = New-Object System.Drawing.Point(20, 20)
    $labelUser.Size = New-Object System.Drawing.Size(350, 20)
    $labelUser.Text = "Pilih User:"
    $form.Controls.Add($labelUser)
    
    $comboUsers = New-Object System.Windows.Forms.ComboBox
    $comboUsers.Location = New-Object System.Drawing.Point(20, 45)
    $comboUsers.Size = New-Object System.Drawing.Size(340, 25)
    $comboUsers.DropDownStyle = 'DropDownList'
    
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
    $labelPass.Location = New-Object System.Drawing.Point(20, 80)
    $labelPass.Size = New-Object System.Drawing.Size(350, 20)
    $labelPass.Text = "Password Baru:"
    $form.Controls.Add($labelPass)
    
    $textPassword = New-Object System.Windows.Forms.TextBox
    $textPassword.Location = New-Object System.Drawing.Point(20, 105)
    $textPassword.Size = New-Object System.Drawing.Size(340, 25)
    $textPassword.PasswordChar = '*'
    $form.Controls.Add($textPassword)
    
    # Confirm Password
    $labelConfirm = New-Object System.Windows.Forms.Label
    $labelConfirm.Location = New-Object System.Drawing.Point(20, 140)
    $labelConfirm.Size = New-Object System.Drawing.Size(350, 20)
    $labelConfirm.Text = "Konfirmasi Password:"
    $form.Controls.Add($labelConfirm)
    
    $textConfirm = New-Object System.Windows.Forms.TextBox
    $textConfirm.Location = New-Object System.Drawing.Point(20, 165)
    $textConfirm.Size = New-Object System.Drawing.Size(340, 25)
    $textConfirm.PasswordChar = '*'
    $form.Controls.Add($textConfirm)
    
    # Buttons
    $btnChange = New-Object System.Windows.Forms.Button
    $btnChange.Location = New-Object System.Drawing.Point(180, 200)
    $btnChange.Size = New-Object System.Drawing.Size(90, 30)
    $btnChange.Text = "Ubah"
    $btnChange.BackColor = [System.Drawing.Color]::LightGreen
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
    $form.Controls.Add($btnChange)
    
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(280, 200)
    $btnCancel.Size = New-Object System.Drawing.Size(80, 30)
    $btnCancel.Text = "Batal"
    $btnCancel.Add_Click({ $form.Close() })
    $form.Controls.Add($btnCancel)
    
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
$mainForm.Size = New-Object System.Drawing.Size(700, 550)
$mainForm.StartPosition = "CenterScreen"
$mainForm.FormBorderStyle = 'FixedDialog'
$mainForm.MaximizeBox = $false
$mainForm.BackColor = [System.Drawing.Color]::WhiteSmoke

# Title
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.Size = New-Object System.Drawing.Size(660, 30)
$titleLabel.Text = "INSTALL PASSWORD LOCK - USER MANAGEMENT TOOL"
$titleLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::DarkBlue
$titleLabel.TextAlign = 'MiddleCenter'
$mainForm.Controls.Add($titleLabel)

# Subtitle
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Location = New-Object System.Drawing.Point(20, 45)
$subtitleLabel.Size = New-Object System.Drawing.Size(660, 20)
$subtitleLabel.Text = "Mengunci Instalasi Software dan Manajemen Akun Administrator"
$subtitleLabel.Font = New-Object System.Drawing.Font("Arial", 9)
$subtitleLabel.ForeColor = [System.Drawing.Color]::Gray
$subtitleLabel.TextAlign = 'MiddleCenter'
$mainForm.Controls.Add($subtitleLabel)

# Panel Buttons
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Location = New-Object System.Drawing.Point(20, 80)
$buttonPanel.Size = New-Object System.Drawing.Size(320, 420)
$buttonPanel.BorderStyle = 'FixedSingle'
$mainForm.Controls.Add($buttonPanel)

# Panel Title
$panelTitle = New-Object System.Windows.Forms.Label
$panelTitle.Location = New-Object System.Drawing.Point(10, 10)
$panelTitle.Size = New-Object System.Drawing.Size(300, 25)
$panelTitle.Text = "MENU UTAMA"
$panelTitle.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
$panelTitle.ForeColor = [System.Drawing.Color]::DarkGreen
$buttonPanel.Controls.Add($panelTitle)

# Button 1: Aktifkan Kunci
$btn1 = New-Object System.Windows.Forms.Button
$btn1.Location = New-Object System.Drawing.Point(10, 45)
$btn1.Size = New-Object System.Drawing.Size(295, 50)
$btn1.Text = "[1] AKTIFKAN KUNCI INSTALASI"
$btn1.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$btn1.BackColor = [System.Drawing.Color]::LightGreen
$btn1.Add_Click({ Enable-InstallLock })
$buttonPanel.Controls.Add($btn1)

# Button 2: Nonaktifkan Kunci
$btn2 = New-Object System.Windows.Forms.Button
$btn2.Location = New-Object System.Drawing.Point(10, 105)
$btn2.Size = New-Object System.Drawing.Size(295, 50)
$btn2.Text = "[2] NONAKTIFKAN KUNCI INSTALASI"
$btn2.Font = New-Object System.Drawing.Font("Arial", 10)
$btn2.BackColor = [System.Drawing.Color]::LightCoral
$btn2.Add_Click({ Disable-InstallLock })
$buttonPanel.Controls.Add($btn2)

# Button 3: Buat Admin Baru
$btn3 = New-Object System.Windows.Forms.Button
$btn3.Location = New-Object System.Drawing.Point(10, 165)
$btn3.Size = New-Object System.Drawing.Size(295, 50)
$btn3.Text = "[3] BUAT AKUN ADMINISTRATOR BARU"
$btn3.Font = New-Object System.Drawing.Font("Arial", 10)
$btn3.BackColor = [System.Drawing.Color]::LightBlue
$btn3.Add_Click({ New-AdminAccount })
$buttonPanel.Controls.Add($btn3)

# Button 4: Aktifkan Admin Built-in
$btn4 = New-Object System.Windows.Forms.Button
$btn4.Location = New-Object System.Drawing.Point(10, 225)
$btn4.Size = New-Object System.Drawing.Size(295, 50)
$btn4.Text = "[4] AKTIFKAN ADMINISTRATOR BUILT-IN"
$btn4.Font = New-Object System.Drawing.Font("Arial", 10)
$btn4.BackColor = [System.Drawing.Color]::LightGoldenrodYellow
$btn4.Add_Click({ Enable-BuiltInAdmin })
$buttonPanel.Controls.Add($btn4)

# Button 5: Ubah Password
$btn5 = New-Object System.Windows.Forms.Button
$btn5.Location = New-Object System.Drawing.Point(10, 285)
$btn5.Size = New-Object System.Drawing.Size(295, 50)
$btn5.Text = "[5] UBAH PASSWORD USER"
$btn5.Font = New-Object System.Drawing.Font("Arial", 10)
$btn5.BackColor = [System.Drawing.Color]::Plum
$btn5.Add_Click({ Set-UserPassword })
$buttonPanel.Controls.Add($btn5)

# Button 6: Refresh Status
$btn6 = New-Object System.Windows.Forms.Button
$btn6.Location = New-Object System.Drawing.Point(10, 345)
$btn6.Size = New-Object System.Drawing.Size(295, 35)
$btn6.Text = "[6] REFRESH STATUS"
$btn6.Font = New-Object System.Drawing.Font("Arial", 9)
$btn6.BackColor = [System.Drawing.Color]::White
$btn6.Add_Click({ Update-StatusDisplay })
$buttonPanel.Controls.Add($btn6)

# Panel Status
$statusPanel = New-Object System.Windows.Forms.Panel
$statusPanel.Location = New-Object System.Drawing.Point(350, 80)
$statusPanel.Size = New-Object System.Drawing.Size(320, 420)
$statusPanel.BorderStyle = 'FixedSingle'
$mainForm.Controls.Add($statusPanel)

# Status Title
$statusTitleLabel = New-Object System.Windows.Forms.Label
$statusTitleLabel.Location = New-Object System.Drawing.Point(10, 10)
$statusTitleLabel.Size = New-Object System.Drawing.Size(300, 25)
$statusTitleLabel.Text = "STATUS KEAMANAN SISTEM"
$statusTitleLabel.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
$statusTitleLabel.ForeColor = [System.Drawing.Color]::DarkBlue
$statusPanel.Controls.Add($statusTitleLabel)

# Status TextBox
$statusText = New-Object System.Windows.Forms.TextBox
$statusText.Location = New-Object System.Drawing.Point(10, 45)
$statusText.Size = New-Object System.Drawing.Size(295, 360)
$statusText.Multiline = $true
$statusText.ScrollBars = 'Vertical'
$statusText.ReadOnly = $true
$statusText.Font = New-Object System.Drawing.Font("Consolas", 9)
$statusText.BackColor = [System.Drawing.Color]::White
$statusPanel.Controls.Add($statusText)

# Initial status load
Update-StatusDisplay

# Show Form
[void]$mainForm.ShowDialog()
