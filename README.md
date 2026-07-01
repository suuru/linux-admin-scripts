## 👥 Bulk User Onboarding via CSV

This project includes an automation extension to handle mass employee onboarding using a single input data file (`.csv`).

### Input File Format (`users.csv`)
The script processes standard comma-separated text files. Create a file matching this schema:
```text
username,group
tunde,engineering
chioma,operations
```

### How to Run the Bulk Script
Provide the path of the target CSV file as an argument using administrative privileges:
```bash
sudo ./scripts/create_users_from_csv.sh path/to/users.csv
```

### Architectural Pipeline Flow
1. **Validation Engine:** Checks for file existence and strips hidden Windows-line formatting (`\r`).
2. **Dynamic Group Creation:** Evaluates the `group` row data; automatically provisions system department boundaries if missing.
3. **Idempotency Safeguard:** Checks the system architecture to see if a username is already taken to prevent database corruption.
4. **Security Hardening:** Enforces `ChangeMe123!` temporary access tokens and flags the account as expired (`passwd --expire`), triggering an immediate mandatory user-reset upon initial SSH handshake.
