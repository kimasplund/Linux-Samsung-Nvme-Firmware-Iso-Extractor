
# Linux Samsung NVMe Firmware ISO Extractor

This script allows you to update the firmware of your Samsung SSD on Linux without needing to make a bootable usb. It extracts the necessary files from a provided ISO image and guides you through the final steps to complete the update.

## Disclaimer

**DISCLAIMER:** I am not affiliated with Samsung. I do not take any responsibility for failed upgrades, broken drives, or lost data that may occur as a result of using this script. Proceed at your own risk.

## Requirements

- Root access (`su` or `sudo su`)
- A compatible Samsung SSD firmware ISO file (e.g., `Samsung_SSD_990_PRO_4B2QJXD7.iso`)

## Download the Script

You can download the script directly from GitHub using `curl` or `wget`:

### Using `curl`

```bash
curl -O https://raw.githubusercontent.com/kimasplund/Linux-Samsung-Nvme-Firmware-Iso-Extractor/main/samsung_firmware_extractor.sh
```

### Using `wget`

```bash
wget https://raw.githubusercontent.com/kimasplund/Linux-Samsung-Nvme-Firmware-Iso-Extractor/main/samsung_firmware_extractor.sh
```

## How to Use the Script

1. **Make the script executable**:

    ```bash
    chmod +x samsung_firmware_extractor.sh
    ```

2. **Run the script as root**:

    Make sure you are logged in as the root user. You can do this by running:

    ```bash
    su
    # Enter your root password
    ```

3. **Run the script with your ISO file**:

    Replace `Samsung_SSD_990_PRO_4B2QJXD7.iso` with the path to your ISO file.

    ```bash
    ./samsung_firmware_extractor.sh /path/to/Samsung_SSD_990_PRO_4B2QJXD7.iso
    ```

4. **Follow the instructions**:

    The script will:
    - Display a disclaimer.
    - Extract the necessary files from the ISO.
    - Provide you with final instructions on how to complete the firmware update.

5. **Final Step**:

    After the script completes, follow the on-screen instructions to navigate to the extracted directory and run the firmware update:

    ```bash
    cd /root/fumagician
    ./fumagician
    ```

## Troubleshooting

If you encounter any issues:
- Ensure the script is being run as the root user.
- Verify the ISO file is valid and correctly specified.
- Check the error messages displayed by the script for guidance.

## Contributing

If you'd like to contribute to this project, feel free to fork the repository and submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
