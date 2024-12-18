# lakehouse
![Sem título-2024-11-19-0736](https://github.com/user-attachments/assets/6c2702e3-e557-402c-9cec-15d28b59619b)

# ENEM Data Analytics

## Índice

1. [Introdução](#introdução)
2. [Arquitetura de Solução e Serviços](#arquitetura-de-solução-e-serviços)
   - [Camada Lakehouse](#camada-lakehouse)
     - [Storage - MinIO](#storage---minio)
     - [Formato de Tabela - Iceberg](#formato-de-tabela---iceberg)
     - [Catálogo de Tabelas - Nessie](#catálogo-de-tabelas---nessie)
     - [Query Engine - Dremio](#query-engine---dremio)
   - [Serviços de Processamento](#serviços-de-processamento)
   - [Aplicações Python e Spark](#aplicações-python-e-spark)
   - [Serviços para Monitoramento e Observabilidade](#serviços-para-monitoramento-e-observabilidade)
3. [Visão de Tabelas e Views no Dremio](#visão-de-tabelas-e-views-no-dremio)
4. [Configurações Iniciais em Recursos Deployados](#configurações-iniciais-em-recursos-deployados)
   - [Serviço de Armazenamento MinIO](#serviço-de-armazenamento-minio)
   - [Ferramenta de Query Engine Dremio](#ferramenta-de-query-engine-dremio)
5. [Desafio](#desafio)
6. [Considerações e Conclusão](#considerações-e-conclusão)

---

## 1. Introdução

Este repositório descreve a solução para o desafio **ENEM Data Analytics**, focado na análise de logs de acesso a servidores web. A solução foi construída utilizando uma arquitetura moderna de dados, com ênfase em escalabilidade, processamento distribuído e análise eficiente. Através de dados simulados (gerados com a biblioteca `rand-engine`), foram processados logs de servidores web para responder a diversas perguntas analíticas.

---

## 2. Arquitetura de Solução e Serviços

A solução utiliza uma arquitetura de Lakehouse composta por diferentes camadas e serviços. Estes serviços interagem entre si para possibilitar a ingestão, processamento e análise dos dados de logs.

### Camada Lakehouse

#### **Storage - MinIO**
- MinIO é um serviço de armazenamento compatível com S3, utilizado para armazenar dados brutos.
- A interface do MinIO pode ser acessada em [http://localhost:9001](http://localhost:9001).

#### **Formato de Tabela - Iceberg**
- O formato Iceberg permite uma gestão eficiente das tabelas, com controle de versões, particionamento e otimização de queries.

#### **Catálogo de Tabelas - Nessie**
- O Nessie é utilizado como catálogo de tabelas open-source, oferecendo versionamento de dados similar ao Git.

#### **Query Engine - Dremio**
- O Dremio é usado como engine de consultas SQL sobre os dados armazenados no MinIO e no Nessie.
- A interface do Dremio está disponível em [http://localhost:9047](http://localhost:9047).

### Serviços de Processamento

#### **Apache Spark**
- Apache Spark é utilizado para o processamento distribuído de dados, possibilitando operações de transformação e agregação de dados de logs.
- A solução utiliza um cluster Spark com **Spark Master** e **Spark Workers**.

### Aplicações Python e Spark

- Um ambiente JupyterLab foi configurado para interagir com o cluster Spark.
- O JupyterLab está disponível em [http://localhost:8888](http://localhost:8888).
  
### Serviços para Monitoramento e Observabilidade

#### **Prometheus, Grafana**
- O Prometheus coleta dados de telemetria dos serviços, enquanto o Grafana é utilizado para a visualização de métricas de monitoramento.
- O Grafana pode ser acessado em [http://localhost:3000](http://localhost:3000).
- A interface do Prometheus está disponível em [http://localhost:9090](http://localhost:9090).

---

## 3. Visão de Tabelas e Views no Dremio

No Dremio, os dados são organizados nas seguintes camadas:

- **Tabela Bronze**: Dados brutos provenientes da camada `landing`.
- **Tabela Silver**: Dados transformados e limpos, prontos para análise.
- **Camada Gold com Star Schema**: Views agregadas para análise de negócios.

---

## 4. Configurações Iniciais em Recursos Deployados

### Serviço de Armazenamento MinIO

Para configurar o MinIO:

1. Acesse o MinIO em [http://localhost:9000](http://localhost:9000).
2. Faça login com o usuário **admin** e senha **password**.
3. Gere uma **API Key** para acesso ao MinIO.
4. Armazene as chaves no arquivo `/services/conf/.lakehouse.conf` para configurar os serviços que irão acessar o MinIO.

### Ferramenta de Query Engine Dremio

Configure o Dremio para conectar-se ao MinIO e ao Nessie:

1. Acesse o Dremio e configure as fontes de dados:
   - **Fonte Nessie**: Defina o endpoint como `http://nessie:19120/api/v2`.
   - **Fonte MinIO**: Defina as credenciais de acesso geradas no MinIO.
---

## 5. Desafio

O desafio consiste em responder a diversas perguntas analíticas baseadas em informações retiradas do Exame Nacional do Ensino Médio. As perguntas são:

1. **Qual o Participante com maior media por cada ano de realização do exame**.
2. **Qual a escola com a maior média de notas por ano?**.
3. **Os 10 alunos com a maior média de notas e o valor dessa média**.
4. **Qual o % de Ausentes por ano**.
5. **Qual o número total de Inscritos por ano?**.
6. **Qual a média por Sexo e Ano?**
7. **Média por Etnia e por Ano**

As respostas são extraídas através de views e tabelas no Dremio, criadas a partir das camadas `bronze`, `silver` e `gold`.

---

## 6. Considerações e Conclusão

A solução foi desenvolvida utilizando containers Docker e orquestrada com Docker Compose, facilitando o deploy local da solução em qualquer máquina. A arquitetura emprega tecnologias modernas como Apache Spark, Dremio e MinIO garantindo uma solução robusta e escalável para processamento e análise dos microdados do enem.

---

## 7. Como Executar a Solução

### Pré-requisitos

- **Docker**
- **Docker Compose**
- **Make**

### Passos para Executar

1. Clone este repositório.

   ```bash
   git clone https://github.com/seu-usuario/lakehouse.git
   cd lakehouse
