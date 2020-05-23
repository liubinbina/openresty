if (( $+commands[kubectl] )); then
    export KUBECTL=${KUBECTL:-kubectl}
elif (( $+commands[k3s] )); then
    export KUBECTL=${KUBECTL:-k3s kubectl}
elif (( $+commands[microk8s.kubectl] )); then
    export KUBECTL=${KUBECTL:-microk8s.kubectl}
fi


if [ ! -z $KUBECTL ]; then
    source $CFG/.zshrc.d/k8s/kubectl.zsh
    source $CFG/.zshrc.d/k8s/kube-ps1.zsh

    export KUBE_EDITOR=vim

    if (( $+commands[k3d] )); then
        export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"
    elif (( $+commands[k3s] )); then
        export KUBECONFIG=~/.local/etc/rancher/k3s/k3s.yaml
        # sudo k3s server --docker --no-deploy traefik
    fi

    if [[ ! "$PATH" == */opt/cni/bin* && -d /opt/cni/bin ]]; then
        export PATH=/opt/cni/bin:$PATH
    fi

    function clean-evicted-pod {
        $KUBECTL get pods --all-namespaces -ojson \
          | jq -r '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | .metadata.name + " " + .metadata.namespace' \
          | xargs -n2 -l bash -c "$KUBECTL delete pods \$0 --namespace=\$1"
    }

fi
