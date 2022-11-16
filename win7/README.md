# Support for old Windows 7

Add requirement:

- .NET Framework >= 4.5
- PowerShell 5

Download:

- [.NET Framework 4.5.2](https://www.microsoft.com/en-us/download/confirmation.aspx?id=42642), sha256 of `Get-FileHash`:

       6C2C589132E830A185C5F40F82042BEE3022E721A216680BD9B3995BA86F3781

- [Windows Management Framework 5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)

  1.  Select `Win7AndW2K8R2-KB3191566-x64.zip`
  2.  Extract the Archive
  3.  sha256 of `Get-FileHash`:

          F383C34AA65332662A17D95409A2DDEDADCEDA74427E35D05024CD0A6A2FA647

Put files into this folder.

Run `apply.cmd` in the target machine.
