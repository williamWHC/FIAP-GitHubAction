# COMO CRIAR UMA IMAGEM DOCKER E PUBLICAR NO DOCKER HUB E SBURI VIA GITHUB ACTIONS

##

### # Fase 2 | GITHUB ACTIONS - REPOSITÓRIO DE IMAGENS DOCKER

## RESITÓRIO DE IMAGENS - I

📁 DockerFile.

Estrutura de um arquivo .dockerfile

```docker
# Link da outra imagem docker, ex skd .net8 + nome da execução
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Entra na pasta /App que quero trabalhar
WORKDIR /App

# Copy everything
COPY . ./

# Restore as distinct layers
RUN dotnet restore

# Build and publich a realease
RUN dotnet publish -c Release -o out

# Pasta de trabalho atual, App/out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /App/out .
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]

```

Executar container configurado

```docker
docker build -t fiap/ghaction:v1 .
```

Listar container

```docker
docker images
```

<img width="714" height="144" alt="image" src="https://github.com/user-attachments/assets/de14688f-b88a-45fa-a3f1-ba29e366bab9" />

Após executar a imagen em no conteiner, é executado nossa solução console, dentro do container.

<img width="600" height="354" alt="image" src="https://github.com/user-attachments/assets/6323a4b0-3a29-4481-a734-a2ac88f8fb5b" />

Observação, é necessario o Docker instalado e Ter uma aplicação .Net criada.

---

## Respositório de imagens - II

Nessa aula iremos usar a imagem criada e enviar para o repositório Docker Hub.

1 - Primeiro passo criar um reposiório no github

2 - Subiar a imagem que criamos

para isso precisamos fazer o login com o nosso docker local com o HUB

---

## Repositório de imagens - III

Nessa aula tem como objetivo, criarmos no GitHub Actions um fluxo automatizado no arquivo de configuração.

1 - Acessar o arquivo ci-cd.yml, e depois clicar em editar, isso abrira no menu lateral opções.

2 - Acessar sessão Marketplace, e pesquisar

<img width="2027" height="934" alt="image" src="https://github.com/user-attachments/assets/f9bce152-fe17-4f35-b533-ae57726abed6" />

3 - Pesquisar no campos de pesquisa pelo nome “Docker Login”

<img width="485" height="100" alt="image" src="https://github.com/user-attachments/assets/a55ac93b-1341-4105-92a9-b6b430927e49" />

4 - Ao clicar na action do Docker Login, copie o pdrão de estrtura de configuração, exmplo a baixo.

<img width="486" height="724" alt="image" src="https://github.com/user-attachments/assets/11fff696-e1fd-4123-9aee-8107d8f1887e" />

Copie as configurações que for usar.
No nosso caso será.

```docker
      #Definindo o nome do workflow
      - name: Docker Login

        uses: docker/login-action@v3.4.0
        with:
          username: 'williamdoxv'
          password: ${{ secrets.DOCKERHUB_PASSWORD }}
```

5 - Adicionar no arquivo principal da Action

6 - Adicionar o login do Docker.

7 - Para não passar a senha do Docker, é preciso criar a secret, e para isso vamos configurar uma.

8 - Ir em configurações do repositorio, e selecionar a opção lateral esquerda ‘ Secrets and variable ’ ⇒ Action

<img width="369" height="982" alt="image" src="https://github.com/user-attachments/assets/fe25616b-0191-449c-be46-c44b1cd57b44" />

9 - Clique botão, criar ‘ New repository secret ’

10 - Escolha o nome e a secret,

11 - No campo ‘Secret’, é preciso adicionar o token de acesso que o DockerHub fornece.
12 - Acesse [DockerHub.com](http://DockerHub.com) ⇒ Perfil ⇒ Configuração de conta ⇒ Token de acesso pessoal.

<img width="446" height="815" alt="image" src="https://github.com/user-attachments/assets/48e72066-50e3-47aa-a3d5-bd1d6a593bbd" />

13 - Clique em ‘Generate new token’, e preencha os campos conforme uso.

<img width="398" height="408" alt="image" src="https://github.com/user-attachments/assets/f51c2497-4033-439a-8414-7abe56a03da1" />

<img width="1336" height="514" alt="image" src="https://github.com/user-attachments/assets/708ee2d9-c197-480d-ade8-f2cea9810ce5" />

14 - Após gerar o token, copiar o token e colocar no campo Secret, e depois salve.

15 - Copie o nome que deu para a secret, voltei para o arquivo de configuração e adicione a varivel no password

```docker
password: ${{ secrets.DOCKERHUB_PASSWORD }}
```

16 - Troque o runner do github, pelo ubuntu-latest, para ser executado na fila de execução, sem ficar pressa.

Modelo final a baixo.

<img width="1493" height="569" alt="image" src="https://github.com/user-attachments/assets/24c667e7-61dd-47c3-bc08-87f959226215" />

---

ci-cd.yml ⇒

```docker
# Definindo o nome do workflow
name: Teste Workflow
# → Este é o nome que será exibido na aba "Actions" do GitHub para identificar o workflow.

# Definindo quando o workflow será executado.
on:
  push:
    branches: [ main, developer ]
# → Este workflow será acionado automaticamente toda vez que houver um push nas branches "main" ou "developer".

# Definindo os jobs que o workflow executará.
jobs:
  test_jobs:
    name: Executando o job de Teste
    # → Nome descritivo do job que aparecerá na interface do GitHub Actions.

    runs-on: ubuntu-latest
    # → Define o ambiente do runner que será usado para executar o job (neste caso, uma máquina com Ubuntu na versão mais recente).

    steps:
      - name: Step 1
        uses: actions/checkout@v4
        # → Faz o checkout do código do repositório na máquina do runner. Necessário para que os próximos passos tenham acesso ao código fonte.

      - name: Docker Login
        uses: docker/login-action@v3.4.0
        # → Utiliza a action oficial para fazer login no Docker Hub, permitindo fazer push ou pull de imagens privadas.
        with:
          username: 'williamdoxv'
          # → Nome de usuário do Docker Hub.

          # Password or personal access token used to log against the Docker registry
          password: ${{ secrets.DOCKERHUB_PASSWORD }}
          # → Token de acesso ou senha do Docker Hub, armazenado de forma segura no GitHub Secrets.

```

---

Configurando o build da imagem do Docker

1 - Acessar o marketplace e selecionar o Docker Build

<img width="472" height="449" alt="image" src="https://github.com/user-attachments/assets/11bb275f-e0ff-405a-a23d-a1ded0ba2f77" />

2 - Criiando a etapa que irá criar o build e subir a imagem para o Docker

Ao selecionar Build and push Docker images, ele ira te informar um modelo que você ira usar conforme a necessidade.
No nosso caso,iremos configurar da seguinte forma.

```docker
#Descrição da etapa no GitHubAction
- name: Build and push Docker imagens
	uses: docker/build-push-action@v6.18.0
	with:
		context: ./ConsoleApp1
		tags: williamdoxv/fiap-ghactions:lastest
		push: true
		file: ./ConsoleApp1/dockerfile
```

O que cada linha faz:

```yaml
name: Build and push Docker imagens
```

🟢 Descrição da etapa do GitHubActions

É apenas o nome da etapa que será exibido no log da execução da pipeline, facilitando a leitura.

---

```yaml
uses: docker/build-and-push-action@v6.18.0
```

🛠️ Essa linha informa que estamos usando a ação ficial [docker/build-and-push-action](https://github.com/docker/build-push-action) na versão v6.18.0, responsavel por:

- contruir imagens Docker com buildx
- e opcionalmente enviar o ( push ) dessa imagem para o regsitro (como Docker Hub)

---

```yaml
with:
```

📦 Inicio das configurações de parametros:

---

```yaml
contexto: ./ConsoleApp1
```

📁 Diretório de onde estão os arquivos da aplicação.

Esse é o “contexto” usado pelo Docker para montar o build — é onde ele vai copiar os arquivos (como .sln , .csproj , etc ).

Equivale ao comando:

```bash
Docker build ./ConsoleApp1
```

---

```yaml
tags: williamdoxv/fiap-ghactions:latest
```

🏷️ Tag da imagem a ser gerada.

Nesse caso a imagem será publicada no Docker Hub com o nome:

```bash
williamdoxv/fiap-ghactions:latest
```

> Essa tag deve estar igual com o seu Docker Hub ID e repositorio

---

```yaml
push:
```

📄 Caminho do Dockefile

Aqui indica onde o arquivo dockerfile está dentro da pasta da aplicação.

> **Importante**: o nome do arquivo precisa estar exatamente como dockerfile ( sem a extensão .Dockerfile) ou você deve escrever file: ./ConsoleApp1/dockerfile , obs o Docker é sensivel com letrás maiúsculas e minúsculas em sistemas Unix/Linux.

---

📁Arquivo Dockerfile final

```yaml
# Definindo o nome do workflow
name: Teste Workflow

# Definindo quando o workflow sera executado.
on:
  push:
    branches: [main, developer]

#Definindo os jobs que o workflow executara.
jobs:
  test_jobs:
    name: Executando o job de Teste
    runs-on: ubuntu-latest
    steps:
      - name: Step 1
        uses: actions/checkout@v4

      - name: Docker Login
        uses: docker/login-action@v3.4.0
        with:
          username: "william"
          # Password or personal access token used to log against the Docker registry
          password: ${{ secrets.DOCKERHUB_PASSWORD }}

      - name: Build and push Docker images
        uses: docker/build-push-action@v6.18.0
        with:
          context: ./ConsoleApp1
          tags: williamdoxv/fiap-ghactions:latest
          push: true
          file: ./ConsoleApp1/dockerfile
```

---

Após subir o arquivos com os parametros de como o docker deve executar, a esteira pipeline executara as etapas do log dos seviço.
