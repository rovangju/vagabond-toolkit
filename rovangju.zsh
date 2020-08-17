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
