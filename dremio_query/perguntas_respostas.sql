1 - Participante com maior media por cada ano

SELECT NU_ANO, ID_PARTICIPANTE, MEDIA_TOTAL
FROM (
      WITH medias AS (
          SELECT
              p.NU_ANO,  -- Ano do participante
              p.ID_PARTICIPANTE,  -- ID do participante
              ROUND(
                  (pr.NU_NOTA_CN + pr.NU_NOTA_CH + pr.NU_NOTA_LC + pr.NU_NOTA_MT + r.NU_NOTA_REDACAO) / 5.0, 2
              ) AS MEDIA_TOTAL  -- Média total de todas as provas (objetivas + redação)
          FROM
              nessie.gold.fato_resultados_enem f
          LEFT JOIN nessie.gold.dim_participante p
              ON f.ID_PARTICIPANTE = p.ID_PARTICIPANTE
          LEFT JOIN nessie.gold.dim_prova_objetiva pr
              ON f.ID_PROVA_OBJETIVA = pr.ID_PROVA_OBJETIVA
          LEFT JOIN nessie.gold.dim_redacao r
              ON f.ID_REDACAO = r.ID_REDACAO
      )
      SELECT
          m.NU_ANO,
          m.ID_PARTICIPANTE,
          m.MEDIA_TOTAL
      FROM
          medias m
      WHERE
          (m.NU_ANO, m.MEDIA_TOTAL) IN (
              SELECT
                  NU_ANO,
                  MAX(MEDIA_TOTAL) AS MEDIA_TOTAL
              FROM
                  medias
              GROUP BY
                  NU_ANO
          )
      ORDER BY
          m.NU_ANO, m.MEDIA_TOTAL DESC
) nested_0
ORDER BY MEDIA_TOTAL DESC;

2 - Qual a escola com a maior média de notas por ano?

WITH MediaNotas AS (
    SELECT
        de.CO_MUNICIPIO_ESC,
        de.NO_MUNICIPIO_ESC,
        de.CO_UF_ESC,
        de.SG_UF_ESC,
        de.TP_DEPENDENCIA_ADM_ESC AS Dependencia_Administrativa,
        de.TP_LOCALIZACAO_ESC AS Localizacao_Escola,
        dp.NU_ANO,
        ROUND(
            AVG(CAST(dpo.NU_NOTA_CN AS DECIMAL(10, 2)) +
                CAST(dpo.NU_NOTA_CH AS DECIMAL(10, 2)) +
                CAST(dpo.NU_NOTA_LC AS DECIMAL(10, 2)) +
                CAST(dpo.NU_NOTA_MT AS DECIMAL(10, 2)) +
                CAST(dr.NU_NOTA_REDACAO AS DECIMAL(10, 2))) / 5.0, 2) AS MEDIA_TOTAL
    FROM nessie.gold.fato_resultados_enem f
    INNER JOIN nessie.gold.dim_escola de ON de.ID_ESCOLA = f.ID_ESCOLA
    INNER JOIN nessie.gold.dim_prova_objetiva dpo ON dpo.ID_PROVA_OBJETIVA = f.ID_PROVA_OBJETIVA
    INNER JOIN nessie.gold.dim_redacao dr ON dr.ID_REDACAO = f.ID_REDACAO
    INNER JOIN nessie.gold.dim_participante dp ON dp.ID_PARTICIPANTE = f.ID_PARTICIPANTE
    GROUP BY
        de.CO_MUNICIPIO_ESC,
        de.NO_MUNICIPIO_ESC,
        de.CO_UF_ESC,
        de.SG_UF_ESC,
        de.TP_DEPENDENCIA_ADM_ESC,
        de.TP_LOCALIZACAO_ESC,
        dp.NU_ANO
),
RankedNotas AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY NU_ANO ORDER BY MEDIA_TOTAL DESC) AS Ranking
    FROM MediaNotas
)
SELECT *
FROM RankedNotas
WHERE Ranking = 1
ORDER BY NU_ANO DESC;




3 - Os 10 alunos com a maior média de notas e o valor dessa média?

SELECT
    dp.NU_INSCRICAO,
    dp.NU_ANO,
    dpo.NU_NOTA_CN AS 'Nota Ciências da Natureza',
    dpo.NU_NOTA_CH AS 'Nota Ciências Humanas',
    dpo.NU_NOTA_LC AS 'Nota Linguagens e Códigos',
    dpo.NU_NOTA_MT AS 'Nota Matemática',
    dr.NU_NOTA_REDACAO AS 'Nota Redação',
    (AVG(dpo.NU_NOTA_CN + dpo.NU_NOTA_CH + dpo.NU_NOTA_LC + dpo.NU_NOTA_MT + dr.NU_NOTA_REDACAO) / 5) AS MEDIA_TOTAL
FROM nessie_gold_fato_resultados_enem f
INNER JOIN nessie.gold.dim_participante dp ON dp.ID_PARTICIPANTE = fi.ID_PARTICIPANTE
INNER JOIN nessie.gold.dim_prova_objetiva dpo dpo ON dpo.ID_PROVA_OBJETIVA = fi.ID_PROVA_OBJETIVA
INNER JOIN nessie.gold.dim_redacao dr ON dr.ID_REDACAO = f.ID_REDACAO
GROUP BY dp.NU_INSCRICAO, dpo.NU_NOTA_CH, dpo.NU_NOTA_CN, dpo.NU_NOTA_LC, dpo.NU_NOTA_MT, dr.NU_NOTA_REDACAO
ORDER BY MEDIA_TOTAL DESC LIMIT 10;

-- 4 - Qual o % de Ausentes por ano?

SELECT
    dp.NU_ANO,
    ROUND(SUM(CASE 
                WHEN dpo.TP_PRESENCA_CN = 'Faltou à prova' THEN 1 
                WHEN dpo.TP_PRESENCA_CN = 'Presente na prova' THEN 0
                ELSE NULL
              END) * 100.0 / COUNT(*), 2) AS "Ciencias da Natureza % Ausentes",
    
    ROUND(SUM(CASE 
                WHEN dpo.TP_PRESENCA_CH = 'Faltou à prova' THEN 1 
                WHEN dpo.TP_PRESENCA_CH = 'Presente na prova' THEN 0
                ELSE NULL
              END) * 100.0 / COUNT(*), 2) AS "Ciencias Humanas % Ausentes",
    
    ROUND(SUM(CASE 
                WHEN dpo.TP_PRESENCA_LC = 'Faltou à prova' THEN 1 
                WHEN dpo.TP_PRESENCA_LC = 'Presente na prova' THEN 0
                ELSE NULL
              END) * 100.0 / COUNT(*), 2) AS "Linguagens e Códigos % Ausentes",
    
    ROUND(SUM(CASE 
                WHEN dpo.TP_PRESENCA_MT = 'Faltou à prova' THEN 1 
                WHEN dpo.TP_PRESENCA_MT = 'Presente na prova' THEN 0
                ELSE NULL
              END) * 100.0 / COUNT(*), 2) AS "Matematica % Ausentes"
FROM nessie.gold.fato_resultados_enem f
INNER JOIN nessie.gold.dim_prova_objetiva dpo ON dpo.ID_PROVA_OBJETIVA = f.ID_PROVA_OBJETIVA
INNER JOIN nessie.gold.dim_participante dp ON dp.ID_PARTICIPANTE = f.ID_PARTICIPANTE
GROUP BY dp.NU_ANO
ORDER BY dp.NU_ANO DESC;




-- 5 - Qual o número total de Inscritos e ano?

SELECT
  dp.NU_ANO,
	COUNT(dpo.ID_PARTICIPANTE) AS 'Total Inscritos'
FROM nessie.gold.fato_resultados_enem f
INNER JOIN nessie.gold.dim_participante dp ON dpo.ID_PARTICIPANTE = f.ID_PARTICIPANTE
GROUP BY dp.NU_ANO
ORDER BY dp.NU_ANO DESC;


-- 6 - Qual a média por Sexo e Ano?
WITH media_ano AS (
SELECT
    dp.NU_ANO,
    dp.TP_SEXO,
    COUNT(*) AS "Quantidade",
    ROUND(AVG(dpo.NU_NOTA_CN), 2) AS "Media Ciências da Natureza",
    ROUND(AVG(dpo.NU_NOTA_CH), 2) AS "Media Ciências Humanas",
    ROUND(AVG(dpo.NU_NOTA_LC), 2) AS "Media Linguagens e Códigos",
    ROUND(AVG(dpo.NU_NOTA_MT), 2) AS "Media Matemática",
    ROUND(AVG(dr.NU_NOTA_REDACAO), 2) AS "Media Redação"
FROM nessie.gold.fato_resultados_enem f
INNER JOIN nessie.gold.dim_prova_objetiva dpo ON dpo.ID_PROVA_OBJETIVA = f.ID_PROVA_OBJETIVA
INNER JOIN nessie.gold.dim_redacao dr ON dr.ID_REDACAO = f.ID_REDACAO
INNER JOIN nessie.gold.dim_participante dp ON dp.ID_PARTICIPANTE = f.ID_PARTICIPANTE
GROUP BY dp.NU_ANO, dp.TP_SEXO
ORDER BY dp.NU_ANO DESC, dp.TP_SEXO)

SELECT *
FROM media_ano
ORDER BY NU_ANO


-- 7 - Média por Etnia e por Ano

SELECT
    dp.NU_ANO,
    dp.TP_COR_RACA AS "Etnia do Participante",
    COUNT(*) AS "Quantidade",
    ROUND(AVG(dpo.NU_NOTA_CN), 2) AS "Media Ciências da Natureza",
    ROUND(AVG(dpo.NU_NOTA_CH), 2) AS "Media Ciências Humanas",
    ROUND(AVG(dpo.NU_NOTA_LC), 2) AS "Media Linguagens e Códigos",
    ROUND(AVG(dpo.NU_NOTA_MT), 2) AS "Media Matemática",
    ROUND(AVG(dr.NU_NOTA_REDACAO), 2) AS "Media Redação"
FROM nessie.gold.fato_resultados_enem f
INNER JOIN nessie.gold.dim_prova_objetiva dpo ON dpo.ID_PROVA_OBJETIVA = f.ID_PROVA_OBJETIVA
INNER JOIN nessie.gold.dim_redacao dr ON dr.ID_REDACAO = f.ID_REDACAO
INNER JOIN nessie.gold.dim_participante dp ON dp.ID_PARTICIPANTE = f.ID_PARTICIPANTE
GROUP BY dp.NU_ANO, dp.TP_COR_RACA
ORDER BY dp.NU_ANO DESC, dp.TP_COR_RACA;

