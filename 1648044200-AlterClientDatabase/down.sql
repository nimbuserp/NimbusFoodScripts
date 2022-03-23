
DECLARE @SQL NVARCHAR(1024) = N'';

ALTER TABLE pergunta_forcada DROP CONSTRAINT pk_pergunta_forcada;
ALTER TABLE resposta DROP CONSTRAINT pk_resposta;

SELECT
    @SQL += 'ALTER TABLE ' + t.name + ' DROP CONSTRAINT ' + dc.name + ';'
FROM
    sys.tables t
    INNER JOIN sys.default_constraints dc ON t.object_id = dc.parent_object_id
WHERE
    t.name = 'pergunta_forcada'

EXEC sp_executeSQL @SQL;

ALTER TABLE pergunta_forcada DROP COLUMN pef_exibe_no_portal;
ALTER TABLE pergunta_forcada DROP COLUMN pef_index;
ALTER TABLE produto_foto DROP COLUMN pro_foto_url;
