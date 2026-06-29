#!/bin/bash
# Usage: sudo ./create_user.sh username groupname

USERNAME=$1
GROUP=$2

if [ -z "$USERNAME" ]; then
  echo "Error: no username provided"
  exit 1
fi

# Create group if it doesn't exist
if ! getent group "$GROUP" &>/dev/null; then
  groupadd "$GROUP"
  echo "Group '$GROUP' created"
fi

# Create user with home dir, assign to group
useradd -m -G "$GROUP" -s /bin/bash "$USERNAME"
echo "$USERNAME:ChangeMe123!" | chpasswd
passwd --expire "$USERNAME"   # force password change on first login

echo "User '$USERNAME' created and added to '$GROUP'"
echo "$(date): Created user $USERNAME" >> /var/log/user_admin.log


