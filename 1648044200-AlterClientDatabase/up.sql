ALTER TABLE pergunta_forcada ADD CONSTRAINT pk_pergunta_forcada PRIMARY KEY (pef_id);
ALTER TABLE resposta ADD CONSTRAINT pk_resposta PRIMARY KEY (resp_id);
ALTER TABLE pergunta_forcada ADD pef_exibe_no_portal BIT NOT NULL DEFAULT 0;
ALTER TABLE pergunta_forcada ADD pef_index INT NOT NULL DEFAULT 999999;
ALTER TABLE produto_foto ADD pro_foto_url VARCHAR(512);
