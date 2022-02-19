$dirs = @()
$dirs += ''

$videosByDir = @()
$videos = @()

foreach ($dir in $dirs) {
    Write-Host 'Looking for MP4s in ' -NoNewline
    Write-Host -ForegroundColor Magenta $dir
    $curdirVideos = Get-ChildItem -Path $dir -Name '*.mp4'
    $videosByDir += , $curdirVideos
    foreach ($video in $curdirVideos) {
        $videos += ($dir + $video)
    }
    Write-Host -ForegroundColor Blue ('Found ' + $curdirVideos.Count)
    Write-Host ''
}

function Get-Random-Video {
    param(
        [Int32] $Count,
        [String] $Name
    )

    if ($Count -eq 0) {
        $Count = 1
    }

    if ($Name -eq '') {
        $filteredVideos = $videos
    } else {
        $filteredVideos = @()
        foreach ($video in $videos) {
            if ($video.ToLower().Contains($Name.ToLower())) {
                $filteredVideos += $video
            }
        }
    }

    if ($filteredVideos.Count -eq 0) {
        Write-Host -ForegroundColor Red 'No videos found'
        return
    }

    for ($i = 0; $i -lt $Count; $i++) {
        $video = $filteredVideos | Get-Random
        Write-Host 'Starting ' -NoNewline
        Write-Host -ForegroundColor Blue $video
        Start-Process vlc -RedirectStandardError /dev/null -ArgumentList "`"$video`""
        Start-Sleep -Milliseconds 500
    }
}
