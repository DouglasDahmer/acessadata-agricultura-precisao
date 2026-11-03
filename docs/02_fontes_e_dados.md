# Fontes e rastreabilidade

O arquivo `metadata/fontes.csv` **começa vazio** por decisão metodológica. Uma linha deve corresponder a uma fonte identificada, nunca a uma medição individual.

## Campos

- `id_fonte`: identificador estável e único.
- `titulo`: nome oficial do conjunto.
- `instituicao`: instituição responsável.
- `url`: endereço público de documentação/origem.
- `licenca`: termos aplicáveis ao uso, redistribuição e publicação.
- `data_acesso`: data no formato `AAAA-MM-DD`.
- `arquivo_local`: nome/caminho do arquivo baixado, quando disponível.
- `sha256`: resumo SHA-256 do arquivo, quando calculado.
- `observacoes`: cobertura, limitações e versão.

## Atenção

A validação em R confere apenas estrutura, preenchimento, formatos e duplicações. **Ela não verifica se a URL existe, se a licença autoriza redistribuição, se o hash bate com os bytes ou se os dados são cientificamente adequados.**

Para calcular SHA-256 de um arquivo real no Windows:

```powershell
Get-FileHash -Algorithm SHA256 'CAMINHO_DO_ARQUIVO'
```

Após obter dados, preservar uma cópia original imutável, registrar proveniência e não adicionar dados sigilosos ou restritos ao Git.
