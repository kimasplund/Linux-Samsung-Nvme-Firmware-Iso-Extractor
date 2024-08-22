#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo ""
    echo ""
    echo "This script must be run as root. Please switch to the root user using 'su' and try again."
    exit 1
fi

# Display disclaimer
echo ""
echo "DISCLAIMER: I am not affiliated with Samsung. "
echo ""
echo "and do not take any responsibility for failed upgrades, broken drives, or lost data that may occur as a result of using this script."
echo ""
echo "Proceed at your own risk."
echo ""
echo "Press Enter to continue or Ctrl+C to cancel."
echo ""
echo "example usage ./samsung_firmware_updater.sh Samsung_SSD_990_PRO_4B2QJXD7.iso"
read

# Check if an ISO file argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_iso_file>"
    exit 1
fi

ISO_PATH="$1"
ISO_MOUNT_DIR="/mnt/iso"
CURRENT_DIR="$(pwd)"

# Redirect output to suppress all except errors and final messages
exec 3>&1
exec 1>/dev/null 2>/dev/null

# Delete /root/fumagician if it exists
if [ -d "/root/fumagician" ]; then
    echo "Deleting existing /root/fumagician directory..." >&3
    rm -rf /root/fumagician
fi

# Check if the ISO mount directory is already mounted, and unmount if necessary
if mount | grep "$ISO_MOUNT_DIR" > /dev/null; then
    echo "ISO mount directory is already mounted. Unmounting..." >&3
    umount "$ISO_MOUNT_DIR"
fi

# Create mount directory if it doesn't exist
mkdir -p "$ISO_MOUNT_DIR"

# Mount the ISO file
echo "Mounting ISO file..." >&3
mount -o loop "$ISO_PATH" "$ISO_MOUNT_DIR"

# Check if the initrd file exists inside the ISO
INITRD_PATH="$ISO_MOUNT_DIR/initrd"
if [ ! -f "$INITRD_PATH" ]; then
    echo "Error: initrd file not found in the ISO." >&3
    umount "$ISO_MOUNT_DIR"
    rmdir "$ISO_MOUNT_DIR"
    exit 1
fi

# Determine the compression format of initrd
echo "Determining compression format of initrd..." >&3
FILE_TYPE=$(file -b "$INITRD_PATH")

# Decompress and extract initrd based on the identified format
echo "Extracting initrd contents..." >&3
mkdir -p "$CURRENT_DIR/initrd_contents"
cd "$CURRENT_DIR/initrd_contents"

case "$FILE_TYPE" in
    *gzip*)
        gunzip -c "$INITRD_PATH" | cpio -idmv
        ;;
    *XZ*)
        xzcat "$INITRD_PATH" | cpio -idmv
        ;;
    *bzip2*)
        bzcat "$INITRD_PATH" | cpio -idmv
        ;;
    *LZMA*)
        lzcat "$INITRD_PATH" | cpio -idmv
        ;;
    *Zstandard*)
        zstdcat "$INITRD_PATH" | cpio -idmv
        ;;
    *LZ4*)
        lz4cat "$INITRD_PATH" | cpio -idmv
        ;;
    *)
        echo "Unknown compression format: $FILE_TYPE" >&3
        cd "$CURRENT_DIR"
        umount "$ISO_MOUNT_DIR"
        rmdir "$ISO_MOUNT_DIR"
        exit 1
        ;;
esac

# Look for the fumagician directory inside the extracted initrd contents
FUMAGICIAN_DIR=$(find . -type d -name "fumagician" | head -n 1)
if [ -z "$FUMAGICIAN_DIR" ]; then
    echo "Error: fumagician folder not found in the initrd contents." >&3
    cd "$CURRENT_DIR"
    umount "$ISO_MOUNT_DIR"
    rmdir "$ISO_MOUNT_DIR"
    exit 1
fi

# Copy the fumagician folder to /root
echo "Copying fumagician folder to /root..." >&3
cp -r "$FUMAGICIAN_DIR" /root/

# Cleanup
cd "$CURRENT_DIR"
umount "$ISO_MOUNT_DIR"
rmdir "$ISO_MOUNT_DIR"
rm -rf "$CURRENT_DIR/initrd_contents"

# Display final instructions
exec 1>&3 2>&3
clear
echo "Files extracted."
echo ""
echo "Last step: Change to the directory /root/fumagician and run ./fumagician"
echo ""
echo ""
echo "  # cd /root/fumagician"
echo ""
echo ""
echo "  # ./fumagician"
echo ""
echo ""
