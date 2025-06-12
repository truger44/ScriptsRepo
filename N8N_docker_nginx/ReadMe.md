
## Copy & Run This Script on Your VPS

1. **Upload your `.env` file** using `scp`:
2. Open a terminal window in the folder containing your downloaded N8N-setup.env file or 'cd' into it
```
scp n8n-setup.env root@YOUR_SERVER_IP:/root/

```


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

