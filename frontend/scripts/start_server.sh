#!/bin/bash
# Stop all servers and start the server
sudo systemctl restart nginx
# Display server status
sudo systemctl status nginx
pm2 status