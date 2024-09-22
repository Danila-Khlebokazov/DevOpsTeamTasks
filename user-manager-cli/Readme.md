# Linux User Manager CLI

## Description
The task is to create a simple CLI to manage users in Linux

## Project Overview
The **User Manager Interface** is a terminal-based user management system, built using `python` to allow system administrators to view, add, delete, lock, and unlock users on a Linux system.

---

## Features
- **List Users:** View all system users with relevant details (username, UID, full name, and lock status).
- **Add User:** Create a new user with a username, full name, and password.
- **Delete User:** Remove an existing user.
- **Lock/Unlock User:** Disable or re-enable a user account.
- **Pagination and Navigation:** Navigate through user lists with pagination.

---

## Requirements
- Python 3.x
- `curses` module (standard in Python)
- `sudo` privileges (for user management operations)
- Linux operating system

---

## Installation and Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Danila-Khlebokazov/DevOpsTeamTasks.git
   cd user-manager-cli
   ```

2. **Run the program**:
   Ensure you have the required `sudo` permissions for user management actions.
   ```bash
   python3 user_utilite.py
   ```

---

## Usage

Once you run the program, it will launch in a terminal window. You can interact with the system using the following commands:

- **Navigation**:
  - `[↑/↓]` to navigate between users
  - `[←/→]` to move between pages

- **Actions**:
  - **Add User**: Press `[N]`, then enter the username, full name, and password.
  - **Delete User**: Press `[BACKSPACE]` to delete a user (confirmation required).
  - **Lock User**: Press `[L]` to lock a user (confirmation required).
  - **Unlock User**: Press `[U]` to unlock a user.
  - **Exit**: Press `[Q]` to quit the application.

### Example:
```bash
sudo python3 user_manager_cli.py
```
Upon execution, you will see a table of users along with their status.

<img width="1064" alt="image" src="https://github.com/user-attachments/assets/91c00bdc-4e2b-40da-9a94-4b32996c32fc">

---

## Environment Variables
No specific environment variables are needed, but the script assumes that `sudo` is configured and the executing user has permission to run `passwd` and `useradd` commands.