# Replace with your software
$SoftwareList = @("msedge")  

# Path and name of the output file
$OutputFile = "./data/traking_power_shell.csv" 

# Checks if the folder exists, otherwise creates it
$FolderPath = Split-Path $OutputFile -Parent
if (-not (Test-Path $FolderPath)) {
    New-Item -ItemType Directory -Path $FolderPath | Out-Null
}

# Creates a state for each program in the SoftwareList variable
$SoftwareState = @{}
foreach ($Software in $SoftwareList) {
    $SoftwareState[$Software] = @{
        Opened    = $false
        StartTime = $null
    }
}

# Infinite loop
while ($true) {
    $Processes = Get-Process | Where-Object { $SoftwareList -contains $_.Name }
    foreach ($Software in $SoftwareList) {
        if ($Processes.Name -contains $Software) {
            if (-not $SoftwareState[$Software].Opened) {
                # Software is opened, updates status and start time
                $SoftwareState[$Software].Opened = $true
                $SoftwareState[$Software].StartTime = Get-Date

                Write-Host "The software '$Software' was opened on $($SoftwareState[$Software].StartTime)"
            }
        }
        else {
            if ($SoftwareState[$Software].Opened) {
                # The software has been closed, calculates the opening time in minutes
                $StartTime = $SoftwareState[$Software].StartTime
                $EndTime = Get-Date
                $Duration = [math]::Round(($EndTime - $StartTime).TotalSeconds)

                Write-Host "The software '$Software' was closed on $EndTime"

                $NewSoftware = [PSCustomObject]@{
                    Software                       = $Software
                    "Start on"                     = $StartTime.ToString("dd-MM-yyyy HH:mm:ss")
                    "Close on"                     = $EndTime.ToString("dd-MM-yyyy HH:mm:ss")
                    "Execution time (seconds)"     = $Duration
                    "User"                         = $env:USERNAME
                }

                # Check if the CSV file already exists
                $csvExists = Test-Path $OutputFile

                if (-not $csvExists) {
                    # Create the CSV file with the header if it does not exist
                    "Software, Start on, Close on, Execution time (seconds), User" | Out-File -FilePath $OutputFile -Encoding utf8
                }

                # Add the new line to the CSV file
                $NewSoftware | ConvertTo-Csv -NoTypeInformation -Delimiter "," | Select-Object -Skip 1 | Out-File -FilePath $OutputFile -Append -Encoding utf8

                Write-Host "New software adds to CSV file: '$Software'"
                
                # Resets software status and start time
                $SoftwareState[$Software].Opened = $false
                $SoftwareState[$Software].StartTime = $null
            }
        }
    }

    Start-Sleep -Seconds 1 # Attendre 5 secondes avant la prochaine iteration
}
