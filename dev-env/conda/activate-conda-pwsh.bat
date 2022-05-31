@echo off
pwsh -ExecutionPolicy ByPass -NoExit -Command "& 'C:\Users\eshan\miniconda3\shell\condabin\conda-hook.ps1' ; conda activate 'C:\Users\eshan\miniconda3' "
conda init powershell
conda config --set auto_activate_base false
echo "Restart/Open Powershell"
