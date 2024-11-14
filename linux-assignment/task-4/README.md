# Simple API with Redirecting Logs

This guide explains how to set up and run a simple API with automatic log rotation using `logrotate` and `systemd`
timers.

---

## How to Run

To start the script and set up logging:

```bash
sudo bash logrotate_setup.sh "<run_command>"
```

## Overview

**Checking and Installing logrotate:**

- The script checks if logrotate is installed on your system. If not, it installs logrotate to enable automatic log
  rotation for your application logs.

**Creating Log Files:**

- The script creates two log files:
    - ``monitoring.log`` — stores logs from ``monitoring.service``, which manages the execution of ``logrotate``.
    - ``loging-timer.log`` — stores logs from ``logrotate.timer``, which periodically triggers ``monitoring.service``
      according to the configured schedule.

**Log Rotation Configuration**:

- The `task4_logs` configuration file for `logrotate` specifies the log rotation
  rules:
    - Defines a maximum log size before rotation (`maxsize 1M`).
    - Retains the last three rotated logs. *
      Uses `copytruncate` to ensure that the logging process can continue without interruption.

**How It Works**:

- The `logrotate.timer` triggers `monitoring.service` at the specified intervals. This service
  runs `logrotate` using the configuration defined in `task4_logs`, ensuring your logs are rotated automatically based
  on
  size.