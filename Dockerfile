FROM python:3
ENV PYTHONUNBUFFERED 1
RUN mkdir /django
WORKDIR /django
ADD requirements.txt /TBP/
RUN pip install -r requirements.txt
ADD . /django/
