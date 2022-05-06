$blocksizes = @("4k","8k","64k","256k","2048MB")
$tiers= @("premium1")
$Jobtypes1 = @("readwrite")
$Jobtypes2 = @("read","randread","write","randwrite","randrw","readwrite")
$TimeStamp = Get-Date -Format 'yyyyMMdd_HHmm'

Start-Transcript -Path C:\temp\FIOResults\Transcscript_$TimeStamp.txt -Append
cd C:\temp\FIOResults
foreach ($bs in $blocksizes) {
    if ($bs -eq "4k") {
        foreach ($tier in $tiers) {
            foreach ($jobtype in $jobtypes1) {
                write-host "Starting $jobtype ramp up test for the $tier blocksize $bs at $(Get-Date -Format 'yyyyMMdd_HHmm')"
                $job = 5
                do {
                    write-host "Job number $job started at $(Get-Date -Format 'yyyyMMdd_HHmm')"
                    fio --name=$jobtype --rw=$jobtype --direct=1 --ioengine=windowsaio --bs=$bs --numjobs=$job --iodepth=128 --size=20G --runtime=600 --group_reporting --output=anf"$tier"_"$job"_"$bs"_"$jobtype".txt --output-format=normal,terse --thread --stonewall --filename=\\fileserver-664b.dev.pts.com\$tier\fiotestfile20G
                    sleep -Seconds 3
                    $job ++
                } until ($job -gt 10) 
            }
        }
    }
    else {
        foreach ($tier in $tiers) {
            foreach ($jobtype in $jobtypes2) {            
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