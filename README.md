# Web Server Setup
Este repositório contém o código e a documentação de um projeto executado como parte de um teste técnico para uma vaga de estágio em DevOps. O objetivo deste projeto era demonstrar as habilidades de infraestrutura e configuração de servidores.

## Descrição do Teste
O teste técnico consiste na configuração de uma infraestrutura web básica, incluindo servidores web, um site PHP e um site Wordpress, e um container Docker. Abaixo estão as instruções originais do teste:

**Site PHP**
- Instalar e configurar o Nginx e o PHP-FPM em um servidor.  
- O conteúdo do site deve estar localizado em `/var/www/html/site-exemplo`.  
- Criar um arquivo `index.php` com a mensagem "Ola XXXX!".  
- Configurar um Virtual Host no Nginx para que o site responda através da URL fornecida.

**Site Wordpress**  
- Configurar o Wordpress em um site, chamado "Site do XXXX", utilizando o Nginx.  
- Configurar o banco de dados necessário para o Wordpress no mesmo servidor.  
- O site Wordpress e o painel de administração (wp-admin) devem estar acessíveis através da URL fornecida.

**Docker**  
- Executar um container Docker do Nginx, expondo a porta 8080.  
- O site deverá exibir a página de boas-vindas do Nginx na URL fornecida.

**Infraestrutura na AWS**  
- A empresa forneceu acesso a chave `.pem` de uma instância EC2 juntamente com o security group devidamente configurado.

**Resolução**
- O passo a passo da resolução original do teste pode ser lida [aqui](https://github.com/x86mota/wss/tree/main/TesteOrginal).
