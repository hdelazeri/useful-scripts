#!/bin/bash

# Chek for root permission
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Remove old versions
echo "Removing old versions"
rm -Rf /opt/firefox-developer*
rm -Rf /usr/bin/firefox-developer
rm -Rf /usr/share/applications/firefox-developer.desktop

# Go to temp folder
cd /tmp

# Download new version
echo "Downloading new version"
wget "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US" -O firefox-developer.tar.bz2 -q --show-progress

# Extract new version
echo "Extracting new version"
tar -jxf  firefox-developer.tar.bz2 -C /opt/ --checkpoint=.100

# Move install to correct location
echo -e "\nMoving files to correct location"
mv /opt/firefox*/ /opt/firefox-developer

# Create bin link
echo "Creating bin file link"
ln -sf /opt/firefox-developer/firefox /usr/bin/firefox-developer

# Create desktop entry
echo "Creating desktop entry"
echo -e '[Desktop Entry]\n Version=59.0.3\n Encoding=UTF-8\n Name=Mozilla Firefox\n Comment=Navegador Web\n Exec=/opt/firefox-developer/firefox\n Icon=/opt/firefox-developer/browser/chrome/icons/default/default128.png\n Type=Application\n Categories=Network\n StartupWMClass=Firefox Developer Edition' >  /usr/share/applications/firefox-developer.desktop

# Removing files
echo "Removing files"
rm -f firefox-developer.tar.bz2

# Done
echo "Done"
