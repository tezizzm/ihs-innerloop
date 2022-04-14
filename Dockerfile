FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base
WORKDIR /app

ENV ASPNETCORE_URLS=http://+:5000

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /src
COPY ["ihs-innerloop.csproj", "./"]
RUN dotnet restore "ihs-innerloop.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ihs-innerloop.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ihs-innerloop.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ihs-innerloop.dll"]
ENV PORT=8080
ENV MANAGMENTPORT=8090
ENV ASPNETCORE_URLS="http://0.0.0.0:${PORT};http://0.0.0.0:${MANAGMENTPORT}"
ENV ASPNETCORE_LOGGING__CONSOLE__DISABLECOLORS=true
ENV LOGGING__CONSOLE__DISABLECOLORS=true
EXPOSE 8080