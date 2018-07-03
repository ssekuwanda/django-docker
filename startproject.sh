#!/usr/bin/sh

if [ ! -f ./Dockerfile ]; then
    echo "[!] Dockerfile is missing."
    echo "[!] Did you clone https://github.com/jams2/django-docker?"
    exit 1
elif [ ! -f ./docker-compose.yml ]; then
    echo "[!] docker-compose.yml is missing."
    echo "[!] Did you clone https://github.com/jams2/django-docker?"
    exit 1
elif ! [ -x "$(command -v docker-compose)" ]; then
    echo "[!] docker-compose must be installed. See README.md"
    exit 1
elif ! [  -x "$(command -v docker)" ]; then
    echo "[!] Docker must be installed. See README.md"
    exit 1
fi


if [ "$1" ]; then
    projectname=$1
else
    echo "[!] Specify name of new Django project."
    exit 1
fi

echo "[+] Setting up '${projectname}'..."
echo "[+] Running Django startproject..."

docker-compose run web django-admin.py startproject $projectname .
chown -R $USER:$USER
