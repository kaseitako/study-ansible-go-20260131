#!/bin/bash

set -e

# Move to project root
cd "$(dirname "$0")/.."

echo "=== Ansible Learning Environment Setup ==="

# Create SSH keys directory
mkdir -p ssh_keys

# Generate SSH key pair if not exists
if [ ! -f ssh_keys/ansible_key ]; then
    echo "Generating SSH key pair..."
    ssh-keygen -t ed25519 -f ssh_keys/ansible_key -N "" -C "ansible@local"
    echo "SSH keys generated."
else
    echo "SSH keys already exist."
fi

# Build and start containers
echo "Building and starting Docker containers..."
docker compose up -d --build

# Wait for SSH to be ready
echo "Waiting for SSH services to start..."
sleep 3

# Copy public key to containers
echo "Copying SSH public key to containers..."
for container in bastion webserver; do
    docker exec "$container" mkdir -p /home/ansible/.ssh
    docker cp ssh_keys/ansible_key.pub "$container":/home/ansible/.ssh/authorized_keys
    docker exec "$container" chown ansible:ansible /home/ansible/.ssh/authorized_keys
    docker exec "$container" chmod 600 /home/ansible/.ssh/authorized_keys
done

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Containers:"
echo "  - bastion:   SSH on localhost:2222 (172.20.0.10)"
echo "  - webserver: SSH on localhost:2223 (172.20.0.20), Web on localhost:8080"
echo ""
echo "SSH Access:"
echo "  ssh -i ssh_keys/ansible_key -p 2222 ansible@localhost  # bastion"
echo "  ssh -i ssh_keys/ansible_key -p 2223 ansible@localhost  # webserver"
echo ""
echo "User: ansible / Password: ansible (SSH key recommended)"
