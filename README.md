# AcessaData — Agricultura de Precisão

**Versão:** 0.1.0 (fundação do projeto; sem resultados agrícolas)
**Responsável técnico pelo repositório:** Douglas Henrique Silveira Dahmer
**Tecnologias da etapa inicial:** R e QGIS. **Rust:** previsto para uma etapa posterior, mediante necessidade comprovada.

## Objetivo

Construir, de forma incremental, um fluxo **reprodutível** de análise de dados espaciais agrícolas, com rastreabilidade de fontes, controle de qualidade e critérios de publicação explícitos. O estudo parte de dados reais que ainda serão selecionados e autorizados para uso.

**Este repositório não contém medições agrícolas, mapas de produtividade, índices de vegetação, resultados de modelos ou recomendações de adubação.** Nenhuma dessas evidências foi produzida nesta etapa.

## Referência bibliográfica

MOLIN, José Paulo; AMARAL, Lucas Rios do; COLAÇO, André Freitas. *Agricultura de Precisão*. São Paulo: Oficina de Textos, 2015. A obra integra a fundamentação bibliográfica do projeto.

## O que a v0.1.0 entrega

- Estrutura de pastas limpa, independente de qualquer projeto anterior.
- Manifesto de fontes de dados **vazio**, para cadastro de bases reais.
- Validador em **R base** para consistência cadastral das fontes (não confundir com auditoria completa dos dados).
- Testes automatizados sem dependências externas.
- Relatório R Markdown sobre o protocolo e o estado do cadastro.
- Procedimento de trabalho no QGIS e regras de publicação.

## Início rápido (Windows / PowerShell)

Extraia o ZIP e entre na pasta do projeto:

```powershell
Set-Location 'C:\Users\Admin\OneDrive\Desktop\AcessaData\AcessaData-AP'
& 'C:\Program Files\R\R-4.6.1\bin\Rscript.exe' 'tests/test_qualidade_fontes.R'
& 'C:\Program Files\R\R-4.6.1\bin\Rscript.exe' 'R/01_diagnostico.R'
```

Para compilar o relatório, após confirmar `rmarkdown`, `knitr` e Pandoc:

```powershell
& 'C:\Program Files\R\R-4.6.1\bin\Rscript.exe' -e "rmarkdown::render('reports/01_fundacao.Rmd', output_dir='outputs')"
```

Se preferir uma única rotina de teste com evidências na Área de Trabalho:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verificar.ps1
```

`verificar.ps1` executa os testes e o diagnóstico; **não** publica nada no GitHub e **não** instala pacotes. A compilação do relatório é um passo independente.

## Estrutura

```text
R/                  Validação de fontes e diagnóstico
reports/            R Markdown inicial
metadata/           Fontes dos dados (cadastro vazio)
data/raw/           Dados originais: não enviar ao Git sem licença/avaliação
data/processed/     Dados derivados: não versionados nesta fase
qgis/               Instruções para projeto cartográfico
scripts/            Execução local e coleta de evidências
tests/              Testes em R base
docs/               Escopo, qualidade, registro de dados e publicação
outputs/            Resultados locais (ignorados pelo Git)
.github/workflows/  Testes no GitHub Actions
```

## Estados de evidência

- **SEM_FONTES**: cabeçalho do cadastro existe, mas nenhuma fonte foi registrada.
- **INVALIDO**: cadastro inconsistente; interromper publicação de resultados.
- **CADASTRADO_NAO_VERIFICADO**: metadados passaram na checagem estrutural; proveniência, licenças, integridade e conteúdo **continuam sem validação**.

O estado de um cadastro **nunca** equivale à aprovação científica de uma base.

## Política de publicação

Uma versão pública só será marcada como concluída após execução comprovada dos testes e revisão de direitos, dados, documentação e limitações. Consulte `docs/04_publicacao.md`.

## Licenciamento

**Ainda não definido.** Nenhuma licença de código aberto é concedida automaticamente pela publicação no GitHub. Definir a licença deliberadamente antes de disponibilizar o repositório publicamente.
