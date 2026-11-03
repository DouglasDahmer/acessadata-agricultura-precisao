# Testes em R base. Usam somente registros temporários artificiais para
# testar o software; NÃO representam observações agrícolas.
source(file.path("R", "qualidade_fontes.R"), encoding = "UTF-8")

n <- 0L
conferir <- function(condicao, descricao) {
  if (!isTRUE(condicao)) stop(paste("FALHOU:", descricao), call. = FALSE)
  n <<- n + 1L
  cat(sprintf("OK %02d | %s\n", n, descricao))
}

tmp <- tempfile(fileext = ".csv")
criar <- function(tabela) {
  utils::write.table(tabela, file = tmp, sep = ";", row.names = FALSE,
                     col.names = TRUE, quote = TRUE, fileEncoding = "UTF-8")
}
base <- as.data.frame(setNames(replicate(length(colunas_fontes()), "", simplify = FALSE),
                               colunas_fontes()), stringsAsFactors = FALSE)
base$id_fonte <- "fonte_teste"
base$titulo <- "Fonte de teste"
base$instituicao <- "Instituicao de teste"
base$url <- "https://example.org/dados"
base$licenca <- "Teste interno"
base$data_acesso <- "2026-11-02"

conferir(identical(validar_fontes("arquivo_ausente_que_nao_existe.csv")$status,
                  "INVALIDO"), "Arquivo ausente rejeitado")
criar(base[0, ])
conferir(identical(validar_fontes(tmp)$status, "SEM_FONTES"),
        "Cadastro vazio identificado sem simular dados")
criar(base[, -1, drop = FALSE])
conferir(identical(validar_fontes(tmp)$status, "INVALIDO"),
        "Coluna obrigatoria ausente rejeitada")
criar(base)
conferir(identical(validar_fontes(tmp)$status, "CADASTRADO_NAO_VERIFICADO"),
        "Cadastro consistente nao recebe aprovacao cientifica")
criar(rbind(base, base))
conferir(identical(validar_fontes(tmp)$status, "INVALIDO"),
        "IDs duplicados rejeitados")
ruim <- base; ruim$url <- "servidor-local"
criar(ruim)
conferir(identical(validar_fontes(tmp)$status, "INVALIDO"),
        "URL malformada rejeitada")
ruim <- base; ruim$data_acesso <- "02/11/2026"
criar(ruim)
conferir(identical(validar_fontes(tmp)$status, "INVALIDO"),
        "Data fora do padrao rejeitada")
ruim <- base; ruim$data_acesso <- "2026-99-99"
criar(ruim)
conferir(identical(validar_fontes(tmp)$status, "INVALIDO"),
        "Data inexistente rejeitada")
ruim <- base; ruim$sha256 <- "123"
criar(ruim)
conferir(identical(validar_fontes(tmp)$status, "INVALIDO"),
        "SHA-256 fora do formato rejeitado")
ruim <- base; ruim$sha256 <- paste(rep("a", 64), collapse = "")
criar(ruim)
conferir(identical(validar_fontes(tmp)$status, "CADASTRADO_NAO_VERIFICADO"),
        "SHA-256 formatado nao implica integridade verificada")
ruim <- base; ruim$instituicao <- " "
criar(ruim)
conferir(identical(validar_fontes(tmp)$status, "INVALIDO"),
        "Campo essencial em branco rejeitado")
unlink(tmp)
cat(sprintf("TOTAL: %d testes aprovados.\n", n))
