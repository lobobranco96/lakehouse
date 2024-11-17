FROM jupyter/scipy-notebook:notebook-6.4.11

USER root

# Instala Java (por exemplo, OpenJDK 11)
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get install -y wget && \
    apt-get clean;

# Define a variável de ambiente JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN pip install pyspark==3.5.1

# Cria diretório para os jars do Spark
RUN mkdir -p /opt/spark/jars

# Baixa os jars necessários
RUN wget -P /opt/spark/jars https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/1.5.2/iceberg-spark-runtime-3.5_2.12-1.5.2.jar
RUN wget -P /opt/spark/jars https://repo1.maven.org/maven2/org/projectnessie/nessie-integrations/nessie-spark-extensions-3.5_2.12/0.99.0/nessie-spark-extensions-3.5_2.12-0.99.0.jar
RUN wget -P /opt/spark/jars https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/2.20.131/bundle-2.20.131.jar
RUN wget -P /opt/spark/jars https://repo1.maven.org/maven2/software/amazon/awssdk/url-connection-client/2.20.131/url-connection-client-2.20.131.jar

# Define o SPARK_HOME
ENV SPARK_HOME=/opt/conda/lib/python3.10/site-packages/pyspark

# Inclui os jars do Spark no classpath
ENV SPARK_CLASSPATH=/opt/spark/jars/*

# Adiciona os binários do Spark ao PATH
ENV PATH="${SPARK_HOME}/bin:${PATH}"

# Define o Python para o PySpark
ENV PYSPARK_PYTHON=python3

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.11 python3.11-distutils

# Instala o pip para o Python 3.11
RUN wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py && \
    python3.11 get-pip.py && \
    rm get-pip.py

# Instala pyspark e ipykernel para o Python 3.11
RUN python3.11 -m pip install pyspark==3.5.1
RUN python3.11 -m pip install ipykernel

# Registra o kernel Python 3.11 no Jupyter
RUN python3.11 -m ipykernel install --user --name=python3.11 --display-name "Python 3.11"

RUN chown -R jovyan:users /home/jovyan/.local
