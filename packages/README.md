# Packages Folder

## Instruction

Translation: [中文](./README_ZH.md)

Download all content into `.\packages`, the setup framework will automatically install them.

- The packages with the mark asterisk \*,
  is required with 7zip to read gzip, xz compression format.

  <details><summary>Please get <code>7z.exe</code> commandline binary into this folder ……</summary><br/>

  1.  [Get installer](https://www.7-zip.org/a/7z2201.exe)
  2.  Install
  3.  Copy to this directory:

          cp "C:\Program Files*\7-Zip*\7z.exe" .

  <br/></details>

- If using Windows 7 or Server 2008R2 old system:

  <details><summary>please install the upgarde package or patches ……</summary><br/>

  - [.NET Framework 4.5.2](https://www.microsoft.com/en-us/download/confirmation.aspx?id=42642) or higher version, Verify by PowerShell:

        (Get-FileHash -Algorithm SHA256 'NDP452-KB2901907-x86-x64-AllOS-ENU.exe').Hash -eq '6C2C589132E830A185C5F40F82042BEE3022E721A216680BD9B3995BA86F3781'

  - [Windows Management Framework 5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)

    1.  Select `Win7AndW2K8R2-KB3191566-x64.zip` to download
    2.  Verify by PowerShell:

            (Get-FileHash -Algorithm SHA256 'Win7AndW2K8R2-KB3191566-x64.zip').Hash -eq 'F383C34AA65332662A17D95409A2DDEDADCEDA74427E35D05024CD0A6A2FA647'

    3.  Extract the archive

  </details><br/>

## Get Your Packages

### Recommendation

- Firefox: privacy-first browser

  [Download Installer directly](https://download.mozilla.org/?product=firefox-latest-ssl&os=win64)

- Thunderbird: Mozilla free email client

  [Official Download Page](https://www.thunderbird.net/)

- Everything: file searcher, experience far beyond the system built-in search engine

  Find `Download Lite Installer 64-bit` at [Official Download Page](https://www.voidtools.com)

- mcmilk's improved 7zip: compressor

  Find `.exe` at [Official GitHub Release](https://github.com/mcmilk/7-Zip-zstd/releases/latest)

### Helper

- VeraCrypt: free hard disk data encryptor

  Find `MSI Installer` at [Official Download Page](https://www.veracrypt.fr/en/Downloads.html)

- Workrave: rest reminder

  [Official GitHub Release](https://github.com/rcaelers/workrave/releases/latest)

- KDE Connect: with your phone

  Find `Offline installers` at [Official Download Page](https://kdeconnect.kde.org/download.html)

- OBS: free live recorder

  [Official Download Page](https://obsproject.com/)

- qBittorrent: free BitTorrent client

  Find `x64` at [FOSSHUB Release](https://www.fosshub.com/qBittorrent.html)

- Cyberduck: cloud storage explorer

  [Official Download Page](https://cyberduck.io/download/)

### For Developers

- VSCode

  Download Installer directly:
  [x64](https://code.visualstudio.com/sha/download?build=stable&os=win32-x64)
  |
  [Arm64](https://code.visualstudio.com/sha/download?build=stable&os=win32-arm64)
  |
  [x86](https://code.visualstudio.com/sha/download?build=stable&os=win32)

  <details> <summary>Support Latest Windows 7 Version: <b>1.70.3</b></summary>

  Download Installer directly:
  [x64](https://update.code.visualstudio.com/1.70.2/win32-x64/stable)
  |
  [Arm64](https://update.code.visualstudio.com/1.70.2/win32-arm64-user/stable)

  </details><br/>

- PowerShell Core: better than classic PowerShell

  Find `win-x64.msi` at [Official GitHub Release](https://aka.ms/powershell-release?tag=stable)

- [Tabby](https://tabby.sh/): most popular social terminal emulator

  [Official GitHub Releases](https://github.com/Eugeny/tabby/releases/latest)

- Sysinternals: advanced system utilities and technical information

  [Download Content directly](https://download.sysinternals.com/files/SysinternalsSuite.zip)

- Git for Windows

  [Official Download Page](https://gitforwindows.org/)

- gVim: text editor Vim with GUI

  Click "Last modified" and find the latest `.exe` at [Official Download Page](https://ftp.nluug.nl/pub/vim/pc/)

- Chocolatey: Packages Manager

  [Download Installer directly](https://community.chocolatey.org/api/v2/package/chocolatey)

- gsudo: acquire administration privilege

  [Get from GitHub Release](https://github.com/gerardog/gsudo/releases/latest/download/gsudoSetup.msi)

- ImDisk Toolkit: ramdisk for Windows and mounting of image files

  [Official Download Page](https://sourceforge.net/projects/imdisk-toolkit/files/latest/download)

- ADB: Android SDK Platform-Tools

  [Download Content directly](https://dl.google.com/android/repository/platform-tools-latest-windows.zip)

- VirtualBox: free open source virtualization platform by Oracle

  Find `Windows hosts` at [Official Download Page](https://www.virtualbox.org/wiki/Downloads#VirtualBoxbinaries)

<details><summary>Optional ...</summary><br/>

- OpenSSH: fix the bug of internal version of SSH

      chan_shutdown_read: shutdown() failed for fd 7 [i0 o0]: Not a socket

  find `OpenSSH-Win64-v` at [Official GitHub Releases](https://github.com/PowerShell/Win32-OpenSSH/releases/latest)

</details><br/>

### Portable Applications

You can get [Firefox ESR](https://portableapps.com/apps/internet/firefox-portable-esr),
unpack it into current repository

### Miscellaneous

Manuall Installers, put them into `.\manual`

- Brave: Free Chromium Distribution

  [Get Online Installer](https://laptop-updates.brave.com/latest/winx64)

- Microsoft Office

  [Get Online Installer](https://setup.office.com/)

<details><summary>Hardware Drivers ...</summary><br/>

- Logi Options+

  [Get Online Installer](https://www.logitech.com/software/logi-options-plus.html)

</details><br/>

## Signature Verification

Excecute `_verify.cmd`
