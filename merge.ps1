Get-ChildItem -Path '.\Dream Theater\' -Recurse | Where { $_.PSIsFile} | Select FullName

ffmpeg -i "03 Constant Motion.m4a" -i "04 The Dark Eternal Night.m4a" -i "02 This Dying Soul.mp3" -filter_complex amix=inputs=3:duration=longest output.mp3