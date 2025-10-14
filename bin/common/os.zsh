up () {
	if [[ ${1:-} == .git ]]
	then
		uptogit
		return
	fi
	newdir="${PWD%/*}"
	until [[ $newdir == "" ]] || [[ ${newdir##*/} =~ ${1:-.} ]]
	do
		newdir=${newdir%/*}
	done
	if [[ $newdir == "" ]] || [[ $newdir == "/" ]]
	then
		echo "Could not find match for $1" >&2
		return 1
	fi
	cd "$newdir"
}

down () {
	local dest
	dest=$( find . -not -name "." -name ".*" -prune -o -type d -print | fzf --select-1 --query "${*}" )
	if [[ -z "$dest" ]]
	then
		return 1
	fi
	echo "cd $( readlink -f $dest )" >&2
	cd "$dest"
}
