#Utility helper script to run codespaces locally

# orgrepo="microsoft/vscode-remote-try-rust"
orgrepo="$1"
repo=`basename $orgrepo`
# dotfiles="pault-tech/dotfiles.git"
dotfiles="$2"

docker ps -a | grep -q csl && \
sleep 2 \
echo connecting to existing local codespace && \
docker exec -it --user vscode csl /bin/bash && exit

echo creating codespaces local

ls $repo || git clone https://github.com/$orgrepo

#TODO: devcontainer templates apply -t ghcr.io/devcontainers/templates/ruby-rails-postgres:latest
ls $repo/.devcontainer || ( echo missing $repo/.devcontainer use devcontainer templates apply. exiting... && exit )
devcontainer up --workspace-folder $repo

dc=`docker ps -q --latest`
# docker ps --format json --filter 'Image=vsc*' | jq
docker rename $dc csl

#TODO copy git key

docker exec -it --user vscode csl /bin/bash -c "cd ~/ && git clone https://github.com/$dotfiles && dotfiles/setup.sh"
# docker exec -it --user vscode csl /bin/bash -c "cd ~/ && curl -fsSL https://code-server.dev/install.sh | sh"

docker exec -it --user vscode csl /bin/bash

function install_devcontainer_cli {

  sudo apt update
  sudo apt install npm
  sudo npm install -g @devcontainers/cli
  
}
