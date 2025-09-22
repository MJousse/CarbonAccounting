# Carbon Accounting in Embera communities of the Bayano lake area, Panama 
Maximiliane Jousse (1), Madelaine Chongo, Grady Zappone (1), Jorge Valdes(2), & Catherine Potvin (1, 2).

2023

Affiliations:
1) Department of Biology, McGill University, Montreal, QC, Canada
2) Smithsonian Tropical Research Institute, Panama City, Panama

## Background 
Tropical forests store about one quarter of all terrestrial carbon and have
the potential for re-creating carbon sinks through reforestation. The [Bayano-McGill Reforestation Project](https://www.mcgill.ca/sustainability/commitments/carbon-neutrality/mcgill-bayano-reforestation), established in 2020, aims to offset part of the university’s carbon emissions through planting and maintaining reforested plots in two Embera communities: Piriati and Ipeti. 

Indigenous communities are stewards, owners or have legally designated rights to about a quarter of the world’s global forest estate, more than a third of intact forest landscapes, and almost a fifth of forest carbon stocks. This project slots itself into a framework that aims to foster community engagement and individual scientific and environmental interest within the Embera communities of Lake Bayano Area. This framework consits of a series of teaching workshops focused on technological advances, and of independent action. Previous workshops included a Computer Literacy Workshop (2019), an Introduction to Computers and EXCEL Workshop (2022), and a What is Carbon? Workshop (2022). Independent action, supported by the Bayano-McGill Reforestation Project, include planting the reforestation plots, and following this project the continual monitoring of carbon stocks in reforested plots.

This project thus came together to create a sustainable and accessible way for participants of the project to monitor their reforested plots independently. A carbon calculator was created, and a 3-day workshop led to the creation of a protocol and documentation to be followed.

### Aims
This project's aims were as follow:
1. Produce a carbon calculator that is easy to use for a wide audience
2. Introduce the concept of carbon monitoring, and the role of carbon and carbon dioxide in climate change
3. Introduce tools and methods to measure carbon stocks, including hand-held LiDAR devices
4. Elaborate a protocol with the workshop participants such that locals can monitor carbon stocks in teforested plots using the tools at their disposal and independently of a third party.

## The Calculator
The carbon calculator is an **excel spreadsheet** with built-in calculations which approximates tree height, above ground biomass, and carbon concentration for each tree input. It then aggregates data per plot and produces an estimation of carbon concentration at the plot level, where plot is a designated number of trees. The carbon calculator (deployed version) can be found in `Carbon Accounting Workshop/Calculadora de Carbono_VersionLibreOfficeFINAL.xlsx`. 

### Methods
Method development can be seen in `CarbonCalculator/Calculator Development`. Taxonomic identification was corroborated by Jorge Valdes. The current version of the calculator calculates different estimates of carbon depending on tree species (see `TreeIdentification\Tree_Identification_Guide_es.md` for species).

#### Data collection
*El protocolo se puede encontrar en español por `Carbon Accounting Workshop/WorkshopMaterial_Es.pdf`.*

#### CALCULATOR: Carbon Stocks for one tree
*Esa información se puede encontrar en español en la calculadora por la hoja Metadata y por `Carbon Accounting Workshop/WorkshopMaterial_Es.pdf`*.

1. `Estimación de altura vertex` (A; Tree height; m) is estimated from the input `DAP` (D; DBH; cm) and `Especie` (Species; for *Roble*, *Espave*, *Cedro Amargo*) using the following equations.
   
   $$𝐴=\frac{e^{5.40175}\times 𝐷^{0.646171}}{100}$$
   
   $$𝐴_{𝑅𝑜𝑏𝑙𝑒}= \frac{e^{5.5399}\times 𝐷^{0.5626}}{100}$$
   
   $$𝐴_{Espave}= \frac{e^{5.4539}\times 𝐷^{0.6144}}{100}$$
   
   $$𝐴_{Espave}= \frac{e^{5.1273}\times 𝐷^{0.8046}}{100}$$
3. `Biomasa` (Tree Biomass; B; Kg) is then estimated from `densidad` (density; ρ; g cm-3; Chave et al. 2009), `DAP` (D; DBH; cm) and `Estimación de altura vertex` (A; Tree height; m) using the following equation (Chave et al. 2014).

    $$B = 0.0673\times(\rho\times D^2\times A)^{0.976}$$
5. 'Biomasa' in Tonnes (Tree Biomass; $B_T$; T) is then estimated by dividing B by 1000.
6. `Cantidad de Carbono` (Carbon amount; C; T) is estimated from `Concentración de Carbono` (Carbon Concentration; c; Thomas & Martin, 2012) and `Biomasa` (Biomass; $B_T$; T)

   $$C = c \times B_T$$
7. `Cantidad CO2` (Amount of CO2; CO2; T) is then calculated using the following equation:  

    $$CO2 = \frac{C \times 44.01}{12.011}$$

#### CALCULATOR: Carbon stocks for a 1 ha plot
*Esa información se puede encontrar en español en la calculadora por la hoja Metadata y por `Carbon Accounting Workshop/WorkshopMaterial_Es.pdf`*.

1. Percentage of sampled trees for a plot (`Porcentaje de árboles medidos`; %) is  calculated
2. Carbon (`Cantidad de Carbono`; C; T) is summed over the plot ($C_{suma}$)
3. CO2 (`Cantidad CO2`; CO2; T) is summed over the plot ($C02_{suma}$)
4. `Estimación de Carbono` (Total carbon estimate; $E_C$; T/Ha) is calculated. NOTE each plot corresponds to **one hectare**. `Arboles Total` (Total trees) corresponds to the total number of trees in the plot, and `Arboles Medidos` to the number of trees measured.
   $$E_C = \frac{C_{suma} \times Arboles Total}{Arboles Medidos}$$
5. `Estimación de C02` (Total carbon estimate; $E_{CO2}$; T/Ha) is calculated. NOTE each plot corresponds to **one hectare**. `Arboles Total` (Total trees) corresponds to the total number of trees in the plot, and `Arboles Medidos` to the number of trees measured.
   $$E_{CO2} = \frac{CO2_{suma} \times Arboles Total}{Arboles Medidos}$$

### How to Use the Calculator
*Esa información se puede encontrar en español en la calculadora por la hoja Metadata y por `Carbon Accounting Workshop/WorkshopMaterial_Es.pdf`*.
#### Page 1: `Clave`
Key for tree species. Associates tree names in Spanish, Embera, and scientific name. Additionally, there is a column for tree density, sourced from Chave et al. 2009, and a concentration of carbon, sourced from Thomas & Martin. 2012. If density is not specified, the mean value for Central America of 0.56 g cm{-3} is used. Likewise, the mean value of carbon density used in absence of data is 0.477 (47.7%).
#### Page 2: `Arboles`
light green columns are columns to be filled by the user. They include `Parcela` (Plot ID), `ID` (Tree ID), `Especie` (Species, to be selected from a dropdown list) and DBH (`DAP`; cm). Using this information and information from `Clave`, the heigjt, biomass, carbon concentration and CO2 concentration are filled. The last two are in dark green - these are the informative columns.
#### Page 3: `Estimación de Carbon`
Likewise, the light green columns are to be filled in. These are `Parcela` (Plot ID), which should correspond to a plot ID in `Arboles`, and `Arboles total`, which is the total number of trees present in the plot. Using this information, the spreadsheet calculates the number of trees measured, the percentage of trees measured, the sum of carbon and CO2 measured, and an estimation of Carbon (T/Ha) and CO2 (T/Ha) per plot.
#### Page 4: `Elegir Lineas`
This page assigns random rows of trees to be measured. `Cantidad de Lineas en la Parcela` is the total number of rows of trees. 4 are then chosen at random (`Linea 1` - `Linea 4`).

## The Workshop
The workshop material, in the original language (spanish), can be found at `Carbon Accounting Workshop/WorkshopMaterial_Es.pdf`.

## File Structure
This repo is split into two major folders. One is dedicated to the Workshop, and contains all files used and presented in the workshop. The second is dedicated to the carbon calculator and includes alternative versions of the carbon calculator, data used for development, and exploratory code.

```
├── README.md
├── CarbonCalculator
    ├── README.md
    ├── Calculadora de Carbono_ChaveEqn.xlsx
    ├── Calculadora de Carbono_Sardinilla.xlsx
    ├── Data
        ├── baseline_table.csv
        └── MJ_SARDINILLA_ALL_YEARS.xlsx
    └── Calculator Development
        ├── HeightDiameterModels_Exploration.Rmd
        ├── HeightDiameterModels_Exploration.html
        └── extractingE.R
└── Carbon Accounting Workshop
    ├── Calculadora de Carbono_VersionLibreOfficeFINAL.xlsx
    ├── DataPresentationSheet.xlsx
    ├── FieldSheet.ods
    ├── WorkshopMaterial_Es.pdf
    ├── WorkshopSummaryPoster.jpg
    ├── Example
        └── Calculadora de Carbono_VersionLibreOfficeFINAL-GRADY.xlsx
    └── TreeIdentification
        ├── Tree_Identification_Guide_es.md
        └── Images
            ├── README.md
            ├── almendro_bark.jpg
            ├── almendro_leaf.jpg
            ├── amarillo_bark.jpg
            ├── amarillo_leaf.jpg
            ├── caoba_bark.jpg
            ├── caoba_leaf.jpg
            ├── cedroamargo_bark.jpg
            ├── cedroamargo_leaf.jpg
            ├── cocobolo_bark.jpg
            ├── cocobolo_leaf.jpg
            ├── espave_bark.jpg
            ├── espave_leaf.jpg
            ├── guayacan_bark.jpg
            ├── guyacan_leaf.jpg
            ├── roble_bark.jpg
            ├── roble_leaf.jpg
            ├── zorro_bark.jpg
            └── zorro_leaf.jpg
```

## References
* Chave, J., Réjou-Méchain, M., Búrquez, A., Chidumayo, E., Colgan, M.S., Delitti, W.B.C., Duque, A., Eid, T., Fearnside, P.M., Goodman, R.C., Henry, M., Martínez-Yrízar, A., Mugasha, W.A., Muller-Landau, H.C., Mencuccini, M., Nelson, B.W., Ngomanda, A., Nogueira, E.M., Ortiz-Malavassi, E., Pélissier, R., Ploton, P., Ryan, C.M., Saldarriaga, J.G. and Vieilledent, G. (2014), Improved allometric models to estimate the aboveground biomass of tropical trees. Glob Change Biol, 20: 3177-3190. https://doi.org/10.1111/gcb.12629
* Chave, J., Coomes, D., Jansen, S., Lewis, S.L., Swenson, N.G., Zanne, A.E. 2009. Towards a worldwide wood economics spectrum. Ecology Letters 12(4): 351-366
* Thomas, S.C.; Martin, A.R. Carbon Content of Tree Tissues: A Synthesis. Forests 2012, 3, 332-352.
