CREATE TABLE delivery_usuario (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  nome VARCHAR(128) NOT NULL,
  documento VARCHAR(16),
  telefone VARCHAR(32) NOT NULL,
  email VARCHAR(256) NOT NULL,
  senha VARCHAR(64) NOT NULL,
  ativo BIT NOT NULL,
  token VARCHAR(128),
  data_atualizacao_token DATETIME,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT pk_delivery_usuario PRIMARY KEY (id)
);

CREATE TABLE delivery_usuario_endereco (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  logradouro VARCHAR(128) NOT NULL,
  numero VARCHAR(16) NOT NULL,
  complemento VARCHAR(64),
  bairro VARCHAR(64) NOT NULL,
  referencia VARCHAR(32),
  cep VARCHAR(16) NOT NULL,
  cidade VARCHAR(128) NOT NULL,
  estado VARCHAR(2) NOT NULL,
  latitude VARCHAR(32) NOT NULL,
  longitude VARCHAR(32) NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  delivery_usuario_id UNIQUEIDENTIFIER NOT NULL,

  CONSTRAINT pk_delivery_usuario_endereco PRIMARY KEY (id),
  CONSTRAINT fk_delivery_usuario_endereco_usuario FOREIGN KEY (delivery_usuario_id) REFERENCES delivery_usuario
);

CREATE TABLE delivery_usuario_refresh_token (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  refresh_token VARCHAR(255) NOT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,

  delivery_usuario_id UNIQUEIDENTIFIER NOT NULL,

  CONSTRAINT pk_delivery_usuario_refresh_token PRIMARY KEY (id),
  CONSTRAINT fk_delivery_usuario_refresh_token_usuario FOREIGN KEY (delivery_usuario_id) REFERENCES delivery_usuario
);

CREATE TABLE delivery_status (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  code VARCHAR(64),
  descricao VARCHAR(255) NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT pk_delivery_status PRIMARY KEY (id)
);

CREATE TABLE delivery (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  numero VARCHAR(16) NOT NULL,
  tipo INT NOT NULL,
  total NUMERIC(16,2) NOT NULL,
  subtotal NUMERIC(16,2) NOT NULL,
  frete NUMERIC(16,2) NOT NULL,
  desconto NUMERIC(16,2) NOT NULL,
  tempo_preparacao INT NOT NULL,
  data_criacao DATETIME NOT NULL,
  data_entrega DATETIME NOT NULL,
  teste BIT NOT NULL,
  cancelado BIT DEFAULT 0 NOT NULL,
  data_cancelamento DATETIME,

  estabelecimento_id INT NOT NULL,
  delivery_usuario_id UNIQUEIDENTIFIER NOT NULL,
  delivery_usuario_endereco_id UNIQUEIDENTIFIER,
  delivery_status_id UNIQUEIDENTIFIER NOT NULL,

  CONSTRAINT pk_delivery PRIMARY KEY (id),
  CONSTRAINT fk_delivery_estabelecimento FOREIGN KEY (estabelecimento_id) REFERENCES estabelecimento (est_id),
  CONSTRAINT fk_delivery_delivery_usuario FOREIGN KEY (delivery_usuario_id) REFERENCES delivery_usuario (id),
  CONSTRAINT fk_delivery_delivery_usuario_endereco FOREIGN KEY (delivery_usuario_endereco_id) REFERENCES delivery_usuario_endereco (id),
  CONSTRAINT fk_delivery_delivery_status FOREIGN KEY (delivery_status_id) REFERENCES delivery_status (id)
);

CREATE TABLE delivery_status_log (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  delivery_status_code VARCHAR(64) NOT NULL,
  delivery_id UNIQUEIDENTIFIER NOT NULL,

  CONSTRAINT pk_delivery_status_log PRIMARY KEY (id),
  CONSTRAINT fk_delivery_status_log_delivery FOREIGN KEY (delivery_id) REFERENCES delivery (id)
);

CREATE TABLE delivery_evento (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  code VARCHAR(64) NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  delivery_id UNIQUEIDENTIFIER NOT NULL,
  estabelecimento_id INT NOT NULL,

  CONSTRAINT pk_delivery_evento PRIMARY KEY (id),
  CONSTRAINT fk_delivery_evento_delivery FOREIGN KEY (delivery_id) REFERENCES delivery (id),
  CONSTRAINT fk_delivery_evento_estabelecimento FOREIGN KEY (estabelecimento_id) REFERENCES estabelecimento (est_id)
);

CREATE TABLE delivery_pagamento (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  descricao VARCHAR(128) NOT NULL,
  valor NUMERIC(16,2) NOT NULL,
  troco NUMERIC(16,2) NOT NULL,
  pago BIT NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  delivery_id UNIQUEIDENTIFIER NOT NULL,
  forma_recebimento_id INT NOT NULL,

  CONSTRAINT pk_delivery_pagamento PRIMARY KEY (id),
  CONSTRAINT fk_delivery_pagamento_delivery FOREIGN KEY (delivery_id) REFERENCES delivery (id),
  CONSTRAINT fk_delivery_pagamento_forma_recebimento FOREIGN KEY (forma_recebimento_id) REFERENCES forma_recebimento (for_id)
);

CREATE TABLE delivery_item (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  descricao VARCHAR(256) NOT NULL,
  quantidade NUMERIC(16,2) NOT NULL,
  preco_unitario NUMERIC(16,2) NOT NULL,
  preco_total NUMERIC(16,2) NOT NULL,
  preco_total_subitens NUMERIC(16,2) NOT NULL,
  adicional NUMERIC(16,2) NOT NULL,
  desconto NUMERIC(16,2) NOT NULL,
  observacao VARCHAR(256) NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  delivery_id UNIQUEIDENTIFIER NOT NULL,
  produto_id INT NOT NULL,

  CONSTRAINT pk_delivery_item PRIMARY KEY (id),
  CONSTRAINT fk_delivery_item_delivery FOREIGN KEY (delivery_id) REFERENCES delivery (id),
  CONSTRAINT fk_delivery_item_produto FOREIGN KEY (produto_id) REFERENCES produto (pro_id)
);

CREATE TABLE delivery_item_adicional (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  nome VARCHAR(255) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  preco NUMERIC(16,2) NOT NULL,
  quantidade INT NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  pergunta_forcada_id INT NOT NULL,
  delivery_item_id UNIQUEIDENTIFIER NOT NULL,
  produto_id INT,

  CONSTRAINT pk_delivery_item_adicional PRIMARY KEY (id),
  CONSTRAINT fk_delivery_item_adicional_delivery_item FOREIGN KEY (delivery_item_id) REFERENCES delivery_item (id),
  CONSTRAINT fk_delivery_item_adicional_pergunta_forcada FOREIGN KEY (pergunta_forcada_id) REFERENCES pergunta_forcada (pef_id),
  CONSTRAINT fk_delivery_item_adicional_produto FOREIGN KEY (produto_id) REFERENCES produto (pro_id)
);

CREATE TABLE delivery_loja_status (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  code VARCHAR(64) NOT NULL,
  descricao VARCHAR(255) NOT NULL, 
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT pk_delivery_loja_status PRIMARY KEY (id)
);

CREATE TABLE delivery_loja (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  nome VARCHAR(128) NOT NULL,
  documento VARCHAR(32) NOT NULL,
  contato VARCHAR(32) NOT NULL,
  sobre VARCHAR(255) NOT NULL,
  tempo_preparo INT NOT NULL,
  entrega BIT NOT NULL,
  retirada BIT NOT NULL,
  mesa BIT NOT NULL,
  valor_frete NUMERIC(16, 2) NOT NULL,
  valor_minimo NUMERIC(16, 2) NOT NULL,
  logo VARCHAR(255),
  logo_path VARCHAR(255),
  banner VARCHAR(255),
  banner_path VARCHAR(255),
  logradouro VARCHAR(255) NOT NULL,
  numero VARCHAR(16) NOT NULL,
  bairro VARCHAR(255) NOT NULL,
  latitude VARCHAR(32),
  longitude VARCHAR(32),
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  estabelecimento_id INT NOT NULL,
  delivery_loja_status_id UNIQUEIDENTIFIER NOT NULL,

  CONSTRAINT pk_delivery_loja PRIMARY KEY (id),
  CONSTRAINT fk_delivery_loja_estabelecimento FOREIGN KEY (estabelecimento_id) REFERENCES estabelecimento (est_id),
  CONSTRAINT fk_delivery_loja_delivery_loja_status FOREIGN KEY (delivery_loja_status_id) REFERENCES delivery_loja_status (id)
);

CREATE TABLE delivery_loja_area_entrega (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  distancia NUMERIC(6, 2) NOT NULL,
  taxa NUMERIC(6, 2) NOT NULL,
  tempo INT NOT NULL,
  latitude VARCHAR(32) NOT NULL,
  longitude VARCHAR(32) NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  delivery_loja_id UNIQUEIDENTIFIER NOT NULL,

  CONSTRAINT pk_delivery_loja_area_entrega PRIMARY KEY (id),
  CONSTRAINT fk_delivery_loja_area_entrega_delivery_loja FOREIGN KEY (delivery_loja_id) REFERENCES delivery_loja (id)
);

CREATE TABLE delivery_loja_horario (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  dia_semana INT NOT NULL,
  horario_inicial INT NOT NULL,
  horario_final INT NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  delivery_loja_id UNIQUEIDENTIFIER NOT NULL,

  CONSTRAINT pk_delivery_loja_horario PRIMARY KEY (id),
  CONSTRAINT fk_delivery_loja_horario_delivery_loja FOREIGN KEY (delivery_loja_id) REFERENCES delivery_loja (id)
);

CREATE TABLE delivery_loja_avaliacao (
  id UNIQUEIDENTIFIER DEFAULT NEWID(),
  descricao VARCHAR(255) NOT NULL,
  nota INT NOT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  delivery_usuario_id UNIQUEIDENTIFIER NOT NULL,

  CONSTRAINT pk_delivery_loja_avaliacao PRIMARY KEY (id),
  CONSTRAINT fk_delivery_loja_avaliacao_delivery_loja FOREIGN KEY (delivery_usuario_id) REFERENCES delivery_usuario (id)
);