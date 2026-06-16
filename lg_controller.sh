#!/bin/bash

# Liquid Galaxy Controller Script for KML Export Feature
# Usage: ./lg_controller.sh <LG_MASTER_IP>

LG_IP=$1
KML_FILE="medium_example.kml"
LG_USER="lg"
LG_PASS="lg" # Default password for LG rigs is usually 'lg'
REMOTE_KML_DIR="/var/www/html"
REMOTE_KML_URL="http://localhost:81/$KML_FILE"

if [ -z "$LG_IP" ]; then
    echo "Error: Please provide the IP address of your Liquid Galaxy Master node."
    echo "Usage: ./lg_controller.sh <LG_MASTER_IP>"
    exit 1
fi

echo "========================================"
echo "🌍 Sending Map to Liquid Galaxy"
echo "========================================"

# 1. Upload KML File to the Master Node
echo "[1/3] Uploading $KML_FILE to $LG_IP..."
scp $KML_FILE $LG_USER@$LG_IP:$REMOTE_KML_DIR/$KML_FILE

# 2. Update kmls.txt to tell Google Earth to load it
echo "[2/3] Instructing LG to load the KML..."
ssh $LG_USER@$LG_IP "echo '$REMOTE_KML_URL' > $REMOTE_KML_DIR/kmls.txt"

# 3. Wait a few seconds for Google Earth to parse the KML
echo "[3/3] Waiting for Google Earth to render..."
sleep 3

echo "========================================"
echo "✈️  Triggering 'Fly To' Animations"
echo "========================================"

# Example 1: Fly to English (UK)
echo "Flying to English (United Kingdom)..."
ssh $LG_USER@$LG_IP "echo 'flytoview=<LookAt><longitude>-1.000000</longitude><latitude>52.000000</latitude><altitude>0</altitude><range>5000000</range><tilt>0</tilt><heading>0</heading><gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode></LookAt>' > /tmp/query.txt"
sleep 8 # Wait for the flight to finish

# Example 2: Fly to Hawaiian (Hawaii)
echo "Flying to Hawaiian (Hawaii)..."
ssh $LG_USER@$LG_IP "echo 'flytoview=<LookAt><longitude>-155.5828</longitude><latitude>19.8968</latitude><altitude>0</altitude><range>5000000</range><tilt>45</tilt><heading>0</heading><gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode></LookAt>' > /tmp/query.txt"

echo "========================================"
echo "✅ Demo Complete!"
echo "========================================"
