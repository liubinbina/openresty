if (( $+commands[$KUBECTL] )); then
    __KUBECTL_COMPLETION_FILE="${HOME}/.zsh_cache/kubectl_completion"

    if [[ ! -f $__KUBECTL_COMPLETION_FILE ]]; then
        mkdir -p ${HOME}/.zsh_cache
        eval $KUBECTL completion zsh >! $__KUBECTL_COMPLETION_FILE
    fi

    [[ -f $__KUBECTL_COMPLETION_FILE ]] && source $__KUBECTL_COMPLETION_FILE

    unset __KUBECTL_COMPLETION_FILE
fi

# This command is used a LOT both below and in daily life
alias k=$KUBECTL
alias kg="$KUBECTL get"
alias kd="$KUBECTL describe"
alias ke="$KUBECTL edit"
alias kc="$KUBECTL create"

# Apply a YML file
alias kaf="$KUBECTL apply -f"
# Apply resources from a directory containing kustomization.yaml
alias kak="$KUBECTL apply -k"

# Drop into an interactive terminal on a container
alias keti="$KUBECTL exec -ti"
alias kat="$KUBECTL exec -ti"

# Manage configuration quickly to switch contexts between local, dev ad staging.
alias kcuc="$KUBECTL config use-context"
alias kcsc="$KUBECTL config set-context"
alias kcdc="$KUBECTL config delete-context"
alias kccc="$KUBECTL config current-context"

# List all contexts
alias kcgc="$KUBECTL config get-contexts"

# General aliases
alias kdel="$KUBECTL delete"
alias kdelf="$KUBECTL delete -f"
alias kdelk="$KUBECTL delete -k"

# Pod management.
alias kgp="$KUBECTL get pods"
alias kgpw="kgp --watch"
alias kgpwide="kgp -o wide"
alias kep="$KUBECTL edit pods"
alias kdp="$KUBECTL describe pods"
alias kdelp="$KUBECTL delete pods"

# get pod by label: kgpl "app=myapp" -n myns
alias kgpl="kgp -l"

# Service management.
alias kgs="$KUBECTL get svc"
alias kgsw="kgs --watch"
alias kgswide="kgs -o wide"
alias kes="$KUBECTL edit svc"
alias kds="$KUBECTL describe svc"
alias kdels="$KUBECTL delete svc"

# Ingress management
alias kgi="$KUBECTL get ingress"
alias kei="$KUBECTL edit ingress"
alias kdi="$KUBECTL describe ingress"
alias kdeli="$KUBECTL delete ingress"

# Namespace management
alias kgns="$KUBECTL get namespaces"
alias kens="$KUBECTL edit namespace"
alias kdns="$KUBECTL describe namespace"
alias kcns="$KUBECTL create namespace"
alias kdelns="$KUBECTL delete namespace"
alias kcn="$KUBECTL config set-context \$($KUBECTL config current-context) --namespace"

# ConfigMap management
alias kgcm="$KUBECTL get configmaps"
alias kecm="$KUBECTL edit configmap"
alias kdcm="$KUBECTL describe configmap"
alias kdelcm="$KUBECTL delete configmap"

# Secret management
alias kgsec="$KUBECTL get secret"
alias kdsec="$KUBECTL describe secret"
alias kdelsec="$KUBECTL delete secret"

# Deployment management.
alias kgd="$KUBECTL get deployment"
alias kgdw="kgd --watch"
alias kgdwide="kgd -o wide"
alias ked="$KUBECTL edit deployment"
alias kdd="$KUBECTL describe deployment"
alias kdeld="$KUBECTL delete deployment"
alias ksd="$KUBECTL scale deployment"
alias krsd="$KUBECTL rollout status deployment"
kres(){
    $KUBECTL set env $@ REFRESHED_AT=$(date +%Y%m%d%H%M%S)
}

# Rollout management.
alias kgrs="$KUBECTL get rs"
alias krh="$KUBECTL rollout history"
alias kru="$KUBECTL rollout undo"

# Statefulset management.
alias kgss="$KUBECTL get statefulset"
alias kgssw="kgss --watch"
alias kgsswide="kgss -o wide"
alias kess="$KUBECTL edit statefulset"
alias kdss="$KUBECTL describe statefulset"
alias kdelss="$KUBECTL delete statefulset"
alias ksss="$KUBECTL scale statefulset"
alias krsss="$KUBECTL rollout status statefulset"

# Port forwarding
alias kpf="$KUBECTL port-forward"

# Tools for accessing all information
alias kga="$KUBECTL get all"
alias kgaa="$KUBECTL get all --all-namespaces"

# Logs
alias kl="$KUBECTL logs"
alias klf="$KUBECTL logs -f"

# File copy
alias kcp="$KUBECTL cp"

# Node Management
alias kgno="$KUBECTL get nodes"
alias keno="$KUBECTL edit node"
alias kdno="$KUBECTL describe node"
alias kdelno="$KUBECTL delete node"

# PVC management.
alias kgpvc="$KUBECTL get pvc"
alias kgpvcw="kgpvc --watch"
alias kepvc="$KUBECTL edit pvc"
alias kdpvc="$KUBECTL describe pvc"
alias kdelpvc="$KUBECTL delete pvc"

# top
alias ktn="$KUBECTL top node"
alias ktp="$KUBECTL top pod"

if (( $+commands[helm] )); then
    __HELM_COMPLETION_FILE="${HOME}/.zsh_cache/helm_completion"

    if [[ ! -f $__HELM_COMPLETION_FILE ]]; then
        helm completion zsh >! $__HELM_COMPLETION_FILE
    fi

    [[ -f $__HELM_COMPLETION_FILE ]] && source $__HELM_COMPLETION_FILE

    unset __HELM_COMPLETION_FILE
fi
