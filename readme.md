# Merge Audio Files
## By Tyson Jones
#### Merges up to 1024 audio files in any subdirectories into one file in which all are played simultaneously.

## Usage
`merge.ps1 [-Directory] <string> [-Output] <string> [[-Extensions] <array>] [[-Exclude] <array>]`

- `-Directory` specifies the directory to search in for audio files.
- `-Output` specifies the output filename with extension (and path if you don't want to put it in the directory where you run the script).
- `-Extensions` is a comma delimited list of extensions you want to include in the search (not wrapped in double quotes and without a leading period). This defaults to `mp3,wav,m4a`.
- `-Exclude` is a comma delimited list of filenames you want to exclude in the search (each file name wrapped in double quotes). 

## Examples
- `./merge.ps1 -Directory "C:\Users\Tyson\Music\iTunes\iTunes Media\Music\Douglas Holmquist\Smash Hit OST" -Output asdf.mp3 -Exclude "17 Part 10 for 10 hours.mp3","15 All parts mixed.mp3"`
- `./merge.ps1 -Directory "C:\Users\Tyson\Music\iTunes\iTunes Media\Music\Plague Inc. OST" -Output "Plague Inc. OST.mp3"`

## Notes
You must have `ffmpeg` installed and accessible via command line in order for this script to work.