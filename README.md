# OpenEMR and FHIR synchronization demo

This a demo of our SyncEngine which syncrhonizes data between OpemMR and a FHIR repository.

## Install iris

You can use the provided docker compose file to install iris and webgate.

## Install OpenEMR

You can use the provided docker compose file to install iris and webgate. Onces installed you need to get the client id and the token for rest callss.

## Create FHIR repository

Create a namespace that will contain the FHIR respository. Then create a FHIR server.

## Install the SyncEngine

1. Create a new namespace.
2. Copy the SECore_v1.0.13.xml file into the shared folder of the docker. This file contains the classes of the core of the synchronization process.
3. Open the terminal of the namespace and run ```set sc = ##class(%Studio.Project).InstallFromFile("/irishealth-shared/SECore_v1.0.13.xml")``` (the path will depend on the shared folder in docker). This will load the classes of the syncEngine process.

## Install the connectors to FHIR and OpenEMR

In order to get changes both from OpenEMR and FHIR we need a connector. The src folder of the repository contains the code that connects to FHIR and OpenEMR to obtain last changes. You can load the classes opening the project in VS Code and importing the classes.

Once the classes are loaded in the namespace you need to run those two methods:
```
do ##class(cysnet.utils.Default).insertDefault()
do ##class(cysnet.utils.Default).crearGloblalDefaultAuditoria()
```

The first one defines the entities that you want to synchronize, the connectors and the mappings between entities. 
The second one enables the auditing.

## Configure the production

First load the provided production cysnet.VirtualizationLoopProd. This is preconfigured with all service, process and operations needed. Then you need to donfigure the connections to FHIR and OpenEMR.

* FHIR. In the HyperObjects operation set the URL and create the credentials (preconfigured as HyperObjects) to connecto to the FHIR repository.
* OpenEMR. In the OpenEMR operation set set the URL, and the OpenEMR-Auth and OpenEMR-Auth credentials.

## Start the prcess

The StartSync service is the one that runs the whole process. The service can be started with 5 different options.
* Paso 1: Obtener cambios (get changes)
* Paso 2: Ordenar cambios (order changes)
* Paso 3: Analizar cambios (analyze changes)
* Paso 4: Aplicar cambios (aply changes)
* Todos los pasos (all stesp)

First 4 options can be used for testing different parts of the sync project. The las one launches the whole process.

Once the production has started, all changes mad in the FHIR repo will be sync to OpemEMR and viceversa.