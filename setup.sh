#!/bin/bash

# Check if bucket name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <bucket-name>"
  exit 1
fi

BUCKET_NAME=$1
REGION=ap-south-2

# update packages
sudo apt update -y

# install node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install v18.20.0

# install npm 
sudo apt install npm -y
# install pm2 
sudo npm install -g pm2

# install dependencies
cd ./http_service
npm install

# start the service
PORT=1444 BUCKET_NAME=$BUCKET_NAME pm2 start index.js --name http_s3_service