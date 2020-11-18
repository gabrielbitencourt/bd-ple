# Trabalho final - Banco de Dados PLE
## Proposta 5

Alteração/Exclusão das informações de paciente em um módulo do questionário na base de dados de Apoio para Pesquisas Clínicas

### Requisitos para rodar o projeto

- [NodeJS e npm](https://nodejs.org/)
- Angular CLI (`npm i -g @angular/cli`)

### Base de dados
Para a criação do schema do banco de dados, utilize o script da pasta server/database. Nele estão todas as estruturas de tabela, triggers e funções utilizadas. Há também um seed de dados inicial, incluindo um usuário para login `admin:senha1234`.

### Instruções para rodar o projeto
0. Caso seja a primeira vez que esteja executando o projeto execute o comando `npm install` em ambos os diretórios (client e server).
1. Entre no diretório client e execute o seguinte comando: `npm run build`.
2. Entre no diretório server e execute o seguinte comando: `npm start`
3. Acesse o site em http://localhost:3000

Obs.: Para facilitar o desenvolvimento é possível rodar o client como uma aplicação separada do server, para isso rode o comando no diretório client: `npm start` e, em outro terminal rode o comando no diretório server: `npm run start:dev`. Com isso é possível acessar o client em http://localhost:4200, que faz o build automáticamente a cada vez que um arquivo é modificado tanto no client como no server.
