#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["awe_blazor.csproj", "."]
RUN dotnet restore "./awe_blazor.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "awe_blazor.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "awe_blazor.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "awe_blazor.dll"]