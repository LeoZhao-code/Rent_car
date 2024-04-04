FROM python:3.9

WORKDIR /app

COPY requirements.txt requirements.txt

RUN apt-get update && apt-get install -y sqlite3
RUN pip install -r requirements.txt

COPY . .

RUN test -f mydatabase.db && rm mydatabase.db || true
RUN sqlite3 mydatabase.db < database/sqlite_database.sql

ENV FLASK_APP app

CMD ["flask", "run", "-h", "0.0.0.0", "-p", "5000"]
