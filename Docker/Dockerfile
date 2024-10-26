FROM archlinux:latest

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm curl base-devel git procps-ng

RUN curl -O https://blackarch.org/strap.sh \
    && chmod +x strap.sh \
    && ./strap.sh --noconfirm \
    && rm strap.sh

# Add more for home hack lab...
RUN pacman -S --noconfirm nmap sqlmap dirb gobuster metasploit nikto wireshark-cli hydra john theharvester wpscan zaproxy

# Keeps the container running
CMD ["tail", "-f", "/dev/null"]
