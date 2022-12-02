Add-Type -assembly "Microsoft.Office.Interop.Outlook"
$outlook = New-Object -ComObject Outlook.Application
$ns = $outlook.GetNamespace("MAPI")
$olFolders = "Microsoft.Office.Interop.Outlook.OlDefaultFolders" -as [type]
$calendar = $ns.GetDefaultFolder($olFolders::olFolderCalendar)
$exporter = $calendar.GetCalendarExporter()
$olCalendarDetail = "Microsoft.Office.Interop.Outlook.OlCalendarDetail" -as [type]
$exporter.CalendarDetail = $olCalendarDetail::olFullDetails
$exporter.IncludePrivateDetails = $true
$exporter.IncludeWholeCalendar = $true
$exporter.SaveAsICal("$HOME\wawa-cal.ics")

C:\WINDOWS\system32\wsl.exe --exec bash -c 'export AWS_CONFIG_FILE=~/winhome/.aws/config.personal-cal; aws s3 cp ~/winhome/wawa-cal.ics s3://jbenner-misc-public/wawa-cal-vahL7roh.ics'
