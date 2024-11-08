# Database Workshop

## Getting Started

### 1. Configure your local environment (optional)
Create a local file `.env.local` and override the necessary environment variables. 

For example:
```.env.local
CONTAINER_NAME=local-db
PORT=5430
```



> [!IMPORTANT]
> Check details before start the container

<details>
    <summary><b>SUBNET Details</b> (important)</summary>

The container use a default subnet defined at .env file. It is recommended to verify the subnet range to avoid 
conflicts with other docker networks or/and VPNs

Use the following command to validate the subnet range:
    
    ip l r

You also can check existing docker network using

    docker network list
    docker network inspect <network>
</details>

### 2. Start docker containers
Use `make up` to start all containers.

The command also accepts [extra options](https://docs.docker.com/reference/cli/docker/compose/up/#options).

### 3. Connect to the database
Run `make connect` to make a connection with the database and run custom queries.

### 4. Connect to Database Expertise Console
Run `make console` to open a console to navigate, run and test the exercises.