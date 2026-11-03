# Executar a partir da raiz do projeto: Rscript R/01_diagnostico.R
raiz <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
fonte_codigo <- file.path(raiz, "R", "qualidade_fontes.R")
if (!file.exists(fonte_codigo)) {
  stop("Execute o diagnóstico na raiz do repositório.", call. = FALSE)
}
source(fonte_codigo, encoding = "UTF-8")
cat("ACESSADATA AP | DIAGNOSTICO DA ETAPA 01\n")
cat("Diretorio: ", raiz, "\n", sep = "")
cat("R: ", as.character(getRversion()), "\n", sep = "")
cat("Pacote rmarkdown: ", requireNamespace("rmarkdown", quietly = TRUE), "\n", sep = "")
cat("Pacote knitr: ", requireNamespace("knitr", quietly = TRUE), "\n", sep = "")
cat("Pacote sf: ", requireNamespace("sf", quietly = TRUE), "\n", sep = "")
cat("Pacote terra: ", requireNamespace("terra", quietly = TRUE), "\n", sep = "")
cat("RMarkdown/Pandoc: ",
    if (requireNamespace("rmarkdown", quietly = TRUE)) rmarkdown::pandoc_available() else FALSE,
    "\n", sep = "")
resultado <- validar_fontes(file.path(raiz, "metadata", "fontes.csv"))
cat("Estado do cadastro: ", resultado$status, "\n", sep = "")
cat("Total de fontes: ", resultado$total, "\n", sep = "")
for (mensagem in resultado$mensagens) cat("- ", mensagem, "\n", sep = "")
if (identical(resultado$status, "INVALIDO")) quit(save = "no", status = 1L)
