function ConvertEpochTimeInMilliseconds
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $EpochTimeStampStart,
        [Parameter(Mandatory=$true)]
        [string]
        $EpochTimeStampEnd
    )

    $epochStart = Get-Date 01.01.1970
    $TimeStart = ($epochStart + ([System.TimeSpan]::frommilliseconds($EpochTimeStampStart))).ToLocalTime()
    $TimeEnd = ($epochStart + ([System.TimeSpan]::frommilliseconds($EpochTimeStampEnd))).ToLocalTime()

    Return $TimeStart,$TimeEnd
}

$uri = "https://api.awattar.at/v1/marketdata"
$Result = Invoke-RestMethod -Uri $uri -SkipCertificateCheck

$Datatable = New-Object System.Data.DataTable
$Datatable.Columns.Add("StartZeit") | Out-Null
$Datatable.Columns.Add("EndZeit") | Out-Null
$Datatable.Columns.Add("Tarif €-Cent") | Out-Null

foreach ($entry in $Result.data)
{
    $TimeSpan = ConvertEpochTimeInMilliseconds -EpochTimeStampStart $entry.start_timestamp -EpochTimeStampEnd $entry.end_timestamp
    $Row = $Datatable.NewRow()
    $row.StartZeit = $TimeSpan[0]
    $row.EndZeit = $TimeSpan[1]
    $row.'Tarif €-Cent' = ([Math]::Round(($Entry.marketprice/10),2))
    $Datatable.Rows.Add($Row)
}
$Datatable