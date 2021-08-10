#START=$(gdate +%s%3N)
# Eliminate Software Flow Control (XON/XOFF flow control)
stty -ixon

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias kcgp="kubectl get pods -owide |awk '{print \$7 , \$1 , \$2 , \$3 , \$4 }' |sort |column -t"
alias lzd="lazydocker"
alias dcp="docker-compose"
alias grw="./gradlew"
alias vimhosts="sudo vi /private/etc/hosts"
alias fdate="date +\"%Y%m%dT%H%M%S\""
alias tf="terraform" 


[[ ! -d /opt/homebrew/bin ]] || export PATH=$PATH:/opt/homebrew/bin

[[ ! -f /usr/local/share/antigen/antigen.zsh ]] || source /usr/local/share/antigen/antigen.zsh
[[ ! -f /usr/share/zsh-antigen/antigen.zsh ]] || source /usr/share/zsh-antigen/antigen.zsh
[[ ! -f /opt/homebrew/share/antigen/antigen.zsh ]] || source /opt/homebrew/share/antigen/antigen.zsh
[[ ! -f $HOME/.kustomize ]] || source $HOME/.kustomize

antigen use oh-my-zsh

antigen bundle git
antigen bundle docker
antigen bundle docker-compose
antigen bundle gradle
antigen bundle mvn
antigen bundle npm
antigen bundle git-flow
# this is absurdly slow ...
#antigen bundle jenv

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

antigen bundle wfxr/forgit
antigen bundle kubermatic/fubectl


antigen theme romkatv/powerlevel10k
antigen apply

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:${HOME}/bin:$PATH"
export EDITOR=vim
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*'"

if command -v most > /dev/null 2>&1; then
	export PAGER="most"
fi

if command -v jenv > /dev/null 2>&1; then
	export PATH="$HOME/.jenv/shims:${PATH}"
	jhome() {
		export JAVA_HOME=$(jenv javahome)
	}
fi

if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
	autoload -Uz compinit
	compinit
fi


BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
	eval "$("$BASE16_SHELL/profile_helper.sh")"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.os.zsh ]] || source ~/.os.zsh
[[ ! -f ~/.vim/plugged/fzf/shell/key-bindings.zsh ]] || source ~/.vim/plugged/fzf/shell/key-bindings.zsh
[[ ! -f ~/.vim/plugged/fzf/shell/completion.zsh ]] || source ~/.vim/plugged/fzf/shell/completion.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

wx() {
	# change Paris to your default location
	local request="wttr.in/${1-West%20Fargo}"
	[ "$(tput cols)" -lt 125 ] && request+='?n'
	curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

# https://docs.microsoft.com/en-us/cli/azure/ext/azure-devops/repos/pr?view=azure-cli-latest#ext_azure_devops_az_repos_pr_create
aprl() {
	az repos pr list --output table --project ${@}
	# @TODO: Make more fancy with jq
}

aprc() {
	# @TODO: reviewers ?
	az repos pr create \
		--draft \
		--open \
		--squash \
		--target-branch ${@}
	}

apro() {
	# @TODO: Use FZF with list
	[[ ! ${1} ]] && echo "Pull request ID required (try aprl)" && return 1;

	az repos pr show \
		--id ${1} \
		--open \
		--output none
	}

unalias gcb
gcb() {
	git for-each-ref --format="%(refname:short)" | fzf | sed 's/\* //g' | xargs -I '{}' git switch -c \{\}
}

git-publish() {

branch=$(git rev-parse --abbrev-ref HEAD)

[[ ! ${branch} ]] && echo "No branch detected" && return 1;

echo -n "Publish and track branch: ${branch}? [yes|*]"
read answer

case ${answer} in
	"yes" ) ;;
	*) return 1;;
esac

git push origin ${branch}:${branch}
git branch ${branch} --set-upstream-to origin/${branch}
}
#END=$(gdate +%s%3N)
#DIFF=$(( $END - $START ))
#echo "init: $DIFF ms"
eval "$(jenv init -)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

