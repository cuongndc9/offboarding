#!/bin/bash

# Get the current logged-in user
CURRENT_USER=$(whoami)

if [[ "$CURRENT_USER" == "root" ]]; then
    echo "❌ This script should not be run as root. Exiting."
    exit 1
fi

echo "🔄 Offboarding process started for user: $CURRENT_USER"

# 🔒 Logout from accounts
echo "🔐 Logging out from accounts..."
pkill -KILL -u "$CURRENT_USER"

# 🗑️ Remove installed applications
APPS=(
    "google-chrome"
    "notion"
    "telegram"
    "spotify"
    "zalo"
    "messenger"
)

echo "🗑️ Removing applications..."
for APP in "${APPS[@]}"; do
    if brew list --cask "$APP" &>/dev/null; then
        echo "❌ Uninstalling $APP..."
        brew uninstall --cask "$APP"
    else
        echo "✔️ $APP is not installed. Skipping."
    fi
done

# 🧹 Cleanup user data
echo "🧹 Cleaning up workspace..."
sudo rm -rf "/Users/$CURRENT_USER"

# 🌍 Flush DNS cache
echo "🌍 Flushing DNS cache..."
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder

echo "✅ Offboarding completed for user: $CURRENT_USER"
