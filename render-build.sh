#!/bin/bash
echo "Installing Google Chrome..."
mkdir -p /opt/render/project/.google-chrome
wget -qO- https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > /opt/render/project/.google-chrome/google-chrome.deb
dpkg -x /opt/render/project/.google-chrome/google-chrome.deb /opt/render/project/.google-chrome/
echo "Google Chrome installed!"
