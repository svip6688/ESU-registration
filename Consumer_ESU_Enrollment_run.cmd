@echo off
:: 原始脚本：用于调用位于同一目录下的 PowerShell 脚本 Consumer_ESU_Enrollment.ps1
:: 汉化说明：仅翻译注释与提示文本，不改变执行逻辑

:: _PSf 保存当前批处理所在目录的 Consumer_ESU_Enrollment.ps1 的完整路径
set "_PSf=%~dp0Consumer_ESU_Enrollment.ps1"

:: 启用延迟变量展开（保持与原脚本行为一致）
setlocal EnableDelayedExpansion

:: 替换路径中单引号为两个单引号（与原脚本等效）
set "_PSf=!_PSf:'=''!"

:: 以 PowerShell 无配置文件、绕过执行策略的方式调用脚本，并把所有参数传递给它
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^& "'!_PSf!' %*"
