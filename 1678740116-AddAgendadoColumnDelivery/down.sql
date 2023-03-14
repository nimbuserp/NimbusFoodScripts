DECLARE @SQL NVARCHAR(1024) = N'';

SELECT
    @SQL += 'ALTER TABLE ' + t.name + ' DROP CONSTRAINT ' + dc.name + ';'
FROM
    sys.tables t
    INNER JOIN sys.default_constraints dc ON t.object_id = dc.parent_object_id
WHERE
    t.name = 'delivery'
    AND dc.name LIKE '%agen%'

EXEC sp_executeSQL @SQL;

ALTER TABLE [dbo].[delivery] DROP COLUMN agendado;
