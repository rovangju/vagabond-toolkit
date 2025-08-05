if command -v iptables > /dev/null 2>&1; then
	alias ipt-ls='sudo iptables -L -n --line-num -v'
fi


if ! command -v pbcopy > /dev/null 2>&1; then

	if command -v clipcopy > /dev/null 2>&1; then
		alias pbcopy='clipcopy'
		alias pbpaste='clippaste'	
	fi
	if command -v clip.exe > /dev/null 2>&1; then
		alias pbcopy='clip.exe'
		alias pbpaste="powershell.exe Get-Clipboard | tr -d '\r'"
 	else if command -v xclip > /dev/null 2>&1; then
		alias pbcopy='xclip -selection clipboard'
		alias pbpaste='xclip -selection clipboard -o'
	fi
fi
