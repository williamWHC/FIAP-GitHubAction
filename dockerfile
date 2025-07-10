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
ENTRYPOINT ["dotnet", "ConsoleApp.dll"]
