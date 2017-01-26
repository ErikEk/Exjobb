README

Inkluderar f�ljande k�llkodsfiler:
build_supervised_dataset_fake_friction.m
logistic_regression.m
build_supervised_dataset.m
run_svm.m
TFANN.py

Resursfiler:
dataset_list.xlsx
query_weatherstation_save_1435.csv, SMHITemp.csv - v�derleksdata

**Fil 1: build_supervised_dataset_fake_friction.m
Denna fil anv�nds f�r att bygga ett data set med fejkade friktionsv�rden i kombination med 
uppm�tt v�derleksdata. Friktionsv�rderna viktas med avseende p� fuktighet och temperatur 
och en slumpfaktor:

friktionsv�rde = (temperatur+fuktighet+slump)/3

d�r slump variabeln varierar mellan 0 och 0.5 (se rad 329).

De tre fejkade f�reg�ende friktionsv�rderna skapas enligt:

f�reg�ende_friktionsv�rde1 = (friktionsv�rde+fuktighet_fr�n_30min+temperatur_fr�n_30min)/3
f�reg�ende_friktionsv�rde2 = (friktionsv�rde+fuktighet_fr�n_60min+temperatur_fr�n_60min)/3
f�reg�ende_friktionsv�rde3 = (friktionsv�rde+fuktighet_fr�n_90min+temperatur_fr�n_90min)/3

D�r fuktighet och temperatur tas fr�n 30, 60 samt 90 minuter sedan (se rad 348,370,390). Avst�nden �r 
satta till 0.005, 0.01 samt 0.02 med m�ttkvalite 5. Fuktigheten och temperaturen har en negativ
korrelation till friktionsv�rdet. D�rf�r tar vi det negativa v�rdet och begr�nsar detta mellan
noll och ett (se kod).

Slutresultatet sparas i variabeln 'cleareddataset' och expoteras som cleareddataset.mat och cleareddataset.csv.

**Fil 2: logistic_regression.m
Bygger Logistic regression modeller

**Fil 3: run_svm.m
Bygger SVM modeller

**Fil 4: build_supervised_dataset.m
Bygger data set fr�n riktiga friktionsm�tningar och v�derleksdata i likehet med 
build_supervised_dataset_fake_friction.m.

**Fil 5: TFANN.py
Bygger ANN modeller
F�r att k�ra TFANN.py beh�vs python 3 och f�ljande paket:
scipy.io
tensorflow (https://www.tensorflow.org/get_started/os_setup)
numpy
pandas
sklearn


**Fil 6: dataset_list.xlsx
Beskriver datastrukturen som skapas av build_supervised_dataset_fake_friction.m
samt build_supervised_dataset.m.