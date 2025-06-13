
## Copy & Run This Script on Your VPS
Open a terminal window in the folder containing your downloaded N8N-setup.env file or 'cd' into it


**SSH into your VPS and run the script**:

```
ssh root@YOUR_SERVER_IP

```

Then run: 
```
bash <(curl -s https://raw.githubusercontent.com/truger44/ScriptsRepo/refs/heads/main/N8N_docker_nginx/n8n-vps-setup/install.sh)

```



## Default Password Summary

|Service|Default Login|
|---|---|
|**n8n**|`admin` / `AbT9eY#73pLr` (from .env)|
|**Postgres**|`n8n` / `PostgresP@ss123`|
|**Nginx Proxy Mgr**|`admin@example.com` / `changeme` (reset on first login)|
UPDATE  YOUR PASSWORDS AFTER USING THIS SCRIPT!


If you get a error about a command not being understood and are using a windows terminal try this instead to fix diffcult windows carriage return issues
```
curl -O https://raw.githubusercontent.com/truger44/ScriptsRepo/refs/heads/main/N8N_docker_nginx/n8n-vps-setup/uninstall.sh
sed -i 's/\r$//' uninstall.sh
chmod +x uninstall.sh
./uninstall.sh

```
