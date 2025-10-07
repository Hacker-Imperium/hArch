#!/bin/bash

# hArch Docker Lab Startup Script
# Author: Binary-Brawler
# Version: 1.0

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

print_header() {
    echo -e "${PURPLE}$1${RESET}"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to check available resources
check_resources() {
    print_info "Checking system resources..."
    
    # Check available memory
    if command -v free >/dev/null 2>&1; then
        available_mem=$(free -m | awk 'NR==2{printf "%.0f", $7}')
        if [ "$available_mem" -lt 4096 ]; then
            print_warning "Available memory is low (${available_mem}MB). Recommended: 8GB+"
        else
            print_success "Memory check passed (${available_mem}MB available)"
        fi
    fi
    
    # Check available disk space
    available_space=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "$available_space" -lt 20 ]; then
        print_warning "Available disk space is low (${available_space}GB). Recommended: 20GB+"
    else
        print_success "Disk space check passed (${available_space}GB available)"
    fi
}

# Function to display lab information
show_lab_info() {
    print_header "=== hArch Docker Lab ==="
    echo
    echo -e "${CYAN}Available Vulnerable Applications:${RESET}"
    echo -e "  ${WHITE}DVWA:${RESET}           http://localhost:8080 (admin/password)"
    echo -e "  ${WHITE}Juice Shop:${RESET}     http://localhost:3000 (admin/admin123)"
    echo -e "  ${WHITE}WebGoat:${RESET}        http://localhost:8081 (webgoat/webgoat)"
    echo -e "  ${WHITE}WebWolf:${RESET}        http://localhost:9090 (webgoat/webgoat)"
    echo -e "  ${WHITE}Mutillidae:${RESET}     http://localhost:8082 (admin/admin)"
    echo -e "  ${WHITE}Metasploitable 2:${RESET} SSH localhost:2222 (msfadmin/msfadmin)"
    echo -e "  ${WHITE}Kioptrix Level 1:${RESET} http://localhost:8083 (root/root)"
    echo
    echo -e "${CYAN}Access the main lab container:${RESET}"
    echo -e "  ${WHITE}docker exec -it harch_lab bash${RESET}"
    echo
    echo -e "${CYAN}Useful commands:${RESET}"
    echo -e "  ${WHITE}docker-compose ps${RESET}           - View container status"
    echo -e "  ${WHITE}docker-compose logs <service>${RESET} - View service logs"
    echo -e "  ${WHITE}docker-compose down${RESET}         - Stop the lab"
    echo -e "  ${WHITE}docker-compose restart <service>${RESET} - Restart a service"
    echo
}

# Function to start the lab
start_lab() {
    local profile=""
    local rebuild=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --logging)
                profile="--profile logging"
                shift
                ;;
            --rebuild)
                rebuild=true
                shift
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --logging    Start with ELK stack for log analysis"
                echo "  --rebuild    Rebuild containers before starting"
                echo "  --help       Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    print_header "Starting hArch Docker Lab..."
    
    # Check prerequisites
    check_docker
    check_resources
    
    # Change to Docker directory
    cd "$(dirname "$0")"
    
    # Rebuild if requested
    if [ "$rebuild" = true ]; then
        print_info "Rebuilding containers..."
        docker-compose build --no-cache
    fi
    
    # Start the lab
    print_info "Starting containers..."
    if [ -n "$profile" ]; then
        print_info "Starting with logging stack..."
        docker-compose $profile up -d
    else
        docker-compose up -d
    fi
    
    # Wait for services to be ready
    print_info "Waiting for services to start..."
    sleep 10
    
    # Check container status
    print_info "Checking container status..."
    docker-compose ps
    
    # Show lab information
    show_lab_info
    
    print_success "hArch Docker Lab is ready!"
    print_info "Access the main container with: docker exec -it harch_lab bash"
}

# Function to stop the lab
stop_lab() {
    print_header "Stopping hArch Docker Lab..."
    
    cd "$(dirname "$0")"
    docker-compose down
    
    print_success "Lab stopped successfully"
}

# Function to show lab status
show_status() {
    print_header "hArch Docker Lab Status"
    
    cd "$(dirname "$0")"
    docker-compose ps
    
    echo
    print_info "Container logs (last 10 lines each):"
    echo
    
    for container in $(docker-compose ps -q); do
        container_name=$(docker inspect --format='{{.Name}}' "$container" | sed 's/\///')
        echo -e "${CYAN}=== $container_name ===${RESET}"
        docker logs --tail 10 "$container" 2>/dev/null || echo "No logs available"
        echo
    done
}

# Function to clean up
cleanup() {
    print_header "Cleaning up hArch Docker Lab..."
    
    cd "$(dirname "$0")"
    
    print_warning "This will remove all containers, networks, and volumes. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        docker-compose down -v --remove-orphans
        docker system prune -f
        print_success "Cleanup completed"
    else
        print_info "Cleanup cancelled"
    fi
}

# Main script logic
case "${1:-start}" in
    start)
        start_lab "$@"
        ;;
    stop)
        stop_lab
        ;;
    status)
        show_status
        ;;
    cleanup)
        cleanup
        ;;
    restart)
        stop_lab
        sleep 2
        start_lab "${@:2}"
        ;;
    *)
        echo "Usage: $0 {start|stop|status|cleanup|restart} [OPTIONS]"
        echo
        echo "Commands:"
        echo "  start     Start the lab (default)"
        echo "  stop      Stop the lab"
        echo "  status    Show lab status and logs"
        echo "  cleanup   Remove all containers and volumes"
        echo "  restart   Restart the lab"
        echo
        echo "Options for start/restart:"
        echo "  --logging    Start with ELK stack"
        echo "  --rebuild    Rebuild containers"
        echo "  --help       Show detailed help"
        exit 1
        ;;
esac
