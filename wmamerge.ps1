$contents = Get-childitem -Include "*.wma" -name -Exclude "out.mp3" | ForEach-Object -Process { "file '" + $_  + "'`r`n"} ;
New-Item -Path . -Name "mylist.txt" -ItemType "file" -Force
[IO.File]::WriteAllLines(("mylist.txt" | Resolve-Path), $contents)
Invoke-Expression "ffmpeg -f concat -safe 0 -i mylist.txt -c copy out.wma"
Remove-Item mylist.txt