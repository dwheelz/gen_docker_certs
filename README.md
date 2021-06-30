# gen_docker_certs
Generates the client and server side certs needed to have a TLS enabled remote docker host

# Steps
  
### 1. Run ./gen_certs.sh (param 1: Common name, param 2: Domain name(s))  
This will create three DIRs: server_certs, client_certs, ca_files  
The certs in server_certs are for the Docker host, the certs required for a connecting client are in client_certs  

### 2. Copy your docker.service file to /etc/systemd/system  
cp /lib/systemd/system/docker.service /etc/systemd/system/docker.service  

### 3. Copy server certs into /etc/docker/certs DIR (You may need to create the 'certs' DIR)
  
### 4. Update /etc/systemd/system/docker.service with your options on ExecStart  
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376 \  
  --tlsverify --tlscacert=/etc/docker/certs/ca.pem \  
  --tlskey=/etc/docker/certs/server-key.pem \  
  --tlscert=/etc/docker/certs/server-cert.pem  
    
### 5. Reload systemd config and restart docker service  
systemctl daemon-reload  
systemctl restart docker  
  
# Using client certs
  
## Example docker compose file using client certs below
![image](https://user-images.githubusercontent.com/48966874/124028597-17383180-d9ec-11eb-85b8-b566a0237929.png)
