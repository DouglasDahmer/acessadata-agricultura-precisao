# AcessaData AP | Fundação científica | Verificação de cadastro de fontes
# R base, sem dependências externas. Não processa nem certifica dados agrícolas.

colunas_fontes <- function() {
  c("id_fonte", "titulo", "instituicao", "url", "licenca", "data_acesso",
    "arquivo_local", "sha256", "observacoes")
}

resultado_fontes <- function(status, total, mensagens = character()) {
  list(status = status, total = as.integer(total), mensagens = as.character(mensagens))
}

validar_fontes <- function(caminho) {
  if (length(caminho) != 1L || is.na(caminho) || !nzchar(caminho)) {
    return(resultado_fontes("INVALIDO", 0L, "Caminho do manifesto não informado."))
  }
  if (!file.exists(caminho)) {
    return(resultado_fontes("INVALIDO", 0L, "Manifesto de fontes não encontrado."))
  }

  fontes <- tryCatch(
    utils::read.csv(caminho, sep = ";", header = TRUE, stringsAsFactors = FALSE,
                    check.names = FALSE, na.strings = character(),
                    fileEncoding = "UTF-8"),
    error = function(e) e
  )
  if (inherits(fontes, "error")) {
    return(resultado_fontes("INVALIDO", 0L,
                            paste("Falha ao ler manifesto:", conditionMessage(fontes))))
  }
  faltantes <- setdiff(colunas_fontes(), names(fontes))
  if (length(faltantes)) {
    return(resultado_fontes("INVALIDO", nrow(fontes),
                            paste("Colunas ausentes:", paste(faltantes, collapse = ", "))))
  }
  if (nrow(fontes) == 0L) {
    return(resultado_fontes("SEM_FONTES", 0L,
                            "Nenhuma fonte cadastrada; nenhuma análise de campo autorizada."))
  }

  campos <- colunas_fontes()
  for (coluna in campos) {
    fontes[[coluna]] <- trimws(as.character(fontes[[coluna]]))
    fontes[[coluna]][is.na(fontes[[coluna]])] <- ""
  }
  erros <- character()
  requeridos <- c("id_fonte", "titulo", "instituicao", "url", "licenca", "data_acesso")
  for (campo in requeridos) {
    linhas_vazias <- which(!nzchar(fontes[[campo]]))
    if (length(linhas_vazias)) {
      erros <- c(erros, sprintf("'%s' vazio nas linhas de dados: %s",
                               campo, paste(linhas_vazias, collapse = ", ")))
    }
  }
  ids <- fontes$id_fonte[nzchar(fontes$id_fonte)]
  if (anyDuplicated(ids)) {
    erros <- c(erros, "Existem identificadores de fonte duplicados.")
  }
  urls <- fontes$url[nzchar(fontes$url)]
  if (length(urls) && any(!grepl("^https?://[^[:space:]]+$", urls))) {
    erros <- c(erros, "URL inválida (esperado http:// ou https://).")
  }
  datas <- fontes$data_acesso[nzchar(fontes$data_acesso)]
  if (length(datas)) {
    formato <- grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", datas)
    parse <- suppressWarnings(as.Date(datas, format = "%Y-%m-%d"))
    if (any(!formato | is.na(parse))) {
      erros <- c(erros, "data_acesso inválida (esperado AAAA-MM-DD).")
    }
  }
  resumos <- fontes$sha256[nzchar(fontes$sha256)]
  if (length(resumos) && any(!grepl("^[0-9a-fA-F]{64}$", resumos))) {
    erros <- c(erros, "sha256 inválido (esperados 64 caracteres hexadecimais).")
  }
  if (length(erros)) {
    return(resultado_fontes("INVALIDO", nrow(fontes), erros))
  }
  resultado_fontes(
    "CADASTRADO_NAO_VERIFICADO", nrow(fontes),
    "Cadastro estruturalmente consistente; a origem, a licença, o conteúdo e os hashes ainda precisam ser conferidos independentemente."
  )
}
