#!/bin/bash
# Usage: sudo ./create_users_from_csv.sh path_to_file.csv

CSV_FILE=$1

# 1. Safety check: Ensure the user provided a file argument
if [ -z "$CSV_FILE" ]; then
  echo "Error: Please provide a CSV file path."
  exit 1
fi

# 2. Safety check: Ensure the file actually exists
if [ ! -f "$CSV_FILE" ]; then
  echo "Error: File '$CSV_FILE' not found."
  exit 1
fi

# 3. Read the CSV file line by line
# 'IFS=,' splits each row by the comma delimiter
# 'read -r username group' stores the first column in $username and second in $group
while IFS=, read -r username group; do
  
  # Skip empty rows or any header rows (like username,group)
  if [ -z "$username" ] || [ "$username" == "username" ]; then
    continue
  fi

  # Clean any hidden carriage returns (common if CSV was created on Windows)
  username=$(echo "$username" | tr -d '\r')
  group=$(echo "$group" | tr -d '\r')

  echo "------------------------------------------------"
  echo "Processing onboarding for: $username ($group)"

  # 4. Check if the department group exists, if not, create it
  if ! getent group "$group" &>/dev/null; then
    groupadd "$group"
    echo "Group '$group' created."
  fi

  # 5. Check if the user already exists to avoid crashing
  if id "$username" &>/dev/null; then
    echo "Warning: User '$username' already exists. Skipping."
  else
    # Create user, force password change, and append to log
    useradd -m -G "$group" -s /bin/bash "$username"
    echo "$username:ChangeMe123!" | chpasswd
    passwd --expire "$username"
    echo "User '$username' successfully created and bound to '$group'."
    echo "$(date): Bulk-created user $username in group $group" >> /var/log/user_admin.log
  fi

done < "$CSV_FILE" # This passes your CSV file into the while loop
