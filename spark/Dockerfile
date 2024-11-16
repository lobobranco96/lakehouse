FROM bitnami/spark:latest

# Corrigir o apt e instalar curl
USER root
RUN mkdir -p /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Baixar e instalar Iceberg para Spark
RUN curl -L -o /opt/iceberg-spark.jar https://repo1.maven.org/maven2/org/apache/iceberg/spark3-runtime/0.14.1/spark3-runtime-0.14.1.jar

# Definir o usuário padrão de volta para o Spark
USER 1001
