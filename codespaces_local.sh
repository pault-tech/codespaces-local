#Utility helper script to run codespaces locally

function devcontainer_up_docker_exec {

type devcontainer || ( echo devcontainer cli not found exiting... && exit )

# orgrepo="microsoft/vscode-remote-try-rust"
orgrepo="$1"
repo=`basename $orgrepo`
# dotfiles="pault-tech/dotfiles.git"
dotfiles="$2"

USERARG="--user codespace"
USERARG="--user vscode"

docker ps -a | grep -q csl && \
sleep 2 \
echo connecting to existing local codespace && \
docker exec -it $USERARG csl /bin/bash && exit

echo creating codespaces local

ls $repo || git clone https://github.com/$orgrepo

#TODO: devcontainer templates apply -t ghcr.io/devcontainers/templates/ruby-rails-postgres:latest
ls $repo/.devcontainer || ( echo missing $repo/.devcontainer use devcontainer templates apply. exiting... && exit )
devcontainer up --workspace-folder $repo

dc=`docker ps -q --latest`
# docker ps --format json --filter 'Image=vsc*' | jq
docker rename $dc csl

#TODO copy git key

# TODO: set user arg dynamically
# docker exec -it csl cat /etc/passwd | grep vscode && USERARG="--user vscode"

docker exec -it $USERARG csl /bin/bash -c "cd ~/ && git clone https://github.com/$dotfiles && dotfiles/setup.sh sup"
# docker exec -it $USERARG csl /bin/bash -c "cd ~/ && curl -fsSL https://code-server.dev/install.sh | sh"

docker exec -it $USERARG csl /bin/bash

}

function install_devcontainer_cli {

#option 1
 curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
  sudo apt-get install -y nodejs
  sudo npm install -g @devcontainers/cli

cd /workspaces/
codespaces-local/codespaces_local.sh pault-tech/devcontainer-ubuntu pault-tech/dotfiles.git    

#option 2 
  # sudo apt update
  # sudo apt install npm -y
  # sudo npm install -g @devcontainers/cli
  
}



#main
devcontainer_up_docker_exec $@
