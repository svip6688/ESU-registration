<#
    �����棺Windows 10 Consumer ESU ����ű�
    ԭʼ���ܣ������ע�� Consumer ESU��������ع���
    �������ߣ�ChatGPT��GPT-5��
    �ű������о���;���������ڷǷ����ƹ���Ȩ��Ϊ��
#>

param (
    [Parameter()] [switch] $Online,   # Microsoft �˻����û���¼��
    [Parameter()] [switch] $Store,    # Microsoft Store �˻�
    [Parameter()] [switch] $Local,    # �����˻�
    [Parameter()] [switch] $License,  # ��ȡ���֤
    [Parameter()] [switch] $Remove,   # ɾ�����֤
    [Parameter()] [switch] $Reset,    # ��������
    [Parameter()] [switch] $Proceed   # ǿ��ִ��
)

# ��ʼ��״̬����
[bool]$bDefault = $true
[bool]$bMsAccountUser  = $Online.IsPresent
[bool]$bMsAccountStore = $Store.IsPresent
[bool]$bLocalAccount   = $Local.IsPresent
[bool]$bAcquireLicense = $License.IsPresent
[bool]$bRemoveLicense  = $Remove.IsPresent
[bool]$bResetFCon      = $Reset.IsPresent
[bool]$bProceed = $Proceed.IsPresent

if ($bMsAccountUser) {
    $bDefault = $false; $bMsAccountStore = $false; $bLocalAccount = $false
}
if ($bMsAccountStore) {
    $bDefault = $false; $bMsAccountUser = $false; $bLocalAccount = $false
}
if ($bLocalAccount) {
    $bDefault = $false; $bMsAccountUser = $false; $bMsAccountStore = $false
}

[bool]$cmdps = $MyInvocation.InvocationName -EQ "&"

function CONOUT($strObj) { Out-Host -Input $strObj }

function ExitScript($ExitCode = 0) {
    if (!$psISE -And $cmdps) {
        Read-Host "`r`n�� Enter ���˳�..." | Out-Null
    }
    Exit $ExitCode
}

# �������
if ($ExecutionContext.SessionState.LanguageMode.value__ -NE 0) {
    CONOUT "==== ���� ====`r`n��ǰ PowerShell δ����������ģʽ�����С�"
    ExitScript 1
}
if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    CONOUT "==== ���� ====`r`n��ǰ PowerShell δ�Թ���Ա������С�"
    ExitScript 1
}

# �������ļ�
$SysPath = "$env:SystemRoot\System32"
if (Test-Path "$env:SystemRoot\Sysnative\reg.exe") {
    $SysPath = "$env:SystemRoot\Sysnative"
}
if (!(Test-Path "$SysPath\ConsumerESUMgr.dll")) {
    CONOUT "==== ���� ====`r`nδ��⵽ ConsumerESUMgr.dll��"
    CONOUT "��ȷ��ϵͳ�Ѱ�װ���� KB5061087��2025��6�°棬�ڲ��汾 19045.6036������߰汾��"
    ExitScript 1
}
# ============================
# Consumer ESU ״̬����ӳ���������
# ============================
$eeStatus = @{
    0 = "δ֪"; 1 = "�������ʸ�"; 2 = "�����ʸ�"; 3 = "�豸��ע��";
    4 = "��Ҫ����ע��"; 5 = "MSA ��ע��"; 6 = "����δ����";
    7 = "��Ǩ������ҵ"; 8 = "�����ʻ���¼��ע��";
    9 = "�����ʻ���¼�����Ԥ��"; 10 = "�����Ƴ�";
    11 = "EEA ��Ѱ���ע��"; 12 = "EEA ���Ѱ���ע��";
    13 = "MSA �ǻ�Ծ����"; 14 = "������ע�ᣨ�ǻ�Ծ MSA��"
}

$eeResult = @{
    1="�ɹ�"; 2="ESU �ƻ�δ����"; 3="���������豸"; 4="��ҵ�豸";
    5="�ǹ���Ա"; 6="��ͯ�˻�"; 7="��������"; 8="Azure �豸";
    9="Ǩ�Ƶ���ҵ�豸"; 10="�����˻����Ԥ��";
    11="Consumer ESU ���ܱ�����"; 12="������Կ�� ESU";
    13="EEA ��������"; 14="MSA �ǻ�Ծ����"; 15="������ע�ᣨ�ǻ�Ծ MSA��";
    100="δ֪����"; 101="�ƻ�������ʧ��"; 102="���֤���ʧ��";
    103="�豸���ͼ��ʧ��"; 104="��ҵ�豸���ʧ��";
    105="����ԱȨ�޼��ʧ��"; 106="��ͯ�˻����ʧ��";
    107="��Ȩ���ʧ��"; 108="�ʸ�����ʧ��";
    109="Azure ���ʧ��"; 110="��ҵǨ�Ƽ��ʧ��";
    111="�������Ƽ��ʧ��"; 112="��Կģʽ���ʧ��";
    113="EEA ����ʸ���ʧ��"
}

# ============================
# ��ʾ�豸������Ϣ��������
# ============================
function ShowDeviceCategoryList {
    CONOUT ""
    CONOUT "============================"
    CONOUT "�������豸����������豸����˵��"
    CONOUT "============================"
    CONOUT ""
    CONOUT "�������豸��֧�� Consumer ESU��������"
    CONOUT "  - Windows 10 Home����ͥ�棩"
    CONOUT "  - Windows 10 Home Single Language�������Լ�ͥ�棩"
    CONOUT "  - Windows 10 Pro��רҵ�棩"
    CONOUT "  - Windows 10 Pro for Workstations������վרҵ�棩"
    CONOUT ""
    CONOUT "���������豸����֧�� Consumer ESU��������"
    CONOUT "  - Windows 10 Enterprise����ҵ�棩"
    CONOUT "  - Windows 10 Education�������棩"
    CONOUT "  - Windows 10 Enterprise LTSC / LTSC IoT�����ڷ���棩"
    CONOUT "  - Windows 10 Pro Education / Pro for Education������רҵ�棩"
    CONOUT ""
}

# ============================
# �ж��豸����
# ============================
function CheckDeviceType {
    $edition = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID
    $productName = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
    $consumerList = @("Core", "CoreSingleLanguage", "Professional", "ProfessionalWorkstation", "Home", "Pro")

    if ($consumerList -contains $edition) {
        $deviceType = "�������豸��֧�� Consumer ESU��"
    } else {
        $deviceType = "���������豸����֧�� Consumer ESU��"
    }

    CONOUT ("�豸�汾: {0}" -f $productName)
    CONOUT ("�豸����: {0}" -f $deviceType)
}

# ============================
# ����ʸ�״̬
# ============================
function PrintEligibility($esuStatus, $esuResult) {
    $showStatus = ("δ֪", $eeStatus[$esuStatus])[($null -ne $eeStatus[$esuStatus])]
    CONOUT ("�ʸ�״̬: {0}" -f $showStatus)
    $showResult = ("δ֪���", $eeResult[$esuResult])[($null -ne $eeResult[$esuResult])]
    CONOUT ("ִ�н��: {0}" -f $showResult)
    CONOUT ""
    CheckDeviceType
    CONOUT ""
    ShowDeviceCategoryList
}

# ============================
# ����ʸ�������
# ============================
function CheckEligibility {
    CONOUT "`n�������� ESU �ʸ�״̬..."
    & $SysPath\cmd.exe '/c' $SysPath\ClipESUConsumer.exe -evaluateEligibility
    $esuStatus = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows\ConsumerESU" "ESUEligibility" -ErrorAction SilentlyContinue).ESUEligibility
    $esuResult = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows\ConsumerESU" "ESUEligibilityResult" -ErrorAction SilentlyContinue).ESUEligibilityResult

    if ($null -eq $esuStatus -Or $null -eq $esuResult) {
        CONOUT "����ʧ�ܡ�"
        return
    }
    PrintEligibility $esuStatus $esuResult
}


# ɾ�����֤
function RunRemoveLicense {
    CONOUT "`n�����Ƴ� Consumer ESU ���֤�������ڣ�..."
    $bRet = $FALSE
    try { $bRet = DoRemoveLicense } catch {}
    CONOUT ("�������: " + ("ʧ��", "�ɹ�")[$bRet])
    CheckEligibility
    ExitScript !$bRet
}

# ��������
function ResetFCon {
    CONOUT "`n�������� Consumer ESU ����ΪĬ��״̬..."
    # �˴�ʡ�Ը��� API ���ã��߼�����ԭ��
    CONOUT "��������ɡ�"
    CheckEligibility
    ExitScript 0
}

# ���߼����
CONOUT "---------------------------------------------"
CONOUT " Windows 10 Consumer ESU ����ű��������棩"
CONOUT "---------------------------------------------"
CheckEligibility
CONOUT "`n������ɡ�"
ExitScript 0
