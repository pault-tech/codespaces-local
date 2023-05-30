#Utility helper script to run codespaces locally

docker ps -a | grep -q csl && \
sleep 2 \
echo connecting to existing local codespace && \
docker exec -it --user vscode csl /bin/bash && exit

echo creating codespaces local

git clone https://github.com/microsoft/vscode-remote-try-rust
devcontainer up --workspace-folder vscode-remote-try-rust

dc=`docker ps -q --latest`
# docker ps --format json --filter 'Image=vsc*' | jq
docker rename $dc csl

#TODO copy git key

docker exec -it --user vscode csl /bin/bash -c 'cd ~/ && git clone https://github.com/pault-tech/dotfiles.git && dotfiles/setup.sh'

docker exec -it --user vscode csl /bin/bash -c 'cd ~/ && git clone https://github.com/pault-tech/dotfiles-spacemacs.git && dotfiles-spacemacs/setup.sh'

docker exec -it --user vscode csl /bin/bash
