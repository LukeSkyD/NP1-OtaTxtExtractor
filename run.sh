#    OtaTxtExtractor copies ota.txt found from /mnt/product/nt_log/ to /sdcard/ota.txt
#    Copyright (C) 2023  Luca Durando
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

# First we use find command to check in which folder ota.txt is located
# Then we copy the file if present to /sdcard/ota.txt

# Error variable for error messages
error=""

# Print start message
echo "OtaTxtExtractor: searching for file"
# Searches with find command the location of ota.txt and saves it to a variable
ota=$(find /mnt/product/nt_log/ -name ota.txt -print -quit 2> error)

# Check if error variable is not empty
if [ -n "$error" ]; then
    # Print error message
    echo "OtaTxtExtractor: find command failed"
    echo "OtaTxtExtractor: error message: $error"
    echo "OtaTxtExtractor: exiting"
    exit 1
fi

# If ota.txt is found, copy it to /sdcard/ota.txt
if [ -f "$ota" ]; then
    echo "OtaTxtExtractor: ota.txt found in /mnt/product/nt_log/*/ folder"
    echo "OtaTxtExtractor: copying ota.txt to /sdcard/ota.txt, \n\tthe newest ota.txt will overwrite the old one if present"
    # Copy ota.txt to /sdcard/ota.txt
    cp "$ota" /sdcard/ota.txt 2> error

    # Check if error variable is not empty
    if [ -n "$error" ]; then
        # Print error message
        echo "OtaTxtExtractor: find command failed"
        echo "OtaTxtExtractor: error message: $error"
        echo "OtaTxtExtractor: exiting"
        exit 1
    fi

    # Check if ota.txt is present in /sdcard/ota.txt
    if [ -f /sdcard/ota.txt ]; then
        # Print success message
        echo "OtaTxtExtractor: ota.txt succesfully copied to /sdcard/ota.txt !!!"
    else
        # Print error message
        echo "OtaTxtExtractor: ota.txt not copied to /sdcard/ota.txt"
        exit 1
    fi
else
    # if not found searches for the latest modified NTota_*.tar.gz file
    echo "OtaTxtExtractor: ota.txt not found in /mnt/product/nt_log/*/ folder"
    echo "OtaTxtExtractor: searching for NTota_*.tar.gz file"
    # Searches with ls command the location of NTota_*.tar.gz and saves it to a variable
    ota=$(ls -t /mnt/product/nt_log/ota_log/NTota_*.tar.gz | head -1)

    # Check if NTota_*.tar.gz is found
    if [ -f "$ota" ]; then
        echo "OtaTxtExtractor: NTota_*.tar.gz found in /mnt/product/nt_log/ota_log/ folder"
        echo "OtaTxtExtractor: extracting from NTota_*.tar.gz"
        # Extract ota.txt from NTota_*.tar.gz to /sdcard/ota.txt
        mkdir /sdcard/OTE/
        tar -xzf "$ota" -C /sdcard/OTE/ 2> error

        # Check if error variable is not empty
        if [ -n "$error" ]; then
            # Print error message
            echo "OtaTxtExtractor: tar command failed"
            echo "OtaTxtExtractor: error message: $error"
            echo "OtaTxtExtractor: exiting"
            exit 1
        fi

        # Check if ota.txt is present in /sdcard/OTE/
        ota=$(find /sdcard/OTE/ -name ota.txt -print -quit 2> error)
        if [ -f "$ota" ]; then
            # Print success message
            cp "$ota" /sdcard/ota.txt 2> error
            rm -rf /sdcard/OTE/
            echo "OtaTxtExtractor: ota.txt succesfully extracted to /sdcard/ota.txt !!!"
        else
            # Print error message
            echo "OtaTxtExtractor: ota.txt not extracted to /sdcard/OTE/"
            exit 1
        fi
    else
        # Print error message
        echo "OtaTxtExtractor: Cannot find ota.txt or NTota_*.tar.gz"
        echo "exiting..."
        exit 1
    fi
fi

exit 0
