FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY pub/ ./
ENTRYPOINT ["dotnet", "RetailClient.Web.dll"]