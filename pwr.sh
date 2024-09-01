#!/bin/bash

# Colors for text formatting
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Opening Information
echo -e "${CYAN}${BOLD}********************************************${NC}"
echo -e "${CYAN}${BOLD}*     1 Click PWR Node Setup by           *${NC}"
echo -e "${CYAN}${BOLD}*           Airdrop Sultan                *${NC}"
echo -e "${CYAN}${BOLD}********************************************${NC}"
echo ""
echo -e "${YELLOW}${BOLD}This entire code is created by Brian (x.com/brianeedsleep)${NC}"
echo -e "${YELLOW}${BOLD}Make sure you have joined Airdrop Sultan at t.me/airdropsultanindonesia${NC}"
echo ""

# Language Selection
echo "Please select your language / Silakan pilih bahasa kamu:"
echo "1) English"
echo "2) Bahasa Indonesia"
read -p "Choose an option (1 or 2): " lang

# Function for displaying messages in both languages
message() {
  if [ "$lang" -eq 1 ]; then
    echo -e "${YELLOW}${BOLD}$1${NC}"
  else
    echo -e "${YELLOW}${BOLD}$2${NC}"
  fi
}

# Operation Selection
echo "Please select an operation / Silakan pilih operasi:"
echo "1) Install"
echo "2) Update"
read -p "Choose an option (1 or 2): " operation

if [ "$operation" -eq 1 ]; then
    # Install Process
    echo -e "${YELLOW}${BOLD}Starting the installation process...${NC}"
    
    # Update OS
    sudo apt update

    # Install Java
    sudo apt install -y default-jdk

    # Download Validator Node Software and Config File
    wget https://github.com/pwrlabs/PWR-Validator-Node/raw/main/validator.jar
    wget https://github.com/pwrlabs/PWR-Validator-Node/raw/main/config.json
    
    # Create Password File
    if [ "$lang" -eq 1 ]; then
        read -sp "Enter your desired password for the node: " NODE_PASSWORD
    else
        read -sp "Masukkan kata sandi yang kamu inginkan untuk node: " NODE_PASSWORD
    fi
    echo "$NODE_PASSWORD" > password

    # Import Validator Key (Optional)
    if [ "$lang" -eq 1 ]; then
        read -p "Do you have a private key to import? (y/n): " import_key
    else
        read -p "Apakah kamu memiliki private key untuk diimpor? (y/n): " import_key
    fi
    if [ "$import_key" = "y" ]; then
      if [ "$lang" -eq 1 ]; then
          read -p "Enter your private key: " PRIVATE_KEY
      else
          read -p "Masukkan private key kamu: " PRIVATE_KEY
      fi
      sudo java -jar validator.jar --import-key "$PRIVATE_KEY" password
    fi

    # Run the Node in the Background
    if [ "$lang" -eq 1 ]; then
        read -p "Enter your server IP address: " SERVER_IP
    else
        read -p "Masukkan alamat IP server kamu: " SERVER_IP
    fi
    nohup sudo java -jar validator.jar password "$SERVER_IP" --compression-level 0 &

    # Confirmation message after starting node
    message "Node validator has been successfully started in the background." "Node validator telah berhasil dimulai di latar belakang."
    
elif [ "$operation" -eq 2 ]; then
    # Update Process
    echo -e "${YELLOW}${BOLD}Starting the update process...${NC}"
    
    # Auto-update system
    while true; do
      # Check for updates
      wget -q --spider https://github.com/pwrlabs/PWR-Validator-Node/raw/main/validator.jar
      if [ $? -eq 0 ]; then
        message "Update found! Updating the validator node..." "Pembaruan ditemukan! Memperbarui node validator..."
        
        # Stop the old validator
        sudo pkill java

        # Remove old files
        sudo rm -rf validator.jar config.json blocks

        # Install new versions
        wget https://github.com/pwrlabs/PWR-Validator-Node/raw/main/validator.jar
        wget https://github.com/pwrlabs/PWR-Validator-Node/raw/main/config.json

        # Run the updated node in the background
        nohup sudo java -jar validator.jar password "$SERVER_IP" --compression-level 0 &
        
        message "Validator node updated and restarted successfully." "Node validator berhasil diperbarui dan dimulai ulang."
      fi

      # Delay before the next update check
      sleep 86400 # Check once a day (86400 seconds)
    done

else
    message "Invalid option selected." "Opsi tidak valid dipilih."
fi

# Closing Information
message "For support, you don’t need to donate. Just follow me on x.com/brianeedsleep and join t.me/airdropsultanindonesia" "Untuk dukungan, kamu tidak perlu berdonasi. Cukup ikuti aku di x.com/brianeedsleep dan bergabunglah dengan t.me/airdropsultanindonesia"
