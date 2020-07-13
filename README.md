# Useful scripts

This repository contains some of the scripts I wrote to automate some tasks.

## Firefox Developer Edition

This script installs [Firefox Developer Edition](https://www.mozilla.org/firefox/developer/) and creates a desktop file in the system.

The script doesn't need any parameter and must be executed as root.

## Spigot (Minecraft Server)

**Read all the documentation for this script before running it**

This script installs [Spigot]([https://link](https://www.spigotmc.org/)), an alternative [Minecraft](https://www.minecraft.net/) server, to the system.

This script is based on the [AUR spigot package](https://aur.archlinux.org/packages/spigot) install script.

### Dependencies

To run this script and correctly run the server you must have these packages installed on your system:

- java
- screen
- sudo
- fontconfig
- bash
- awk
- sed
- git

### Installation

To install the server on your system you must run the script as root. It will download all the required files, build the server jar file, put all the files in the correct location and create the user and group for a secure install.

After the script completes the installation process you can add your user to the `spigot` group to edit the files in the server root.

The script installs all the files for the server in `/srv/spigot`.

### More documentation

For more documentation please refer to the [Minecraft Server](https://wiki.archlinux.org/index.php/Minecraft#Server) Arch wiki setup content changing the `minecraftd` command for `spigot` as explained in the alternatives server part. All the files are in the same locations except for the server root changed from `/srv/craftbukkit` to `/srv/spigot` and the user and group for the spigot server changed from `craftbukkit` to `spigot`.

## License

The files and scripts in this repository are licensed under the [GPL License](LICENSE).