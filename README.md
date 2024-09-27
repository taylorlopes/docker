# docker
Instalar Docker e Docker-compose no Linux (Debian e derivados)

### Pré-requiisito: curl
<code>
sudo apt update
sudo apt install curl
</code>

### Instalação
<code>
wget https://raw.githubusercontent.com/taylorlopes/docker/refs/heads/main/docker-install.s
chmod +x docker-install.sh  
./docker-install.sh
</code>


### Observação

NÃO EXECUTE COM SUDO, pois o script irá adicionar o usuário corrente ao grupo docker.
