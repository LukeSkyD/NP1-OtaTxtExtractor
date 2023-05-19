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
    # Print error message
    echo "OtaTxtExtractor: ota.txt not found in /mnt/product/nt_log/*/ folder"
    exit 1
fi

exit 0
