configuration CreateFile
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
                Write-Host "fadfda"
            })
        }
    }
}
CreateFile