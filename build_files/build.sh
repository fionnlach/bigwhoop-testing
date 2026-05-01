#!/bin/bash
set -ouex pipefail

# 1. Enable Repositories
# Dank Linux COPR for DMS, dgop, and other Dank tools
dnf -y copr enable avengemedia/danklinux

# (Optional) Niri is in official Fedora repos, but the COPR version is often newer
dnf -y copr enable yalter/niri

# 2. Install Packages
# niri: The scrollable window manager
# dms: Dank Material Shell
# matugen: Material color generator (required for DMS themes)
dnf -y install \
    niri \
    dms \
    matugen \
    dgop \
    dsearch \
    accountsservice

# 3. Configure /etc/skel
# This ensures new users get the Dank config in their home directory automatically.
# We create the directory structure and use 'dms setup' logic.
mkdir -p /etc/skel/.config/niri

# Create a basic autostart for niri to launch dms
cat <<EOF > /etc/skel/.config/niri/config.kdl
// Run Dank Material Shell on startup
spawn-at-startup "dms" "run"

// Include default niri binds or your custom ones here
EOF

# 4. Enable Services
# Some Dank tools run as user services. 
# We can pre-enable them for all users by symlinking in /usr/lib/systemd/user/
mkdir -p /usr/lib/systemd/user/default.target.wants
ln -s /usr/lib/systemd/user/dms.service /usr/lib/systemd/user/default.target.wants/dms.service

# 5. Cleanup
dnf clean all
