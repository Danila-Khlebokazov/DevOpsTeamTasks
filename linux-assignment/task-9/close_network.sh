#! /bin/bash
# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

declare -A allow_ips
declare -a deny_ips
declare -a allow_ports
allow_all=false


print_options(){
  echo "[options]";
  echo "-h, --help                show brief help";
  echo "-a, --allow_ip            specify an allow ip and port to allow (0 to all). Example: 192.168.0.1:80";
  echo "-d, --deny_ip             specify an deny ip";
  echo "-p, --allow_port          specify an allow port (this port will be open to all ips, even denied)";
  echo "--allow_all               allow all ips";
}

was_option_passed=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help)
        print_options
        exit 0
        ;;
        -a|--allow_ip)
        IFS=':' read -r -a ip_port <<< "$2"
        if [ "${#ip_port[@]}" -ne 2 ]; then
          echo "Invalid ip and port $2"
          print_options
          exit 1
        fi
        allow_ips[${ip_port[0]}]="${ip_port[1]}"
        shift;;
        -d|--deny_ip)
        deny_ips+=("$2"); shift;;
        -p|--allow_port)
        allow_ports+=("$2"); shift;;
        --allow_all)
          allow_all=true
          shift;;
        *)
        echo "Need to pass a valid option"
        print_options
        exit 1
        ;;
    esac
    was_option_passed=true
    shift
done

if [ "$was_option_passed" = false ]; then
  echo "Need to pass an option"
  print_options
  exit 1
fi

sudo apt-get install ufw > /dev/null
if [ "$allow_all" = false ]; then
  sudo ufw default deny incoming > /dev/null
fi
sudo ufw default allow outgoing > /dev/null
sudo ufw allow 22 > /dev/null


for ip in "${!allow_ips[@]}"; do
  if [ "${allow_ips[$ip]}" = 0 ]; then
      sudo ufw allow from "$ip" > /dev/null
      continue
  fi
  sudo ufw allow from "$ip" to any port "${allow_ips[$ip]}" > /dev/null
done

for ip in "${deny_ips[@]}"; do
  sudo ufw deny from "$ip" > /dev/null
done

for port in "${allow_ports[@]}"; do
  sudo ufw allow "$port" > /dev/null
done

sudo ufw show added

read -rp "Do you want to enable the firewall? (y/n): " enable_firewall

if [ "$enable_firewall" = "y" ]; then
  echo "y" | sudo ufw enable > /dev/null
  exit 0
fi

echo "Firewall not enabled"
sudo ufw delete allow 22 > /dev/null
for ip in "${!allow_ips[@]}"; do
  if [ -z "${allow_ips[$ip]}" ]; then
      sudo ufw delete allow from "$ip" > /dev/null
      continue
  fi
  sudo ufw delete allow from "$ip" to any port "${allow_ips[$ip]}" > /dev/null
done

for ip in "${deny_ips[@]}"; do
  sudo ufw delete deny from "$ip" > /dev/null
done

for port in "${allow_ports[@]}"; do
  sudo ufw delete allow "$port" > /dev/null
done

sudo ufw default allow incoming > /dev/null
exit 0
