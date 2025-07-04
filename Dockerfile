FROM python:3.10-slim-bullseye

# Previne o Python de escrever arquivos .pyc e de bufferizar stdout/stderr
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file to the working directory
COPY requirements.txt .

# Instala as dependências
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Cria um usuário não-root para executar a aplicação por segurança
RUN addgroup --system app && adduser --system --group app

# Copia o restante do código da aplicação
COPY . .

# Define o usuário não-root como proprietário dos arquivos
RUN chown -R app:app /app

# Muda para o usuário não-root
USER app

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Run app.py when the container launches
# Use 0.0.0.0 to make it accessible from outside the container
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
