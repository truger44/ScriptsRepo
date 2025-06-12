#!/bin/bash

# Load .env config
source /root/n8n-setup.env

# Update and install dependencies
apt update && apt upgrade -y
apt install -y curl ufw docker.io git

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/2.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create working dir
mkdir -p /opt/n8n-setup
cd /opt/n8n-setup

# Write .env
cat <<EOF > .env
N8N_BASIC_AUTH_USER=$N8N_USER
N8N_BASIC_AUTH_PASSWORD=$N8N_PASSWORD
POSTGRES_USER=$POSTGRES_USER
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_DB=$POSTGRES_DB
EOF

# Write docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  postgres:
    image: postgres:14
    restart: always
    environment:
      POSTGRES_USER: \${POSTGRES_USER}
      POSTGRES_PASSWORD: \${POSTGRES_PASSWORD}
      POSTGRES_DB: \${POSTGRES_DB}
    volumes:
      - postgres-data:/var/lib/postgresql/data

  n8n:
    image: n8nio/n8n
    restart: always
    ports:
      - "5678:5678"
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=\${POSTGRES_DB}
      - DB_POSTGRESDB_USER=\${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=\${POSTGRES_PASSWORD}
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=\${N8N_BASIC_AUTH_USER}
      - N8N_BASIC_AUTH_PASSWORD=\${N8N_BASIC_AUTH_PASSWORD}
      - N8N_HOST=$DOMAIN_NAME
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=https://$DOMAIN_NAME/
    depends_on:
      - postgres
    volumes:
      - n8n-data:/home/node/.n8n

  npm:
    image: jc21/nginx-proxy-manager:latest
    restart: always
    ports:
      - "80:80"
      - "81:81"
      - "443:443"
    volumes:
      - npm-data:/data
      - npm-letsencrypt:/etc/letsencrypt

volumes:
  postgres-data:
  n8n-data:
  npm-data:
  npm-letsencrypt:
EOF

# Start containers
docker-compose up -d

# Setup firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable

# Harden SSH
mkdir -p ~/.ssh
echo "$SSH_PUBLIC_KEY" > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh

sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
systemctl restart ssh

echo "✅ Setup complete! Access Nginx Proxy Manager at: http://$DOMAIN_NAME:81"