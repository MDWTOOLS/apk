#!/bin/bash
# ============================================
# Ubuntu Desktop + noVNC for Railway
# ============================================

export TMPDIR=/root/tmp
export TMP=/root/tmp
export TEMP=/root/tmp

echo "[1/5] Starting D-Bus..."
dbus-daemon --system --fork 2>/dev/null
mkdir -p /run/dbus

echo "[2/5] Starting VNC Server..."
vncserver :1 -geometry 1920x1080 -depth 24 -localhost no 2>/dev/null
sleep 3

echo "[3/5] Starting noVNC (websockify) on port 8080..."
# Kill any existing websockify
pkill -f websockify 2>/dev/null
sleep 1

# Start websockify + noVNC web interface on port 8080
websockify --web /usr/share/novnc/ 8080 localhost:5901 \
    --heartbeat 30 \
    > /root/tmp/websockify.log 2>&1 &
sleep 2

echo "[4/5] Starting SSH Server..."
# Generate host keys if missing
ssh-keygen -A 2>/dev/null
/usr/sbin/sshd 2>/dev/null

echo "[5/5] All services started!"
echo "============================================="
echo " Desktop: https://YOUR-RAILWAY-URL/"
echo " VNC Password: Dandi"
echo " SSH: port 22 (if exposed)"
echo "============================================="

# Keep container alive
wait
