# Critérios para GitHub e versões

O objetivo é construir um portfólio por entregas pequenas, reais e verificáveis. Não marcar uma etapa como concluída só por existir código.

## Antes de tornar público

- [ ] Rodar `tests/test_qualidade_fontes.R` e guardar o log.
- [ ] Rodar `R/01_diagnostico.R` e guardar o log.
- [ ] Gerar `outputs/01_fundacao.html` com o relatório.
- [ ] Conferir ausência de dados pessoais, senhas, arquivos privados e dados com licenças restritivas.
- [ ] Escolher explicitamente a licença do código.
- [ ] Revisar `README.md`, limites e estado do projeto.
- [ ] Criar commit e tag somente após aprovação.

## Publicação manual após os testes

```powershell
git init
git branch -M main
git add .
git commit -m "chore: inicia projeto AcessaData AP do zero"
# Criar um repositório vazio no GitHub, então configurar o URL abaixo.
git remote add origin https://github.com/SEU_USUARIO/acessadata-agricultura-precisao.git
git push -u origin main
git tag -a v0.1.0 -m "Fundacao cientifica e testes aprovados"
git push origin v0.1.0
```

Os comandos acima são exemplos; substitua o endereço e confirme o resultado de cada etapa. **Não foram executados.**

## Releases posteriores

Cada versão acrescentará uma funcionalidade demonstrável com teste e evidência científica; não há compromisso de publicar resultados em uma data fixa.
