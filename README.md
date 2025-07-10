# WILLIAM

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

![image.png](attachment:076f21c8-5493-4ab0-8255-c6faa867e10d:image.png)

Após executar a imagen em no conteiner, é executado nossa solução console, dentro do container.

![image.png](attachment:890b7495-9756-4104-a262-3f205a6327ef:image.png)

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

![image.png](attachment:15de6e6b-a405-4915-9e03-88b406f906a6:image.png)

3 - Pesquisar no campos de pesquisa pelo nome “Docker Login”

![image.png](attachment:58be8dd7-002d-4116-a406-a9ce8cadf433:image.png)

4 - Ao clicar na action do Docker Login, copie o pdrão de estrtura de configuração, exmplo a baixo.

![image.png](attachment:87ee8be8-9009-48c9-8b36-c2248ef57c79:image.png)

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

![image.png](attachment:56f68f5b-3284-4632-a61d-f10bd776ab04:image.png)

9 - Clique botão, criar ‘ New repository secret ’

10 - Escolha o nome e a secret,

11 - No campo ‘Secret’, é preciso adicionar o token de acesso que o DockerHub fornece.
12 - Acesse [DockerHub.com](http://DockerHub.com) ⇒ Perfil ⇒ Configuração de conta ⇒ Token de acesso pessoal.

![image.png](attachment:f04a5a6a-2015-442b-8349-546d9fd8e899:image.png)

13 - Clique em ‘Generate new token’, e preencha os campos conforme uso.

![image.png](attachment:93899c51-acff-4b92-ba14-4ee156ab1581:image.png)

![image.png](attachment:b61e1b49-9e61-4539-8acd-42e8a06a5297:image.png)

14 - Após gerar o token, copiar o token e colocar no campo Secret, e depois salve.

15 - Copie o nome que deu para a secret, voltei para o arquivo de configuração e adicione a varivel no password

```docker
password: ${{ secrets.DOCKERHUB_PASSWORD }}
```

16 - Troque o runner do github, pelo ubuntu-latest, para ser executado na fila de execução, sem ficar pressa.

Modelo final a baixo.

![image.png](attachment:9e189f97-6fae-4fd5-a950-329db59e1c16:image.png)

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

![image.png](attachment:56576b85-760e-4441-806e-a9bf4353ac8d:image.png)

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
