ALTER TABLE [dbo].[delivery_item_adicional] ALTER COLUMN pergunta_forcada_id INT NOT NULL;

ALTER TABLE [dbo].[delivery_item_adicional] DROP CONSTRAINT [fk_delivery_item_adicional_sub_grupo_produto];
ALTER TABLE [dbo].[delivery_item_adicional] DROP COLUMN sub_grupo_id;

ALTER TABLE [dbo].[delivery_item_adicional] DROP CONSTRAINT [fk_delivery_item_adicional_resposta];
ALTER TABLE [dbo].[delivery_item_adicional] DROP COLUMN resposta_id;

ALTER TABLE [dbo].[delivery_item_adicional] ADD descricao VARCHAR(255) NOT NULL;

ALTER TABLE [dbo].[delivery_loja] DROP COLUMN precificacao_pizza;

ALTER TABLE [dbo].[delivery_loja] ALTER COLUMN sobre VARCHAR(255) NULL;
