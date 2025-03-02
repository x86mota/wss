## Descrição do Teste
O teste técnico consiste na configuração de uma infraestrutura web básica, incluindo servidores web, um site PHP e um site Wordpress, e um container Docker. Abaixo estão as instruções originais do teste:

**Site PHP**
- Instalar e configurar o Nginx e o PHP-FPM em um servidor.  
- O conteúdo do site deve estar localizado em `/var/www/html/site-exemplo`.  
- Criar um arquivo `index.php` com a mensagem "Ola XXXX!".  
- Configurar um Virtual Host no Nginx para que o site responda através da URL `http://php-felipe-cruz.devopssquad.com.br`.

**Site Wordpress**  
- Configurar o Wordpress em um site, chamado "Site do XXXX", utilizando o Nginx.  
- Configurar o banco de dados necessário para o Wordpress no mesmo servidor.  
- O site Wordpress e o painel de administração (wp-admin) devem estar acessíveis através da URL `http://blog-felipe-cruz.devopssquad.com.br`.

**Docker**  
- Executar um container Docker do Nginx, expondo a porta 8080.  
- O site deverá exibir a página de boas-vindas do Nginx na URL `http://docker-felipe-cruz.devopsfsquad.com.br:8080`.

**Infraestrutura na AWS**  
- A empresa forneceu acesso a chave `.pem` de uma instância EC2 juntamente com o security group devidamente configurado.

<br>

## Reslução
A resolução do teste foi feita manualmente, sem nenhum uso de automação, acessando diretamente a instância EC2.

**Parametros**
```bash
IP="3.81.219.38"
KEY="${HOME}/Documents/DevOpsSquad/candidate.pem"
AWS_USER="ec2-user"
SITE_PHP="http://php-felipe-cruz.devopssquad.com.br"
WORDPRESS="http://blog-felipe-cruz.devopssquad.com.br"
DOCKER="http://docker-felipe-cruz.devopsfsquad.com.br:8080"

ssh -i $KEY $AWS_USER@$IP
```

### Site PHP
- Instalação dos pacotes.
    ```bash
    dnf install nginx php-fpm -y
    ```

- Alterar o diretório padrão de arquivos estáticos do nginx de `/usr/share/nginx/html/` para `/var/www/html/`.
    ```bash
    nano /etc/nginx/nginx.conf
    ```

- Alterar o usuario e grupo do phm.fpm para nginx
    ```bash
    nano /etc/php-fpm.d/www/conf
    ```

- Configuração do virtual host
    ```bash
    nano /etc/nginx/conf.d/php-felipe-cruz.conf
	
    server {
        listen 80;
        server_name php-felipe-cruz.devopssquad.com.br www.php-felipe-cruz.devopssquad.com.br;

        root /var/www/html/site-exemplo;
        index index.php index.html index.htm;

        location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                include fastcgi_params;
                fastcgi_pass unix:/run/php-fpm/www.sock;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }

        error_log /var/log/nginx/php-felipe-cruz_error.log;
        access_log /var/log/nginx/php-felipe-cruz_access.log;
    }
    ```

 - Reinicializar os serviços do nginx e php-fpm
    ```bash
    systemctl restart nginx.service php-fpm.service
    ```

### WordPress
- Instalação do banco de dados MariaDB
    ```bash
    dnf install mariadb105-server-3:10.5.25-1.amzn2023.0.1.x86_64 php-mysqli
    ```

- Inicialização do serviço
    ```bash
    systemctl enable --now mariadb.service
    ```

- Configuração do DB
    ```bash
    mysql -u root
    ```

    ```SQL
    CREATE DATABASE wordpress;
    CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wordpress';
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
    FLUSH PRIVILEGES;
    EXIT;
    ```

- Instalação do WordPress
    ```bash
    # Download
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz -C /var/www/html/
    
    # Alteração do dono do diretório wordpress para nginx 
    chown -R nginx:nginx /var/www/html/wordpress/

    # Edição do arquivo wp-config.php e alteração dos parametros de acesso
    cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

    nano wp-config.php
    ```

- Configuração do virtual host
    ```bash
    nano /etc/nginx/conf.d/wordpress.conf

    server {
        listen 80;
        server_name blog-felipe-cruz.devopssquad.com.br www.blog-felipe-cruz.devopssquad.com.br;

        root /var/www/html/wordpress;
        index index.php index.html index.htm;

        location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                fastcgi_pass unix:/run/php-fpm/www.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }

        location ~ /\.ht {
                deny all;
        }
    }
    ```

 - Reinicializar os serviços do nginx e php-fpm
    ```bash
    systemctl restart nginx.service php-fpm.service
    ```

### Docker
- Instalação
    ```bash
    dnf install docker -y
    ```

- Habilitando o serviço
    ```bash
    systemctl enable --now docker.service
    ```

- Execução do container expondo a porta 8080
    ```bash
    docker container run --detach --publish 8080:80 nginx
    ```