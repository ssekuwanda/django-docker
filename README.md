# django-docker

Simple docker-compose setup for getting a Django/postgresql project going. See the official docs [here](https://docs.docker.com/compose/django/)


# Usage

1. Install Docker
    - [OSX](https://docs.docker.com/docker-for-mac/install/)
    - [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
    - [Arch](https://wiki.archlinux.org/index.php/Docker)
2. Install [Docker Compose](https://docs.docker.com/compose/install/)    
    - Arch: install package `docker-compose`
3. `git clone https://github.com/jams2/django-docker && cd django-docker`


## The short way:

`./startproject.sh projectname` and follow the prompts.

## The long way:

1. Start the project and fix permissions (Docker creates files as root)
    - `docker-compose run web django-admin.py startproject projectname .`
    - `sudo chown -R $USER:$USER .`
2. Connect database:
    - in projectname/settings.py:
    ```
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': 'postgres',
            'USER': 'postgres',
            'HOST': 'db',
            'PORT': 5432,
        }
    }
    ```
3. Additional config:
    - `docker-compose run web python /code/manage.py createsuperuser`
    - `docker-compose run web python /code/manage.py makemigrations`
    - `docker-compose run web python /code/manage.py migrate`
4. Mount the image and run the development server:
    - `docker-compose up`
    - From there you should be able to access localhost:8000
5. To get a shell in the Docker image:
    - `docker-compose run web bash`

Commands on the Image can be run with the prefix `docker-compose run web ...`
