# Defina o caminho para os discos virtuais
$virtualDisks = @(
    "d:\virtual-disks\codesolver.vhdx",
    "d:\virtual-disks\digicon.vhdx"
)

# Variável inicial do drive físico
$physicalDrives = wmic diskdrive list brief | Select-String "PHYSICALDRIVE" 
$physicalDriveNumber = $physicalDrives.Count

Write-Output "Total de drives anexados inicialmente: $physicalDriveNumber"

# Execute o DiskPart com o comando necessário para cada disco virtual e monte no WSL
foreach ($disk in $virtualDisks) {
    $script = @"
select vdisk file="$disk"
attach vdisk
"@
    $script | diskpart.exe
    
    # Construa o nome do drive físico atual
    $physicalDrive = "PHYSICALDRIVE$physicalDriveNumber"
    
    # Monte o disco no WSL
    wsl.exe --mount \\.\$physicalDrive

    # Incremente o número do drive físico para o próximo disco
    $physicalDriveNumber++
}

Write-Output "Todos os discos virtuais foram anexados e montados no WSL."
