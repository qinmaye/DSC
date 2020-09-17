configuration DSC
{
    param
    (
        [string[]]$Nodename = $env:computername
    )
    node $NodeName
    {
        Script test {
            GetScript  = {
                return @{
                    SetScript  = $SetScript
                    TestScript = $TestScript
                    GetScript  = $GetScript
                }
            }
            TestScript = { $false }
            SetScript  = ([String] {
                Invoke-WebRequest -Uri https://github.com/qinmaye/DSC/raw/master/Monitoring.zip -OutFile C:\Monitoring.zip
                Expand-Archive -Path 'C:\Monitoring.zip' -DestinationPath 'C:\'
                $BaseMonitoringPath = Join-Path -Path "C:\" -ChildPath "Monitoring"
                $TaskAction = New-ScheduledTaskAction -Execute (Join-Path -Path $BaseMonitoringPath -ChildPath "runagent.cmd")
                $TaskTrigger = New-ScheduledTaskTrigger -AtStartup
                $TaskPricipal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
                $TaskSetting = New-ScheduledTaskSettingsSet -ExecutionTimeLimit '00:00:00' -RunOnlyIfNetworkAvailable -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
                Register-ScheduledTask "StartAzSecPack" -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPricipal -Settings $TaskSetting
                Start-ScheduledTask -TaskName "StartAzSecPack"
                Write-Output "Sleep 60s to wait Azsecpack"
                Start-Sleep -Seconds 60
            })
        }
    }
}
DSC