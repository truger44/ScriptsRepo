#!/bin/bash

echo "🧹 Reverting n8n/Docker/Nginx Proxy Manager setup..."

cd /opt/n8n-setup 2>/dev/null || true

# Stop and remove containers
if [ -f docker-compose.yml ]; then
  echo "🛑 Stopping Docker containers..."
  docker-compose down -v --remove-orphans
fi

# Remove Docker volumes, if any
echo "🧽 Removing Docker volumes and data..."
docker volume rm $(docker volume ls -qf "name=n8n") 2>/dev/null || true
docker volume rm $(docker volume ls -qf "name=postgres") 2>/dev/null || true
docker volume rm $(docker volume ls -qf "name=npm") 2>/dev/null || true

# Remove Docker images (optional, can keep them for reuse)
echo "🗑️ Optionally removing related Docker images..."
docker rmi n8nio/n8n jc21/nginx-proxy-manager postgres:14 2>/dev/null || true

# Remove docker-compose binary
echo "🧼 Cleaning Docker Compose..."
rm -f /usr/local/bin/docker-compose

# Remove .env and files
echo "🗃️ Cleaning up config files..."
rm -rf /opt/n8n-setup
rm -f /root/n8n-setup.env

# Restore SSH config (if changed)
echo "🔐 Restoring SSH config..."
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart ssh

# Remove SSH authorized_keys if we added one
if grep -q "ssh-rsa" ~/.ssh/authorized_keys; then
  echo "🧾 Removing SSH public key (manually added)..."
  > ~/.ssh/authorized_keys
fi

# Reset UFW rules (careful: this disables firewall)
echo "🚧 Resetting UFW firewall..."
ufw --force disable
ufw reset

echo "✅ Uninstallation complete. System should now be back to normal."
