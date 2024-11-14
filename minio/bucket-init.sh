#!/bin/sh

# Aguarda o servidor MinIO estar ativo
sleep 10

# Configura o alias para o MinIO client usando as variáveis de ambiente
mc alias set myminio http://localhost:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"

# Cria os buckets necessários
mc mb myminio/landing
mc mb myminio/bronze
mc mb myminio/silver
mc mb myminio/gold

# Copia os arquivos CSV da pasta 'include' para o bucket 'landing'
mc cp /minio/include/marca_carro.csv myminio/landing/marca_carro.csv
