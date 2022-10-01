# 下载安装包

推荐的自由软件

- Firefox: 有效保护隐私的浏览器

  [点击直接下载](https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=zh-CN)

- Everything：文件搜索器，体验远超系统内置搜索引擎

  找到 `精简版安装版本 64 位` 下载，见[官方下载页](https://www.voidtools.com/zh-cn/)

- qBittorrent-Enhanced-Edition: 改良版 BT 下载器

  找到 `_x64_setup.exe` 下载，见[GitHub 下载页](https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/latest)

- OBS: 自由的直播录屏器

  找到 `-Full-Installer-x64 (exe)` 下载，见[高校镜像站](https://mirrorz.org/app/OBS)

## 思源字体

可自由出版商用的字体，由谷歌联手 Adobe 共同设计

- Noto Sans CJK: 思源黑体

  - [从官方 GitHub 下载](https://github.com/googlefonts/noto-cjk/releases/latest/download/03_NotoSansCJK-OTC.zip)
  - 找到 `OTC` 下载，见[高校镜像站](https://mirrorz.org/font/GoogleFonts)

- Noto Sans Mono: 等宽版本

  - [从官方 GitHub 下载](https://github.com/googlefonts/noto-cjk/releases/latest/download/13_NotoSansMonoCJKsc.zip)
  - 找到 `MonoCJKsc` 下载，见[高校镜像站](https://mirrorz.org/font/GoogleFonts)

- Source Han Serif: 思源宋体

  - [从官方 GitHub 下载](https://github.com/adobe-fonts/source-han-serif/releases/latest/download/01_SourceHanSerif.ttc.zip)
  - 找到 `Serif-VF.ttf` 下载，见[高校镜像站](https://mirrorz.org/font/AdobeSourceHan)

## 开发者工具

- VSCode: 开发神器

  ```powershell
  # 从 Azure 中国服务器快速下载的脚本：
  $req = Invoke-WebRequest -useb "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user" -method head
  if ($null -ne $req.BaseResponse.RequestMessage) {
      $path = $req.BaseResponse.RequestMessage.RequestUri.LocalPath
  } else {
      $path = $req.BaseResponse.ResponseUri.AbsolutePath
  }
  $name = ($path -split '/')[-1]
  Invoke-WebRequest "https://vscode.cdn.azure.cn$path" -o $name
  ```

- VirtualBox: Oracle 公司维护的免费开源虚拟化平台

  从[高校镜像站](https://mirrorz.org/app/VirtualBox)下载

- Git for Windows: 开发必备

  找到 `64-bit, exe` 下载，见[高校镜像站](https://mirrorz.org/app/Git)

- PowerShell Core: PowerShell 最新稳定版

  找到 `win-x64.msi` 下载，见[高校镜像站](https://mirrorz.org/list/PowerShell)

- gVim: 文本编辑器

  按修改时间倒排，找到最新版 `.exe` 下载，见[高校镜像站](https://mirrorz.org/list/vim)

## 其它

- MSYS2: 仿 UNIX 开发和构建环境

  从[高校镜像站](https://mirrorz.org/app/MSYS2)下载

## 仅外网提供

- Everything: 文件搜索器，体验远超系统内置搜索引擎
- Thunderbird: 广受欢迎的 Mozilla 邮件客户端
- 7zip: 压缩软件
- VeraCrypt: 自由的硬盘数据加密器

辅助向：

- Workrave: 长时间工作休息提醒
- Cyberduck: 云端存储浏览器
- AltSnap: 按住修改键配合鼠标，轻松调整窗口

开发向：

- Sysinternals: 系统实用程序
- ImDisk Toolkit: 挂载内存盘、镜像文件
- OpenSSH: 升级组件包
