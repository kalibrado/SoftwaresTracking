$SoftwareList = @("chrome", "calc", "code")  # Remplacez par vos logiciels
$OutputFile = "./data/suivi_logiciels_power_shell.csv"  # Chemin d'accès et nom du fichier de sortie

# Crée un dictionnaire pour stocker l'état de chaque logiciel et le temps d'ouverture
$SoftwareState = @{}
foreach ($Software in $SoftwareList) {
    $SoftwareState[$Software] = @{
        Opened    = $false
        StartTime = $null
    }
}

if (-not (Test-Path $OutputFile)) {
    # Crée le fichier CSV avec l'en-tête s'il n'existe pas
    "Logiciel, Demarrer le, Fermer le, Temps executions(minutes)" | Out-File -FilePath $OutputFile -Encoding utf8
}

while ($true) {
    $Processes = Get-Process | Where-Object { $SoftwareList -contains $_.Name }

    foreach ($Software in $SoftwareList) {
        if ($Processes.Name -contains $Software) {
            if (-not $SoftwareState[$Software].Opened) {
                # Le logiciel est ouvert, met à jour l'état et l'heure de début
                $SoftwareState[$Software].Opened = $true
                $SoftwareState[$Software].StartTime = $Processes | Where-Object { $_.Name -eq $Software } | Select-Object -First 1 -ExpandProperty StartTime

                Write-Host "Le logiciel $Software ouvert le $($SoftwareState[$Software].StartTime)"
            }
        }
        else {
            if ($SoftwareState[$Software].Opened) {
                # Le logiciel a été fermé, calcule la durée d'ouverture en minutes
                $StartTime = $SoftwareState[$Software].StartTime
                $EndTime = Get-Date
                $Duration = [math]::Round(($EndTime - $StartTime).TotalMinutes, 2)

                Write-Host "Le logiciel $Software fermer le $EndTime."

                # Vérifie si le logiciel est déjà dans le fichier CSV
                $ExistingSoftware = Import-Csv -Path $OutputFile | Where-Object { $_.Logiciel -eq $Software }

                if (-not $ExistingSoftware) {
                    # Le logiciel n'est pas encore présent, ajoute une nouvelle ligne au fichier CSV
                    $NewSoftware = [PSCustomObject]@{
                        Logiciel           = $Software
                        "Demarrer le"      = $StartTime.ToString("dd-MM-yyyy HH:mm:ss")
                        "Fermer le"        = $EndTime
                        "Temps executions" = $Duration
                    }

                    $NewSoftware | Export-Csv -Path $OutputFile -Append -NoTypeInformation -Encoding UTF8

                    Write-Host "Nouveau logiciel ajouter au fichier CSV : $Software"
                }
                else {
                    # Le logiciel est déjà présent, met à jour la durée d'ouverture
                    $ExistingSoftware."Temps executions" = $Duration

                    $TempFile = "$OutputFile.tmp"

                    # Crée un tableau pour stocker les lignes du fichier CSV mises à jour
                    $UpdatedData = @()

                    Import-Csv -Path $OutputFile | ForEach-Object {
                        if ($_.Logiciel -eq $Software) {
                            # Ajoute la ligne mise à jour dans le tableau
                            $UpdatedData += $ExistingSoftware
                        }
                        else {
                            # Ajoute les autres lignes inchangées dans le tableau
                            $UpdatedData += $_
                        }
                    }

                    # Exporte le contenu mis à jour dans un nouveau fichier CSV temporaire
                    $UpdatedData | Export-Csv -Path $TempFile -NoTypeInformation -Encoding UTF8

                    # Remplace le fichier CSV original par le fichier temporaire
                    Move-Item -Path $TempFile -Destination $OutputFile -Force

                    Write-Host "Duree d'execution du logiciel $Software mise a jour dans le fichier CSV."
                }

                # Réinitialise l'état et l'heure de début du logiciel
                $SoftwareState[$Software].Opened = $false
                $SoftwareState[$Software].StartTime = $null
            }
        }
    }

    Start-Sleep -Seconds 5 # Attendre 5 secondes avant la prochaine itération
}
