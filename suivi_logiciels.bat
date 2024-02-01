@echo off
setlocal enabledelayedexpansion

REM Replace the following software with the ones you want to monitor
set "SoftwareList=msedge"

REM Path and name of output file
set "OutputFile=./data/traking_batch.csv"

REM Check if the folder exists, otherwise create it
if not exist "./data" mkdir "./data"

REM Creates a state for each program in the SoftwareList variable
for %%i in (%SoftwareList%) do (
    set "SoftwareState[%%i]=false"
    set "StartTime[%%i]="
)

REM Infinity loop
:loop
REM Gets the list of currently running processes
set "Processes="
for /f "usebackq tokens=1" %%a in (`tasklist /fo csv ^| findstr /i /c:"\".*\""`) do (
    for %%b in (%%a) do (
        set "Processes=!Processes! %%~b"
    )@echo off
setlocal enabledelayedexpansion

set SoftwareList=chrome msedge code
set OutputFile=./data/suivi_logiciels_batch.csv

REM Crée le fichier CSV avec l'en-tête s'il n'existe pas
if not exist "%OutputFile%" (
    echo "Logiciel, Demarrer le, Fermer le, Temps executions(minutes)" > "%OutputFile%"
)

for %%S in (%SoftwareList%) do (
    set "SoftwareState_%%S_Opened=false"
    set "SoftwareState_%%S_StartTime="
)

:loop
for %%S in (%SoftwareList%) do (
    tasklist /FI "IMAGENAME eq %%S.exe" 2>nul | find /i "%%S.exe" >nul
    if errorlevel 1 (
        if "!SoftwareState_%%S_Opened!"=="true" (
            REM Le logiciel a été fermé, calcule la durée d'ouverture en minutes
            set StartTime=!SoftwareState_%%S_StartTime!
            set EndTime=!TIME!
            
            REM Convertit l'heure de fin en un format lisible
            for /F "tokens=1-3 delims=:." %%A in ("!EndTime!") do (
                set "EndTime=%%A:%%B:%%C"
            )
            
            REM Calcule la durée en minutes
            set Duration=
            for /F "tokens=1-3 delims=:." %%A in ("!StartTime!") do (
                set /A "StartSeconds=(((%%A*60)+1%%B %% 100)*60)+1%%C %% 100"
            )
            for /F "tokens=1-3 delims=:." %%A in ("!EndTime!") do (
                set /A "EndSeconds=(((%%A*60)+1%%B %% 100)*60)+1%%C %% 100"
            )
            set /A "Duration=(EndSeconds-StartSeconds+86400) %% 86400 / 60"
            
            REM Vérifie si le logiciel est déjà dans le fichier CSV
            set ExistingSoftware=
            for /F "usebackq skip=1 tokens=1 delims=," %%L in ("%OutputFile%") do (
                for /F "tokens=1 delims=," %%N in ("%%L") do (
                    if "%%N"=="%%S" (
                        set ExistingSoftware=1
                        goto :update_csv
                    )
                )
            )
            
            REM Le logiciel n'est pas encore présent, ajoute une nouvelle ligne au fichier CSV
            echo %%S, !StartTime!, !EndTime!, !Duration! >> "%OutputFile%"
            echo Nouveau logiciel ajouté au fichier CSV : %%S
            
            :update_csv
            REM Le logiciel est déjà présent, met à jour la durée d'ouverture
            if defined ExistingSoftware (
                set TempFile="%OutputFile%.tmp"
                > !TempFile! (
                    for /F "usebackq tokens=1-4 delims=," %%A in ("%OutputFile%") do (
                        if "%%A"=="Logiciel" (
                            echo %%A, %%B, %%C, %%D
                        ) else (
                            if "%%A"=="%%S" (
                                echo %%A, %%B, %%C, !Duration!
                            ) else (
                                echo %%A, %%B, %%C, %%D
                            )
                        )
                    )
                )
                
                REM Remplace le fichier CSV original par le fichier temporaire
                move /y !TempFile! "%OutputFile%" >nul
                echo Durée d'exécution du logiciel %%S mise à jour dans le fichier CSV.
            )
            
            REM Réinitialise l'état et l'heure de début du logiciel
            set "SoftwareState_%%S_Opened=false"
            set "SoftwareState_%%S_StartTime="
        )
    ) else (
        if "!SoftwareState_%%S_Opened!"=="false" (
            REM Le logiciel est ouvert, met à jour l'état et l'heure de début
            set "SoftwareState_%%S_Opened=true"
            REM Utilise WMIC pour récupérer l'heure de début du processus
            for /F "skip=1 tokens=2 delims=," %%T in ('wmic process where "name='%%S.exe'" get creationdate /FORMAT:CSV') do (
                set "SoftwareState_%%S_StartTime=%%T"
            )
            REM Formate l'heure de début en HH:mm:ss
            set "SoftwareState_%%S_StartTime=!SoftwareState_%%S_StartTime:~8,2!:!SoftwareState_%%S_StartTime:~10,2!:!SoftwareState_%%S_StartTime:~12,2!"
            
            echo Le logiciel %%S ouvert le !SoftwareState_%%S_StartTime!
        )
    )
)

REM Attendre 5 secondes avant la prochaine itération
echo Attente de 5 secondes...
ping -n 6 127.0.0.1 >nul

goto :loop

)

REM Parcourt chaque logiciel de la liste
for %%i in (%SoftwareList%) do (
    REM Verifie si le logiciel est en cours d'execution
    echo !Processes! | findstr /i /c:"%%i" >nul
    if !errorlevel! equ 0 (
        REM Le logiciel est ouvert
        if not !SoftwareState[%%i]! equ true (
            REM Met à jour l'etat et l'heure de debut
            set "SoftwareState[%%i]=true"
            for /f "usebackq tokens=3,4" %%a in (`tasklist /fo csv ^| findstr /i /c:"\"%%i\"`) do (
                set "StartTime[%%i]=%%~a %%~b"
            )

            echo Le logiciel '%%i' a ete ouvert le !StartTime[%%i]!
        )
    ) else (
        REM Le logiciel a ete ferme
        if !SoftwareState[%%i]! equ true (
            REM Calcule la duree d'ouverture en secondes
            for /f "tokens=1-3 delims=:." %%a in ("%TIME%") do (
                set "EndTime=%%a:%%b:%%c"
            )
            for /f "tokens=1-4 delims=/: " %%a in ("!DATE!") do (
                set "EndDate=%%c-%%b-%%a"
            )

            set "StartTime[%%i]="
            set "SoftwareState[%%i]=false"

            echo Le logiciel '%%i' a ete ferme le !EndDate! !EndTime!

            REM Calcule la duree d'execution en secondes
            for /f "tokens=1-4 delims=/:. " %%a in ("!EndDate! !EndTime! !StartDate! !StartTime[%%i]!") do (
                set /a "Duration=(((%%e*24+%%f)*60+%%g)*60+%%h)-(((%%a*24+%%b)*60+%%c)*60+%%d)"
            )

            REM Ajoute une nouvelle ligne au fichier CSV
            echo %%i,!StartDate! !StartTime[%%i]!,!EndDate! !EndTime!,!Duration!,%USERNAME% >> "%OutputFile%"

            echo Nouveau logiciel ajoute au fichier CSV : '%%i'
        )
    )
)

REM Attendre 1 seconde avant la prochaine iteration
ping -n 2 127.0.0.1 >nul
goto loop
