# Simple API with Redirecting Logs

Create `/home/logs` for storing log files. Create `/home/log_rotates.log` to save the execution time of your log rotations.

## Set up

### 1. Redirect logs to `app.log` file
```bash
./main > /home/fifs/logs/app.log 2>&1
```
### 2. Create logrotate configuration
```bash
sudo nano /etc/logrotate.d/task4_logs
```
Write the following inside `task4_logs`:
````
/home/$USER/logs/app.log {
	hourly
 	size 1M
	rotate 3
	su $USER $GROUP
	create
	copytruncate
}
}
````
### 3. Run logrotate manually
```bash
sudo logrotate -f /etc/logrotate.d/task4_logs
```
