ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';
SELECT id_tipo_propiedad AS "TIPO",
    COUNT(nro_propiedad) AS "TOTAL_PROPIEDADES",
    TO_CHAR(MAX (valor_arriendo), '$9G999G999') AS "MAX_ARRIENDO",
    TO_CHAR(ROUND(AVG(valor_arriendo)), '$9G999G999') AS "PROMEDIO_ARRIENDO",
    TO_CHAR(MIN (valor_arriendo),'$9G999G999') AS "MIN_ARRIENDO",
    CASE
        WHEN MAX(valor_arriendo) > 1000000 THEN 'PREMIUM'
        ELSE 'ESTANDAR'
    END AS "CLASIFICACION",
    TO_CHAR (SUM(NVL(valor_gasto_comun, 0)),'$9G999G999') AS "TOTAL_GASTOS_COMUNES"
FROM   propiedad
GROUP  BY ID_TIPO_PROPIEDAD 
HAVING SUM(NVL(valor_gasto_comun, 0))> &VALOR_TOTAL_GASTO_COMUN
ORDER  BY SUM(NVL(valor_gasto_comun, 0)) DESC;  


SELECT UPPER(nombre_emp || ' ' || appaterno_emp) AS "Nombre Empleado", 
       TO_CHAR(sueldo_emp, '$9G999G999') AS "Sueldo con formato", 
       CASE
        WHEN (sueldo_emp) > 2000000 THEN 'ALTO'
        ELSE 'MEDIO'
    END AS "Clasificacion de sueldo",
    TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) AS "Años Antigüedad",
    'Corresponde bono ' ||
    CASE
    WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) BETWEEN 5 AND 10 THEN ' 5'
    WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) BETWEEN 11 AND 20 THEN '10'
    ELSE '15'
END || '%:' ||
TO_CHAR(ROUND(sueldo_emp *
    CASE
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) BETWEEN 5 AND 10 THEN 0.05
        WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) BETWEEN 11 AND 20 THEN 0.10
        ELSE 0.15
    END), '$9G999G999') AS "BONO"
FROM   empleado
WHERE  id_categoria_emp = 3
AND    id_sucursal != &CODIGO_SUCURSAL
AND    TRUNC(MONTHS_BETWEEN(SYSDATE, fecing_emp) / 12) > 5
ORDER  BY sueldo_emp DESC;


SELECT CASE
           WHEN renta_cli >= 1000000 THEN 'PREMIUM'
           WHEN renta_cli >= 600000 THEN 'ALTA'
           WHEN renta_cli >= 300000 THEN 'MEDIA'
           ELSE 'BAJA'
       END AS "CLASIFICACION_RENTA",
       COUNT(numrut_cli) AS "CANTIDAD_CLIENTES",
       TO_CHAR(ROUND(AVG(renta_cli)), '$9G999G999') AS "RENTA_PROMEDIO",
       CASE
            WHEN COUNT(celular_cli) = 0 THEN 'Clientes sin telefono'
       ELSE 'Clientes con Telefono'
END AS "ESTADO_TELEFONO"
FROM   cliente
GROUP  BY CASE
              WHEN renta_cli >= 1000000 THEN 'PREMIUM'
              WHEN renta_cli >= 600000 THEN 'ALTA'
              WHEN renta_cli >= 300000 THEN 'MEDIA'
              ELSE 'BAJA'
          END
HAVING AVG(NVL(renta_cli, 0)) > 200000;          


