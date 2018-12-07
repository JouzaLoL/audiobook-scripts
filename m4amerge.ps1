$contents = Get-childitem -Include "*.m4a" -path "." -name -Exclude "out.mp3" | ForEach-Object -Process { "file '" + $_  + "'`r`n"} ;
[System.IO.File]::WriteAllLines("mylist.txt", "$contents")
Invoke-Expression "ffmpeg -f concat -safe 0 -i mylist.txt -c copy out.mp3"
Remove-Item mylist.txt