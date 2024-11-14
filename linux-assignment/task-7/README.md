# Monitoring and Setting Permissions on New Files

This bash script monitors a specified directory for newly
created files and automatically sets read/write permissions
and ownership on them. It uses a `systemd` timer and service
to check for new files periodically.

---

## How to Run the Script

```bash
sudo bash service_timer.sh
```

## Key Files

1. **/home/file_monitoring.sh** — The main script that:
    - Detects new files by comparing the current directory file names (by creating temporary file ``.newfileslogs``) with a saved before file names (`.oldfiles`).
    - Changes ownership and permissions on new files.
2. **/etc/systemd/system/rw_permissions.timer** — Systemd timer that:
    - Starts `rw_permissions.service` every 10 seconds.

3. **/etc/systemd/system/rw_permissions.service** — Systemd service that:
    - Runs `/home/file_monitoring.sh` to apply permissions on new files in `/home/logs/`.

## Usage

**Check the Status**:
- To view the status of the timer or service, use:
```bash
sudo systemctl status rw_permissions.timer
sudo systemctl status rw_permissions.service
```

## Important Notes

- This configuration assumes `/home/logs/` exists from task4
- Ownership is set to `task5user:task5group` and permissions to `660` for each new file detected. This user and group created in task5.
