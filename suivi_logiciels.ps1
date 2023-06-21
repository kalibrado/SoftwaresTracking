$SoftwareList = @("msedge")  # Remplacez par vos logiciels
$OutputFile = "./data/suivi_logiciels_power_shell.csv"  # Chemin d'accès et nom du fichier de sorti

# Verifie si le dossier existe, sinon le cree
$FolderPath = Split-Path $OutputFile -Parent
if (-not (Test-Path $FolderPath)) {
    New-Item -ItemType Directory -Path $FolderPath | Out-Null
}

# Crée un etat pour chaque programe dans la variable SoftwareList
$SoftwareState = @{}
foreach ($Software in $SoftwareList) {
    $SoftwareState[$Software] = @{
        Opened    = $false
        StartTime = $null
    }
}

# Boucle a l'infinie
while ($true) {
    $Processes = Get-Process | Where-Object { $SoftwareList -contains $_.Name }
    foreach ($Software in $SoftwareList) {
        if ($Processes.Name -contains $Software) {
            if (-not $SoftwareState[$Software].Opened) {
                # Le logiciel est ouvert, met a jour l'etat et l'heure de debut
                $SoftwareState[$Software].Opened = $true
                $SoftwareState[$Software].StartTime = Get-Date

                Write-Host "Le logiciel '$Software' a ete ouvert le $($SoftwareState[$Software].StartTime)"
            }
        }
        else {
            if ($SoftwareState[$Software].Opened) {
                # Le logiciel a ete ferme, calcule la duree d'ouverture en minutes
                $StartTime = $SoftwareState[$Software].StartTime
                $EndTime = Get-Date
                $Duration = [math]::Round(($EndTime - $StartTime).TotalSeconds)

                Write-Host "Le logiciel '$Software' a ete ferme le $EndTime"

                $NewSoftware = [PSCustomObject]@{
                    Logiciel                      = $Software
                    "Demarrer le"                 = $StartTime.ToString("dd-MM-yyyy HH:mm:ss")
                    "Fermer le"                   = $EndTime.ToString("dd-MM-yyyy HH:mm:ss")
                    "Temps executions (secondes)" = $Duration
                    "Utilisateur"                 = $env:USERNAME
                }

                # Verifie si le fichier CSV existe deja
                $csvExists = Test-Path $OutputFile

                if (-not $csvExists) {
                    # Cree le fichier CSV avec l'en-tête s'il n'existe pas
                    "Logiciel, Demarrer le, Fermer le, Temps executions (secondes), Utilisateur" | Out-File -FilePath $OutputFile -Encoding utf8
                }

                # Ajoute la nouvelle ligne au fichier CSV
                $NewSoftware | ConvertTo-Csv -NoTypeInformation -Delimiter "," | Select-Object -Skip 1 | Out-File -FilePath $OutputFile -Append -Encoding utf8

                Write-Host "Nouveau logiciel ajoute au fichier CSV : '$Software'"
                
                # Reinitialise l'etat et l'heure de debut du logiciel
                $SoftwareState[$Software].Opened = $false
                $SoftwareState[$Software].StartTime = $null
            }
        }
    }

    Start-Sleep -Seconds 1 # Attendre 5 secondes avant la prochaine iteration
}
