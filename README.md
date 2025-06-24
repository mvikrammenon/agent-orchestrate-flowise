# Flowise Docker Setup

This project provides a Docker setup to run [Flowise](https://github.com/FlowiseAI/Flowise) locally. This allows for easy testing and development of LLM agent workflows, including integration with services like AWS Bedrock.

## Prerequisites

*   [Docker](https://docs.docker.com/get-docker/) installed on your system.
*   [Docker Compose](https://docs.docker.com/compose/install/) (usually included with Docker Desktop).

## Getting Started

1.  **Clone the repository (or create the files):**
    If you've cloned this setup, you're ready. Otherwise, ensure you have the `Dockerfile` and `docker-compose.yml` in your project directory.

2.  **Create a `.env` file (Optional but Recommended):**
    Create a file named `.env` in the same directory as `docker-compose.yml` to store your Flowise credentials and any other sensitive information. This keeps them out of your `docker-compose.yml` file.

    ```env
    # .env
    FLOWISE_USERNAME=your_flowise_admin_username
    FLOWISE_PASSWORD=your_flowise_admin_password

    # Optional: AWS Credentials for Bedrock (if not using IAM roles or other methods)
    # AWS_ACCESS_KEY_ID=your_aws_access_key_id
    # AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
    # AWS_REGION=your_aws_region # e.g., us-east-1
    ```
    Replace the placeholder values with your desired username and password for Flowise, and your AWS credentials if you choose to manage them this way.

3.  **Create Data Directory:**
    The `docker-compose.yml` is configured to mount a local directory `flowise_data` into the container at `/root/.flowise` to persist your Flowise chatflows, credentials, and other data. Create this directory in your project root:
    ```bash
    mkdir flowise_data
    ```
    *Note: You'll need to run this command in your local terminal, not through the agent's bash session.*

4.  **Build and Run the Container:**
    Open a terminal in the project directory (where `docker-compose.yml` is located) and run:
    ```bash
    docker-compose up --build
    ```
    The `--build` flag ensures the image is built (or rebuilt if changes were made to `Dockerfile`). In subsequent runs, you can omit `--build` if the Dockerfile hasn't changed: `docker-compose up`.

    To run in detached mode (in the background):
    ```bash
    docker-compose up -d --build
    ```

5.  **Access Flowise:**
    Once the container is running, open your web browser and navigate to:
    [http://localhost:3000](http://localhost:3000)

    You should see the Flowise interface. If you set `FLOWISE_USERNAME` and `FLOWISE_PASSWORD` in your `.env` file, Flowise will prompt you for these credentials.

## AWS Bedrock Integration

To use AWS Bedrock tools with Flowise:

1.  **Configure AWS Credentials:**
    *   **Recommended (Cloud Environments):** If running this Docker setup on an EC2 instance or ECS, configure an IAM role with appropriate Bedrock permissions for the instance/task. Flowise (and the AWS SDK it uses) should automatically pick up these credentials.
    *   **Local Development (using `.env`):** As shown in the `.env` file example, you can set `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_REGION` in your `.env` file. These will be passed as environment variables to the Flowise container.
    *   **Shared Credentials File (Local Development):** You can mount your local AWS credentials file (`~/.aws/credentials`) and config file (`~/.aws/config`) into the container. This is generally more secure than environment variables for local development but requires modifying `docker-compose.yml`:
        ```yaml
        # In docker-compose.yml services.flowise.volumes:
        # - ~/.aws:/root/.aws:ro # Mount as read-only
        ```
        And ensure your `~/.aws/credentials` and `~/.aws/config` files are set up correctly on your host machine.
    Ensure the credentials or IAM role have permissions to access AWS Bedrock services (e.g., `bedrock:InvokeModel`, `bedrock:ListFoundationModels`).

2.  **Use Bedrock Nodes in Flowise:**
    *   Inside Flowise, when building your chatflows, you will find nodes for AWS Bedrock under "Chat Models" or "LLMs".
    *   Select the desired Bedrock model and configure its parameters, including selecting your AWS credential name (if you've added one in Flowise) or relying on the environment/IAM role.
    *   For using "Agent as Tool" specifically with Bedrock, refer to the official Flowise documentation: [Agent as Tool Tutorial](https://docs.flowiseai.com/tutorials/agent-as-tool). This will guide you on how to integrate Bedrock-powered agents or functions as tools within a larger Flowise agent. You'll typically create a chatflow that uses a Bedrock model and then expose that chatflow as a tool for another agent.

## Managing the Container

*   **Stop the container:**
    If running in the foreground, press `Ctrl+C` in the terminal.
    If running in detached mode, use:
    ```bash
    docker-compose down
    ```
*   **View logs (if running in detached mode):**
    ```bash
    docker-compose logs -f flowise
    ```
*   **Remove the container (and network, but not the volume):**
    ```bash
    docker-compose down
    ```
*   **Remove the container, network, AND the data volume (`flowise_data` contents will be deleted if you used the local directory):**
    ```bash
    docker-compose down -v
    ```

## Customization

*   You can modify the `Dockerfile` to install additional dependencies if needed. Remember to rebuild the image (`docker-compose build` or `docker-compose up --build`) after changes.
*   Adjust port mappings or environment variables in `docker-compose.yml` as required.
*   The `flowise_data` directory (if you created it locally and mounted it) will persist your Flowise configurations. Back up this directory if needed.
```
