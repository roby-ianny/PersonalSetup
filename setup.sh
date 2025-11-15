#!/bin/bash
# Execute this script as administrator

echo "Update fedora and install frequently used packages"
sudo dnf update -y                          					# update everything
sudo dnf install distrobox podman-docker podman-compose -y      # install distrobox and podman goodies
sudo dnf install bat -y											# install bat (cool version of cat)
sudo dnf install nextcloud-client -y							# for nextcloud syncronization

echo "Installing flatpaks"
xargs flatpak install -y --noninteractive flathub < flatpaks.txt

# https://github.com/containers/buildah/issues/2959
echo "Change BUILDAH_FORMAT=docker to build Dockerfile with podman with no issues"
sudo echo 'BUILDAH_FORMAT=docker' | sudo tee -a /etc/environment # build Dockerfiles the same way as docker

echo "Set up Git with GitHub CLI"
sudo dnf install gh	-y											# better github integration
gh auth login
gh auth setup-git


read -p "Insert username for git" username
git config --global user.name $username
read -p "Insert username for git" mail
git config --global user.email $mail

# additional configuration for desktop 
read -p "Apply additional config for your desktop? (y/n)" confirm
if [ "$confirm" == "y" ]; then
	# https://discussion.fedoraproject.org/t/severe-display-glitches-on-fedora-43-intel-arc-b580/170988
	echo "Apply patch for broken GTK applications for Intel Arc B580"
	echo 'GSK_RENDERER=gl' | sudo tee -a /etc/environment
	
	echo "Installing additional flatpaks for desktop"
	xargs flatpak install -y --noninteractive flathub < flatpaks_desktop.txt
fi

echo "RESULTS:"

bat /etc/environment
flatpak list

echo "DONE!"
