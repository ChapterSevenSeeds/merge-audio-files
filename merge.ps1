param(
    [Parameter(Mandatory, HelpMessage = "The directory to find the audio files")]
    [string]$Directory,
    [Parameter(Mandatory, HelpMessage = "The output filename")]
    [string]$Output,
    [Parameter(HelpMessage = "A comma delimited list of audio extensions to include (e.g. mp3,m4a,wav)")]
    [array]$Extensions = ("mp3", "m4a", "wav", "wma"),
    [Parameter(HelpMessage = "A comma delimited list of files to exclude (filenames with spaces must be surrounded in quotes)")]
    [array]$Exclude
)

# Change each extension to have an asterisk and a period before the name
for ($i = 0; $i -lt $Extensions.Length; $i++) { 
    $Extensions[$i] = "*.$($Extensions[$i])"
}
$Extensions = [String]::Join(',', $Extensions)

IF ($Exclude.Length -gt 0) {
    # Wrap each exclusion in double quotes.
    for ($i = 0; $i -lt $Exclude.Length; $i++) { 
        $Exclude[$i] = """$($Exclude[$i])"""
    }
    $Exclude = [String]::Join(',', $Exclude)
}

# Get the files
$getFilesExpression = "Get-ChildItem -File -Recurse -Path ""$($Directory)"" -Include $($Extensions)"
IF ($Exclude.Length -gt 0) {
    $getFilesExpression += " -Exclude $($Exclude)"
}
$getFilesExpression += " | Select FullName"
$files = Invoke-Expression $getFilesExpression

# Make sure we don't exceed the ffmpeg input limit.
IF ($files.Length -gt 1024) {
    Write-Output "The most files that ffmpeg can handle is 1024."
    return
}

$previousDirectory = Get-Location
$tempPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "maft")
IF (!(Test-Path -Path $tempPath)) {
    mkdir $tempPath
}
Set-Location $tempPath
$ffmpegArgs = ""
for ($i = 0; $i -lt $files.Length; $i++) { 
    New-Item -ItemType HardLink -Path "$($i)" -Target "$($files[$i].FullName)"
    $ffmpegArgs = "$($ffmpegArgs) -i $($i)"
}

$ffmpegArgs = $ffmpegArgs + " -filter_complex amix=inputs=$($files.Length):duration=longest ""$([IO.Path]::Combine($previousDirectory, $Output))"""

Start-Process -FilePath "ffmpeg" -Wait -ArgumentList $ffmpegArgs

Get-ChildItem -Path "$($tempPath)" -Recurse | Remove-Item
Set-Location $previousDirectory