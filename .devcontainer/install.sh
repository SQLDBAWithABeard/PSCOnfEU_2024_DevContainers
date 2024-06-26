curl -s https://ohmyposh.dev/install.sh | bash -s
mkdir /root/.config/
mkdir /root/.config/powershell/
touch /root/.config/powershell/Microsoft.PowerShell_profile.ps1
curl -o /root/.config/powershell/Microsoft.PowerShell_profile.ps1 https://gist.githubusercontent.com/SQLDBAWithABeard/13e1f7bf3dd69afc3496e00f6d945b49/raw/afb2970fa26eb774c4b4df8188e0f25099f134af/profileforcontainers.ps1
pwsh -c "Install-Module PSFramework,ImportExcel,Pester,Profiler -Scope AllUsers"