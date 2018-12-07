$contents = Get-childitem -Include "*.mp3" -name -Exclude "out.mp3" | ForEach-Object -Process { "file '" + $_  + "'`r`n"} ;
New-Item -Path . -Name "mylist.txt" -ItemType "file" -Force
[IO.File]::WriteAllLines(("mylist.txt" | Resolve-Path), $contents)
Invoke-Expression "ffmpeg -f concat -safe 0 -i mylist.txt -c copy out.mp3"
Remove-Item mylist.txt