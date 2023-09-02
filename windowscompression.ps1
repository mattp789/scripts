Param(
$directory = "",

$zipdir = "C:\tmp\zipdir",

#Current Date and Time
$date = (get-date -format "yyyy_MM_dd_hh_ss"),

$destination = "C:\Users\Desktop\backup1\zipped$date.zip",

$fileextention = @("bak", "trc")
)

Add-Content $loglocation "The following files deleted:"

New-Item -ItemType directory -Path $zipdir;

function do-compression {
    Param (
        $source = " ",
        #edit this to make it local directory filename.zip
        $destination =  " "
        ##################################################
    )
    #if(test-path $destination) {remove-item $destination}
    add-type -Assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::CreateFromDirectory($source, $destination)
}

function Start-compression {

    Param (

        #Specify directory location containing files to be compressed

        $directory = " "
    )
    foreach ($direct in $directory) {
        compress-file -direct $direct -fileextention $fileextention
    }
}

function compress-file {
    Param (
        $direct = " ",
        $fileextention = @()
    )
    foreach ($dir in $direct){
        foreach ($ext in $fileextention) {
            $bakname = (@(get-childitem -path $direct *.$ext).name)
            foreach ($f in $bakname) {
            #Add-Content $loglocation "$direct\$F"
            Move-Item $direct\$f -Destination $zipdir
            #write-host $direct\$f
            }
        }
    } 
}


start-compression -directory $directory
do-compression -source $zipdir -destination $destination
Remove-Item $zipdir -Recurse
