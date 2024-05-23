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
3. Create the internal network (only accessible internally to containers):

    ```bash
        docker network create internal
    ```

4. Clone, download, or recreate the `docker-compose.yaml` file on the VM.
5. Start the services using:

    ```bash
        docker compose up -d
    ```

6. Navigate to Nginx Proxy Manager (NPM) `(http://<IP>:81)` and Portainer `(https://<IP>:9443)` to create accounts.
      * The default admin credentials for NPM are:
        Email: `admin@example.com`
        Password: `changeme`

      * Portainer does not have default admin credentials but it will timeout if an account isn't created soon after launch.
        You can restart it using `docker compose restart portainer`

7. Log into NPM using the newly-created account and create the necessary reverse proxy routes protected by HTTPS.

### Scripts

There are scripts in the `scripts` folder to help with deployment workflows.
