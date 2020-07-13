#!/bin/bash

BLUE='\033[0;34m'
NC='\033[0m'

function echo_info() {
    echo -e $BLUE$@$NC
}

_game="spigot"
_version=1.16.1
_serverRoot="/srv/spigot"
_user="spigot"

_depends=('java' 'screen' 'sudo' 'fontconfig' 'bash' 'awk' 'sed' 'git')
_commandsDepends=('java' 'screen' 'sudo' 'fc-list' 'bash' 'awk' 'sed' 'git')

_spigotBuildToolsUrl="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
_spigotAurUrl="https://aur.archlinux.org/spigot.git"

# Chek for root permission
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Detect dependencies
echo_info "Detecting dependencies"

for i in "${!_depends[@]}"
do
    if ! command -v ${_commandsDepends[$i]} &> /dev/null
    then
        echo_info "${_depends[$i]} could not be found."
        exit
    fi
done

echo_info "All dependencies found!"
echo_info "There are some optional dependencies for some additional functionalities"
echo_info "\ttar: needed in order to create world backups"
echo_info "\tnetcat: required in order to suspend an idle server"

# Download required files
echo_info "Downloading required files"
cd /tmp
git clone ${_spigotAurUrl}
cd spigot
wget ${_spigotBuildToolsUrl} -O BuildTools.jar -q --show-progress

# Compile the server
echo_info "Compiling the Spigot server jar"
export MAVEN_OPTS="-Xmx2g"
java -jar "BuildTools.jar" --rev ${_version}

sed -i 's/craftbukkit/spigot/g' spigot.conf

# Move the files to the correct locations
echo_info "Moving files to correct location"

install -Dm644 "${_game}.conf" "/etc/conf.d/${_game}"
install -Dm755 "${_game}.sh" "/usr/bin/${_game}"
install -Dm644 "${_game}.service" "/usr/lib/systemd/system/${_game}.service"
install -Dm644 "${_game}-backup.service" "/usr/lib/systemd/system/${_game}-backup.service"
install -Dm644 "${_game}-backup.timer" "/usr/lib/systemd/system/${_game}-backup.timer"
install -Dm644 "${_game}-${_version}.jar" "${_serverRoot}/${_game}.${_version}.jar"
ln -s "${_game}.${_version}.jar" "${_serverRoot}/${_game}.jar"

mkdir -p "/var/log/"
install -dm775 "${_serverRoot}/logs"
ln -s "${_serverRoot}/logs" "/var/log/${_game}"

chmod g+ws "${_serverRoot}"

install -dm777 "${_serverRoot}/plugins"

# Create user and group

if ! getent group "${_user}" &>/dev/null; then
    echo "Adding ${_user} system group..."
    groupadd -r "${_user}" 1>/dev/null
fi

if ! getent passwd "${_user}" &>/dev/null; then
    echo "Adding ${_user} system user..."
    useradd -r -g "${_user}" -d "${_serverRoot}" "${_user}" 1>/dev/null
fi

chown -R "${_user}":"${_user}" "${_serverRoot}"

echo_info "The world data is stored under ${_serverRoot} and the server runs as ${_user} user to increase security."
echo_info "Use the ${_game} script under /usr/bin/${_game} to start, stop or backup the server."
echo_info "Adjust the configuration file under /etc/conf.d/${_game} to your liking."
echo_info "For the server to start you have to accept the EULA in ${_serverRoot}/eula.txt !"
echo_info "The EULA file is generated after the first server start."

# Clean up
rm -rf /tmp/spigot