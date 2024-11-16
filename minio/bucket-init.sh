#!/bin/sh

echo "Aguardando MinIO estar ativo..."
while ! curl -s http://localhost:9000/minio/health/live > /dev/null; do
    echo "MinIO ainda não está ativo. Tentando novamente em 3 segundos..."
    sleep 3
done
echo "MinIO está ativo."

echo "Configurando alias para o MinIO client..."
mc alias set myminio http://localhost:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"

echo "Criando buckets..."
mc mb myminio/landing || true
mc mb myminio/bronze || true
mc mb myminio/silver || true
mc mb myminio/gold || true

echo "Copiando arquivos CSV para o bucket 'landing'..."
mc cp /minio/include/marca_carro.csv myminio/landing/marca_carro.csv || true

echo "Script finalizado com sucesso!"
