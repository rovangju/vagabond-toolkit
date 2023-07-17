#START=$(gdate +%s%3N)
# Eliminate Software Flow Control (XON/XOFF flow control)
stty -ixon

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -d /opt/homebrew/bin ]] || export PATH=/opt/homebrew/bin:$(/opt/homebrew/bin/brew --prefix)/opt/coreutils/libexec/gnubin:${PATH}
[[ ! -d ${HOME}/.docker/bin ]] || export PATH=${HOME}/.docker/bin:${PATH}
[[ ! -f /usr/local/share/antigen/antigen.zsh ]] || source /usr/local/share/antigen/antigen.zsh
[[ ! -f /usr/share/zsh-antigen/antigen.zsh ]] || source /usr/share/zsh-antigen/antigen.zsh
[[ ! -f /opt/homebrew/share/antigen/antigen.zsh ]] || source /opt/homebrew/share/antigen/antigen.zsh

alias kcgp="kubectl get pods -owide |awk '{print \$7 , \$1 , \$2 , \$3 , \$4 }' |sort |column -t"
alias ls="ls --color"
alias grw="./gradlew"
alias vimhosts="sudo vi /private/etc/hosts"
alias fdate="date +\"%Y%m%dT%H%M%S\""

antigen use oh-my-zsh
antigen bundle git # helpers like glo, gd, gs, gp, etc.
antigen bundle aliases # 'acs' - lists groups of aliases so you know what's aliased from where
antigen bundle terraform # Adds tf, tfv, tfa, tfp, tfc, tfd, etc helpers.
antigen bundle agkozak/zsh-z # add "z" command :P
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle wfxr/forgit
antigen bundle kubermatic/fubectl
antigen bundle rovangju/fzf-brew

antigen theme romkatv/powerlevel10k
antigen apply

export EDITOR=vim
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*'"

if test -d "$HOME/.kube/configs"; then
	for file in $(find $HOME/.kube/configs -type f); do
		export KUBECONFIG="$KUBECONFIG:$file"
	done
fi

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
[[ ! -d ~/go/bin ]] || export PATH=$PATH:~/go/bin
[[ ! -f ${HOME}/.kustomize ]] || source ${HOME}/.kustomize
[[ ! -d ${HOME}/.krew ]] || export PATH=${HOME}/.krew/bin:${PATH}


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

awsp() {
	local profile=$(aws configure list-profiles | sort | fzf --height="30%" --header="PROFILES" --prompt "Filter >" --reverse)
	export AWS_PROFILE=$profile
}
awsl() {
	awsp
	aws sso login --profile "${AWS_PROFILE}"
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
#eval "$(jenv init -)"

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

# Keep this before fzf 
bindkey -v
export keytimeout=1

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/vault vault

# Enable vim mode cursor changing 
cursor_mode() {
		# See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
		cursor_block='\e[2 q'
		cursor_beam='\e[6 q'

		function zle-keymap-select {
				if [[ ${KEYMAP} == vicmd ]] ||
						[[ $1 = 'block' ]]; then
						echo -ne $cursor_block
				elif [[ ${KEYMAP} == main ]] ||
						[[ ${KEYMAP} == viins ]] ||
						[[ ${KEYMAP} = '' ]] ||
						[[ $1 = 'beam' ]]; then
						echo -ne $cursor_beam
				fi
		}

		zle-line-init() {
				echo -ne $cursor_beam
		}

		zle -N zle-keymap-select
		zle -N zle-line-init
}

cursor_mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# https://thevaluable.dev/zsh-install-configure-mouseless/
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
	bindkey -M $km -- '-' vi-up-line-or-history
	for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
		bindkey -M $km $c select-quoted
	done
	for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
		bindkey -M $km $c select-bracketed
	done
done
