# ud-calendar

Calendar for Universal Dashboard

# Installation

```
Install-Module UniversalDashboard.Calendar
```

# Example

```
$Sessions = (Invoke-Restmethod http://powershell.fun) | ForEach-Object {
    @{
        title = $_.Name
        desc = $_.Speaker + [Environment]::NewLine + $_.Description
        start = $_.Starts
        end = $_.Ends
    }
}

New-UDCalendar -Events $Sessions
```

![](./images/calendar.png)