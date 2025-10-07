FROM archlinux:latest

# Update system and install base packages
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm \
        curl \
        wget \
        base-devel \
        git \
        procps-ng \
        sudo \
        vim \
        nano \
        python \
        python-pip \
        nodejs \
        npm \
        go \
        rust \
        jdk-openjdk

# Install BlackArch repository
RUN curl -O https://blackarch.org/strap.sh \
    && chmod +x strap.sh \
    && echo "y" | ./strap.sh \
    && rm strap.sh \
    && pacman -Syu --noconfirm

# Install comprehensive hacking tools
RUN pacman -S --noconfirm \
    # Network scanning and enumeration
    nmap \
    masscan \
    zmap \
    unicornscan \
    \
    # Web application testing
    sqlmap \
    dirb \
    gobuster \
    dirbuster \
    nikto \
    wpscan \
    zaproxy \
    burpsuite \
    \
    # Password attacks
    hydra \
    john \
    hashcat \
    medusa \
    \
    # Exploitation frameworks
    metasploit \
    beef \
    \
    # Network analysis
    wireshark-cli \
    tcpdump \
    netcat \
    socat \
    \
    # Information gathering
    theharvester \
    recon-ng \
    maltego \
    \
    # Wireless testing
    aircrack-ng \
    reaver \
    \
    # Forensics
    volatility3 \
    sleuthkit \
    \
    # Reverse engineering
    radare2 \
    ghidra \
    \
    # Additional useful tools
    curl \
    wget \
    net-tools \
    dnsutils \
    whois \
    enum4linux \
    smbclient \
    ldap-utils

# Create a non-root user for security
RUN useradd -m -s /bin/bash hacker \
    && echo "hacker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /home/hacker/tools \
    && mkdir -p /home/hacker/workspace \
    && chown -R hacker:hacker /home/hacker

# Set up working directory
WORKDIR /home/hacker

# Switch to non-root user
USER hacker

# Create useful aliases and environment setup
RUN echo 'alias ll="ls -la"' >> ~/.bashrc \
    && echo 'alias la="ls -A"' >> ~/.bashrc \
    && echo 'alias l="ls -CF"' >> ~/.bashrc \
    && echo 'alias ..="cd .."' >> ~/.bashrc \
    && echo 'alias ...="cd ../.."' >> ~/.bashrc \
    && echo 'export PATH=$PATH:/home/hacker/tools' >> ~/.bashrc

# Create a startup script
RUN echo '#!/bin/bash' > /home/hacker/start_lab.sh \
    && echo 'echo "=== hArch Hacking Lab ==="' >> /home/hacker/start_lab.sh \
    && echo 'echo "Available vulnerable applications:"' >> /home/hacker/start_lab.sh \
    && echo 'echo "- DVWA: http://localhost:8080"' >> /home/hacker/start_lab.sh \
    && echo 'echo "- Juice Shop: http://localhost:3000"' >> /home/hacker/start_lab.sh \
    && echo 'echo "- WebGoat: http://localhost:8081"' >> /home/hacker/start_lab.sh \
    && echo 'echo "- Mutillidae: http://localhost:8082"' >> /home/hacker/start_lab.sh \
    && echo 'echo "- VulnHub VMs: Check docker-compose for details"' >> /home/hacker/start_lab.sh \
    && echo 'echo ""' >> /home/hacker/start_lab.sh \
    && echo 'echo "Happy Hacking!"' >> /home/hacker/start_lab.sh \
    && chmod +x /home/hacker/start_lab.sh

# Expose common ports for tools
EXPOSE 4444 8080 8081 8082 3000 9090

# Keep container running and show lab info
CMD ["/bin/bash", "-c", "/home/hacker/start_lab.sh && tail -f /dev/null"]
