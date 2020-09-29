# Aliases for oh-my-zsh custom dir ($ZSH/custom)
alias kcgp="kubectl get pods -owide |awk '{print \$7 , \$1 , \$2 , \$3 , \$4 }' |sort |column -t"
alias kc="kubectl"
alias kcg="kubectl get"
alias kcd="kubectl describe"
alias kce="kubectl edit"
alias kcns="kubectl config set-context --current --namespace"
alias lzd="lazydocker"
alias dcp="docker-compose"
alias art="php artisan"
alias grw="./gradlew"
alias vimhosts="sudo vi /private/etc/hosts"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="/Users/jusrov/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git docker docker-compose kubectl gradle mvn npm git-flow composer jenv)

source $ZSH/oh-my-zsh.sh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /Users/jusrov/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/jusrov/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
