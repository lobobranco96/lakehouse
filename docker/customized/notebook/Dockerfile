FROM bitnami/spark:3.5.3

WORKDIR /app
USER root
RUN install_packages curl



RUN /opt/bitnami/spark/bin/spark-shell \
    --packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.6.1,\
               org.projectnessie.nessie-integrations:nessie-spark-extensions-3.5_2.12:0.99.0,\
               org.apache.iceberg:iceberg-aws-bundle:1.6.1,\
               software.amazon.awssdk:bundle:2.28.13 \
    --repositories https://repo.maven.apache.org/maven2
#COPY conf/spark-defaults.conf /opt/bitnami/spark/conf/spark-defaults.conf

ENV SPARK_CLASSPATH="/opt/bitnami/spark/jars/*"
RUN chmod -R 777 /opt/bitnami/spark/jars

COPY requirements.txt .
RUN pip install -r requirements.txt

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root",  "--NotebookApp.token=''"]