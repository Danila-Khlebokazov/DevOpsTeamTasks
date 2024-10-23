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

#### Some notes:

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