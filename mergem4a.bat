(for %%i in (*.m4a) do @echo file '%%i') > mylist.txt
ffmpeg -f concat -safe 0 -i mylist.txt -c copy out.m4a
del mylist.txt