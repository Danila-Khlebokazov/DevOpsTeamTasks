# ~/.bashrc in order to be able to use this function everywhere

function setup_ssh {
    set -e

    local CURR_USER="$1"    
    local CURR_HOST="$2"    
    SSH_DIR="$HOME/.ssh"
    PRIVATE_KEY="$SSH_DIR/id_rsa"
    PUBLIC_KEY="$SSH_DIR/id_rsa.pub"

    if [ ! -f "$PRIVATE_KEY" ]; then 
        echo "There is no SSH key, creating..."
        ssh-keygen -t rsa -b 4096 -f "$PRIVATE_KEY" -N ""
    else
        echo "SSH key exists."
    fi

    if [ ! -f "$PUBLIC_KEY" ]; then
        echo "Error, no public key!"
        return 1 
    fi

    echo "Copying public key to server..."
    ssh-copy-id -i "$PUBLIC_KEY" "$CURR_USER@$CURR_HOST" || { echo "Failed to copy SSH key."; return; }
    ssh "$CURR_USER@$CURR_HOST" "echo 'Successful!'; exit" || { echo "SSH connection failed."; return; }
    
    echo "Setting correct permissions on the server..."
    ssh "$CURR_USER@$CURR_HOST" << 'EOF'
        chmod 700 ~/.ssh
        chmod 600 ~/.ssh/authorized_keys
        echo "Chmod things done!"
EOF

    echo "Everything is fine, now you can connect to the server using the command 'ssh $CURR_USER@$CURR_HOST'"
}