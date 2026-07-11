param(
    [switch]$Watch
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

function Build-Cv {
    Write-Host "Building CV from arul_rhik_mazumder_cv.tex ..."

    $latexmk = Get-Command latexmk -ErrorAction SilentlyContinue
    $tectonic = Get-Command tectonic -ErrorAction SilentlyContinue

    if ($latexmk) {
        & latexmk -pdf -interaction=nonstopmode -file-line-error arul_rhik_mazumder_cv.tex
        if ($LASTEXITCODE -ne 0) { throw "latexmk failed with exit code $LASTEXITCODE" }
    }
    elseif ($tectonic) {
        & tectonic -X compile arul_rhik_mazumder_cv.tex --outdir .
        if ($LASTEXITCODE -ne 0) { throw "tectonic failed with exit code $LASTEXITCODE" }
    }
    else {
        throw "Install latexmk or tectonic to build the CV."
    }

    if (-not (Test-Path "arul_rhik_mazumder_cv.pdf")) {
        throw "Expected arul_rhik_mazumder_cv.pdf was not produced."
    }

    New-Item -ItemType Directory -Force -Path "cv" | Out-Null
    Copy-Item "arul_rhik_mazumder_cv.pdf" "cv/cv.pdf" -Force

    $built = Get-Date -Format "yyyyMMddHHmmss"
    $info = @{
        built  = $built
        source = "arul_rhik_mazumder_cv.tex"
    } | ConvertTo-Json -Compress

    Set-Content -Path "cv/build-info.json" -Value $info -Encoding utf8
    Write-Host "Wrote cv/cv.pdf and cv/build-info.json (built=$built)"
}

if ($Watch) {
    Write-Host "Watching arul_rhik_mazumder_cv.tex - save the file to rebuild. Ctrl+C to stop."
    Build-Cv

    $texPath = Join-Path $Root "arul_rhik_mazumder_cv.tex"
    $lastWrite = (Get-Item $texPath).LastWriteTimeUtc

    while ($true) {
        Start-Sleep -Milliseconds 500
        $current = (Get-Item $texPath).LastWriteTimeUtc
        if ($current -gt $lastWrite) {
            Start-Sleep -Milliseconds 400
            $lastWrite = (Get-Item $texPath).LastWriteTimeUtc
            try {
                Build-Cv
            }
            catch {
                Write-Host $_.Exception.Message -ForegroundColor Red
            }
        }
    }
}
else {
    Build-Cv
}
