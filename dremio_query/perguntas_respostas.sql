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
