#--- Author : Ali Hojaji ---#

#--*-------------------*--#
#---> Manage Storages <---#
#--*-------------------*--#

#--> create a new storage pool
New-StoragePool -FriendlyName AllThDisks -StorageSubSystemUniqueId (Get-StorageSubSystem).UniqueId -PhysicalDisks (Get-PhysicalDisk -CanPool $true)

#--> create virtual disk
New-VirtualDisk -FriendlyName companyData -StoragePoolFriendlyName AllTheDisks -Size 2TB -ProvisioningType Thin -ResiliencySettingName Mirror

#--> initialize underlying physical disks
Initialize-Disk -VirtualDisk (Get-VirtualDisk -FriendlyName CompanyData)

#--> partition and format volumes from virtual disk
$vd = Get-VirtualDisk -FriendlyName CompanyData | Get-Disk

$vd | 
    New-Partition -Size 100GB -DriveLetter U |
            Format-Volum -FileSystem NTFS -AllocationUnitSize 4096 -NewFileSystemLabel "User Data"

$vd |
    New-Partition -Size 500GB -DriveLetter I |
         Format-Volum -FileSystem ReFS -AllocationUnitSize 4096 -NewFileSystemLabel "IT Data"

$vd
    New-Partition -Size 1TB -DriveLetter V |
         Format-Volum -FileSystem ReFS -AllocationUnitSize 65536 -NewFileSystemLabel "VM Data"