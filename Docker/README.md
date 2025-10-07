# hArch Docker Home Lab

A comprehensive Docker-based penetration testing lab environment built on Arch Linux with BlackArch tools and vulnerable applications.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- At least 8GB RAM recommended
- 20GB free disk space

### Basic Usage
```bash
# Start the lab
docker-compose up -d

# Access the main hArch container
docker exec -it harch_lab bash

# View lab status
docker-compose ps

# Stop the lab
docker-compose down
```

## 🎯 Available Vulnerable Applications

| Application | URL | Description | Credentials |
|-------------|-----|-------------|-------------|
| **DVWA** | http://localhost:8080 | Damn Vulnerable Web Application | admin/password |
| **Juice Shop** | http://localhost:3000 | OWASP Juice Shop | admin/admin123 |
| **WebGoat** | http://localhost:8081 | OWASP WebGoat | webgoat/webgoat |
| **WebWolf** | http://localhost:9090 | OWASP WebWolf | webgoat/webgoat |
| **Mutillidae** | http://localhost:8082 | OWASP Mutillidae II | admin/admin |
| **Metasploitable 2** | SSH: localhost:2222 | VulnHub VM | msfadmin/msfadmin |
| **Kioptrix Level 1** | http://localhost:8083 | VulnHub VM | root/root |

## 🛠️ Included Tools

### Network Scanning & Enumeration
- `nmap` - Network mapper
- `masscan` - High-speed port scanner
- `zmap` - Internet-wide scanner
- `unicornscan` - Network port scanner

### Web Application Testing
- `sqlmap` - SQL injection tool
- `dirb` - Directory brute forcer
- `gobuster` - Directory/file brute forcer
- `nikto` - Web vulnerability scanner
- `wpscan` - WordPress security scanner
- `zaproxy` - OWASP ZAP proxy
- `burpsuite` - Web application security testing

### Password Attacks
- `hydra` - Network login cracker
- `john` - Password cracker
- `hashcat` - Advanced password recovery
- `medusa` - Network authentication brute forcer

### Exploitation Frameworks
- `metasploit` - Penetration testing framework
- `beef` - Browser exploitation framework

### Network Analysis
- `wireshark-cli` - Network protocol analyzer
- `tcpdump` - Network packet analyzer
- `netcat` - Network utility
- `socat` - Multipurpose relay

### Information Gathering
- `theharvester` - Email/subdomain/people harvester
- `recon-ng` - Web reconnaissance framework
- `maltego` - Information gathering tool

### Wireless Testing
- `aircrack-ng` - Wireless security tools
- `reaver` - WPS attack tool

### Forensics
- `volatility3` - Memory forensics framework
- `sleuthkit` - Digital forensics toolkit

### Reverse Engineering
- `radare2` - Reverse engineering framework
- `ghidra` - Software reverse engineering suite

## 🔧 Advanced Usage

### Start with Logging Stack
```bash
# Start with ELK stack for log analysis
docker-compose --profile logging up -d
```

### Access Kibana
- URL: http://localhost:5601
- View logs from all containers

### Custom Tool Installation
```bash
# Access the hArch container
docker exec -it harch_lab bash

# Install additional tools
sudo pacman -S <tool-name>

# Or use AUR
yay -S <aur-package>
```

### Volume Management
```bash
# View volumes
docker volume ls

# Backup workspace
docker run --rm -v harch_workspace:/data -v $(pwd):/backup alpine tar czf /backup/workspace-backup.tar.gz -C /data .

# Restore workspace
docker run --rm -v harch_workspace:/data -v $(pwd):/backup alpine tar xzf /backup/workspace-backup.tar.gz -C /data
```

## 🐛 Troubleshooting

### Common Issues

**Container won't start:**
```bash
# Check logs
docker-compose logs <service-name>

# Rebuild containers
docker-compose build --no-cache
```

**Port conflicts:**
```bash
# Check what's using ports
netstat -tulpn | grep :8080

# Modify ports in docker-compose.yaml
```

**Out of disk space:**
```bash
# Clean up Docker
docker system prune -a

# Remove unused volumes
docker volume prune
```

**BlackArch installation fails:**
```bash
# Rebuild with verbose output
docker-compose build --no-cache --progress=plain harch
```

### Performance Optimization

**Resource Limits:**
- Adjust CPU/memory limits in docker-compose.yaml
- Use `docker stats` to monitor resource usage

**Network Performance:**
- Use host networking for better performance: `network_mode: host`
- Adjust network buffer sizes if needed

## 🔒 Security Notes

- This lab is for educational purposes only
- Never expose these containers to the internet
- Use strong passwords in production environments
- Regularly update base images and tools
- Monitor container logs for suspicious activity

## 📚 Learning Resources

### Web Application Security
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [DVWA Documentation](http://www.dvwa.co.uk/)
- [WebGoat Lessons](https://owasp.org/www-project-webgoat/)

### Network Security
- [Nmap Documentation](https://nmap.org/book/)
- [Metasploit Unleashed](https://www.offensive-security.com/metasploit-unleashed/)

### Forensics
- [Volatility Documentation](https://volatility3.readthedocs.io/)
- [SANS Digital Forensics](https://www.sans.org/white-papers/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Disclaimer

This tool is for educational and authorized testing purposes only. Users are responsible for complying with all applicable laws and regulations. The authors are not responsible for any misuse of this tool.
