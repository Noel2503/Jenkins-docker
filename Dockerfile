FROM rapidfort/flaskapp:latest
WORKDIR /app
COPY . .
CMD ["python", "app.py"]
