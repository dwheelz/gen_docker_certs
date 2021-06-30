#!/bin/bash
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
openssl genrsa -out server-key.pem 4096
echo 'Common Name =' $1
openssl req -subj "/CN=$1" -sha256 -new -key server-key.pem -out server.csr
echo 'Domain name =' $2
echo subjectAltName = DNS:$2,IP:0.0.0.0,IP:127.0.0.1 >> extfile.cnf
echo extendedKeyUsage = serverAuth >> extfile.cnf
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
openssl genrsa -out key.pem 4096
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile-client.cnf
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile-client.cnf
rm -v client.csr server.csr extfile.cnf extfile-client.cnf
mkdir server_certs client_certs ca_files
cp ca.pem ./server_certs
mv server-cert.pem server-key.pem ./server_certs
mv ca.pem cert.pem key.pem ./client_certs
mv ca-key.pem ca.srl ./ca_files
