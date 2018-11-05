README

Inkluderar följande källkodsfiler:
Matlab:
build_supervised_dataset_fake_friction.m
logistic_regression.m
build_supervised_dataset.m
run_svm.m
Python:
TFANN.py
LoadCarData.m
LoadWeatherData.m
LoadWeatherDataVV.m
ManupulateDataForDebugging.m
SaveData.m
ClearData.m
GenerateFakeFrictionValues.m

Resursfiler:
dataset_list.xlsx
query_weatherstation_save_1435.csv, SMHITemp.csv - väderleksdata
feature_list.txt - Listar olika feature uppstättningar


**Fil 1: logistic_regression.m
Bygger Logistic regression-modeller

**Fil 2: run_svm.m
Bygger SVM modeller

**Fil 3: build_supervised_dataset.m
Sammanställer data set från riktiga friktionsmätningar och väderleksdata

**Fil 4: **Fil 1: build_supervised_dataset_fake_friction.m

**Fil 5: TFANN.py
Bygger ANN-modeller

**Fil 6: LoadCarData.m
Laddar in data från bildata

**File 7: LoadWeatherData.m
Laddar in data från väderdata

**File 8: LoadWeatherVVData.m
Laddar in data från väderdata (VV)

**Fil 9: SaveData.m
Sparar data till disk

**Fil 10:DefineConstants.m
Sätter värden för alla konstanter

**Fil 11: ManupulateDataFroDebugging.m
Ändrar data setet för att plotta vissa grafer.

**File 12: GenerateFakeFrictionValues.m

Denna fil används för att bygga ett data set med fejkade friktionsvärden i kombination med 
uppmätt väderleksdata. Friktionsvärderna viktas med avseende på fuktighet och temperatur 
och en slumpfaktor:

friktionsvärde = (temperatur+fuktighet+slump)/3

där slump variabeln varierar mellan 0 och 0.5 (se rad 329).

De tre fejkade föregående friktionsvärderna skapas enligt:

föregående_friktionsvärde1 = (friktionsvärde+fuktighet_från_30min+temperatur_från_30min)/3
föregående_friktionsvärde2 = (friktionsvärde+fuktighet_från_60min+temperatur_från_60min)/3
föregående_friktionsvärde3 = (friktionsvärde+fuktighet_från_90min+temperatur_från_90min)/3

Där fuktighet och temperatur tas från 30, 60 samt 90 minuter sedan (se rad 348,370,390). Avstånden är 
satta till 0.005, 0.01 samt 0.02 med måttkvalite 5. Fuktigheten och temperaturen har en negativ
korrelation till friktionsvärdet. Därför tar vi det negativa värdet och begränsar detta mellan
noll och ett (se kod).

**Fil 13: dataset_list.xlsx
Beskriver datastrukturen som skapas av build_supervised_dataset_fake_friction.m
samt build_supervised_dataset.m.
