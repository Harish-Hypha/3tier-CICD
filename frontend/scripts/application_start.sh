# #!/bin/bash

# sudo wget -O /var/www/html/app.js https://raw.githubusercontent.com/fredritchie/3-tier-CICD/main/frontend/app.js

# npm install express
# npm install aws-sdk 
# # Run the Express.js app using PM2
# sudo pm2 stop all
# sudo pm2 start /var/www/html/app.js

# # Save PM2 process list to automatically start at boot
# sudo pm2 save


#!/bin/bash
# Install unzip and aws-cli
sudo apt-get update
sudo apt-get install -y unzip awscli

# Download and extract files from S3
sudo aws s3 cp s3://hypha-terraform-backend-01/frontend/app.js /var/www/html/
sudo aws s3 cp s3://hypha-terraform-backend-01/frontend/package.json /var/www/html/
sudo aws s3 cp s3://hypha-terraform-backend-01/frontend/package-lock.json /var/www/html/
sudo aws s3 cp --recursive s3://hypha-terraform-backend-01/frontend/node_modules /var/www/html/node_modules

# Navigate to the frontend directory (where package.json is located)
cd /var/www/html

# Install express and aws-sdk (if not already in your project's dependencies)
sudo npm install express aws-sdk 

# Run the Express.js app using PM2
sudo pm2 stop all
sudo pm2 start /var/www/html/app.js

# Save PM2 process list to automatically start at boot
sudo pm2 save
