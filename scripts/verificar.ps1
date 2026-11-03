# Coleta evidencia local na Area de Trabalho, sem alterar o GitHub.
param([string]$Rscript = "C:\Program Files\R\R-4.6.1\bin\Rscript.exe")
$ErrorActionPreference = "Stop"
$raiz = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
if (-not (Test-Path -LiteralPath $Rscript)) {
    throw "Rscript não encontrado: $Rscript"
}
$pasta = Join-Path ([Environment]::GetFolderPath("Desktop")) "AcessaData-AP-Evidencias"
New-Item -ItemType Directory -Force -Path $pasta | Out-Null
$log = Join-Path $pasta "etapa01_validacao.log"
Push-Location $raiz
try {
    "ACESSADATA AP - ETAPA 01 - $(Get-Date -Format s)" | Set-Content -Encoding UTF8 $log
    "=== TESTES ===" | Add-Content -Encoding UTF8 $log
    $saidaTestes = & $Rscript "tests/test_qualidade_fontes.R" 2>&1
    $codigoTestes = $LASTEXITCODE
    $saidaTestes | Out-Host
    $saidaTestes | Out-File -FilePath $log -Encoding UTF8 -Append
    if ($codigoTestes -ne 0) { throw "Testes falharam (exit code $codigoTestes). Consulte $log" }
    "=== DIAGNOSTICO ===" | Add-Content -Encoding UTF8 $log
    $saidaDiagnostico = & $Rscript "R/01_diagnostico.R" 2>&1
    $codigoDiagnostico = $LASTEXITCODE
    $saidaDiagnostico | Out-Host
    $saidaDiagnostico | Out-File -FilePath $log -Encoding UTF8 -Append
    if ($codigoDiagnostico -ne 0) { throw "Diagnostico falhou (exit code $codigoDiagnostico). Consulte $log" }
    Write-Host "Testes e diagnostico executados. Evidencia: $log"
    Write-Host "A renderizacao do R Markdown deve ser feita separadamente."
}
finally { Pop-Location }
