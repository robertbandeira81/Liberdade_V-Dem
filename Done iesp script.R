# ============================================================
# LIBERDADES NO BRASIL A PARTIR DO V-DEM
# Série 2015-2025
#
# Fonte: V-Dem Dataset v16
# Elaboração: Robert Bandeira (UFPI/Sociometria)
# Para: Done IESP
# ============================================================


# ------------------------------------------------------------
# 1. PACOTES
# ------------------------------------------------------------

# Instalar os pacotes apenas na primeira utilização

if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}

if (!requireNamespace("tidyr", quietly = TRUE)) {
  install.packages("tidyr")
}

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

# O pacote oficial com os dados do V-Dem pode ser instalado
# diretamente do repositório do projeto.

if (!requireNamespace("vdemdata", quietly = TRUE)) {
  
  if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("devtools")
  }
  
  devtools::install_github("vdeminstitute/vdemdata")
}


# Carregar os pacotes

library(vdemdata)
library(dplyr)
library(tidyr)
library(ggplot2)


# ------------------------------------------------------------
# 2. INDICADORES UTILIZADOS
# ------------------------------------------------------------

# Os seis indicadores selecionados representam dimensões
# distintas das liberdades civis e políticas mensuradas
# pelo V-Dem.

variaveis <- c(
  "v2x_civlib",          # Civil liberties index
  "v2x_clphy",           # Physical violence index
  "v2x_clpriv",          # Private civil liberties index
  "v2x_clpol",           # Political civil liberties index
  "v2x_freexp_altinf",   # Freedom of expression and alternative information
  "v2x_frassoc_thick"    # Freedom of association thick index
)


# ------------------------------------------------------------
# 3. CONFERÊNCIA DOS INDICADORES
# ------------------------------------------------------------

# Esta etapa permite verificar diretamente no codebook
# incorporado ao pacote o nome, a definição e a escala
# de cada indicador.

lapply(
  variaveis,
  vdemdata::var_info
)


# ------------------------------------------------------------
# 4. BASE DO BRASIL
# ------------------------------------------------------------

# Selecionar o Brasil e o período 2015-2025.

brasil <- vdemdata::vdem %>%
  filter(
    country_name == "Brazil",
    year >= 2015,
    year <= 2025
  ) %>%
  select(
    country_name,
    year,
    all_of(variaveis)
  )


# Conferência da base

print(brasil)


# ------------------------------------------------------------
# 5. NOMES EM PORTUGUÊS
# ------------------------------------------------------------

rotulos <- c(
  v2x_civlib = "Liberdades civis",
  v2x_clphy = "Integridade física",
  v2x_clpriv = "Liberdades privadas",
  v2x_clpol = "Liberdades políticas",
  v2x_freexp_altinf = "Liberdade de expressão",
  v2x_frassoc_thick = "Liberdade de associação"
)


# ============================================================
# GRÁFICO 1
# TRAJETÓRIA DAS LIBERDADES ENTRE 2015 E 2025
# ============================================================


# ------------------------------------------------------------
# 6. TRANSFORMAR A BASE PARA FORMATO LONGO
# ------------------------------------------------------------

brasil_long <- brasil %>%
  pivot_longer(
    cols = all_of(variaveis),
    names_to = "indicador",
    values_to = "valor"
  ) %>%
  mutate(
    dimensao = recode(
      indicador,
      !!!rotulos
    )
  )


# ------------------------------------------------------------
# 7. ORDEM DOS PAINÉIS
# ------------------------------------------------------------

ordem_dimensoes <- c(
  "Integridade física",
  "Liberdade de associação",
  "Liberdade de expressão",
  "Liberdades civis",
  "Liberdades políticas",
  "Liberdades privadas"
)

brasil_long <- brasil_long %>%
  mutate(
    dimensao = factor(
      dimensao,
      levels = ordem_dimensoes
    )
  )


# ------------------------------------------------------------
# 8. CONSTRUIR O GRÁFICO 1
# ------------------------------------------------------------

grafico1 <- ggplot(
  brasil_long,
  aes(
    x = year,
    y = valor
  )
) +
  
  # Série anual
  geom_line(
    color = "black",
    linewidth = 0.75,
    lineend = "round"
  ) +
  
  # Observações anuais
  geom_point(
    color = "black",
    size = 2.2
  ) +
  
  # Início do governo Bolsonaro
  geom_vline(
    xintercept = 2019,
    linetype = "dashed",
    linewidth = 0.45,
    color = "black"
  ) +
  
  # Início do governo Lula III
  geom_vline(
    xintercept = 2023,
    linetype = "dashed",
    linewidth = 0.45,
    color = "black"
  ) +
  
  # Um pequeno gráfico para cada dimensão
  facet_wrap(
    ~ dimensao,
    ncol = 2
  ) +
  
  # Eixo dos anos
  scale_x_continuous(
    breaks = 2015:2025,
    limits = c(2014.7, 2025.3),
    expand = c(0, 0)
  ) +
  
  # Todos os painéis utilizam a mesma escala
  scale_y_continuous(
    limits = c(0.40, 0.97),
    breaks = seq(
      0.5,
      0.9,
      by = 0.1
    )
  ) +
  
  labs(
    title =
      "Gráfico 1 - Como as liberdades mudaram no Brasil antes, durante e depois de Bolsonaro?",
    
    subtitle =
      "Indicadores do V-Dem, 2015–2025",
    
    x = NULL,
    
    y =
      "Índice V-Dem (0–1)",
    
    caption = paste0(
      "Fonte: V-Dem Dataset v16. Elaboração: Robert Bandeira (UFPI | Sociometria).\n",
      "Nota: as linhas tracejadas indicam o início dos governos Bolsonaro (2019) e Lula III (2023)."
    )
  ) +
  
  theme_minimal(
    base_size = 12
  ) +
  
  theme(
    
    plot.title = element_text(
      size = 18,
      face = "plain",
      hjust = 0,
      margin = margin(b = 6)
    ),
    
    plot.subtitle = element_text(
      size = 12.5,
      hjust = 0,
      margin = margin(b = 12)
    ),
    
    strip.text = element_text(
      size = 11.5,
      face = "plain",
      color = "black"
    ),
    
    strip.background =
      element_blank(),
    
    panel.grid.major.y =
      element_line(
        color = "grey85",
        linewidth = 0.4
      ),
    
    panel.grid.major.x =
      element_line(
        color = "grey90",
        linewidth = 0.35
      ),
    
    panel.grid.minor =
      element_blank(),
    
    axis.text.x = element_text(
      size = 9.5,
      color = "black"
    ),
    
    axis.text.y = element_text(
      size = 9.5,
      color = "black"
    ),
    
    axis.title.y = element_text(
      size = 12,
      color = "black"
    ),
    
    panel.spacing =
      unit(1.15, "lines"),
    
    plot.caption = element_text(
      size = 9.5,
      color = "black",
      hjust = 1,
      lineheight = 1.15,
      margin = margin(t = 9)
    ),
    
    plot.margin = margin(
      t = 10,
      r = 15,
      b = 5,
      l = 10
    )
  )


# Exibir o Gráfico 1

grafico1

# ------------------------------------------------------------
# 9. SALVAR GRÁFICO 1 EM PNG - 300 DPI
# ------------------------------------------------------------

arquivo_grafico1 <- file.path(
  getwd(),
  "grafico_1_liberdades_brasil_vdem_2015_2025.png"
)

ggsave(
  filename = arquivo_grafico1,
  plot = grafico1,
  device = "png",
  width = 13,
  height = 7,
  units = "in",
  dpi = 300,
  bg = "white"
)

# Verificar onde o arquivo foi salvo

arquivo_grafico1

# Confirmar que o arquivo foi criado

file.exists(arquivo_grafico1)

# ============================================================
# GRÁFICO 2
# VARIAÇÃO DAS LIBERDADES NOS DOIS GOVERNOS
# ============================================================


# ------------------------------------------------------------
# 10. CALCULAR A MUDANÇA EM CADA PERÍODO
# ------------------------------------------------------------

dados_grafico2 <- brasil %>%
  
  filter(
    year %in% c(
      2018,
      2022,
      2025
    )
  ) %>%
  
  pivot_longer(
    cols = all_of(variaveis),
    names_to = "indicador",
    values_to = "valor"
  ) %>%
  
  pivot_wider(
    names_from = year,
    values_from = valor,
    names_prefix = "ano_"
  ) %>%
  
  mutate(
    
    # Mudança acumulada durante o período Bolsonaro
    Bolsonaro =
      (ano_2022 - ano_2018) * 100,
    
    # Mudança acumulada durante o período disponível de Lula III
    `Lula III` =
      (ano_2025 - ano_2022) * 100,
    
    dimensao =
      recode(
        indicador,
        !!!rotulos
      )
  ) %>%
  
  select(
    dimensao,
    Bolsonaro,
    `Lula III`
  ) %>%
  
  pivot_longer(
    cols = c(
      Bolsonaro,
      `Lula III`
    ),
    names_to = "governo",
    values_to = "mudanca"
  )

# ------------------------------------------------------------
# 11. RÓTULOS PARA O EIXO X
# ------------------------------------------------------------

rotulos_grafico2 <- c(
  "Integridade física" =
    "Integridade\nfísica",
  
  "Liberdade de expressão" =
    "Liberdade de\nexpressão",
  
  "Liberdades civis" =
    "Liberdades\ncivis",
  
  "Liberdades políticas" =
    "Liberdades\npolíticas",
  
  "Liberdades privadas" =
    "Liberdades\nprivadas",
  
  "Liberdade de associação" =
    "Liberdade de\nassociação"
)


ordem_grafico2 <- c(
  "Integridade física",
  "Liberdade de expressão",
  "Liberdades civis",
  "Liberdades políticas",
  "Liberdades privadas",
  "Liberdade de associação"
)


dados_grafico2 <- dados_grafico2 %>%
  
  mutate(
    
    dimensao = factor(
      dimensao,
      levels = ordem_grafico2
    ),
    
    governo = factor(
      governo,
      levels = c(
        "Bolsonaro",
        "Lula III"
      )
    ),
    
    rotulo =
      sprintf(
        "%+.1f",
        mudanca
      ),
    
    # posição vertical do número
    posicao_rotulo =
      ifelse(
        mudanca >= 0,
        mudanca + 1.2,
        mudanca - 1.2
      ),
    
    # alinhamento do número
    alinhamento_rotulo =
      ifelse(
        mudanca >= 0,
        0,
        1
      )
  )

# ------------------------------------------------------------
# 12. CORES
# ------------------------------------------------------------

cores_governo <- c(
  "Bolsonaro" = "#C95A5A",
  "Lula III" = "#3F73B8"
)


# ------------------------------------------------------------
# 13. CONSTRUIR O GRÁFICO 2
# ------------------------------------------------------------

grafico2 <- ggplot(
  dados_grafico2,
  aes(
    x = dimensao,
    y = mudanca,
    fill = governo
  )
) +
  
  # Linha de referência: ausência de mudança
  geom_hline(
    yintercept = 0,
    color = "grey40",
    linewidth = 0.65
  ) +
  
  # Barras lado a lado
  geom_col(
    position = position_dodge(width = 0.72),
    width = 0.62
  ) +
  
  # Valores das barras
  geom_text(
    aes(
      y = posicao_rotulo,
      label = rotulo,
      vjust = alinhamento_rotulo
    ),
    position = position_dodge(width = 0.72),
    color = "black",
    size = 4,
    fontface = "bold"
  ) +
  
  # Cores e legenda
  scale_fill_manual(
    values = cores_governo,
    labels = c(
      "Bolsonaro" = "Bolsonaro: 2018–2022",
      "Lula III" = "Lula III: 2022–2025"
    ),
    name = NULL
  ) +
  
  # Nomes das dimensões
  scale_x_discrete(
    labels = rotulos_grafico2
  ) +
  
  # Escala do eixo vertical
  scale_y_continuous(
    limits = c(-25, 42),
    breaks = seq(-20, 40, by = 10)
  ) +
  
  # Títulos e notas
  labs(
    title = "Gráfico 2 - Como as liberdades mudaram nos governos Bolsonaro e Lula III",
    subtitle = "Variação acumulada dos indicadores do V-Dem em pontos na escala 0–100",
    x = NULL,
    y = "Mudança no índice",
    caption = paste0(
      "Fonte: V-Dem Dataset v16. Elaboração: Robert Bandeira (UFPI | Sociometria).\n",
      "Nota: Bolsonaro = 2018–2022; Lula III = 2022–2025. Os períodos têm durações distintas.\n",
      "Valores negativos indicam redução da liberdade; valores positivos indicam aumento."
    )
  ) +
  
  # Tema
  theme_minimal(base_size = 13) +
  
  theme(
    plot.title = element_text(
      size = 18,
      face = "plain",
      hjust = 0,
      margin = margin(b = 6)
    ),
    
    plot.subtitle = element_text(
      size = 12.5,
      hjust = 0,
      margin = margin(b = 12)
    ),
    
    panel.grid.minor = element_blank(),
    
    panel.grid.major.x = element_blank(),
    
    panel.grid.major.y = element_line(
      color = "grey88",
      linewidth = 0.4
    ),
    
    axis.text.x = element_text(
      size = 10.5,
      color = "black",
      lineheight = 0.95,
      margin = margin(t = 6)
    ),
    
    axis.text.y = element_text(
      size = 10,
      color = "black"
    ),
    
    axis.title.y = element_text(
      size = 11.5,
      color = "black"
    ),
    
    legend.position = "top",
    
    legend.text = element_text(
      size = 11
    ),
    
    plot.caption = element_text(
      size = 9.5,
      color = "black",
      hjust = 0,
      lineheight = 1.15,
      margin = margin(t = 12)
    ),
    
    plot.margin = margin(
      t = 10,
      r = 20,
      b = 30,
      l = 10
    )
  )

grafico2

# ============================================================
# SALVAR O GRÁFICO EM PNG - 300 DPI
# ============================================================

arquivo_grafico2 <- file.path(
  getwd(),
  "grafico_2_mudanca_liberdades_bolsonaro_lula.png"
)

# Apagar versão anterior, se existir
if (file.exists(arquivo_grafico2)) {
  file.remove(arquivo_grafico2)
}

# Abrir dispositivo PNG
png(
  filename = arquivo_grafico2,
  width = 3900,
  height = 2610,
  res = 300,
  bg = "white"
)

# Imprimir o gráfico no arquivo
print(grafico2)

# Fechar o dispositivo
dev.off()

# Conferir criação
file.exists(arquivo_grafico2)

# Conferir tamanho e data de criação
file.info(arquivo_grafico2)[, c("size", "mtime")]

# Mostrar caminho completo
arquivo_grafico2
