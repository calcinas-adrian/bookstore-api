# syntax=docker/dockerfile:1

# ---------- build ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files first so restore stays cacheable.
COPY ["Libreria.sln", "./"]
COPY ["Libreria.PresentationLayer/Libreria.PresentationLayer.csproj", "Libreria.PresentationLayer/"]
COPY ["Libreria.BusinessLogicLayer/Libreria.BusinessLogicLayer.csproj", "Libreria.BusinessLogicLayer/"]
COPY ["Libreria.DataAccessLayer/Libreria.DataAccessLayer.csproj", "Libreria.DataAccessLayer/"]
COPY ["Libreria.Models/Libreria.Models.csproj", "Libreria.Models/"]

RUN dotnet restore "Libreria.sln"

# Copy the rest and publish the API project.
COPY . .
RUN dotnet publish "Libreria.PresentationLayer/Libreria.PresentationLayer.csproj" \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

# ---------- runtime ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080 \
    ASPNETCORE_ENVIRONMENT=Production \
    DOTNET_NOLOGO=true

EXPOSE 8080

USER $APP_UID

ENTRYPOINT ["dotnet", "Libreria.PresentationLayer.dll"]