@setlocal DisableDelayedExpansion
@echo off

:: ����ϵͳ·��
set "Path=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0\"
if exist "%SystemRoot%\Sysnative\reg.exe" (
    set "Path=%SystemRoot%\Sysnative;%SystemRoot%;%SystemRoot%\Sysnative\Wbem;%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\;%Path%"
)

set "_err===== ���� ====="

:: ���ϵͳ�汾������ Windows 10 22H2��
for /f "tokens=6 delims=[]. " %%# in ('ver') do (
    if %%# gtr 19045 goto :E_Win
    if %%# lss 19041 goto :E_Win
)

:: ����Ƿ��Թ���ԱȨ������
reg query HKU\S-1-5-19 1>nul 2>nul || goto :E_Admin

:: ����ע����·��
set "_uKey=HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\ConsumerESU"
set "_mKey=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\ESU"

:: ��ʼ������
set _uESU=0
set _mESU=0

:: ��ȡ�û���ϵͳ�� ESU ע���״̬
for /f "skip=2 tokens=2*" %%a in ('reg query "%_uKey%" /v ESUEligibility 2^>nul') do call set /a _uESU=%%b
for /f "skip=2 tokens=2*" %%a in ('reg query "%_mKey%" /v Win10ConsumerESUStatus 2^>nul') do call set /a _mESU=%%b

set _enrolled=1
if %_uESU% neq 3 if %_uESU% neq 11 if %_uESU% neq 12 set _enrolled=0
if %_mESU% neq 3 if %_mESU% neq 11 if %_mESU% neq 12 set _enrolled=0

if %_enrolled% equ 1 (
    set "_status=��ע�ᣨEnrolled��"
) else (
    set "_status=����δע�ᣨNOT ENROLLED������"
)

:mMenu
@cls
echo ============================================================
echo Windows 10 ��������չ��ȫ���£�Consumer ESU��״̬
echo ============================================================
echo ��ǰ״̬��%_status%
echo ============================================================
echo.
echo [1] ���� Consumer ESU �ƻ�����
echo.
echo [2] ���� Consumer ESU �ƻ�����
echo.
echo [3] �˳�
echo.
echo ============================================================
echo.
choice /C 123 /N /M "��ѡ��һ��ѡ��: "
set _elr=%errorlevel%
if %_elr%==3 goto :eof
if %_elr%==2 (set "_opt=/ENABLE"&goto :Tasks)
if %_elr%==1 (set "_opt=/DISABLE"&goto :Tasks)
goto :mMenu

:Tasks
@cls
set "_cmnd=schtasks.exe /Change %_opt% /TN"
set "_task=\Microsoft\Windows\Clip\ClipEsuConsumer"
echo.
%_cmnd% "%_task%" 2>nul && echo.
%_cmnd% "%_task%ProcessPreOrder" 2>nul && echo.
%_cmnd% "%_task%ProcessRefund" 2>nul && echo.
%_cmnd% "%_task%ProcessECUpdate" 2>nul && echo.
echo.
echo ��������ɡ�
goto :TheEnd

:E_Admin
echo %_err%
echo �˽ű���Ҫ����ԱȨ�ޣ����Ҽ��ԡ�����Ա������С���
goto :TheEnd

:E_Win
echo %_err%
echo ���ű��������� Windows 10 22H2 �汾��
goto :TheEnd

:TheEnd
echo.
echo ��������˳�����
pause >nul
goto :eof
