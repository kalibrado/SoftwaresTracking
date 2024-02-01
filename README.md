# Windows software execution time tracking

## TODO: the batch script currently being developed 😜

## 📚 Description

The PowerShell/Batch Software Monitoring script is a tool for monitoring the opening and closing of specific software on a Windows system. It saves this information in a CSV file, providing accurate tracking of each software's execution time.
The main purpose of this script is to allow users to track and analyze the usage of certain software, whether for productivity, monitoring or billing reasons. It can be used in various settings, such as professional environments, educational institutions or even for personal use.

The script creates a CSV file with the following columns:
- Software: the name of the software
- Start on: the start time of the execution
- Close on: the end time of the execution
- Execution time (seconds): the execution time in seconds
- User: the name of the current user
  
---
## 💪 Features

  - Real-time monitoring: The script continuously monitors processes running on the system and detects software specified in a predefined list.
  - Data logging: Every time a software is detected to be open, the script records the execution start time. When the software is closed, it records the end time and calculates the execution time in seconds.
  - CSV file: The collected information is stored in a CSV (Comma-Separated Values) file, which is a commonly used format for storing tabular data. The CSV file contains the following columns: Software, Start on, Close on, Execution time (seconds), User.
  - Dynamic update: The CSV file is updated by adding a new line for each software opening and closing detected. Thus, the user has detailed and chronological monitoring of each use.
  - Customization: The user can specify the software to monitor by modifying the list of software in the script. It can also set the path and name of the output CSV file as needed.
---

The PowerShell/Batch Software Tracking script provides a convenient solution for tracking and recording software usage, giving users a better understanding of their execution time and productivity.

## 🏓 Using PowerShell script


1. Modify the list of software to monitor by replacing the values ​​of the `$SoftwareList` variable. For example, if you want to monitor "chrome", "msedge" and "code" software, use the following line:
   ```powershell
   $SoftwareList = @("chrome", "msedge", "code")
   ```
2. Specify the path and name of the CSV output file in the $OutputFile variable. For example, use the following line to save the file in the data folder with the name continued_software_power_shell.csv:
    ```powershell
   $OutputFile = "./data/traking_power_shell.csv"
   ```
3. Navigate to the file directory:
      ```powershell
      cd /path/to/the/folder
      ```
4. Grant execution rights:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    ```
5. Run the script using PowerShell. The script will continuously monitor the software and update the CSV file every time a software is opened and then closed.
    ```powershell
   ./powershell_traking.ps1
   ```

The script will continue to run until you manually close it by pressing Ctrl + C in the PowerShell window.

# 😱 Note: Make sure you have the necessary permissions to create and modify files in the directory specified for the output CSV file.

## This script was designed to run continuously and does not have a built-in mechanism to be stopped automatically. Be sure to monitor it and manually turn it off when you are finished using it.

# Capture 

![Sortie csv ](https://github.com/kalibrado/suivi_logiciels/blob/master/sortie_csv.png?raw=true)

![Sortie console ](https://github.com/kalibrado/suivi_logiciels/blob/master/sortie_console.png?raw=true)
