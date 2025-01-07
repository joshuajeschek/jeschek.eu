#!/bin/bash
# Used only on STEAM DOCKERFILE
# Steam Version doesn't have a proper SH start File
# and we require on to execute properly on xterm
echo "Running Stardew Valley" 
cd "${GAME_PATH}" 
chmod +x * 
./"StardewValley" 
