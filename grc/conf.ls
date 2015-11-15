# size
regexp=(\s|^)\d+([.,]\d+)?\s?([kKMG][bB]|[bB]|[kKMG])(?=[\s,]|$)
colours=yellow
=======
# time
regexp=(\s|^)\d+(:\d+)+(?=[\s,]|$)
colours=bold green
=======
# mounth
regexp=\s[a-z]{3}\s
colours=yellow
=======
#regexp=(?<=\d):(?=\d)
#colours=bold yellow
#=======
# root
regexp=root|wheel(?=\s|$)
colours=bold red
=======
# -rwxrwxrwx 
regexp=(-|([bcCdDlMnpPs?]))(?=[-r][-w][-xsStT][-r][-w][-xsStT][-r][-w][-xsStT])
colours=unchanged,unchanged,bold blue
=======
# Dir names blue
regexp=d[-r][-w][-xsStT][-r][-w][-xsStT][-r][-w][-xsStT] +.+? +.+? +.+? +.+? +.+? +.+? +.+? (.+)
colours=unchanged,bold blue
=======
# Symlinks
regexp=(l)[-r][-w][-xsStT][-r][-w][-xsStT][-r][-w][-xsStT] +.+? +.+? +.+? +.+? +.+? +.+? +.+? (.+) (->) (.+)
colours=unchanged,bold cyan,bold cyan,bold yellow,bold magenta
=======
# User perms.
regexp=(?<=[-bcCdDlMnpPs?])(-|(r))(-|(w))(-|([xsStT]))(?=[-r][-w][-xsStT][-r][-w][-xsStT])
colours=unchanged,unchanged,bold green,unchanged,bold green,unchanged,bold green
=======
# Group perms.
regexp=(?<=[-bcCdDlMnpPs?][-r][-w][-xsStT])(-|(r))(-|(w))(-|([xsStT]))(?=[-r][-w][-xsStT])
colours=unchanged,unchanged,bold yellow,unchanged,bold yellow,unchanged,bold yellow
=======
# Other perms.
regexp=(?<=[-bcCdDlMnpPs?][-r][-w][-xsStT][-r][-w][-xsStT])(-|(r))(-|(w))(-|([xsStT]))
colours=unchanged,unchanged,bold red,unchanged,bold red,unchanged,bold red
