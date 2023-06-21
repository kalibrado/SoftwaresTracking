# Suivi de temps d'exécution des logiciels Windows

## TODO : le script batch en cours de dev 😜

## 📚 Description

Le script "Suivi des logiciels PowerShell/Batch" est un outil qui permet de surveiller l'ouverture et la fermeture de logiciels spécifiques sur un système Windows. Il enregistre ces informations dans un fichier CSV, fournissant ainsi un suivi précis du temps d'exécution de chaque logiciel.
L'objectif principal de ce script est de permettre aux utilisateurs de suivre et d'analyser l'utilisation de certains logiciels, que ce soit pour des raisons de productivité, de surveillance ou de facturation. Il peut être utilisé dans divers contextes, tels que les environnements professionnels, les établissements d'enseignement ou même pour un usage personnel.

Le script crée un fichier CSV avec les colonnes suivantes :
- Logiciel : le nom du logiciel
- Démarrer le : l'heure de début de l'exécution
- Fermer le : l'heure de fin de l'exécution
- Temps d'exécution (secondes) : la durée d'exécution en secondes
- Utilisateur : le nom de l'utilisateur actuel
  
---

## 💪 Fonctionnalités

  - Surveillance en temps réel : Le script surveille en permanence les processus en cours d'exécution sur le système et détecte les logiciels spécifiés dans une liste prédéfinie.
  - Enregistrement des données : Chaque fois qu'un logiciel est détecté comme étant ouvert, le script enregistre l'heure de début de l'exécution. Lorsque le logiciel est fermé, il enregistre l'heure de fin et calcule la durée d'exécution en secondes.
  - Fichier CSV : Les informations collectées sont stockées dans un fichier CSV (Comma-Separated Values), qui est un format couramment utilisé pour stocker des données tabulaires. Le fichier CSV contient les colonnes suivantes : Logiciel, Démarrer le, Fermer le, Temps d'exécution (secondes), Utilisateur.
  - Mise à jour dynamique : Le fichier CSV est mis à jour en ajoutant une nouvelle ligne pour chaque ouverture et fermeture de logiciel détectée. Ainsi, l'utilisateur dispose d'un suivi détaillé et chronologique de chaque utilisation.
  - Personnalisation : L'utilisateur peut spécifier les logiciels à surveiller en modifiant la liste des logiciels dans le script. Il peut également définir le chemin d'accès et le nom du fichier CSV de sortie selon ses besoins.
  
---

Le script "Suivi des logiciels PowerShell/Batch" offre une solution pratique pour suivre et enregistrer l'utilisation des logiciels, offrant ainsi aux utilisateurs une meilleure compréhension de leur temps d'exécution et de leur productivité.

## 🏓 Utilisation du script PowerShell

1. Modifiez la liste des logiciels à surveiller en remplaçant les valeurs de la variable `$SoftwareList`. Par exemple, si vous souhaitez surveiller les logiciels "chrome", "msedge" et "code", utilisez la ligne suivante :
   ```powershell
   $SoftwareList = @("chrome", "msedge", "code")
   ```
2. Spécifiez le chemin d'accès et le nom du fichier de sortie CSV dans la variable $OutputFile. Par exemple, utilisez la ligne suivante pour enregistrer le fichier dans le dossier data avec le nom suivi_logiciels_power_shell.csv :
    ```powershell
   $OutputFile = "./data/suivi_logiciels_power_shell.csv"
   ```
3. Accédez au répertoire du fichier :
      ```powershell
      cd /chemin/vers/le/dossier
      ```
4. Accordez les droits d'exécution :
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    ```
5. Exécutez le script en utilisant PowerShell. Le script surveillera en continu les logiciels et mettra à jour le fichier CSV chaque fois qu'un logiciel est ouvert puis fermé.
    ```powershell
   ./suivi_logiciels.ps1
   ```

Le script continuera à s'exécuter jusqu'à ce que vous le fermiez manuellement en appuyant sur Ctrl + C dans la fenêtre PowerShell.

# 😱 Remarque : Assurez-vous d'avoir les autorisations nécessaires pour créer et modifier des fichiers dans le répertoire spécifié pour le fichier de sortie CSV.

## Note : Ce script a été conçu pour être exécuté en continu et n'a pas de mécanisme intégré pour être arrêté automatiquement. Veillez à le surveiller et à l'arrêter manuellement lorsque vous avez terminé son utilisation.