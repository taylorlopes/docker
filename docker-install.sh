#!/bin/bash

###############################################################################
#
# Intall Docker and Docker-compose on Linux SO
#
# @version 1.0.5
# @license MIT License
#
# Copyright (c) 2022 Taylor Lopes <taylorlopes@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
###############################################################################

# Input valid arguments
ARG=
while getopts 'dh' opt; do
  case "$opt" in
    d)
      ARG='d'
      ;;
    ?|h)
      echo -e "\n\033[1mEste script tem por finalidade: \033[0m" 
      echo -e "- Instalar a versao atual do Docker em SO Linux"
      echo -e "- Adicionar o usuario corrente ao grupo Docker"
      echo -e "- Inicializar o daemon Docker"
      echo -e "- Instalar o Docker-compose"
      echo -e "- Exibir a versao instalada do Docker/Compose\n"         
      echo -e "\033[1mModo de uso:\033[0m ./$(basename $0) [-d] [-h]"
      echo -e "[-d] Debug: exibe detalhes do processamento"
      echo -e "[-h] Ajuda: exibe ajuda\n"
      echo -e "\033[1mObservacoes importantes: \033[0m"
      echo -e "- Compativel com distribuicoes Linux Debian e variantes"
      echo -e "- O usuario corrente deve ter privilegios sudo"
      echo -e "- Pode ser necessario remover instalacoes antigas"
      echo -e "- Ao finalizar, reiniciar ou fazer logout/login\n"
      exit 1
      ;;
  esac
done 

# Bootstrap (http://patorjk.com/software/taag/#p=display&f=Ivrit&t=Docker)
echo -e "
  ____             _             
 |  _ \  ___   ___| | _____ _ __ 
 | | | |/ _ \ / __| |/ / _ \ '__|
 | |_| | (_) | (__|   <  __/ |   
 |____/ \___/ \___|_|\_\___|_|   

  Instala o Docker e Docker-compose em SO Linux
  Para ajuda, execute ./$(basename $0) -h\n"

# Execution confirmation 
read -r -p "  Deseja continuar? [s/N] " REPLY
if ! [[ "$REPLY" =~ ^([sS][eE][sS]|[sS])$ ]]
then
    echo -e "  Script finalizado pelo usuario\n"
    exit 1
fi
 
# Loader spinner
loading() {
    local i sp n;sp='/-\|';n=${#sp};printf '';while sleep 0.1; do printf "%s\b" "${sp:i++%n:1}";done
}

# If DEBUG is ON
if [[ $ARG == 'd' ]]
then
    echo -e '\n\033[1m- Instalando a versao atual do Docker \033[0m'
    sudo apt update
    sudo apt install curl -y
    curl -fsSL https://get.docker.com | sh
    echo -e '  Ok'

    echo -e '\n\033[1m- Adicionando o usuario corrente ao grupo Docker \033[0m'
    sleep 2
    sudo groupadd docker 
    sudo usermod -aG docker $USER
    echo -e '  Ok'

    echo -e '\n\033[1m- Inicializando o daemon Docker \033[0m'
    sleep 2 
    sudo systemctl start docker 
    echo -e '  Ok'

    echo -e '\n\033[1m- Instalando o Docker-compose \033[0m'
    sleep 2 
    sudo apt install docker-compose -y
    echo -e '  Ok'

# If DEBUG is OFF
else 
    echo -e '\n\033[1m- Instalando a versao atual do Docker \033[0m'
    loading & {
      sleep 2
      sudo apt update
      sudo apt install curl -y
      curl -fsSL https://get.docker.com | sh
    } &>/dev/null; kill "$!"
    echo -e '  Ok'

    echo -e '\n\033[1m- Adicionando o usuario corrente ao grupo Docker \033[0m'
    loading & {
      sleep 2
      sudo groupadd docker 
      sudo usermod -aG docker $USER
    } &>/dev/null; kill "$!"
    echo -e '  Ok'

    echo -e '\n\033[1m- Inicializando o daemon Docker \033[0m'
    loading & {
      sleep 2 
      sudo systemctl start docker 
    } &>/dev/null; kill "$!"
    echo -e '  Ok'

    echo -e '\n\033[1m- Instalando o Docker-compose \033[0m'
    loading & {
      sleep 2 
      sudo apt install docker-compose -y
    } &>/dev/null; kill "$!"
    echo -e '  Ok'

fi

# Show versions
echo -e '\n\033[1m- Exibindo a versao instalada do Docker/Compose \033[0m'
echo -e ' ' `docker -v`
echo -e ' ' `docker-compose --version`
echo -e ''
echo -e 'IMPORTANTE: reiniciar ou fazer login/logout para aplicar as mudancas\n'
