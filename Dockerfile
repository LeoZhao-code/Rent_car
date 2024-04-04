FROM python:3.8-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt

RUN apt-get update && apt-get install -y sqlite3
RUN pip install -r requirements.txt

COPY . .

RUN test -f mydatabase.db && rm mydatabase.db || true
RUN sqlite3 mydatabase.db < database/sqlite_database.sql

ENV FLASK_APP app

CMD ["flask", "run", "-h", "0.0.0.0", "-p", "5000"]

#docker build -t car_rent_demo:1.0 .
#docker run --name demoflask -itd -p 5000:5000 car_rent_demo:1.0
