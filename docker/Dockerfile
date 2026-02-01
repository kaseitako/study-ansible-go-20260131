FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    python3 \
    python3-apt \
    sudo \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Go
ENV GO_VERSION=1.25.0
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -O /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/home/ansible/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Create SSH directory
RUN mkdir /var/run/sshd

# Create ansible user with sudo privileges
RUN useradd -m -s /bin/bash ansible && \
    echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Setup SSH for ansible user
RUN mkdir -p /home/ansible/.ssh && \
    chmod 700 /home/ansible/.ssh && \
    chown ansible:ansible /home/ansible/.ssh

# Setup Go environment for ansible user
RUN mkdir -p /home/ansible/go && \
    chown ansible:ansible /home/ansible/go && \
    echo 'export PATH="/usr/local/go/bin:$PATH"' >> /home/ansible/.bashrc && \
    echo 'export GOPATH="/home/ansible/go"' >> /home/ansible/.bashrc && \
    echo 'export PATH="$GOPATH/bin:$PATH"' >> /home/ansible/.bashrc

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
