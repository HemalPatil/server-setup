$dirs = @()
$dirs += ''

$picsByDir = @()
$pics = @()

foreach ($dir in $dirs) {
    Write-Host 'Looking for JPGs in ' -NoNewline
    Write-Host -ForegroundColor Magenta $dir
    $curdirPics = Get-ChildItem -Path $dir -Recurse -Name '*.jpg'
    $picsByDir += , $curdirPics
    foreach ($pic in $curdirPics) {
        $pics += ($dir + $pic)
    }
    Write-Host -ForegroundColor Blue ('Found ' + $curdirPics.Count)
    Write-Host ''
}

function Get-Random-Pic {
    param(
        [Int32] $Count,
        [String] $Name
    )

    if ($Count -eq 0) {
        $Count = 1
    }

    if ($Name -eq '') {
        $filteredPics = $pics
    } else {
        $filteredPics = @()
        foreach ($pic in $pics) {
            if ($pic.ToLower().Contains($Name.ToLower())) {
                $filteredPics += $pic
            }
        }
    }

    if ($filteredPics.Count -eq 0) {
        Write-Host -ForegroundColor Red 'No pictures found'
        return
    }

    for ($i = 0; $i -lt $Count; $i++) {
        $pic = $filteredPics | Get-Random
        Write-Host 'Starting ' -NoNewline
        Write-Host -ForegroundColor Blue $pic
        Start-Process eog -ArgumentList "`"$pic`""
        Start-Sleep -Milliseconds 750
    }
}
