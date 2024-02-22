# From https://stackoverflow.com/questions/1059663/is-there-a-way-to-wordwrap-results-of-a-powershell-cmdlet
function wrapText( $text, $width=50 )
{
    $words = $text -split "\s+"
    $col = 0
    $lines = ""
    foreach ( $word in $words )
    {
        $col += $word.Length + 1
        if ( $col -gt $width )
        {
            $lines += "`n  "
            $col = $word.Length + 1
        }
        $lines += "$word "
    }
    return $lines
}

Add-Type -assembly "Microsoft.Office.Interop.Outlook"
$outlook = New-Object -ComObject Outlook.Application
$ns = $outlook.GetNamespace("MAPI")
$olFolders = "Microsoft.Office.Interop.Outlook.OlDefaultFolders" -as [type]
$calendar = $ns.GetDefaultFolder($olFolders::olFolderCalendar)

$start = [DateTime]::Now.AddDays(-1)
$startStr = $start.ToString("g")
$end = $start.AddDays(14)
$endStr = $end.ToString("g")
$dateFilter = "[Start] >= '$startStr' AND [Start] <= '$endStr'"
$items = $calendar.items
$items.IncludeRecurrences = $true
$items.Sort("[Start]")
$itemsInDateRange = $items.Restrict($dateFilter)

$icsDateFormat = "yyyyMMddTHHmmssZ"

$ics = @"
BEGIN:VCALENDAR
PRODID:-//joshbenner//export-cal2.ps1//EN
VERSION:2.0
METHOD:PUBLISH

"@

foreach ($item in $itemsInDateRange) {
    if ($item.Subject -in ("Reserved", "Stop")) { continue }
    $subject = wrapText "$($item.Subject)"
    $location = wrapText "$($item.Location)"
    $ics += @"
BEGIN:VEVENT
UID:$([guid]::NewGuid())
CREATED:$($item.CreationTime.ToUniversalTime().ToString($icsDateFormat))
DTSTAMP:$($item.CreationTime.ToUniversalTime().ToString($icsDateFormat))
LAST-MODIFIED:$($item.LastModificationTime.ToUniversalTime().ToString($icsDateFormat))
CLASS:PUBLIC
SEQUENCE:0
DTSTART:$($item.Start.ToUniversalTime().ToString($icsDateFormat))
DTEND:$($item.End.ToUniversalTime().ToString($icsDateFormat))
SUMMARY:$subject
LOCATION:$location
TRANSP:OPAQUE
END:VEVENT

"@
}

$ics += @"
END:VCALENDAR
"@

[System.IO.File]::WriteAllLines("$HOME\outlook-min-export.ics", $ics)
