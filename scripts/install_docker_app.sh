#!/bin/bash

# Installing docker
sudo yum update -y
sudo yum install docker -y

# Adding the user to the docker group to avoid using sudo for every docker cmd
sudo usermod -a -G docker ec2-user
sleep 5
newgrp docker

sudo systemctl enable docker.service
sudo systemctl start docker.service
sleep 5

if docker info >/dev/null 2>&1; then
    echo "Docker is running. Proceeding with setup..."
else
    echo "Docker is not running. Please start Docker and run this script again."
    exit 1
fi

# To create app content
mkdir -p /home/ec2-user/infrastructure/dev/app
cd /home/ec2-user/infrastructure/dev/app

# Creating files to run an application
echo "# flask_web/app.py
from flask import Flask, jsonify, request
import random
import os

app = Flask(__name__)
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = False

@app.route('/', methods=['GET'])
def hello_world():
    return jsonify({\"data\": {\"name\": os.getenv('HOSTNAME'), \"temp\": random.randrange(-10, 20, 1)}})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')" > app.py

echo "Flask==2.1.1" > requirements.txt

echo "#!/bin/bash
pip install -r requirements.txt &&
python app.py" > run.sh

# Make run.sh executable
chmod +x run.sh

# Run Docker command inside the dev directory
cd /home/ec2-user/infrastructure/dev
docker run -itd -v $PWD/app:/app -w /app python /bin/bash run.sh

echo "Setup completed."