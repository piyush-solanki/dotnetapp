FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["project1.csproj", "./"]
RUN dotnet restore "project1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "project1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "project1.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "project1.dll"]