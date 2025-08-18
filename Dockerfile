# Start with slim Python base
FROM python:3.11-slim

# Install essential Linux packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    ca-certificates \
    docker.io \
    openssh-client \
    jq \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Install kubectl (latest stable)
RUN KUBE_VERSION=$(curl -s https://dl.k8s.io/release/stable.txt) \
    && curl -LO "https://dl.k8s.io/release/${KUBE_VERSION}/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Upgrade pip
RUN pip install --upgrade pip setuptools wheel

# Install Python packages
RUN pip install \
    configparser \
    requests-html \
    lxml_html_clean

# Show versions (debug)
RUN git --version \
    && docker --version \
    && python3 --version \
    && pip --version \
    && aws --version \
    && kubectl version --client \
    && ssh -V \
    && jq --version \
    && openssl version
