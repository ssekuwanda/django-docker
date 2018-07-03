# django-docker

Simple docker-compose setup for getting a django project going. See the official docs [here](https://docs.docker.com/compose/django/)


## Usage

1. Install Docker
    - [OSX](https://docs.docker.com/docker-for-mac/install/)
    - [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
    - [Arch](https://wiki.archlinux.org/index.php/Docker)
2. Install [Docker Compose](https://docs.docker.com/compose/install/)    
    - Arch: install package `docker-compose`
3. `git clone https://github.com/`
4. In top project directory (contains Dockerfile, docker-compose.yml), run:
    - `docker-compose run web python /code/manage.py createsuperuser`
    - `docker-compose run web python /code/manage.py makemigrations`
    - `docker-compose run web python /code/manage.py migrate`
    - `docker-compose up`

From there you should be able to access localhost:8000, without having to configure database settings.
