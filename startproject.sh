#!/usr/bin/sh

if [ ! -f ./Dockerfile ]; then
    echo "[!] Dockerfile is missing."
    echo "[-] Did you clone https://github.com/jams2/django-docker?"
    exit 1
elif [ ! -f ./docker-compose.yml ]; then
    echo "[!] docker-compose.yml is missing."
    echo "[-] Did you clone https://github.com/jams2/django-docker?"
    exit 1
elif ! [ -x "$(command -v docker-compose)" ]; then
    echo "[-] docker-compose must be installed. See README.md."
    exit 1
elif ! [  -x "$(command -v docker)" ]; then
    echo "[-] Docker must be installed. See README.md."
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

echo "[+] Docker creates files as root. Enter password when prompted to change ownership to ${USER}:${USER}"
sudo chown -R $USER:$USER .
echo "[!] Ownership granted to ${USER}."

echo "[+] Updating ${projectname}/settings.py to use postgresql..."
cat $projectname/settings.py | sed -e "78s/sqlite3/postgresql/" > $projectname/tmp
mv $projectname/tmp $projectname/settings.py
cat $projectname/settings.py | sed -e "79s/os.path.join(BASE_DIR, 'db.sqlite3')/'postgres'/" > $projectname/tmp
mv $projectname/tmp $projectname/settings.py
sed -i "80i\ \ \ \ \ \ \ \ 'USER': 'postgres',"
sed -i "81i\ \ \ \ \ \ \ \ 'HOST': 'db',"
sed -i "82i\ \ \ \ \ \ \ \ 'PORT': 5432,"

echo "[+] Making initial migrations..."
docker-compose run web python /django/manage.py mikemigrations
docker-compose run web python /django/manage.py migrate

echo "[!] Done. Create Django superuser? [Y/n]"
read choice
if [ -z $choice ] || [ $choice == "y" ]; then
    docker-compose run web python /django/manage.py createsuperuser
fi

echo "[!] Initial project setup complete. Run development server?"
read choice
if [ -z $choice ] || [ $choice == "y" ]; then
    docker-compose up
else
    echo "Quitting..."
fi
