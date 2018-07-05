#!/usr/bin/sh

if [ ! -f ./Dockerfile ]; then
    printf "[!] Dockerfile is missing.\n"
    printf "[-] Did you clone https://github.com/jams2/django-docker?\n"
    exit 1
elif [ ! -f ./docker-compose.yml ]; then
    printf "[!] docker-compose.yml is missing.\n"
    printf "[-] Did you clone https://github.com/jams2/django-docker?\n"
    exit 1
elif [ ! -x "$(command -v docker-compose)" ]; then
    printf "[-] docker-compose must be installed. See README.md.\n"
    exit 1
elif [ !  -x "$(command -v docker)" ]; then
    printf "[-] Docker must be installed. See README.md.\n"
    exit 1
fi

if [ "$1" ]; then
    projectname=$1
else
    printf "[!] Usage: ./startproject.sh projectname\n"
    exit 1
fi

printf "[+] Setting up '${projectname}'...\n"
printf "[+] Running Django startproject...\n"
docker-compose run web django-admin.py startproject $projectname .

printf "[+] Docker creates files as root. Enter password when prompted to change ownership to ${USER}:${USER}\n"
sudo chown -R $USER:$USER .
printf "[!] Ownership granted to ${USER}.\n"

printf "[+] Updating ${projectname}/settings.py to use postgresql...\n"
sed -i "78s/sqlite3/postgresql/" $projectname/settings.py
sed -i "79s/os.path.join(BASE_DIR, 'db.sqlite3')/'postgres'/" $projectname/settings.py
sed -i "80i\ \ \ \ \ \ \ \ 'USER': 'postgres'," $projectname/settings.py
sed -i "81i\ \ \ \ \ \ \ \ 'HOST': 'db'," $projectname/settings.py
sed -i "82i\ \ \ \ \ \ \ \ 'PORT': 5432," $projectname/settings.py

printf "[+] Performing initial migration..."
docker-compose run web python /django/manage.py migrate

printf "[!] Done. Create Django superuser?"
read -p " [Y/n] " choice
if [ -z $choice ] || [ $choice == y* ] || [ $choice == Y* ]; then
    docker-compose run web python /django/manage.py createsuperuser
fi

printf "[!] Initial project setup complete. Run development server now?"
read -p " [Y/n] " choice
if [ -z $choice ] || [ $choice == y* ] || [ $choice == Y* ]; then
    exec docker-compose up
else
    printf "Quitting...\n"
fi
