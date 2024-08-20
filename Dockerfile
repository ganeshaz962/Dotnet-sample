FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5135

ENV ASPNETCORE_URLS=http://+:5135

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["mywebapitest.csproj", "./"]
RUN dotnet restore "mywebapitest.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "mywebapitest.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "mywebapitest.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "mywebapitest.dll"]
