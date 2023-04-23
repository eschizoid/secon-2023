FROM python:3.8-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY playground.py playground.py

EXPOSE 8501

CMD ["streamlit", "run", "playground.py", "--server.port", "8501"]
