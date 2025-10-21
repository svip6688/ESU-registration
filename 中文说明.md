# Windows 10 消费者版扩展安全更新 (Consumer ESU) 注册脚本  
===============================
作者原版：https://github.com/abbodi1406/ConsumerESU
我们只是做了下汉化改进，最终解释权归作者所有!
此 PowerShell 脚本用于通过 **免费备份选项** 并使用 **Microsoft 帐户** 注册加入 Windows 10 消费者扩展安全更新（Consumer Extended Security Updates，简称 ESU）计划。  

---

📘 消费者设备与非消费者设备分类说明
============================

✅ 消费者设备（支持 Consumer ESU）包括：
  - Windows 10 Home（家庭版）
  - Windows 10 Home Single Language（单语言家庭版）
  - Windows 10 Pro（专业版）
  - Windows 10 Pro for Workstations（工作站专业版）

🚫 非消费者设备（不支持 Consumer ESU）包括：
  - Windows 10 Enterprise（企业版）
  - Windows 10 Education（教育版）
  - Windows 10 Enterprise LTSC / LTSC IoT（长期服务版）
  - Windows 10 Pro Education / Pro for Education（教育专业版）
### **更新日志 2025-10-12**
---------------------------------

- 从 **2025-10-08** 起，不再支持在未登录 Microsoft 帐户的情况下注册。  
- 不登录注册账号直接获取许可证的方式也已失效。  
- 已经注册成功的设备（使用本地账户或已获取许可证）不受影响。 
### 你的系统版本，非家庭版，单语言家庭版，专业版，工作站专业版，是不能注册的，需要转换成消费者版才可以注册ESU ###
K949M-8N2TP-2H9VY-BVQJR-FC2KM（专业版，只能转成专业版，不能激活，激活可自行网上查找资料！）

---

## 系统要求

- [Consumer ESU 前提条件](https://www.microsoft.com/windows/extended-security-updates) （[旧页面](https://web.archive.org/web/20250727070928/https://support.microsoft.com/en-us/windows/windows-10-consumer-extended-security-updates-esu-program-33e17de9-36b3-43bb-874d-6c53d2e4bf42)）  
- 已安装 2025 年 6 月累积更新 KB5061087（版本 19045.6036）或更新版本  
- Consumer ESU 功能已启用（见下方说明）  
- 管理员权限账户  
- 网络连接正常  
- 用户地区未被地理封锁（下列地区被封锁：俄罗斯、白俄罗斯、伊朗、古巴、朝鲜、叙利亚、苏丹、黎巴嫩、委内瑞拉）  

---

## 工作原理（设计逻辑）

脚本默认按以下顺序执行操作（如果前一步失败，将自动尝试下一步）：

1. 使用当前登录的 **Microsoft 帐户（Windows 用户）** 注册  
2. 使用当前登录的 **Microsoft 商店账户** 注册  

---

## 使用方法

1. 点击页面顶部的 **Code > [Download ZIP](https://github.com/svip6688/ESU-registration/archive/refs/tags/V0.0.7.zip)** 按钮下载脚本  
2. 解压 ZIP 文件中的所有内容  
3. 右键以管理员身份运行 `Consumer_ESU_Enrollment_run.cmd`  

---

## 高级用法

### **命令提示符方式：**

1. 点击 **Code > [Download ZIP](https://github.com/svip6688/ESU-registration/archive/refs/tags/V0.0.7.zip)** 下载  
2. 解压所有文件  
3. 在解压后的文件夹内以管理员身份打开命令提示符（或用 `cd /d` 命令进入该目录）  
4. 执行以下命令运行脚本（可带可选参数）  

示例：
```
Consumer_ESU_Enrollment_run.cmd -Store -Proceed
Consumer_ESU_Enrollment_run.cmd -Remove
Consumer_ESU_Enrollment_run.cmd -Reset
```

---

### **Windows PowerShell 方式：**

1. 点击 **Code > [Download ZIP](https://github.com/svip6688/ESU-registration/archive/refs/tags/V0.0.7.zip)** 下载  
2. 解压所有文件  
3. 在解压目录中以管理员身份打开 **PowerShell**  
4. 临时允许执行未签名脚本：
```
Set-ExecutionPolicy Bypass -Scope Process -Force
```
5. 执行 PowerShell 脚本（可带可选参数）  

示例：
```
.\Consumer_ESU_Enrollment.ps1
.\Consumer_ESU_Enrollment.ps1 -Store -Proceed
.\Consumer_ESU_Enrollment.ps1 -Remove
.\Consumer_ESU_Enrollment.ps1 -Reset
```

---

## 可选参数说明

| 参数开关 | 功能说明 |
|-----------|-----------|
| `-Online` | 仅使用 Microsoft 用户帐户令牌进行注册，失败则退出 |
| `-Store` | 仅使用 Microsoft 商店帐户令牌进行注册，失败则退出 |
| `-Remove` | 删除现有 Consumer ESU 许可证 |
| `-Reset` | 重置 Consumer ESU 功能为默认状态（若被脚本修改过） |
| `-Proceed` | 即使已注册仍强制重新注册 |

**注意：**
- 前两个参数（`-Online` 与 `-Store`）只能同时指定其中一个。  
- 仅 `-Proceed` 参数可与注册参数一起使用，以便使用不同令牌重新注册。  

---

## 重要说明

- 如果系统中只有一个用户账号，在成功获得 `DeviceEnrolled` 状态后，  
  为避免状态被更改或回滚（尤其在 EEA 或地理封锁地区），  
  建议禁用所有与 Consumer ESU 相关的计划任务。  
- 执行方法：以管理员身份运行 `Consumer_ESU_ScheduledTasks.cmd`，按 **1** 禁用相关任务。  
- 需要重新启用时，运行同一脚本并按 **2** 即可恢复。  

---

## Consumer ESU 功能启用

- 如果此功能尚未全面开放，脚本将自动尝试启用。  
- 如果脚本提示关闭会话，请直接关闭整个控制台窗口，然后重新运行脚本（参数保持一致）。  

<details><summary>手动启用参考方法</summary>

手动启用此功能（需重启系统生效）：

1. 以管理员身份运行命令提示符。  
2. 输入以下命令：
```
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 4011992206 /t REG_DWORD /d 2 /f
```
3. 以管理员身份运行 PowerShell，并依次执行以下命令（等待 “Task Completed” 提示）：  
```
$TN = "ReconcileFeatures"; $TP = "\Microsoft\Windows\Flighting\FeatureConfig\"; $null = Enable-ScheduledTask $TN $TP
Start-ScheduledTask $TN $TP; while ((Get-ScheduledTask $TN $TP).State.value__ -eq 4) {start-sleep -sec 1}; "Task Completed"
#
$TN = "UsageDataFlushing"; $TP = "\Microsoft\Windows\Flighting\FeatureConfig\"; $null = Enable-ScheduledTask $TN $TP
Start-ScheduledTask $TN $TP; while ((Get-ScheduledTask $TN $TP).State.value__ -eq 4) {start-sleep -sec 1}; "Task Completed"
#
```
4. **重启系统。**  
5. 再次以管理员身份打开命令提示符，执行以下命令：
```
cmd /c ClipESUConsumer.exe -evaluateEligibility
reg.exe query "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\ConsumerESU"
```
6. 检查最后一条命令的输出是否包含 **ESUEligibility** 且值不为零。  
   若不为零，说明功能已启用，可继续执行主脚本。  
   若值为 `0x0` 或不存在，说明尚未开放，需要等待微软正式推送。  
</details>

---

## 绕过地区封锁（Region Block）

<details><summary>点击展开查看</summary>

临时切换地区到未被封锁的国家/地区：

微软地区代码表参考：  
[Table of Geographical Locations](https://learn.microsoft.com/en-us/windows/win32/intl/table-of-geographical-locations)

手动更改路径：  
`设置 > 时间和语言 > 区域 > 国家或地区`

或在 PowerShell 中执行命令：  
```
Set-WinHomeLocation -GeoId 244
```

然后按照上方说明运行注册脚本。  

注册成功（显示 `DeviceEnrolled / SUCCESS`）后：  
以管理员身份运行 `Consumer_ESU_ScheduledTasks.cmd` 并选择：  

`[1] 禁用 Consumer ESU 计划任务`

最后可将地区恢复为原始设置（手动或 PowerShell 命令恢复）。  
</details>
