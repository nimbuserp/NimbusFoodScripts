ALTER TABLE [dbo].[delivery_item_adicional] ALTER COLUMN pergunta_forcada_id INT NULL;

ALTER TABLE [dbo].[delivery_item_adicional] ADD sub_grupo_id INT NULL;
ALTER TABLE [dbo].[delivery_item_adicional] ADD CONSTRAINT [fk_delivery_item_adicional_sub_grupo_produto] FOREIGN KEY (sub_grupo_id) REFERENCES sub_grupo_produto (sgp_id);

ALTER TABLE [dbo].[delivery_item_adicional] ADD resposta_id INT NULL;
ALTER TABLE [dbo].[delivery_item_adicional] ADD CONSTRAINT [fk_delivery_item_adicional_resposta] FOREIGN KEY (resposta_id) REFERENCES resposta (resp_id);

ALTER TABLE [dbo].[delivery_item_adicional] DROP COLUMN descricao;

ALTER TABLE [dbo].[delivery_loja] ADD precificacao_pizza VARCHAR(255) NULL;

ALTER TABLE [dbo].[delivery_loja] ALTER COLUMN sobre TEXT NULL;
