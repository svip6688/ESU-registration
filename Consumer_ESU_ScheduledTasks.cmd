@setlocal DisableDelayedExpansion
@echo off

:: 设置系统路径
set "Path=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SystemRoot%\System32\WindowsPowerShell\v1.0\"
if exist "%SystemRoot%\Sysnative\reg.exe" (
    set "Path=%SystemRoot%\Sysnative;%SystemRoot%;%SystemRoot%\Sysnative\Wbem;%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\;%Path%"
)

set "_err===== 错误 ====="

:: 检查系统版本（仅限 Windows 10 22H2）
for /f "tokens=6 delims=[]. " %%# in ('ver') do (
    if %%# gtr 19045 goto :E_Win
    if %%# lss 19041 goto :E_Win
)

:: 检查是否以管理员权限运行
reg query HKU\S-1-5-19 1>nul 2>nul || goto :E_Admin

:: 定义注册表键路径
set "_uKey=HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\ConsumerESU"
set "_mKey=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\ESU"

:: 初始化变量
set _uESU=0
set _mESU=0

:: 读取用户和系统的 ESU 注册表状态
for /f "skip=2 tokens=2*" %%a in ('reg query "%_uKey%" /v ESUEligibility 2^>nul') do call set /a _uESU=%%b
for /f "skip=2 tokens=2*" %%a in ('reg query "%_mKey%" /v Win10ConsumerESUStatus 2^>nul') do call set /a _mESU=%%b

set _enrolled=1
if %_uESU% neq 3 if %_uESU% neq 11 if %_uESU% neq 12 set _enrolled=0
if %_mESU% neq 3 if %_mESU% neq 11 if %_mESU% neq 12 set _enrolled=0

if %_enrolled% equ 1 (
    set "_status=已注册（Enrolled）"
) else (
    set "_status=！！未注册（NOT ENROLLED）！！"
)

:mMenu
@cls
echo ============================================================
echo Windows 10 消费者扩展安全更新（Consumer ESU）状态
echo ============================================================
echo 当前状态：%_status%
echo ============================================================
echo.
echo [1] 禁用 Consumer ESU 计划任务
echo.
echo [2] 启用 Consumer ESU 计划任务
echo.
echo [3] 退出
echo.
echo ============================================================
echo.
choice /C 123 /N /M "请选择一个选项: "
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
echo 操作已完成。
goto :TheEnd

:E_Admin
echo %_err%
echo 此脚本需要管理员权限，请右键以“管理员身份运行”。
goto :TheEnd

:E_Win
echo %_err%
echo 本脚本仅适用于 Windows 10 22H2 版本。
goto :TheEnd

:TheEnd
echo.
echo 按任意键退出……
pause >nul
goto :eof
