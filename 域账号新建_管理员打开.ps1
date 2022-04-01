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