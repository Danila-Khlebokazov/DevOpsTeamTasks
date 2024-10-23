```plaintext
  _____             _              __      ___                 
 |  __ \           | |             \ \    / (_)                
 | |  | | ___   ___| | _____ _ __   \ \  / / _ _ __   ___ _ __ 
 | |  | |/ _ \ / __| |/ / _ \ '__|   \ \/ / | | '_ \ / _ \ '__|
 | |__| | (_) | (__|   <  __/ |       \  /  | | |_) |  __/ |   
 |_____/ \___/ \___|_|\_\___|_|        \/   |_| .__/ \___|_|   
                                              | |              
                                              |_|                                                                                                  
```

### How to use

1. Pull this git repo


2. Run the `install` script through `sudo`

> [note!]:
>
> You need to be in the same directory as the `install` script to run it properly

```bash
sudo ./install
```

3. Enjoy the result!

#### Common questions:

1. Where to find the viping logs?

```bash
sudo cat /var/lib/docker-viper/viper.log
```

2. How to see current viping journal?

```bash
sudo cat /var/lib/docker-viper/vipe-image.journal
```

3. How to set default vipe time?
You can change default settings by modifying the 
/var/lib/docker-viper/docker-viper.env file

Defaults:
```dotenv
VIPE_TIME=604800
VIPE_JOURNAL=/var/lib/docker-viper/vipe-image.journal
VIPE_LOG=/var/lib/docker-viper/viper.log
```

### How it works
The docker viper runs every second and checks the time in journal.  
If some image is out of time it removes from computer.  
If some image is new to computer then the last_used time becomes now.  
If there are running containers on the computer then times for all 'running' images will be updated.