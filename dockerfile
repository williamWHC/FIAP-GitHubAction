# Link da outra imagem docker, ex skd .net8 + nome da execução
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Entra na pasta /App que quero trabalhar
WORKDIR /App

# Copy everything
# COPY . ./

# Copia apenas os arquivos da solução
COPY ConsoleApp1.sln ./
COPY ConsoleApp1/ConsoleApp1.csproj ./ConsoleApp1/

# Restore as distinct layers
RUN dotnet restore

# Copia o restante do código
COPY ConsoleApp1/. ./ConsoleApp1/


# Build and publich a realease
WORKDIR /App/ConsoleApp1
RUN dotnet publish -c Release -o out

# Pasta de trabalho atual, App/out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /App/out .
ENTRYPOINT ["dotnet", "ConsoleApp1.dll"]
