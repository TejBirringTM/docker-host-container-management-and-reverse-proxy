# Container Management and Reverse Proxy for Docker Host

The Docker Compose File is intended to be used on a Linux-based virtual machine with Docker CE and Docker Compose installed.

In the directory of the Docker Compose File, simply run:

```bash
    docker compose up -d
```

## How It Works

The Docker Compose file will create two services:

### Nginx Proxy Manager

This provides a visual interface over Nginx for creating reverse proxy routes.

### Portainer

This allows for Docker containers to be created, managed, and destroyed using a visual interface.

## How To Use

1. Create a VM.
2. SSH into the VM as `root` user.
3. Clone, download, or recreate the `docker-compose.yaml` file on the VM.
4. Start the services using:

    ```bash
        docker compose up -d
    ```

5. Navigate to Nginx Proxy Manager (NPM) `(http://<IP>:81)` and Portainer `(http://<IP>:8000)` to create accounts.
6. Log into NPM using the newly-created account and create the necessary reverse proxy routes protected by HTTPS.

### Scripts

There are scripts in the `scripts` folder to help with deployment workflows.
