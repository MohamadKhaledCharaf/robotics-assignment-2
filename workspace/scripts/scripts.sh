#!/bin/bash
# setup.sh
# ---------------------------------------------------------------
# This script automates the project setup by creating a consistent
# directory structure and populating files with specified content.
#
# The following directories are created under "workspace":
#   docs   - Contains documentation files (cd.txt, ls.txt, etc.)
#   logs   - Contains log files (a copy of welcome.txt with added info)
#   data   - (Reserved for data files)
#   scripts- (Reserved for scripts; permissions can be set securely)
#
# Files created in workspace/docs:
#   cd.txt           : Explains the 'cd' command.
#   ls.txt           : Explains the 'ls' command.
#   touchInfo1.txt   : Explains the first use of 'touch'.
#   touchInfo2.txt   : Explains the second use of 'touch'.
#   SummaryTouch.txt : A 13-line file built by concatenating touchInfo1.txt,
#                      touchInfo2.txt, then appending lines 3–13.
#   SummaryForOnlyTouch.txt : The first two lines of SummaryTouch.txt.
#   welcome.txt      : A welcome message.
#
# Additionally, welcome.txt is copied to the logs folder, and then
# appended with a line about search queries.
#
# Usage:
#   From the project root, run:
#       bash scripts/setup.sh
# ---------------------------------------------------------------

# Exit immediately if a command fails
set -e

# -----------------------------
# 1. Create Workspace Directories
# -----------------------------
echo "Creating workspace directories..."
mkdir -p workspace/{docs,logs,data,scripts}

# Define directory variables
DOCS_DIR="workspace/docs"
LOGS_DIR="workspace/logs"
DATA_DIR="workspace/data"
SCRIPTS_DIR="workspace/scripts"

# -----------------------------
# 2. Create Documentation Files in 'docs'
# -----------------------------

# Create cd.txt with its content
echo "Creating cd.txt..."
cat > "$DOCS_DIR/cd.txt" <<EOF
The cd command in Linux is used to change the current directory
to a specified directory
EOF

# Create ls.txt with its content
echo "Creating ls.txt..."
cat > "$DOCS_DIR/ls.txt" <<EOF
The ls command in Linux is used to list the contents of a directory,
including files and subdirectories.
EOF

# Create touchInfo1.txt with its content
echo "Creating touchInfo1.txt..."
cat > "$DOCS_DIR/touchInfo1.txt" <<EOF
you can use touch to create multiple files at Once such as: touch file1.txt file2.txt file3.txt
EOF

# Create touchInfo2.txt with its content
echo "Creating touchInfo2.txt..."
cat > "$DOCS_DIR/touchInfo2.txt" <<EOF
you can also update file timestamps without modifying Contenct by running filename.txt
EOF

# Create SummaryTouch.txt by concatenating touchInfo1.txt and touchInfo2.txt
# (which will be the first two lines) and then appending lines 3 to 13.
echo "Creating SummaryTouch.txt..."
cat "$DOCS_DIR/touchInfo1.txt" "$DOCS_DIR/touchInfo2.txt" > "$DOCS_DIR/SummaryTouch.txt"
cat >> "$DOCS_DIR/SummaryTouch.txt" <<EOF
3: Regardles on whether this file is named for Touch, head lists first 10 lines of a file
4:
5:
6:
7:
8:
9:
10:
11:
12:
13: Right Tail lists the last ten lines of the file
EOF
# Query the functionality of head from SummaryTouch.txt
cat SummaryTouch.txt | grep head | cat > "$LOGS_DIR/search_results.txt"
# Create SummaryForOnlyTouch.txt by taking the first two lines of SummaryTouch.txt
echo "Creating SummaryForOnlyTouch.txt..."
head -n 2 "$DOCS_DIR/SummaryTouch.txt" > "$DOCS_DIR/SummaryForOnlyTouch.txt"

# Create welcome.txt with a welcome message
echo "Creating welcome.txt..."
echo "Welcome to the project workspace" > "$DOCS_DIR/welcome.txt"

# -----------------------------
# 3. Copy and Update welcome.txt in 'logs'
# -----------------------------
echo "Copying welcome.txt to logs and appending search query info..."
cp "$DOCS_DIR/welcome.txt" "$LOGS_DIR/"
echo "Here youre serach queries of the functionalities will reside." >> "$LOGS_DIR/welcome.txt"

# -----------------------------
# 4. (Optional) Set Permissions for the Scripts Directory
# -----------------------------
# For example, restrict the scripts folder so that only the owner has full access.
echo "Setting secure permissions for the scripts directory..."
chmod 700 "$SCRIPTS_DIR"



# Define the user and group names
USER="mohamad-khaled-charaf"
GROUP="potato"

# Ensure script is run with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)" >&2
    exit 1
fi

# Check if the group exists
if getent group "$GROUP" >/dev/null; then
    echo "Group '$GROUP' already exists."
else
    echo "Creating group '$GROUP'..."
    groupadd "$GROUP"
fi

# Check if the user exists
if id "$USER" &>/dev/null; then
    echo "User '$USER' already exists."
else
    echo "Creating user '$USER' and adding to group '$GROUP'..."
    useradd -m -g "$GROUP" -s /bin/bash "$USER"
fi



# -----------------------------
# 5. Display the Final Directory Structure
# -----------------------------
echo "Setup complete. The resulting directory structure is:"
find workspace

