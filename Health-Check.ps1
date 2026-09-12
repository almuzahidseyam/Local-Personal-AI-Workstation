$ErrorActionPreference = "SilentlyContinue"
function Test-Port([int]$Port) {
    $c = New-Object System.Net.Sockets.TcpClient
    try {
        $iar = $c.BeginConnect("127.0.0.1",$Port,$null,$null)
        if (-not $iar.AsyncWaitHandle.WaitOne(800,$false)) { return $false }
        $c.EndConnect($iar); return $true
    } catch { return $false }
    finally { try{$c.Close()}catch{} }
}
$rows = @()
$rows += [PSCustomObject]@{Item="Ollama API";Status=$(if(Test-Port 11434){"PASS"}else{"FAIL"});Detail="127.0.0.1:11434"}
$rows += [PSCustomObject]@{Item="Open WebUI";Status=$(if(Test-Port 8080){"PASS"}else{"FAIL"});Detail="127.0.0.1:8080"}
$rows += [PSCustomObject]@{Item="Docling CLI";Status=$(if(Test-Path "D:\AI\DoclingServe\.venv\Scripts\docling.exe"){"PASS"}else{"FAIL"});Detail="D:\AI\DoclingServe\.venv\Scripts\docling.exe"}
$rows += [PSCustomObject]@{Item="OCR Router v1.3";Status=$(if(Test-Path "D:\AI\Pipeline\ocr_router_v1_3.py"){"PASS"}else{"FAIL"});Detail="D:\AI\Pipeline\ocr_router_v1_3.py"}
$rows += [PSCustomObject]@{Item="Personal AI Launcher";Status=$(if(Test-Path "D:\AI\PersonalAI\PersonalAI-Start.ps1"){"PASS"}else{"FAIL"});Detail="D:\AI\PersonalAI"}
Write-Host ""
Write-Host "========== PERSONAL AI WORKSTATION HEALTH =========="
$rows | Format-Table -AutoSize
Write-Host ""
Write-Host "Ollama models:"
$ollama = Get-Command ollama.exe -ErrorAction SilentlyContinue
if ($ollama) { & $ollama.Source list } else { Write-Host "ollama.exe not found in PATH" }
Write-Host ""
Write-Host "GPU:"
$nvsmi = Get-Command nvidia-smi.exe -ErrorAction SilentlyContinue
if ($nvsmi) { & $nvsmi.Source --query-gpu=name,memory.total,driver_version --format=csv,noheader }
Write-Host ""
Write-Host "PyTorch/CUDA in Docling venv:"
$py = "D:\AI\DoclingServe\.venv\Scripts\python.exe"
if (Test-Path $py) {
    & $py -c "import torch; print('torch=',torch.__version__); print('cuda_available=',torch.cuda.is_available()); print('cuda_build=',torch.version.cuda); print('gpu=',torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'NONE')"
}
