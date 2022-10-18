$path = "$(
[Environment]::GetFolderPath('Desktop')
)\$(
Get-Translation 'README.txt' -cn '注意事项.txt'
)"

Copy-Item (Get-Translation 'README.md' -cn 'README-CN.md') $path
Copy-Item $path 'C:\Users\Default\Desktop'
