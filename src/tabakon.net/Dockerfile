FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

RUN sed -i 's/SECLEVEL=2/SECLEVEL=1/g' /etc/ssl/openssl.cnf & \
    sed -i 's/TLSv1.2/TLSv1.0/g' /etc/ssl/openssl.cnf & \
    sed -i 's/DEFAULT@SECLEVEL=2/DEFAULT@SECLEVEL=1/g' /etc/ssl/openssl.cnf & \
    sed -i 's/MinProtocol = TLSv1.2/MinProtocol = TLSv1/g' /etc/ssl/openssl.cnf & \
    sed -i '/^ssl_conf = ssl_sect$/s/^/#/' /etc/ssl/openssl.cnf & \
    
    sed -i 's/SECLEVEL=2/SECLEVEL=1/g' /usr/lib/ssl/openssl.cnf & \
    sed -i 's/TLSv1.2/TLSv1.0/g' /usr/lib/ssl/openssl.cnf & \
    sed -i 's/DEFAULT@SECLEVEL=2/DEFAULT@SECLEVEL=1/g' /usr/lib/ssl/openssl.cnf & \
    sed -i 's/MinProtocol = TLSv1.2/MinProtocol = TLSv1/g' /usr/lib/ssl/openssl.cnf  & \
    sed -i '/^ssl_conf = ssl_sect$/s/^/#/' /usr/lib/ssl/openssl.cnf

RUN update-ca-certificates

ENV TZ="Europe/Moscow"

WORKDIR /app
COPY pub/ ./
ENTRYPOINT ["dotnet", "RetailClient.Web.dll"]