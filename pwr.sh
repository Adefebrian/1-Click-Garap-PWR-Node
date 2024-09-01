#!/bin/bash

CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${CYAN}${BOLD}********************************************${NC}"
echo -e "${CYAN}${BOLD}*     1 Click PWR Node Setup by           *${NC}"
echo -e "${CYAN}${BOLD}*           Airdrop Sultan                *${NC}"
echo -e "${CYAN}${BOLD}********************************************${NC}"
echo ""
echo -e "${YELLOW}${BOLD}This entire code is created by Brian (x.com/brianeedsleep)${NC}"
echo -e "${YELLOW}${BOLD}Make sure you have joined Airdrop Sultan at t.me/airdropsultanindonesia${NC}"
echo ""

echo "Choose your language / Pilih bahasa:"
echo "1) English"
echo "2) Bahasa Indonesia"
read -p "Enter 1 or 2 / Masukkan 1 atau 2: " language

if [ "$language" -eq 1 ]; then
    lang="en"
elif [ "$language" -eq 2 ]; then
    lang="id"
else
    echo "Invalid input. Defaulting to English."
    lang="en"
fi

message() {
    if [ "$lang" == "en" ]; then
        echo -e "$1"
    else
        echo -e "$2"
    fi
}

install_docker() {
    message "Do you want to install Docker? (Y/N)" "Apakah kamu ingin menginstal Docker? (Y/N)"
    read -p "(Y/N): " install_docker

    if [ "$install_docker" == "Y" ] || [ "$install_docker" == "y" ]; then
        sudo apt-get install -y docker.io
    else
        message "Skipping Docker installation." "Melewatkan instalasi Docker."
    fi
}

install_docker_compose() {
    message "Do you want to install Docker Compose? (Y/N)" "Apakah kamu ingin menginstal Docker Compose? (Y/N)"
    read -p "(Y/N): " install_docker_compose

    if [ "$install_docker_compose" == "Y" ] || [ "$install_docker_compose" == "y" ]; then
        sudo apt-get install -y docker-compose
    else
        message "Skipping Docker Compose installation." "Melewatkan instalasi Docker Compose."
    fi
}

install_java() {
    message "Do you want to install openjdk-19-jdk-headless? (Y/N)" "Apakah kamu ingin menginstal openjdk-19-jdk-headless? (Y/N)"
    read -p "(Y/N): " install_java

    if [ "$install_java" == "Y" ] || [ "$install_java" == "y" ]; then
        sudo apt update
        sudo add-apt-repository ppa:openjdk-r/ppa
        sudo apt update
        sudo apt install -y openjdk-19-jdk-headless
    else
        message "Skipping openjdk-19-jdk-headless installation." "Melewatkan instalasi openjdk-19-jdk-headless."
    fi
}

install_docker
install_docker_compose
install_java

message "Opening required TCP and UDP ports..." "Membuka port TCP dan UDP yang diperlukan..."
sudo ufw allow 8231/tcp
sudo ufw allow 8085/tcp
sudo ufw allow 7621/udp

message "Removing old Docker Compose file..." "Menghapus file Docker Compose lama..."
rm -f docker-compose.yml

message "Downloading validator software..." "Mengunduh software validator..."
wget https://github.com/pwrlabs/PWR-Validator-Node/raw/main/validator.jar

message "Downloading config file..." "Mengunduh file konfigurasi..."
wget https://github.com/pwrlabs/PWR-Validator-Node/raw/main/config.json

if [ ! -f "config.json" ]; then
    message "Error: config.json file not found!" "Error: file config.json tidak ditemukan!"
    exit 1
fi

message "Please enter your desired password:" "Silakan masukkan kata sandi yang kamu inginkan:"
read -s password
echo $password > password

message "Please enter your server IP address:" "Silakan masukkan alamat IP server kamu:"
read -p "Server IP: " server_ip

message "Do you want to import a private key? (Y/N)" "Apakah kamu ingin mengimpor private key? (Y/N)"
read -p "(Y/N): " import_key

if [ "$import_key" == "Y" ] || [ "$import_key" == "y" ]; then
    message "Please enter your private key:" "Silakan masukkan private key kamu:"
    read -s private_key
    sudo java -jar validator.jar --import-key $private_key password
fi

message "Creating new Docker Compose file..." "Membuat file Docker Compose baru..."
cat <<EOF > docker-compose.yml
version: '3'
services:
  pwr-validator-node:
    image: openjdk:latest
    container_name: pwr-validator-node
    volumes:
      - ./validator.jar:/app/validator.jar
      - ./config.json:/app/config.json
    command: ["java", "-jar", "/app/validator.jar", "password", "$server_ip", "--compression-level", "0"]
    ports:
      - "8231:8231"
      - "8085:8085"
      - "7621:7621/udp"
    restart: unless-stopped
EOF

message "Starting PWR Validator Node in Docker..." "Memulai PWR Validator Node di Docker..."
docker-compose up -d

message "PWR Validator Node setup complete and running in Docker!" "PWR Validator Node berhasil dipasang dan berjalan di Docker!"
echo ""
message "For support, you don’t need to donate. Just follow me on x.com/brianeedsleep and join t.me/airdropsultanindonesia" "Untuk dukungan, kamu tidak perlu berdonasi. Cukup ikuti aku di x.com/brianeedsleep dan bergabunglah dengan t.me/airdropsultanindonesia"
