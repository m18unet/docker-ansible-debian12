# Debian 12 (Bookworm) Ansible Container Image

Debian 12 (Bookworm) container image designed for testing Ansible playbooks and roles.

## How to Use

1. [Install Docker](https://docs.docker.com/engine/install/)
1. Pull this image:
    ```bash
    docker pull ghcr.io/m18unet/docker-ansible-debian12:latest
    ```
1. Run a container from the image:
  - Example 1:

    ```bash
    docker run -it ghcr.io/m18unet/docker-ansible-debian12:latest
    ```
  - Example 2:
    ```bash
    docker run -it \
      --mount type=bind,source=<INVENTORY_FILE>,dst=/tmp/inventory.ini \
      --mount type=bind,source=<PLAYBOOK_FILE>,dst=/tmp/playbook.yml \
      ghcr.io/m18unet/docker-ansible-debian12:latest /tmp/playbook.yml --inventory /tmp/inventory.ini
    ```

## Notes

Use on production servers/in the wild at your own risk!

## To-dos

- Integrate with Github Action
