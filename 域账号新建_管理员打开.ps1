Import-Module -Name C:\Users\Administrator.ZILLION\Desktop\账号新建\excel_moudel\ImportExcel.psd1
$newusers = Import-Excel C:\Users\Administrator.ZILLION\Desktop\账号新建\入职单-NH148_test.xlsx
Write-Warning "开始检查账户~~~"

foreach($user in $newusers.domainaccount){
try {Get-ADUser -Identity $user > $null  -ErrorAction Stop} catch{}
if ($? -eq $false)
{
Write-Host "$($user):OK"}

else{Write-Host -ForegroundColor Red "$($user):NOT_OK"
#Write-Warning "有重名！已停止！！"
}
}
pause
function users_add($Newusers,$OuPath){
foreach($newuser in $newusers){
try{
New-ADUser -Enabled $true `
-GivenName $newuser.ChineseName `
-Surname 'SJW' `
-Name $newuser.ChineseName `
-DisplayName $newuser.ChineseName `
-SamAccountName $newuser.DomainAccount `
-AccountPassword (ConvertTo-SecureString -AsPlainText Zillion123456 -Force ) `
-ChangePasswordAtLogon $true `
-Path $OuPath `
-ErrorAction stop
Write-Host "$($newuser.DomainAccount)状态：OK"
}
catch{
Write-Host `
 -ForegroundColor Red "$($newuser.DomainAccount) $($newuser.ChineseName) 创建出错！！！"
}
}}

$ou = Read-Host "输入新建的批次OU，如果不需要则直接回车"
if ($ou -ne ''){
try{
New-ADOrganizationalUnit -Name $ou -Path "OU=Zillion-Users,DC=zillion,DC=com" -ErrorAction stop
Write-Host -BackgroundColor Green "创建成功:OK"
users_add -Newusers $newusers -OuPath "OU=$($ou),OU=Zillion-Users,DC=zillion,DC=com"
Write-Warning "请继续创建邮箱账号，同步路径输入`nOU=$($ou),OU=Zillion-Users,DC=zillion,DC=com"
pause
}
catch{Write-Warning "创建失败！！！"}


}
else{
users_add -Newusers $newusers -OuPath "OU=Zillion-Users,DC=zillion,DC=com"
Write-Warning "请继续创建邮箱账号，同步路径输入`nOU=Zillion-Users,DC=zillion,DC=com"
pause
}
###
# 导入 PowerShell 模块
Import-Module -Name C:\Users\Administrator.ZILLION\Desktop\账号新建\excel_moudel\ImportExcel.psd1

# 导入 Excel 数据
$newusers = Import-Excel C:\Users\Administrator.ZILLION\Desktop\账号新建\入职单-NH148_test.xlsx

Write-Host "开始检查账户~~~"

foreach ($user in $newusers.domainaccount) {
    if (-not (Get-ADUser -Filter {SamAccountName -eq $user})) {
        # 用户不存在，创建用户
        try {
            $userProperties = @{
                Enabled            = $true
                GivenName          = $user.ChineseName
                Surname            = 'SJW'
                Name               = $user.ChineseName
                DisplayName        = $user.ChineseName
                SamAccountName     = $user.DomainAccount
                AccountPassword    = (ConvertTo-SecureString -AsPlainText Zillion123456 -Force)
                ChangePasswordAtLogon = $true
                Path               = "OU=Zillion-Users,DC=zillion,DC=com"
            }
            New-ADUser @userProperties -ErrorAction Stop
            Write-Host "$($user.DomainAccount): OK"
        } catch {
            Write-Host -ForegroundColor Red "$($user.DomainAccount) $($user.ChineseName) 创建出错！！！"
        }
    } else {
        Write-Host "$($user): OK"
    }
}

# 提示用户输入新建的批次OU，如果不需要则直接回车
$ou = Read-Host "输入新建的批次OU，如果不需要则直接回车"

if ($ou) {
    # 用户提供了 OU 名称，创建新的 OU
    try {
        New-ADOrganizationalUnit -Name $ou -Path "OU=Zillion-Users,DC=zillion,DC=com" -ErrorAction Stop
        Write-Host -BackgroundColor Green "创建成功: OK"
    } catch {
        Write-Warning "创建失败！！！"
    }

    # 调用函数创建用户帐户
    users_add -Newusers $newusers -OuPath "OU=$ou,OU=Zillion-Users,DC=zillion,DC=com"
    Write-Warning "请继续创建邮箱账号，同步路径输入`nOU=$ou,OU=Zillion-Users,DC=zillion,DC=com"
    pause
} else {
    # 用户没有提供 OU 名称，直接调用函数创建用户帐户
    users_add -Newusers $newusers -OuPath "OU=Zillion-Users,DC=zillion,DC=com"
    Write-Warning "请继续创建邮箱账号，同步路径输入`nOU=Zillion-Users,DC=zillion,DC=com"
    pause
}

# 定义函数创建用户帐户
function users_add($Newusers, $OuPath) {
    foreach ($newuser in $Newusers) {
        if (-not (Get-ADUser -Filter {SamAccountName -eq $newuser.DomainAccount})) {
            # 用户不存在，创建用户
            try {
                $userProperties = @{
                    Enabled            = $true
                    GivenName          = $newuser.ChineseName
                    Surname            = 'SJW'
                    Name               = $newuser.ChineseName
                    DisplayName        = $newuser.ChineseName
                    SamAccountName     = $newuser.DomainAccount
                    AccountPassword    = (ConvertTo-SecureString -AsPlainText Zillion123456 -Force)
                    ChangePasswordAtLogon = $true
                    Path               = $OuPath
                }
                New-ADUser @userProperties -ErrorAction Stop
                Write-Host "$($newuser.DomainAccount)状态：OK"
            } catch {
                Write-Host -ForegroundColor Red "$($newuser.DomainAccount) $($newuser.ChineseName) 创建出错！！！"
            }
        } else {
            Write-Host "$($newuser.DomainAccount): OK"
        }
    }
}
