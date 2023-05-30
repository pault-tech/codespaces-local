#Utility helper script to run codespaces locally

orgrepo="microsoft/vscode-remote-try-rust"
repo=`basename $orgrepo`
dotfiles="pault-tech/dotfiles.git"

docker ps -a | grep -q csl && \
sleep 2 \
echo connecting to existing local codespace && \
docker exec -it --user vscode csl /bin/bash && exit

echo creating codespaces local

ls $repo || git clone https://github.com/$orgrepo
devcontainer up --workspace-folder $repo

dc=`docker ps -q --latest`
# docker ps --format json --filter 'Image=vsc*' | jq
docker rename $dc csl

#TODO copy git key

docker exec -it --user vscode csl /bin/bash -c "cd ~/ && git clone https://github.com/$dotfiles && dotfiles/setup.sh"

docker exec -it --user vscode csl /bin/bash -c 'cd ~/ && git clone https://github.com/pault-tech/dotfiles-spacemacs.git && dotfiles-spacemacs/setup.sh'

docker exec -it --user vscode csl /bin/bash
