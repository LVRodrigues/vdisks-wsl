# Defina o caminho para os discos virtuais
$virtualDisks = @(
    "d:\virtual-disks\digicon.vhdx",
    "d:\virtual-disks\codesolver.vhdx"
)

# Variável inicial do drive físico
$physicalDrives = wmic diskdrive list brief | Select-String "PHYSICALDRIVE" 
$physicalDriveNumber = $physicalDrives.Count

Write-Output "Total de drives anexados inicialmente: $physicalDriveNumber"

foreach ($disk in $virtualDisks) {
    # Decrementa o número do drive físico localizar o disco corrente
    $physicalDriveNumber--

    # Desmonte o disco no WSL
    wsl.exe --unmount \\.\PHYSICALDRIVE$physicalDriveNumber

    # Execute o DiskPart com o comando necessário para cada disco virtual e desmonte no WSL
    $script = @"
select vdisk file="$disk"
detach vdisk
"@
    $script | diskpart.exe
}

Write-Output "Todos os discos virtuais foram desmontados no WSL e desanexados."