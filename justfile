test tag="latest":
    docker run --rm \
        --name=test \
        -p 8090:80 \
        -p 8022:22 \
        -v $(pwd):/app \
        -v vscode-server:/root/.vscode-server \
        -e WEB_ROOT=/app \
        -v $PWD/id_ed25519.pub:/etc/authorized_keys/root \
        nnurphy/or