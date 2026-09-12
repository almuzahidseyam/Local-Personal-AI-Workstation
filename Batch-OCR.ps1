param(
    [string]$InputFolder = "D:\AI\Pipeline\Input",
    [ValidateSet("quality","fast")]
    [string]$Mode = "quality",
    [switch]$Execute
)
$ErrorActionPreference = "Stop"
$RouterWrapper = "D:\AI\Pipeline\Run-OCRRouter-v1.3.ps1"
$LogDir = "D:\AI\Pipeline\Logs\Batch"
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
if (-not (Test-Path $InputFolder)) { Write-Host "Input folder not found: $InputFolder" -ForegroundColor Red; exit 2 }
if (-not (Test-Path $RouterWrapper)) { Write-Host "Router wrapper not found: $RouterWrapper" -ForegroundColor Red; exit 2 }
$files = Get-ChildItem $InputFolder -Recurse -File -Filter *.pdf | Sort-Object FullName
Write-Host "PDFs found: $($files.Count)"
Write-Host "Mode: $Mode"
if (-not $Execute) {
    Write-Host "DRY RUN ONLY. Re-run with -Execute." -ForegroundColor Yellow
    $files | Select-Object FullName,Length,LastWriteTime | Format-Table -AutoSize
    exit 0
}
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$summary = Join-Path $LogDir "batch_$stamp.csv"
$rows = @()
foreach ($f in $files) {
    Write-Host "============================================================"
    Write-Host $f.FullName -ForegroundColor Cyan
    $started = Get-Date
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $RouterWrapper -Pdf $f.FullName -Mode $Mode
    $rows += [PSCustomObject]@{
        File=$f.FullName; Mode=$Mode; ExitCode=$LASTEXITCODE;
        Seconds=[math]::Round(((Get-Date)-$started).TotalSeconds,1)
    }
}
$rows | Export-Csv $summary -NoTypeInformation -Encoding UTF8
Write-Host "Batch summary: $summary" -ForegroundColor Green
