# Use uma imagem base oficial com Python 3
FROM python:3

# Atualizar apt-get e instalar o OpenJDK 11 e o JupyterLab
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    curl \
    && pip install jupyterlab

# Copiar o arquivo de dependências (requirements.txt)
COPY ./requirements.txt .

# Instalar pacotes do requirements.txt
RUN pip install -r requirements.txt

# Definir o diretório de trabalho
WORKDIR /notebooks

# Definir o comando de execução para iniciar o JupyterLab
CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--port", "8888", "--NotebookApp.token=''", "--NotebookApp.password=''", "--no-browser", "--allow-root"]
