# 部署

## 下载安装包

如果部分链接下载速度慢，推荐[安装迅雷](https://dl.xunlei.com/)加速下载。

请将安装包放置在本目录下，安装框架将会自动部署。

### 常用必备

- 为了支持 Windows 7 系列的老系统 ……

  <details><summary>升级与补丁</summary><br/>

  - 安装 [.NET Framework 4.5.2](https://www.microsoft.com/en-us/download/confirmation.aspx?id=42642) 或更高版本，使用 PowerShell 校验安装包：

        (Get-FileHash -Algorithm SHA256 'NDP452-KB2901907-x86-x64-AllOS-ENU.exe').Hash -eq '6C2C589132E830A185C5F40F82042BEE3022E721A216680BD9B3995BA86F3781'

  - 安装 [Windows Management Framework 5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)

    1.  选择 `Win7AndW2K8R2-KB3191566-x64.zip` 以下载
    2.  使用 PowerShell 校验安装包:

            (Get-FileHash -Algorithm SHA256 'Win7AndW2K8R2-KB3191566-x64.zip').Hash -eq 'F383C34AA65332662A17D95409A2DDEDADCEDA74427E35D05024CD0A6A2FA647'

    3.  解压内容

  </details><br/>

- Firefox: 有效保护隐私的浏览器

  [点击直接下载](https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=zh-CN)

- Everything：文件搜索器，体验远超系统内置搜索引擎

  找到 `精简版安装版本 64 位` 下载，见[官方下载页](https://www.voidtools.com/zh-cn/)

### 开发者工具

- PowerShell Core: PowerShell 最新稳定版

  找到 `win-x64.msi` 下载，见[高校镜像站](https://mirrorz.org/list/PowerShell)

- Git for Windows: 开发必备

  找到 `64-bit, exe` 下载，见[高校镜像站](https://mirrorz.org/app/Git)

- gVim: 文本编辑器

  按修改时间倒排，找到最新版 `.exe` 下载，见[高校镜像站](https://mirrorz.org/list/vim)

- ADB: 安卓手机/虚拟机调试工具

  [Download Content directly](https://dl.google.com/android/repository/platform-tools-latest-windows.zip)

- VirtualBox: Oracle 公司维护的免费开源虚拟化平台

  从[高校镜像站](https://mirrorz.org/app/VirtualBox)下载

### 更多

- qBittorrent-Enhanced-Edition: 改良版 BT 下载器

  找到 `_x64_setup.exe` 下载，见 [GitHub 下载页](https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/latest)

- OBS: 自由的直播录屏器

  找到 `-Full-Installer-x64 (exe)` 下载，见[高校镜像站](https://mirrorz.org/app/OBS)

这些软件下载地址[见前文](./README.md):

- Everything 文件搜索器，体验远超系统内置搜索引擎
- Thunderbird 广受欢迎的 Mozilla 邮件客户端
- 7zip 压缩软件
- VeraCrypt 自由的硬盘数据加密器

- Workrave 长时间工作休息提醒
- Cyberduck 云端存储浏览器
- KDE Connect 手机互联

- VSCode 开发神器
- gsudo 获取管理员权限
- Tabby 终端模拟器
- Sysinternals 系统实用程序
- ImDisk Toolkit 挂载内存盘、镜像文件
- OpenSSH 组件升级包（ 可选 ）

### 手动安装

请下载到 `.\manual` 目录内，需要手动安装

- 思源字体：可自由出版商用的字体，由谷歌联手 Adobe 共同设计

  - Noto Sans CJK: 思源黑体

    - [从官方 GitHub 下载](https://github.com/googlefonts/noto-cjk/releases/latest/download/03_NotoSansCJK-OTC.zip)
    - 找到 `OTC` 下载，见[高校镜像站](https://mirrorz.org/font/GoogleFonts)

  - Noto Sans Mono: 等宽版本

    - [从官方 GitHub 下载](https://github.com/googlefonts/noto-cjk/releases/latest/download/13_NotoSansMonoCJKsc.zip)
    - 找到 `MonoCJKsc` 下载，见[高校镜像站](https://mirrorz.org/font/GoogleFonts)

  - Source Han Serif: 思源宋体

    - [从官方 GitHub 下载](https://github.com/adobe-fonts/source-han-serif/releases/latest/download/01_SourceHanSerif.ttc.zip)
    - 找到 `Serif-VF.ttf` 下载，见[高校镜像站](https://mirrorz.org/font/AdobeSourceHan)

- Brave: 免费的 Chromium 发行版

  [获取在线安装器](https://laptop-updates.brave.com/latest/winx64)

- 微软 Office

  [获取在线安装器](https://setup.office.com/)

硬件驱动：

- Logi Options+

  [获取在线安装器](https://www.logitech.com.cn/zh-cn/software/logi-options-plus.html)

## 数字签名验证

执行 `_verify.cmd`
