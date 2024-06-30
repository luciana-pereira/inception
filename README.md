# Inception 🐳​
`CURSO: Engenharia de Software | 42SP`

`ATIVIDADE: Inception`

## :page_facing_up: Índice

* [1. Visão Geral](#1-visão-geral)
  * [1.1 Recomendações](11-recomendações)
  * [1.2 Docker e o docker compose](12-docker-e-o-docker-compose)
  * [1.3 Difereça da imagem docker com ou sem docker compose](13-difereça-da-imagem-docker-com-ou-sem-docker-compose)
  * [1.4 Docker x VMs](14-docker-x-vms)
* [2. Etapas do Projeto](#2-etapas-do-projeto)
  * [2.1. Etapa 1: Makefile e docker-compose.yml](#21-etapa-1-makefile-e-docker-composeyml)
    * [2.1.1 network: host, links ou --link](#211-network:-host,-links-ou---link)
    * [2.1.2 network no docker-compose.yml](#212-network-no-docker-compose.yml)
    * [2.1.3 Requisitos do docker-compose.yml](#213-requisitos-do-docker-compose.yml)
    * [2.1.4 Não aplicaveis no mandatorio](214-não-aplicaveis-no-mandatorio)
  * [2.2. Etapa 2: Dockerfiles](#22-etapa-2-dockerfiles)
    * [2.2.1 Comandos de loop infinito](221-comandos-de-loop-infinito)
    * [2.2.2 Gerenciamento de Processos e PID 1](222-gerenciamento-de-processos-e-pid-1)
  * [2.3. Etapa 3: Configuração do MariaDB](#23-etapa-3-configuração-do-mariadb)
  * [2.4. Etapa 4: Configuração do NGINX](#24-etapa-4-configuração-do-nginx)
    * [2.4.1 Arquivos de configuração do NGINX](241-arquivos-de-configuração-do-nginx)
    * [2.4.2 Acessando o NGINX pela porta 443](242-acessando-o-nginx-pela-porta-443)
  * [2.5. Etapa 5: Configuração do Wordpress](#25-etapa-5-configuração-do-wordpress)
  * [2.6. Etapa Bônus](#26-etapa-bônus)
    * [2.6.1. Configuração do Cache Redis](#261-configuração-do-cache-redis)
* [3. Comandos Proibidos](#3-comandos-proibidos)
* [4. Banco de Dados WordPress](#4-banco-de-dados-wordpress)
* [5. Volumes](#5-volumes)
* [6. Diagrama do Resultado](#6-diagrama-do-resultado)
* [7. Estrutura do Projeto](#7-estrutura-do-projeto)
* [8. Desenvolvimento da Parte Bônus](#8-desenvolvimento-da-parte-bônus)
* [9. Instalação e Execução do Projeto](#9-instalação-e-execução-do-projeto)
* [10. Passos para Colocar o Site no Ar](#10-passos-para-colocar-o-site-no-ar)
* [11. Configuração](#11-configuração)
* [12. Documentação de Referência](#12-documentação-de-referência)
* [13. Desenvolvedora](#13-desenvolvedora)

## 1. Visão Geral
Este projeto tem como objetivo criar toda a infraestrutura de componentes e programas necessários para que um site vá (eventualmente) ao ar na internet. Ou seja, seu objetivo é ampliar nosso conhecimento de administração de sistemas utilizando o Docker.

Como requisito, devemos construir as imagens Docker do projeto, sem a utilização, ou sem extrair imagens Docker prontas ou serviços como _**Docker Hub**_. Realizamos a configuração de um contêiner Docker que contém:
- [x] O NGINX somente com o TLSv1.2 ou TLSv1.3
- [x] WordPress + php-fpm (deve ser instalado e configurado) sem nginx

Volume que contém:
- [x] Banco de dados WordPress
- [x] Arquivos do site WordPress
- [x] Um docker-network que estabelece a conexão entre os contêineres.

## 1.1 Recomendações
Para este projeto é _**recomendado aprender sobre PID 1 e as melhores práticas para escrever Dockerfiles**_, além da utilização para construção das imagens a penúltima versão estável do Alpine ou Debian. No caso para este projeto a penúltima versão estável, de acordo com a documentação ou os anúncios de lançamento do Debian e do Alpine, é a versão de junho de 2024, a versão estável mais recente do Debian 12 (Bookworm). Desta forma, _**a penúltima versão estável seria o Debian 11 (Bullseye)**_ e para o _**Alpine é a versão 3.17**_.

## 1.2 Docker e o docker compose
_**o Docker é uma plataforma usada para criar e executar contêineres isolados, enquanto o Docker Compose facilita a definição e a execução de aplicativos compostos por múltiplos contêineres interconectados**_. Ambos são amplamente utilizados no desenvolvimento e na implantação de software moderno, proporcionando eficiência, portabilidade e consistência no gerenciamento de ambientes de aplicativos.

## 1.3 Difereça da imagem docker com ou sem docker compose
A principal diferença entre uma imagem Docker utilizada com Docker Compose e uma imagem Docker utilizada sem Docker Compose está no contexto de como elas são orquestradas e gerenciadas. 
-  _**Sem docker compose**_, ela e ideal para  executar contêineres únicos ou para casos simples e a configuração e aplicada diretamente em comandos docker. A parte de gerenciamento e orquestração, o gerenciamento e manual de cada contêiner.
- _**Com docker compose**_, ela e ideal para aplicativos complexos que consistem em múltiplos serviços interdependentes e a configuração e definida e centralizada em um arquivo YAML.  A parte de gerenciamento e orquestração, o gerenciamento e simplificado para os múltiplos contêineres, com definição de dependências e redes.

## 1.4 Docker x VMs
O Docker e as máquinas virtuais (VMs) são tecnologias que oferecem formas de isolar e gerenciar aplicações, mas elas funcionam de maneiras diferentes e têm seus próprios benefícios e casos de uso. 

- **Docker**: Contêineres compartilham o mesmo kernel do sistema operacional host, resultando em menos sobrecarga. Contêineres são significativamente mais leves e consomem menos recursos do que VMs. Eles iniciam quase instantaneamente e utilizam menos memória e CPU. Com contêineres, os desenvolvedores podem rapidamente construir, testar e implantar aplicativos. A criação e o início de contêineres são rápidos, facilitando iterações rápidas e frequentes. Proporciona consistência entre ambientes, garantindo que todas as dependências e configurações necessárias estejam contidas. Cada contêiner é isolado, mas pode compartilhar o mesmo sistema operacional host.
- **VMs**: Cada VM inclui um sistema operacional completo, seu próprio kernel, drivers, etc., o que resulta em maior uso de recursos. As VMs são mais pesadas e levam mais tempo para iniciar. A configuração e o provisionamento de VMs são mais lentos, o que pode atrasar o ciclo de desenvolvimento. Oferecem isolamento total, incluindo o sistema operacional, mas a sobrecarga é maior.

Docker oferece uma solução mais leve, eficiente e portátil em comparação com VMs, facilitando o desenvolvimento, teste e implantação de aplicativos. No entanto, VMs ainda têm seu lugar para casos onde o isolamento completo e a execução de diferentes sistemas operacionais são necessários. A escolha entre Docker e VMs dependerá dos requisitos específicos do seu projeto e da infraestrutura disponível.

## 2. Etapas do Projeto

### 2.1. Etapa 1: Makefile e docker-compose.yml
Para o desenvolvimento deste projeto começamos criando o _**Makefile**_ e o _**docker-compose.yml**_ e realizando sua configuração.
- **Makefile**
- **docker-compose.yml**

O docker-compose.yml é um arquivo de configuração que define como os contêineres Docker devem ser orquestrados. Ele especifica os serviços que compõem a aplicação, as imagens Docker a serem usadas ou construídas, as redes, os volumes, as variáveis de ambiente e outras configurações.

### 2.1.1 network: host, links ou --link
Por requisito do projeto, este arquivo **não pode conter:**
  - _**links**_: Que é uma funcionalidade mais antiga que _**permite conectar contêineres e fornecer uma maneira simplificada de comunicação entre eles**_. No entanto, _**links é considerado obsoleto e foi substituído pelo uso de redes no Docker Compose**_.
  - _**network_mode: host**_: _**Permite que o contêiner compartilhe a pilha de rede do host, o que elimina o isolamento entre o contêiner e o host**_. Isso vai contra o requisito de que cada serviço deve rodar em um contêiner dedicado. _**O isolamento de contêineres é uma das principais vantagens do Docker, permitindo que cada contêiner tenha seu próprio espaço de rede**_, filesystem e processos, o que aumenta a segurança e a estabilidade. Usar network_mode: host pode introduzir riscos de segurança, pois o contêiner tem acesso direto à rede do host, o que pode ser problemático se o contêiner for comprometido. Além disso, compartilhar a pilha de rede pode causar conflitos de portas, uma vez que o contêiner e o host competem pelas mesmas portas de rede.
- _**--link**_: O parâmetro --link no Makefile ou em scripts geralmente serve para criar um link simbólico (ou symlink) para um arquivo ou diretório. Um link simbólico é um tipo de atalho que aponta para outro arquivo ou diretório no sistema de arquivos. Isso é útil para referenciar um arquivo ou diretório de forma mais conveniente ou para criar aliases para caminhos longos ou complexos. No contexto do Makefile, o --link poderia ser usado, por exemplo, para criar links simbólicos para arquivos de biblioteca compartilhada ou para organizar a estrutura de diretórios de um projeto de uma maneira mais modular e acessível.

### 2.1.2 network no docker-compose.yml
_**O projeto exige que criemos uma rede Docker personalizada para interligar os contêineres**_, conforme pode ser observado no exemplo abaixo. Isso _**permite um controle mais granular sobre como os serviços se comunicam**_, simplifica a resolução de nomes de contêineres (usando DNS interno do Docker) e melhora a segurança. O docker-compose.yml deve garantir que todos os contêineres se comuniquem de forma segura e eficiente dentro de uma rede isolada.

```yaml
services:
  web:
    image: nginx
    networks:
      - inception

  db:
    image: mariadb
    networks:
      - inception

networks:
  inception:
```
### 2.1.3 Requisitos do docker-compose.yml
Os requisitos para construção do _**docker-compose.yml**_ são:
- Conter o _**networks**_, ele definirá as redes que serão usadas pelos serviços especificados no arquivo. _**As redes vão permitir que os contêineres se comuniquem entre si de forma segura e isolada**_. Além de permitir ajustar as propriedades da rede, como o driver de rede a ser usado (por exemplo, bridge, overlay) como no exemplo abaixo:

```yaml
networks:
  inception:         # Nome da rede criada, onde os serviços poderão se comunicar
    driver: bridge   # Rede padrão usada para comunicação de contêineres em um único host Docker
```

*inception*: Contêineres conectados a essa rede com o driver bridge podem se comunicar diretamente, usando os nomes dos serviços como hostnames.

### 2.1.4 Não aplicaveis no mandatorio
Os itens abaixo, não são apicaveis para a parte mandatoria do projeto
- & Que permite a execução do comando em segundo plano.
- ; Que executa individualmente os comando em sequência.
- ()  Substituição de comando



### 2.2. Etapa 2: Dockerfiles
_**O Dockerfile é um arquivo de script utilizado pelo Docker para criar imagens de contêiner de maneira automatizada e consistente.**_ Ele contém uma série de instruções que especificam como construir uma imagem Docker, incluindo a definição do ambiente, a instalação de dependências, a configuração de variáveis e a especificação dos comandos que serão executados dentro do contêiner. De forma geral, _**Dockerfile é utilizado pelo docker-compose.yml para realizar a criação das imagens Docker necessárias para os serviços definidos no arquivo de composição**_.

Exemplo:

```Dockerfile
FROM alpine:3.12
RUN apk add --no-cache nginx
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
### 2.2.1 Comandos de loop infinito
Por requisito do projeto, este arquivo **não pode conter:**
- _**"tail -f" ou qualquer outro comando que resulte em um loop infinito na seção entrypoint**_:

Usar tail -f ou um loop infinito (sleep infinity, while true) como entrypoint _**faz com que esses comandos se tornem PID 1, o que é problemático porque eles não têm capacidade adequada para gerenciar outros processos ou sinais do sistema corretamente**_. Isso pode levar a problemas na hora de parar ou reiniciar os contêineres. Usar _**tail -f ou outros comandos de loop infinito consome recursos desnecessários do sistema sem fornecer valor real**_. Isso pode levar a uma utilização ineficiente dos recursos da máquina hospedeira.

### 2.2.2 Gerenciamento de Processos e PID 1
O PID 1 é o primeiro processo que é iniciado dentro de um contêiner Docker. Este processo é responsável por gerenciar outros processos dentro do contêiner. Se o processo com PID 1 termina, o contêiner inteiro termina. Portanto, é crucial que o PID 1 seja um processo bem-comportado que gerencie corretamente os sinais do sistema e os processos filho. O Docker depende do comportamento adequado dos processos PID 1 para enviar sinais e parar os contêineres de forma limpa. Se o processo não responder corretamente aos sinais, pode causar interrupções e comportamento inesperado.

### 2.3 Etapa 3: Configuração do MariaDB
Para configurar o banco precisamos criar o Dockerfile para criar a imagem e o arquivo de configuração _**my.conf**_ que ficará dentro da pasta conf.

- **conf/my.conf**:
  O arquivo my.conf contém as configurações especificadas para garantir que o contêiner do MariaDB funcione corretamente dentro da rede Docker, permitindo a comunicação necessária entre os serviços e atendendo aos requisitos e melhores práticas delineados pelo projeto.

- **tools/init_mariadb.sh**:
  O arquivo init_mariadb.sh é para automatizar a inicialização e a configuração inicial do banco de dados MariaDB

Exemplo de _**Dockerfile**_:

```Dockerfile
FROM mariadb:10.5

# Copiar arquivo de configuração personalizada
COPY ./conf/my.cnf /etc/mysql/my.cnf

# Copiar script de inicialização
COPY ./tools/init_mariadb.sh /docker-entrypoint-initdb.d/

# Definir variáveis de ambiente para configuração do banco de dados
ENV MYSQL_ROOT_PASSWORD=myrootpassword
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=wordpress_user
ENV MYSQL_PASSWORD=wordpress_password

# Expor a porta padrão do MariaDB
EXPOSE 3306
```

A utilização do ENV:
- **MYSQL_ROOT_PASSWORD**: Define a senha do usuário root do MariaDB. Esta senha é crucial para a segurança do banco de dados, e seu valor deve ser forte e mantido em sigilo.
- **MYSQL_DATABASE**: Especifica o nome do banco de dados a ser criado automaticamente na inicialização do contêiner. Neste caso, estamos criando um banco de dados chamado wordpress.
- **MYSQL_USER e MYSQL_PASSWORD**: Define um novo usuário e senha que terão acesso ao banco de dados especificado (neste caso, wordpress). Estes valores são importantes para a aplicação WordPress se conectar ao banco de dados com permissões apropriadas.

**Testes Mariadb:**
```bash
docker exec -it mariadb mysql -up wp_superuser -p # Acesse o Contêiner do wordpress para acessar o banco
cat /var/www/wordpress/wp-config.php              # Acessar o arquivo de configuração
mysql -h $MARIADB_ROOT_HOST -u $MARIADB_USER -p$MARIADB_PASSWORD $MARIADB_DATABASE  # Acessa o banco e a conexão
SHOW DATABASES;                                   # Visualizar o banco.
USE wp;
SHOW TABLES;                                      # Visualisar as tabelas
SELECT COUNT(*) FROM wp_comments;                 # Verificar numero de comentarios no wordpress
SELECT COUNT(*) FROM wp_posts;                    # Verificar numero de postagens***
```
#### Acesso ao Login
```
https://lucperei.42.fr/wp-login.php
```

#### Acesso a area administrativa do Wordpress
```
https://lucperei.42.fr/wp-admin
```
### 2.4. Etapa 4: Configuração do NGINX
NGINX é uma ferramenta essencial para servir o conteúdo estático, balancear a carga de tráfego e atuar como proxy reverso, proporcionando desempenho e segurança ao site WordPress.

Para configurar o nginx precisamos criar o Dockerfile e os arquivos de configuração _**nginx.conf**_ e _**self-signed.conf**_, e a geração do certificado SSL dentro da pasta _**tools**_.

### 2.4.1 Arquivos de configuração do NGINX
- **conf/nginx.conf**:
  O arquivo nginx.conf é para realizar a configuração do servidor web NGINX.

- **conf/self-signed.conf**:
  O arquivo self-signed.conf realiza a configuração do uso de certificados autoassinados.

- **tools/ssl.sh**:
  O arquivo ssl.sh realiza a geração do certificado SSL autoassinado.

- **tools/start_server.sh**:
  O arquivo start_server.sh realiza o script de inicialização para garantir que o contêiner do NGINX inicie corretamente.

Exemplo de _**Dockerfile**_:

```Dockerfile
FROM debian:bullseye

# Instalar OpenSSL para gerar certificados
RUN apk add --no-cache openssl

# Copiar arquivos de configuração
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/self-signed.conf /etc/nginx/conf.d/self-signed.conf

# Copiar scripts de inicialização e SSL
COPY ./tools/ssl.sh /usr/local/bin/ssl.sh
COPY ./tools/start_server.sh /usr/local/bin/start_server.sh

# Gerar certificados SSL autoassinados
RUN /usr/local/bin/ssl.sh

# Expor a porta padrão do NGINX (80 e 443 para HTTPS)
EXPOSE 80 443

# Definir comando de inicialização
CMD ["/usr/local/bin/start_server.sh"]
```

### 2.4.2 Acessando o NGINX pela porta 443
Para garantir que o NGINX esta executando na porta 443 e so indicar no comando abaixo e para testar pode colocar outras portas para ver se conecta como no exemplo abaixo:

```bash
user42@42saopaulo:~/workspace/inception$ curl -v https://lucperei.42.fr/:443
*   Trying 127.0.0.1:443...
* TCP_NODELAY set
* Connected to lucperei.42.fr (127.0.0.1) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (OUT), TLS alert, unknown CA (560):
* SSL certificate problem: self signed certificate
* Closing connection 0
curl: (60) SSL certificate problem: self signed certificate
More details here: https://curl.haxx.se/docs/sslcerts.html

```
### 2.5 Etapa 5: Configuração do Wordpress

**Testes no Wordpress:**
Login no Wordpress:
```bash
https://lucperei.42.fr/wp-login.php
```

Acesso a area administrativa do Wordpress:
```bash
https://lucperei.42.fr/wp-admin
```

### 2.6 Etapa Bônus
Os requisitos do projeto envolvem a configuração de serviços como:

### 2.6.1 Configuração do Cache Redis
O **Cache Redis** é um sistema de armazenamento em memória de código aberto que pode ser usado como um cache de alto desempenho para acelerar o acesso a dados frequentemente acessados. No contexto do Site WordPress, ele é utilizado como um cache para melhorar a velocidade e o desempenho do site.

Ele armazena em pares de chaves e valores. As chaves podem representar consultas de banco de dados, resultados de consultas, objetos de cache, etc. Os valores correspondentes são os dados associados a essas chaves.

*Para usar o Redis como cache no WordPress, utilizamos de um plugin de cache compatível com Redis, como o Redis Object Cache. Este plugin se integra ao WordPress e usa Redis como backend para armazenar e recuperar dados em cache aém dos arquivos de configuração.

**Testes do Redis no Wordpress para ver a configuração:**
```bash
docker exec -it wordpress bash      # Acesse o Contêiner do Wordpress
wp redis status --allow-root        # Verifica se o comando redis está ativo e instalado.
wp plugin list --allow-root         # Procure pelo plugin redis-cache na lista.
keys wp_redis_keywp:users:*         # Visualiza todos usuarioskey
keys wp_redis_keywp:users:1         # Pega a chave
keys wp_redis_keywp:users:1         # Visualizar o usuario
keys wp_redis_keywp:userlogins:*    # Visualizar logins
get wp_redis_keywp:userlogins:lucperei # Obter o numero de logins
```

**Testes do Redis no Wordpress:**
```bash
docker exec -it redis bash      # Acesse o Contêiner do Redis
redis-cli                       # Conecte-se ao Redis CLI
keys *                          # Liste as Chaves no Redis
get wp:options:alloptions       # Verifique o valor de uma chave específica apos alteração no wordpress
keys wp_redis_keywp:posts:*     # Captura o numero da postagem pela chave
get wp_redis_keywp:posts:1      # Pega o posto pelo numero, no caso o numero 1 do Hello Word
```
Outras Chaves para visualizar
```bash
wp_redis_keywp:post_meta:1
wp_redis_keywp:comment:last_changed
wp_redis_keywp:post-queries
wp_redis_keywp:userlogins:wp_superuser
wp_redis_keywp:useremail:wp_superuser@example.com
wp_redis_keywp:comment-queries
wp_redis_keywp:users
wp_redis_keywp:posts:last_changed
wp_redis_keywp:theme_files:wp_theme_patterns_twentytwentytwo
wp_redis_keywp:userlogins:wp_user
"wp_redis_keywp:comment:1
```

### 2.6.2 Configuração do Servidor FTP
O servidor FTP, permite a transferência de arquivos de maneira segura e eficiente.

O servidor FTP utilizado é o vsftpd (Very Secure FTP Daemon), conhecido por sua simplicidade e segurança.

O Dockerfile criado para o serviço FTP realiza a instalação do vsftpd, copia os arquivos de configuração e define scripts de inicialização.

Por fim, o serviço é configurado no docker-compose.yml, com variáveis de ambiente para o usuário FTP e senha, volumes para persistência de dados e a definição da rede para comunicação.

Os arquivos configurados para o servidor FTP são:
- **Dockerfile**:
  Realiza a construção da imagem personalizada com vsftpd.

- **vsftpd.conf**:
  Arquivo de configuração do vsftpd.

- **start_ftp.sh**:
  Script para inicializar o vsftpd.

**Testes do FTP:**
```bash
ftp lucperei.42.fr # Conectar com o nome do host
```
- Depois de acessao o ftp, entre com o usuario e senha definido no .env.
- **Acesse o Admin do WordPress**, e va até a seção onde podemos **carregar arquivos**, por exemplo, **no menu "Mídia"**.

**Podemos ver estes arquivos baixados acessando conforme o exemplo abaixo:
```bash
docker exec -it ftp /bin/sh
ls -la /var/www/wordpress
ls -la /var/www/wordpress/wp-content/uploads/2024/06 # Onde as imagens foram carregadas
```

### 2.6.3 Configuração do Site estático
O site estático criado e um pequeno blog desenvolvido e estilizado em markdown utilizando algumas ferramentas como o hugo-theme-m10c para estilização do site.

![Pagina Sobre mim](https://github.com/luciana-pereira/inception/assets/37550557/c946ad4b-7063-4072-8e1f-73c787355af7)

### 2.6.4 Configuração do Adminer
O Adminer é uma ferramenta de gerenciamento de banco de dados de código aberto, escrita em PHP. Ele oferece uma interface web única para interagir com múltiplos sistemas de banco de dados, como MySQL, PostgreSQL, SQLite, Microsoft SQL Server e outros. O Adminer é uma alternativa mais leve e eficiente ao phpMyAdmin.

![Tela do Adminer](https://github.com/luciana-pereira/inception/assets/37550557/40dd2436-216a-433b-9f4f-7f20780e6a4a)

### 2.6.5 Configuração do cAdvisor

Acesse a interface web do cAdvisor através da URL:
```bash
https://lucperei.42.fr/cadvisor/containers/
```

Acessar Métricas do Docker (dos Subcontainers):
```bash
https://lucperei.42.fr/cadvisor/containers/docker
```

Esta página exibe um painel com informações e gráficos sobre os contêineres em execução.

**Principais Seções da Interface Web do cAdvisor**
- **Dashboard**: A visão geral mostra métricas agregadas para todos os contêineres.
- **Containers**: A visualização detalhada dos contêineres individuais, com gráficos e estatísticas.
- **Graph**: Gráficos interativos mostrando o histórico de uso de recursos.
- **Stats**: Estatísticas detalhadas sobre CPU, memória, disco e rede para contêineres.
- **API**: Acessa a API RESTful para integrar métricas com outras ferramentas ou scripts personalizados.

![Tela do cAdvisor](https://github.com/luciana-pereira/inception/assets/37550557/9304d292-d206-4ee3-9ab4-deb61f5c0829)

### 3. Comandos Proibidos
- Para atender aos requisitos do projeto, certos comandos e práticas são proibidos, a fim de garantir uma implementação limpa e eficiente.
- Por exemplo, o uso de "tail -f" ou loops infinitos nos Dockerfiles é proibido, pois isso pode impedir o contêiner de gerenciar corretamente os sinais e processos, levando a problemas na inicialização e encerramento dos contêineres.
- Em vez disso, deve-se utilizar práticas recomendadas, como configurar os serviços corretamente para que executem em primeiro plano, garantindo uma operação estável e previsível.

### 4. Banco de Dados WordPress
- O banco de dados WordPress é configurado utilizando o MariaDB, um sistema de gerenciamento de banco de dados relacional que é uma bifurcação do MySQL.
- O banco de dados WordPress armazenará todas as informações essenciais do site, incluindo postagens, páginas, usuários, configurações e muito mais.
- Para garantir a persistência dos dados, um volume é configurado no docker-compose.yml para o contêiner do MariaDB.
- Além disso, o Dockerfile do MariaDB é configurado com variáveis de ambiente para definir o nome do banco de dados, usuário e senha, e scripts de inicialização para criar o banco de dados e aplicar permissões.

### 5. Volumes
- Os volumes são utilizados no Docker para persistir dados gerados pelos contêineres, mesmo após a reinicialização dos contêineres.
- No projeto, volumes são configurados para os contêineres do WordPress, NGINX e MariaDB.
- Para o WordPress, os volumes garantem que os arquivos de mídia, plugins, temas e outras customizações sejam persistidos.
- Para o NGINX, os volumes podem ser utilizados para armazenar os arquivos de configuração e os certificados SSL.
- Para o MariaDB, os volumes são essenciais para persistir os dados do banco de dados.

### 6. Diagrama do Resultado
Um diagrama visual pode ajudar a entender a arquitetura do projeto, mostrando a relação entre os contêineres e os serviços.

O diagrama deve incluir os seguintes elementos:
- Contêiner NGINX, atuando como servidor web e proxy reverso.
- Contêiner WordPress, servindo o site WordPress.
- Contêiner MariaDB, armazenando o banco de dados do WordPress.
- Contêiner FTP, permitindo a transferência de arquivos.
- Rede Docker personalizada, conectando todos os contêineres.
- Volumes para persistência de dados para cada contêiner.

### 7. Estrutura do Projeto
A estrutura do projeto deve ser organizada para facilitar o desenvolvimento e a manutenção. Aqui está um exemplo de como os arquivos e diretórios podem ser organizados:

```bash
ft_irc/
│
├── Makefile
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   |   └── my.conf
        │   └── tools/
        │       └── setup_mariadb.sh
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        │       └── nginx.conf
        └── wordpress/
            ├── Dockerfile
            └── conf/
                └── wp-config.php

```


### 8. Desenvolvimento da Parte Bônus
- Para a parte bônus do projeto, a configuração de um servidor FTP é realizada.
- O Dockerfile é criado para instalar o vsftpd, copiar os arquivos de configuração e definir scripts de inicialização.
- O arquivo de configuração vsftpd.conf é personalizado para permitir a transferência segura de arquivos.
- O script start_ftp.sh é criado para inicializar o serviço FTP.
- Finalmente, o serviço FTP é adicionado ao docker-compose.yml, com variáveis de ambiente, volumes e a definição da rede.

### 9. Instalação e Execução do Projeto
Para instalar e executar o projeto, siga estas etapas:

1. Clone o repositório:
```bash
git clone <URL do repositório>
cd inception
```
2. Construa e inicie os serviços Docker:
```bash
docker-compose up --build
```
3. Acesse o site WordPress pelo navegador, usando o endereço configurado no arquivo nginx.conf (por exemplo, http://localhost).

### 10. Passos para Colocar o Site no Ar
1. Certifique-se de que todos os serviços Docker estão em execução.
2. Configure o DNS para apontar para o IP do servidor onde o Docker está executando.
3. Acesse o site pelo navegador, usando o nome de domínio configurado no DNS.
4. Certifique-se de que o NGINX está servindo o site corretamente e que o SSL está configurado e funcionando.

### 11. Configuração
- A configuração dos serviços é realizada nos arquivos de configuração específicos, como nginx.conf, my.cnf e vsftpd.conf.
- As variáveis de ambiente são definidas no docker-compose.yml para facilitar a personalização dos serviços.
- Scripts de inicialização são utilizados para configurar e iniciar os serviços corretamente.

### 12. Documentação de Referência
Para mais informações, consulte a documentação oficial das ferramentas e tecnologias utilizadas:

- [Docker Documentation](https://docs.docker.com/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [WordPress Documentation](https://wordpress.org/support/article/wordpress-documentation/)
- [vsftpd Documentation](https://security.appspot.com/vsftpd.html)

### 13. Desenvolvedora
:octocat:
Este projeto foi desenvolvido por Luciana Pereira, estudante da [42SP](). Para mais informações, entre em contato comigo.
<table>
  <tr>
     <td align="center">
      <a href="https://github.com/luciana-pereira" target="_blank">
        <img src="https://avatars.githubusercontent.com/u/37550557?v=4" width="100px;" alt="Foto de Fernanda no GitHub"/><br>
        <sub>
          <b>Luciana Pereira</b>
        </sub>
      </a>
    </td>
  </tr>
</table>

---

#### Notas Finais
Seguir as melhores práticas de desenvolvimento Docker e manter a segurança do sistema são essenciais para o sucesso deste projeto. O uso de certificados SSL, a configuração adequada do banco de dados e a utilização de variáveis de ambiente para senhas e usuários são alguns dos pontos críticos a serem observados.

O desenvolvimento contínuo e a atualização das dependências garantirão a robustez e a segurança do sistema, proporcionando uma experiência estável e segura para os usuários finais.

O projeto, ao ser concluído, fornecerá uma plataforma WordPress segura e eficiente, pronta para produção, utilizando contêineres Docker para facilitar a implantação e o gerenciamento.
