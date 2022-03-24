DECLARE @SQL NVARCHAR(1024) = N'';

SELECT
    @SQL += 'ALTER TABLE ' + t.name + ' DROP CONSTRAINT ' + dc.name + ';'
FROM
    sys.tables t
    INNER JOIN sys.default_constraints dc ON t.object_id = dc.parent_object_id
WHERE
    t.name = 'produto'
    AND dc.name LIKE '%pro_pro%'

EXEC sp_executeSQL @SQL;

ALTER TABLE [dbo].[produto] DROP COLUMN pro_promocao_portal;
