@echo off
:: ԭʼ�ű������ڵ���λ��ͬһĿ¼�µ� PowerShell �ű� Consumer_ESU_Enrollment.ps1
:: ����˵����������ע������ʾ�ı������ı�ִ���߼�

:: _PSf ���浱ǰ����������Ŀ¼�� Consumer_ESU_Enrollment.ps1 ������·��
set "_PSf=%~dp0Consumer_ESU_Enrollment.ps1"

:: �����ӳٱ���չ����������ԭ�ű���Ϊһ�£�
setlocal EnableDelayedExpansion

:: �滻·���е�����Ϊ���������ţ���ԭ�ű���Ч��
set "_PSf=!_PSf:'=''!"

:: �� PowerShell �������ļ����ƹ�ִ�в��Եķ�ʽ���ýű����������в������ݸ���
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^& "'!_PSf!' %*"
