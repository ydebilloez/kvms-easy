#!/bin/bash

#change to wsdd2 for faster performance
WSDD=wsdd

#### Function to install packages
samba_install() {
    check_sudo_user
    # Check if Samba is installed
    if ! dpkg -s samba > /dev/null 2>&1 ; then
        # Install Samba if it's not already installed
        echo "Samba is not installed. Installing..."
  
        sudo apt-get update
        sudo apt install samba -y
    else
        echo "Samba is already installed."
    fi

    # install wsdd
    sudo apt install $WSDD -y

    # install avahi for macOS clients
    sudo apt install avahi-daemon -y

    # Install the gvfs-backends
    sudo apt install gvfs-backends -y
}

#### Function to remove packages
samba_uninstall() {
    # Check if Samba is installed
    if ! dpkg -s samba > /dev/null 2>&1 ; then
        exit
    fi
    # remove samba and other related tools
    check_sudo_user
    sudo apt remove samba $WSDD avahi-daemon gvfs-backends -y
}

#### Function to capture path
samba_selectfolder() {
  while true; do
    echo ""  
    SHARENAME_DEFAULT="Data-disk"
    echo -e "Shared folder location will be: \e[32m$SHAREPATH\e[0m"
    read -p "Please type a name for the new shared folder [${SHARENAME_DEFAULT}]: " SHARENAME
    SHARENAME=${SHARENAME:-$SHARENAME_DEFAULT}

    # Set shared folder location to current folder by default
    SHAREPATH=$PWD

    # Show preview of selected options
    echo ""  
    echo -e "Share name: \e[32m$SHARENAME\e[0m"
    echo -e "Shared folder location will be: \e[32m$SHAREPATH/$SHARENAME\e[0m"
    read -p "Is this correct? (Y/N) [Y]: " confirm

    confirm=${confirm:-"Y"}
    # If user confirms, exit the loop and continue with setup
    if [ "$confirm" = "Y" ] || [ "$confirm" = "y" ]; then
      break
    fi
  done
  # Create directory for shared folder
  mkdir -p "$SHAREPATH/$SHARENAME"
}

#### Function to setup the shared folder as guest on the server
samba_server_guest() {

samba_install

echo "Setting up SAMBA shared folder..."
echo "Current user: $USER"

#Allow samba in the firewall
sudo ufw allow samba

samba_selectfolder

# Add configuration to smb.conf file
sudo tee -a /etc/samba/smb.conf > /dev/null <<EOT

# The following share was created by the setup samba shared folder script.
[$SHARENAME]
path = $SHAREPATH/$SHARENAME
read only = no
force user = $USER
guest ok = yes
EOT

# Restart the SAMBA service
sudo systemctl restart smbd
clear
echo ""
echo -e "Shared folder '\e[32m$SHARENAME\e[0m' has been set up successfully at \e[32m$SHAREPATH/$SHARENAME\e[0m"

## Get the IP address of the local machine (option replaced by hostname)
## IPADDR=$(hostname -I | awk '{print $1}')

# Display instructions for accessing the shared folder
echo ""
echo "To access the shared folder from other machines on the network:"
echo ""
echo "Linux clients:"
echo "1. Open the file manager."
echo -e "2. Enter the following URL in the address bar: \e[32msmb://$HOSTNAME.local/$SHARENAME\e[0m"
echo "3. Click 'Connect' and enter 'anonymous' as the username (no password needed)."
echo "If you want to set up the shared folder PERMANENTLY on your client,  "
echo "leave this window open, run this script on your client machine and select"
echo "the 'Setup this computer as the client' option from the menu"
echo -e "RED ADDRESS (for client setup): \e[31m//$HOSTNAME.local/$SHARENAME\e[0m"
echo ""
echo "Windows clients:"
echo "1. Open File Explorer."
echo "2. Click on 'This PC' on the left sidebar."
echo "3. Click on the computer tab and then choose 'Map network drive' in the top bar."
echo -e "4. Enter the following URL in the 'Folder' field: \e[32m\\\\\\\\$HOSTNAME\\\\$SHARENAME\e[0m"
echo "5. Click 'Finish' and enter 'guest' as the username (no password needed)."
echo ""

read -p "Press Enter to exit this program"
exit

}
#### End function to setup the shared folder as guest on the server

#### Function to setup the shared folder with password on the server
samba_server_passw() {

samba_install

echo "Setting up SAMBA shared folder..."
echo "Current user: $USER"

#Allow samba in the firewall
sudo ufw allow samba

samba_selectfolder

# Add configuration to smb.conf file
sudo tee -a /etc/samba/smb.conf > /dev/null <<EOT

# The following share was created by the setup samba shared folder script.
[$SHARENAME]
path = $SHAREPATH/$SHARENAME
read only = no
force user = $USER
guest ok = no
EOT

## Password setup
# Get the current user's name
samba_username=$USER

# Prompt user to enter a password
read -s -p "Enter the password for the shared folder: " password
echo ""

# Set up the shared folder with the password
echo -e "Setting up shared folder with password..."
echo -e "$password\n$password" | sudo smbpasswd -a -s "$samba_username"
echo -e "Shared folder was succesfully set with password: " $password

# Restart the SAMBA service
sudo systemctl restart smbd

echo -e "Shared folder '\e[32m$SHARENAME\e[0m' has been set up successfully at \e[32m$SHAREPATH/$SHARENAME\e[0m"

## Get the IP address of the local machine (option replaced by hostname)
## IPADDR=$(hostname -I | awk '{print $1}')

# Display instructions for accessing the shared folder
clear
echo ""
echo "To access the shared folder from other machines on the network:"
echo ""
echo "Linux clients:"
echo "1. Open the file manager."
echo -e "2. Enter this address: \e[32msmb://$HOSTNAME.local/$SHARENAME\e[0m"
echo "3. Connect as 'Registered User'"
echo -e "Username: \e[32m$samba_username\e[0m, Domain: '\e[32mworkgroup\e[0m', password: \e[32m$password\e[0m"
echo "If you want to set up the shared folder PERMANENTLY on your client,  "
echo "DO NOT CLOSE THIS WINDOW, run this script on your client machine"
echo -e "RED ADDRESS (for client setup): \e[31m//$HOSTNAME.local/$SHARENAME\e[0m"
echo ""
echo "Windows clients:"
echo "1. Open File Explorer."
echo "2. Click on 'This PC' on the left sidebar."
echo "3. Click on the computer tab and then choose 'Map network drive' in the top bar."
echo -e "4. Enter this URL in the folder field: \e[32m\\\\\\\\$HOSTNAME\\\\$SHARENAME\e[0m"
echo "5. Tick the 'Connect using different credentials' checkbox"
echo -e "Username: \e[32m$samba_username\e[0m, password: \e[32m$password\e[0m"
echo "6. Remember my credentials and click 'OK'."

read -p "Press Enter to exit this program"
exit
}
#### End Function to setup the shared folder with password on the server

#### Function to setup the client with a CIFS mount
cifs_setup() {
check_sudo_user
# Prompt the user for a directory name
read -p "Enter the name of the shared directory: " dir_name

# Create the directory and set full access for the current user
sudo mkdir -p "/media/$USER/$dir_name"
sudo chmod 777 "/media/$USER/$dir_name"
sudo chown -R $USER:$USER "/media/$USER/$dir_name"

# Prompt the user for the network share path

while true; do
    read -p "Enter the path of the shared folder on the server EXACTLY AS DISPLAYED IN RED during setup (e.g. //hostname/ShareName): " share_path
    if [[ $share_path =~ ^\/\/[a-zA-Z0-9_.-]+\/[a-zA-Z0-9_]+ ]]; then
        break
    else
        echo "Invalid format. Please enter the path in the format //hostname/ShareName"
    fi
done

# Add the CIFS mount to /etc/fstab
echo "${share_path} /media/$USER/$dir_name cifs credentials=/home/$USER/.smbcredentials,uid=$UID,nounix,noauto,user,dir_mode=0777,file_mode=0666 0 0" | sudo tee -a /etc/fstab > /dev/null

# Prompt the user for the username and password to access the network share
read -p "Enter the username to access the network share (hit ENTER if no username was set): " username
read -s -p "Enter the password to access the network share (hit ENTER if no password was set): " password

# Create the .smbcredentials file with the username and password
echo "username=$username" | tee ~/.smbcredentials > /dev/null
echo "password=$password" | tee -a ~/.smbcredentials > /dev/null
chmod 600 ~/.smbcredentials

# Install the gvfs-backends
sudo apt install gvfs-backends -y

# Mount the share
sudo mount -a
echo ""
read -p "Press Enter to exit this program"
exit
}
#### END Function to setup the client with a CIFS mount

# Function to check if user is in sudo group
check_sudo_user() {
    if [ -z "$(groups $USER | grep sudo)" ]; then
        echo -e "\e[1;31muser $USER is not in sudo group\e[0m"
        exit
    fi
    # user is in sudo group, but could not be allowed to run
    # specific command
    #if [ ! $# -eq 0 ]; then
        # test specific command
    #fi
}

#### Main section with the setup menu

# Function to display the main menu
show_menu() {
    clear
    echo -e "\e[1;36mSelect a server option:\e[0m"
    echo -e "\e[1;34m1. Share a folder with password from this computer\e[0m"
    echo -e "\e[1;34m2. Share a folder anonymously from this computer\e[0m"
    echo -e "\e[1;34m3. Un-Share a folder from this computer\e[0m"
    echo -e "\e[1;36mClient options\e[0m"
    echo -e "\e[1;34m4. Connect this computer to a shared folder (client)\e[0m"
    echo -e "\e[1;34m5. Disconnect this computer from a shared folder\e[0m"
    echo -e "\e[1;36mCleanup options\e[0m"
    echo -e "\e[1;34m9. Uninstall samba from this computer\e[0m"
    echo -e "\e[1;31m0. Quit\e[0m"
}

# Loop to display the main menu until user quits
while true; do
    show_menu
    read -p "Enter your choice: " choice
    case $choice in
        1) samba_server_guest ;;
        2) samba_server_passw ;;
        3) samba_unshare ;;
        4) cifs_setup ;;
        5) cifs_disconnect ;;
        9) samba_uninstall;;
        0) exit 0 ;;
        *) clear; echo -e "\e[1;31mInvalid option. Please try again.\e[0m" ;;
    esac
done

