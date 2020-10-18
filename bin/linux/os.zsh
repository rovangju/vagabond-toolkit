if command -v iptables > /dev/null 2>&1; then
	alias ipt-ls='sudo iptables -L -n --line-num -v'
fi


if ! command -v pbcopy > /dev/null 2>&1; then

	if command -v clipcopy > /dev/null 2>&1; then
		alias pbcopy='clipcopy'
		alias pbpaste='clippaste'	
	fi
 	else if command -v xclip > /dev/null 2>&1; then
		alias pbcopy='xclip -selection clipboard'
		alias pbpaste='xclip -selection clipboard -o'
	fi
	
fi
