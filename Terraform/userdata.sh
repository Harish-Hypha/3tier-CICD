#!/bin/bash
set -ex

# Redirect logs
exec > >(tee /var/log/user_data.log|logger -t user-data ) 2>&1

# Auto-restart services post package updates
sudo sed -i 's/#\$nrconf{restart} = '\''i'\'';/\$nrconf{restart} = '\''a'\'';/g' /etc/needrestart/needrestart.conf

# Update system
sudo apt-get update

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install dependencies
sudo apt install -y ruby-full wget nginx

# Install CodeDeploy agent
cd /home/ubuntu
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Install PM2 globally
sudo npm install -g pm2

# Clone your GitHub repo (you can override if CodeDeploy handles it)
cd /var/www
sudo git clone https://github.com/Harish-Hypha/3tier-CICD.git html
cd html/frontend

# Install Node dependencies (if package.json exists)
[ -f package.json ] && npm install

# Setup Nginx reverse proxy
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo systemctl restart nginx

# Start your app
cd scripts
chmod +x application_start.sh
./application_start.sh

# Save PM2 process list
pm2 save
