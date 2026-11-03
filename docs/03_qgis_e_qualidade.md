# Procedimento QGIS — primeira inspeção

**Esta etapa não entrega um arquivo `.qgz`**, pois ainda não há uma área real e um sistema de referência definido.

Quando houver uma fonte espacial autorizada:

1. Criar projeto no QGIS e registrar sua versão.
2. Importar a camada por seu formato real e conferir CRS declarado e efetivo.
3. Checar se coordenadas, extensão espacial e localização são plausíveis.
4. Verificar validade geométrica e feições vazias.
5. Escolher CRS projetado adequado para medir áreas e distâncias. **Não medir área em graus de longitude/latitude.**
6. Conferir unidade, precisão, identificadores e atributos.
7. Registrar os procedimentos e salvar um `.qgz` no diretório `qgis/`, após conferência.

Apenas selecionar um CRS para o projeto QGIS **não** transforma automaticamente os dados de origem. Registrar reprojeções explicitamente.

## Próxima etapa

Somente com talhão real e fontes documentadas será implementado um validador geográfico em R (`sf`) e a conferência cruzada QGIS/R.
