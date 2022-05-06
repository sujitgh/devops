$blocksizes = @("4k","8k","64k","256k","2048MB")
$tiers= @("ultra1","zfs","standard1","premium1")
$Jobtypes = @("read","randread")
$TimeStamp = Get-Date -Format 'yyyyMMdd_HHmm'

<#
foreach ($bs in $blocksizes) {
    foreach ($tier in $tiers) {
        foreach ($jobtype in $jobtypes) {
            $job = 1
            do {
                write-host "starting $jobtype ramp up test for the $tier"
                $job
                if ($tier -eq "zfs") {
                    fio --name=$jobtype --rw=$jobtype --direct=1 --ioengine=windowsaio --bs=$bs --numjobs=$job --iodepth=128 --size=20G --runtime=600 --group_reporting --output=zfs_"$job"_"$bs"_"$jobtype".txt --output-format=normal,terse --thread --stonewall --filename=\\172.23.8.4\data\Common\fiotestfile20G
                    sleep -Seconds 3        
                }
                else {
                    fio --name=$jobtype --rw=$jobtype --direct=1 --ioengine=windowsaio --bs=$bs --numjobs=$job --iodepth=128 --size=20G --runtime=600 --group_reporting --output=anf"$tier"_"$job"_"$bs"_"$jobtype".txt --output-format=normal,terse --thread --stonewall --filename=\\fileserver-664b.dev.pts.com\$tier\fiotestfile20G
                    sleep -Seconds 3
                }
                $job ++
            } until ($job -ge 10)    
        }
    }
}
/#>
Start-Transcript -Path C:\temp\FIOResults\Transcscript_$TimeStamp.txt -Append
cd C:\temp\FIOResults
foreach ($bs in $blocksizes) {
    foreach ($tier in $tiers) {
        foreach ($jobtype in $jobtypes) {            
            if ($tier -eq "zfs") {
                write-host "Starting $jobtype ramp up test for the $tier blocksize $bs at $(Get-Date -Format 'yyyyMMdd_HHmm')"
                $job = 1
                do {
                    write-host "Job number $job started at $(Get-Date -Format 'yyyyMMdd_HHmm')"
                    fio --name=$jobtype --rw=$jobtype --direct=1 --ioengine=windowsaio --bs=$bs --numjobs=$job --iodepth=128 --size=20G --runtime=600 --group_reporting --output=zfs_"$job"_"$bs"_"$jobtype".txt --output-format=normal,terse --thread --stonewall --filename=\\172.23.8.4\data\Common\fiotestfile20G
                    sleep -Seconds 3
                    $job ++
                } until ($job -gt 10)          
            }
            else {
                write-host "Starting $jobtype ramp up test for the $tier blocksize $bs at $(Get-Date -Format 'yyyyMMdd_HHmm')"
                $job = 1
                do {
                    write-host "Job number $job started at $(Get-Date -Format 'yyyyMMdd_HHmm')"
                    fio --name=$jobtype --rw=$jobtype --direct=1 --ioengine=windowsaio --bs=$bs --numjobs=$job --iodepth=128 --size=20G --runtime=600 --group_reporting --output=anf"$tier"_"$job"_"$bs"_"$jobtype".txt --output-format=normal,terse --thread --stonewall --filename=\\fileserver-664b.dev.pts.com\$tier\fiotestfile20G
                    sleep -Seconds 3
                    $job ++
                } until ($job -gt 10) 
            }
 
        }
    }
}
Stop-Transcript