# AcessaData-AP | Ajuste editorial da Etapa 01
# Altera somente README.md, docs/05_referencia.md e reports/01_fundacao.Rmd.
# Faz backup em outputs/ (ignorado pelo Git) e nao altera scripts, testes nem dados.
param(
    [string]$Projeto = 'C:\Users\Admin\OneDrive\Desktop\AcessaData\AcessaData-AP'
)
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)

$relativos = @('README.md', 'docs/05_referencia.md', 'reports/01_fundacao.Rmd')
foreach ($relativo in $relativos) {
    $arquivo = Join-Path $Projeto $relativo
    if (-not (Test-Path -LiteralPath $arquivo -PathType Leaf)) {
        throw "Arquivo exigido nao encontrado: $arquivo"
    }
}

$backup = Join-Path $Projeto ('outputs\backup_documentacao_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
New-Item -ItemType Directory -Path $backup -Force | Out-Null
foreach ($relativo in $relativos) {
    $nomeSeguro = ($relativo -replace '[/\\]', '__')
    Copy-Item -LiteralPath (Join-Path $Projeto $relativo) -Destination (Join-Path $backup $nomeSeguro) -ErrorAction Stop
}

function AtualizarTexto([string]$Relativo, [scriptblock]$Transformacao) {
    $arquivo = Join-Path $Projeto $Relativo
    $antigo = [System.IO.File]::ReadAllText($arquivo)
    $novo = & $Transformacao $antigo
    if ($null -eq $novo) { throw "Transformacao invalida: $Relativo" }
    if ($novo -cne $antigo) {
        [System.IO.File]::WriteAllText($arquivo, [string]$novo, $utf8)
        Write-Host "ATUALIZADO: $Relativo"
    } else {
        Write-Host "SEM ALTERACAO (possivelmente ja ajustado): $Relativo"
    }
}

AtualizarTexto 'reports/01_fundacao.Rmd' {
    param($t)
    $t = $t.Replace('# Referência e limites', '# Referência bibliográfica')
    $t = $t.Replace('Referência inicial: **MOLIN, José Paulo; AMARAL, Lucas Rios do; COLAÇO, André Freitas. Agricultura de Precisão. Oficina de Textos, 2015.**',
                    'MOLIN, José Paulo; AMARAL, Lucas Rios do; COLAÇO, André Freitas. *Agricultura de Precisão*. São Paulo: Oficina de Textos, 2015.')
    $t = $t.Replace(' Neste momento há identificação bibliográfica pela capa fornecida, sem análise dos capítulos ou atribuição de fórmulas específicas à obra.', '')
    return $t
}

AtualizarTexto 'docs/05_referencia.md' {
    param($t)
    $t = $t.Replace('A identificação foi feita a partir da **capa fotografada pelo usuário**. O conteúdo interno não foi fornecido para análise nesta etapa. Não se atribuem conceitos, equações ou sequências de capítulos ao livro sem consulta às páginas correspondentes.',
                    'A obra integra a fundamentação bibliográfica do projeto de Agricultura de Precisão. As análises e os resultados produzidos serão fundamentados nas fontes e nos dados efetivamente utilizados.')
    return $t
}

AtualizarTexto 'README.md' {
    param($t)
    $t = $t.Replace(' O livro orienta o tema do estudo; não atribuímos a ele técnicas, páginas ou resultados que não foram conferidos no exemplar.',
                    ' A obra integra a fundamentação bibliográfica do projeto.')
    $t = $t.Replace("Set-Location 'C:\Users\Admin\Projetos\acessadata-ap-do-zero-v0.1.0'",
                    "Set-Location 'C:\Users\Admin\OneDrive\Desktop\AcessaData\AcessaData-AP'")
    return $t
}

$ocorrencias = @()
foreach ($relativo in $relativos) {
    $arquivo = Join-Path $Projeto $relativo
    $conteudo = [System.IO.File]::ReadAllText($arquivo)
    if ($conteudo -match 'capa fotografada|capa fornecida|conteúdo interno não foi fornecido|não atribuímos a ele') {
        $ocorrencias += $relativo
    }
}
if ($ocorrencias.Count -gt 0) {
    throw "Revisao manual necessaria: texto editorial persiste em $($ocorrencias -join ', ')"
}
Write-Host "AJUSTE CONCLUIDO. Copias anteriores em: $backup"
