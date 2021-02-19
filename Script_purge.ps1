
#Commande pour lancer le script en shell
#powershell "chemin/"Script_purge.ps1

#------------------------------------------------------------
#Variable log
$hour = Get-Date -Format "HH:mm"  #on récupe l'heure
$date = Get-Date -Format "dd/MM/yyyy" #on récupère la date sous la forme "Jour/Mois/Année"
$userName= [Environment]::UserName

#------------------------------------------------------------
#Créer le fichier de log
$file_log="$pwd/log.txt"
If ((Test-Path $file_log) -eq $True)
    {
    ADD-content -path $file_log -value "----------------------------------------------------------------------------------------------------`r`nscript lancé le $date à $hour par $userName"
    }
else
    {
    ADD-content -path $file_log -value "----------------------------------------------------------------------------------------------------`r`nscript lancé le $date à $hour par $userName"
    }

#------------------------------------------------------------
#variable
$emplacement = Read-Host "Chemin du répertoire format (T:/)"
$nb_days = $null
$nb_days= Read-Host "Supprimer les fichiers plus vieux de "
while ($nb_days -eq "" -or $null)
{
$nb_days= Read-Host "Supprimer les fichiers plus vieux de "
}

#------------------------------------------------------------
#code
#------------------------------------------------------------
#------------On récupère le nombre de fichier 
$nb_fichier = Get-ChildItem -path T:/ -Include * -File -Recurse |where CreationTime -LT (Get-Date).AddDays(-$nb_days)
$nb_fichiercount = $nb_fichier.count

If ((Test-Path $file_log) -eq $True)
    {
    ADD-content -path $file_log -value "`r`n $nb_fichiercount fichier de plus de $nb_days jours ont été trouver"
    }

#----------On supprime les fichiers
Write-Host " $nb_fichiercount fichier de plus de $nb_days ont été supprimer"
Get-ChildItem -path T:/ -Include * -File -Recurse |where CreationTime -LT (Get-Date).AddDays(-$nb_days) | foreach { $_.Delete()}

#------------------------------------------------------------
#------------On récupère le nombre de dossier vide

$Empty_Folder = Get-ChildItem $emplacement -Directory -Recurse |Where-Object {(Get-ChildItem $_.FullName -File -Recurse -Force).Count -eq 0}
$Emptycount= $Empty_Folder.count
Write-Host " $Emptycount dossier de plus de $nb_days jours ont été trouver"

If ((Test-Path $file_log) -eq $True)
    {
    ADD-content -path $file_log -value "`r`n $Emptycount dossiers vide ont été trouver"
    }

#------------On Supprime les dossiers vide
Foreach ($Dir in $Empty_Folder)
{
Remove-Item -LiteralPath $Dir.FullName -recurse -force -erroraction SilentlyContinue
}
Read-Host "Terminer"
