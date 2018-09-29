#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM microsoft/dotnet:2.1-aspnetcore-runtime-nanoserver-sac2016 AS base
WORKDIR /app
EXPOSE 1960
EXPOSE 44367

FROM microsoft/dotnet:2.1-sdk-nanoserver-sac2016 AS build
WORKDIR /src
COPY ["test-net-core-api/test-net-core-api.csproj", "test-net-core-api/"]
RUN dotnet restore "test-net-core-api/test-net-core-api.csproj"
COPY . .
WORKDIR "/src/test-net-core-api"
RUN dotnet build "test-net-core-api.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "test-net-core-api.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "test-net-core-api.dll"]