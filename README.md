# Suivi de temps d'exécution des logiciels Windows
Le projet "Suivi de temps d'exécution des logiciels Windows" propose un ensemble de scripts batch Windows et PowerShell conçus pour faciliter le suivi du temps d'exécution des programmes Windows. Ces scripts permettent aux utilisateurs de surveiller et d'enregistrer le temps passé sur différents logiciels afin d'analyser leur utilisation et d'optimiser leur productivité.

L'utilisateur a la possibilité de personnaliser les logiciels à surveiller en modifiant une variable dans chaque script. Il suffit de spécifier les noms des logiciels à suivre, tels que "chrome" ou "code". De plus, l'utilisateur peut également définir le chemin d'accès et le nom du fichier de sortie qui enregistrera les données de suivi.

L'utilisation des scripts est simple et directe. Pour le script batch, il est recommandé de l'exécuter dans une fenêtre de commande avec des droits d'administration. L'utilisateur doit se rendre dans le répertoire du fichier et exécuter le script à l'aide d'une commande. De même, pour le script PowerShell, l'utilisateur doit se rendre dans le répertoire du fichier, accorder les droits d'exécution nécessaires, puis lancer le script.

Une fois les scripts exécutés, les données de suivi seront enregistrées dans un fichier CSV spécifié. Ces données peuvent ensuite être utilisées pour générer des rapports, analyser les habitudes d'utilisation des logiciels, identifier les goulots d'étranglement et prendre des décisions informées pour optimiser l'efficacité du travail.

En résumé, le projet "Suivi de temps d'exécution des logiciels Windows" fournit des outils pratiques et personnalisables pour surveiller le temps d'exécution des logiciels Windows. Il aide les utilisateurs à mieux comprendre et gérer leur utilisation des logiciels, ce qui peut conduire à une amélioration de la productivité et de l'efficacité dans leur travail quotidien.

# ⚙️ Configuration
## Chaque script contient deux variables à personnaliser en fonction de vos besoins :


```ps1
-> suivi_logiciels.ps1
    # Remplacez par vos logiciels
    $SoftwareList = @("chrome", "code")  
    # Chemin d'accès et nom du fichier de sortie
    $OutputFile = "./data/suivi_logiciels_power_shell.csv" 
```

```bat
-> suivi_logiciels.bat
    REM  # Remplacez par vos logiciels
    set SoftwareList=chrome code
    REM  # Chemin d'accès et nom du fichier de sortie
    set OutputFile=./data/suivi_logiciels_batch.csv
```

# 🏍️ Utilisation
## ⚡ Terminal avec les droits administrateur ⚡

- # Script Batch
    - Accédez au répertoire du fichier :

        ```cmd
        cd /chemin/ver/le/dossier
        ```
    - Lancez le script :
        
        ```cmd
        ./suivi_logiciels.bat
        ```

- # Script PowerShell
    - Accédez au répertoire du fichier :

        ```ps1
        cd /chemin/ver/le/dossier
        ```
    - Accordez les droits d'exécution :

        ```ps1
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted
        ```
    - Lancez le script :
        
        ```ps1
        ./suivi_logiciels.ps1
        ```
