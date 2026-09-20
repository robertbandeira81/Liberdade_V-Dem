# Liberdade_V-Dem
“Resgatar a Liberdade”: o que concretamente Bolsonaro entregou?

Este repositório disponibiliza o código utilizado na análise **“‘Resgatar a Liberdade’: o que concretamente Bolsonaro entregou?”**, elaborada por **Robert Bandeira (UFPI/Sociometria)** para o **De Olho nas Eleições 2026, do DONE/IESP**.

O objetivo é permitir a reprodução das análises e dos gráficos produzidos a partir dos indicadores do **Varieties of Democracy (V-Dem)**.

## Sobre a análise

A análise acompanha a trajetória de diferentes dimensões das liberdades civis e políticas no Brasil e compara as mudanças registradas nos períodos correspondentes ao governo Bolsonaro e ao período disponível do governo Lula III.

Em vez de observar apenas um indicador agregado, foram selecionadas seis dimensões do V-Dem:

| Indicador V-Dem     | Dimensão utilizada na análise |
| ------------------- | ----------------------------- |
| `v2x_civlib`        | Liberdades civis              |
| `v2x_clphy`         | Integridade física            |
| `v2x_clpriv`        | Liberdades privadas           |
| `v2x_clpol`         | Liberdades políticas          |
| `v2x_freexp_altinf` | Liberdade de expressão        |
| `v2x_frassoc_thick` | Liberdade de associação       |

## Fonte dos dados

Os dados são provenientes do:

**V-Dem Dataset v16 – Varieties of Democracy**

A base é acessada diretamente no R por meio do pacote `vdemdata`.

O script seleciona os dados referentes ao **Brasil** para o período de **2015 a 2025**.

## Estrutura da análise

O código executa as seguintes etapas:

1. instalação e carregamento dos pacotes necessários;
2. definição dos seis indicadores selecionados;
3. conferência das definições e escalas dos indicadores a partir do codebook incorporado ao `vdemdata`;
4. seleção dos dados brasileiros entre 2015 e 2025;
5. organização e transformação da base;
6. construção do Gráfico 1;
7. cálculo das mudanças entre os períodos selecionados;
8. construção do Gráfico 2;
9. exportação dos gráficos em formato PNG com resolução de 300 dpi.

## Gráfico 1

### Como as liberdades mudaram no Brasil antes, durante e depois de Bolsonaro?

O primeiro gráfico apresenta a trajetória anual das seis dimensões entre **2015 e 2025**.

As linhas verticais tracejadas identificam:

* **2019**, início do governo Bolsonaro;
* **2023**, início do governo Lula III.

As dimensões são apresentadas separadamente para evitar que diferenças de trajetória fiquem escondidas em um único indicador agregado.

Arquivo produzido pelo script:

`grafico_1_liberdades_brasil_vdem_2015_2025.png`

## Gráfico 2

### Como as liberdades mudaram nos governos Bolsonaro e Lula III?

O segundo gráfico compara a mudança acumulada nos seis indicadores em dois períodos:

* **Bolsonaro: 2018–2022**
* **Lula III: 2022–2025**

A mudança é calculada pela diferença entre o valor observado ao final e no início de cada período:

```text
Bolsonaro = indicador em 2022 − indicador em 2018

Lula III = indicador em 2025 − indicador em 2022
```

Para facilitar a leitura, as diferenças são multiplicadas por 100 e apresentadas como pontos em uma escala de 0 a 100.

Valores negativos representam redução no indicador e valores positivos representam aumento.

É importante observar que os dois intervalos possuem durações diferentes. A comparação apresentada é, portanto, **descritiva** e não deve ser interpretada como uma estimativa causal do efeito de cada governo.

Arquivo produzido pelo script:

`grafico_2_mudanca_liberdades_bolsonaro_lula.png`

## Arquivos do repositório

```text
.
├── Done iesp script.R
└── README.md
```

O arquivo principal da análise é:

`Done iesp script.R`

O arquivo:

`Done IESP.Rproj`

permite abrir o projeto diretamente no RStudio.

## Pacotes necessários

O código utiliza os seguintes pacotes:

```r
library(vdemdata)
library(dplyr)
library(tidyr)
library(ggplot2)
```

Caso o pacote `vdemdata` ainda não esteja instalado, o próprio script realiza sua instalação a partir do repositório oficial do V-Dem no GitHub:

```r
devtools::install_github("vdeminstitute/vdemdata")
```

## Como reproduzir a análise

### 1. Baixe ou clone este repositório

No GitHub, utilize **Code → Download ZIP** ou clone o repositório utilizando Git.

### 2. Abra o projeto no RStudio

Abra o arquivo:

```text
Done IESP.Rproj
```

### 3. Execute o script

Abra:

```text
Done iesp script.R
```

e execute o código desde o início.

Na primeira execução, o R poderá instalar os pacotes ainda ausentes.

### 4. Confira os resultados

O script:

* acessa a base do V-Dem;
* seleciona os dados do Brasil;
* organiza os indicadores;
* calcula as mudanças utilizadas na comparação;
* produz os dois gráficos;
* salva os gráficos em PNG na pasta de trabalho do projeto.

## Reprodutibilidade

O repositório foi organizado com o objetivo de permitir que os resultados apresentados no texto possam ser conferidos e reproduzidos.

O código também utiliza a função:

```r
vdemdata::var_info()
```

para consultar diretamente no codebook do V-Dem as definições dos indicadores empregados na análise.

Isso permite verificar as variáveis utilizadas antes da realização dos cálculos e da construção dos gráficos.

## Nota metodológica

Os indicadores utilizados são produzidos pelo projeto **Varieties of Democracy (V-Dem)** e devem ser interpretados de acordo com sua metodologia de mensuração.

A comparação realizada neste repositório descreve as mudanças observadas nos indicadores ao longo dos períodos selecionados. Por se tratar de uma comparação temporal descritiva, os resultados não constituem, isoladamente, uma identificação causal dos efeitos dos governos analisados.

## Autor

**Robert Bandeira**
Professor da Universidade Federal do Piauí – UFPI
Sociometria – Núcleo de Pesquisa e Extensão em Métodos Quantitativos em Ciências Sociais

## Fonte

**Varieties of Democracy (V-Dem).**
V-Dem Dataset v16.
V-Dem Institute.
