FROM bitnami/spark:3.5.3

WORKDIR /app
USER root

# Instalar pacotes básicos
RUN install_packages curl

# Diretório para armazenar os JARs necessários
RUN mkdir -p /opt/bitnami/spark/jars

# Baixar os JARs necessários e colocá-los no diretório de JARs do Spark
RUN curl -L -o /opt/bitnami/spark/jars/iceberg-spark-runtime-3.5_2.12-1.6.1.jar \
    https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/1.6.1/iceberg-spark-runtime-3.5_2.12-1.6.1.jar && \
    curl -L -o /opt/bitnami/spark/jars/nessie-spark-extensions-3.5_2.12-0.99.0.jar \
    https://repo1.maven.org/maven2/org/projectnessie/nessie-spark-extensions-3.5_2.12/0.99.0/nessie-spark-extensions-3.5_2.12-0.99.0.jar && \
    curl -L -o /opt/bitnami/spark/jars/iceberg-aws-bundle-1.6.1.jar \
    https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/1.6.1/iceberg-aws-bundle-1.6.1.jar && \
    curl -L -o /opt/bitnami/spark/jars/amazon-sdk-bundle-2.28.13.jar \
    https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.28.13/bundle-2.28.13.jar && \
    curl -L -o /opt/bitnami/spark/jars/amazon-sdk-url-connection-client-2.28.13.jar \
    https://repo1.maven.org/maven2/software/amazon/awssdk/url-connection-client/2.28.13/url-connection-client-2.28.13.jar

# Ajustar permissões dos JARs
RUN chmod -R 777 /opt/bitnami/spark/jars

# Configurar o classpath do Spark para incluir os JARs adicionais
ENV SPARK_CLASSPATH="/opt/bitnami/spark/jars/*"

# Copiar arquivo de configurações do Spark (se necessário)
COPY conf/spark-defaults.conf /opt/bitnami/spark/conf/spark-defaults.conf

# Copiar e instalar dependências Python
COPY requirements.txt .
RUN pip install -r requirements.txt

# Iniciar o Jupyter Notebook
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
