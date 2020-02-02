Describe "Calendar" {
    Context "New-UDCalendar" {
        Set-TestDashboard {
            $Sessions = (Invoke-Restmethod http://powershell.fun) | ForEach-Object {
                @{
                    title = $_.Name
                    desc = $_.Speaker + [Environment]::NewLine + $_.Description
                    start = $_.Starts
                    end = $_.Ends
                }
            }

            New-UDCalendar -Events $Sessions
        }
    }
}