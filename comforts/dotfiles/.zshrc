# Eliminate Software Flow Control (XON/XOFF flow control)
stty -ixon

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias kcgp="kubectl get pods -owide |awk '{print \$7 , \$1 , \$2 , \$3 , \$4 }' |sort |column -t"
alias lzd="lazydocker"
alias dcp="docker-compose"
alias art="php artisan"
alias grw="./gradlew"
alias vimhosts="sudo vi /private/etc/hosts"
alias fdate="date +\"%Y%m%dT%H%M%S\""

[[ ! -f /usr/local/share/antigen/antigen.zsh ]] || source /usr/local/share/antigen/antigen.zsh
[[ ! -f /usr/share/zsh-antigen/antigen.zsh ]] || source /usr/share/zsh-antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle docker
antigen bundle docker-compose
antigen bundle gradle
antigen bundle mvn
antigen bundle npm
antigen bundle git-flow
antigen bundle jenv

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

antigen bundle kubermatic/fubectl

antigen theme romkatv/powerlevel10k


antigen apply

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/.os.zsh ]] || source ~/.os.zsh
[[ ! -f ~/.vim/plugged/fzf/shell/key-bindings.zsh ]] || source ~/.vim/plugged/fzf/shell/key-bindings.zsh
[[ ! -f ~/.vim/plugged/fzf/shell/completion.zsh ]] || source ~/.vim/plugged/fzf/shell/completion.zsh

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
