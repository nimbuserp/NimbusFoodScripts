/*
 * ================ ADMERP ================
 */
INSERT INTO delivery_autenticacao (
	nome,
	documento
)
VALUES (
	'nimbusfood',
	'50487463000106'
)

/*
 * ================ CLIENT ================
 */

-- USER
DECLARE @delivery_usuario TABLE (id UNIQUEIDENTIFIER);
DECLARE @delivery_usuario_id UNIQUEIDENTIFIER;

DECLARE @delivery_usuario_endereco TABLE (id UNIQUEIDENTIFIER);
DECLARE @delivery_usuario_endereco_id UNIQUEIDENTIFIER;

INSERT INTO delivery_usuario (
	nome, documento,
	telefone, email, senha,
	ativo,
	criado_em, atualizado_em
) OUTPUT INSERTED.id INTO @delivery_usuario
VALUES (
	'Evandro Junior', '45326512807',
	'18991823034', 'evandro@webworks.com.br', '$2a$08$gw.1qcYMsXaN1Skc0RLIPOsH/MUYjaLkgB6cPnZLIbAMpkIBqBnkG',
	1,
	CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
)

SELECT @delivery_usuario_id = id FROM @delivery_usuario

INSERT INTO delivery_usuario_endereco (
	logradouro, numero,
	complemento, bairro,
	referencia, cep,
	cidade, estado,
	latitude, longitude,
	delivery_usuario_id
) OUTPUT INSERTED.id INTO @delivery_usuario_endereco
VALUES (
	'Rua Carolina Lopes de Faria', '69',
	'', 'Jardim Campo Belo',
	'Casa com Portão Branco', '19060460',
	'Presidente Prudente', 'SP',
	'-22.123157023471897', '-51.415829289004364',
	@delivery_usuario_id
)

SELECT @delivery_usuario_endereco_id = id FROM @delivery_usuario_endereco

--MERCHANT
DECLARE @delivery_loja TABLE (id UNIQUEIDENTIFIER);
DECLARE @delivery_loja_id UNIQUEIDENTIFIER;

DECLARE @delivery_loja_status TABLE (id UNIQUEIDENTIFIER, code VARCHAR(64));
DECLARE @delivery_loja_status_id UNIQUEIDENTIFIER;

INSERT INTO delivery_loja_status (
	code, descricao
) OUTPUT INSERTED.id, INSERTED.code INTO @delivery_loja_status
VALUES
	('OPEN', 'Aberta para receber pedidos'),
	('CLOSED', 'Fora do horário de atendimento'),
	('PAUSED', 'Pausada por algum motivo');

SELECT @delivery_loja_status_id = id FROM @delivery_loja_status WHERE code = 'OPEN'

DECLARE @logradouro VARCHAR(MAX);
DECLARE @numero VARCHAR(MAX);
DECLARE @bairro VARCHAR(MAX);

SELECT TOP 1 @logradouro = est_logradouro, @numero = est_numero, @bairro = est_bairro FROM estabelecimento

INSERT INTO delivery_loja (
	nome, documento, contato,
	sobre, tempo_preparo,
	entrega, retirada, mesa,
	valor_frete, valor_minimo,
	logo, banner,
	logradouro, numero, bairro,
    latitude, longitude,
	estabelecimento_id, delivery_loja_status_id
) OUTPUT INSERTED.id INTO @delivery_loja
VALUES (
	'Nimbus Food', '07258579000136', '18981461155',
	'Nunc vitae orci est. Aenean vel euismod metus. Ut feugiat mauris sed arcu rhoncus mattis. Donec rutrum venenatis justo, ut rutrum leo suscipit in. Nullam dignissim, est vel ullamcorper fermentum, felis ipsum venenatis lectus.', 50,
	1, 1, 1,
	7.90, 12.00,
	'uploads/07258579000136-logo.jpg', 'uploads/07258579000136-banner.jpg',
    @logradouro, @numero, @bairro,
	'-22.1231866', '-51.3939638',
	1, @delivery_loja_status_id
);

SELECT @delivery_loja_id = id FROM @delivery_loja

INSERT INTO delivery_loja_horario (
	dia_semana,
	horario_inicial, horario_final,
	delivery_loja_id
)
VALUES
	(0, 480, 720, @delivery_loja_id),		-- Domingo	08:00 - 12:00
	(1, 480, 720, @delivery_loja_id),		-- Segunda	08:00 - 12:00
	(1, 840, 1080, @delivery_loja_id),	-- Segunda	14:00 - 18:00
	(2, 480, 720, @delivery_loja_id),		-- Terça		08:00 - 12:00
	(2, 840, 1080, @delivery_loja_id),	-- Terça		14:00 - 18:00
	(3, 480, 720, @delivery_loja_id),		-- Quarta		08:00 - 12:00
	(3, 840, 1080, @delivery_loja_id),	-- Quarta		14:00 - 18:00
	(4, 480, 720, @delivery_loja_id),		-- Quinta		08:00 - 12:00
	(4, 840, 1080, @delivery_loja_id),	-- Quinta		14:00 - 18:00
	(5, 480, 1439, @delivery_loja_id),	-- Sexta		08:00 - 23:59
	(6, 480, 1439, @delivery_loja_id);	-- Sábado		08:00 - 23:59

INSERT INTO delivery_loja_area_entrega (
	distancia, taxa, tempo,
	latitude, longitude,
	delivery_loja_id
)
VALUES
	(1, 5.00, 10, '-22.1231866', '-51.3939638', @delivery_loja_id),
	(5, 7.00, 30, '-22.1231866', '-51.3939638', @delivery_loja_id);

INSERT INTO delivery_status (
	code, descricao
)
VALUES 
	('PLACED', 'Novo pedido no sistema'),
	('INTEGRATED', 'Pedido integrado no PDV'),
	('CONFIRMED', 'Pedido confirmado e será preparado'),
	('READY_TO_PICKUP', 'Pedido pronto para ser retirado'),
	('DISPATCHED', 'Pedido saiu para a entrega'),
	('CONCLUDED', 'Pedido foi concluído'),
	('CANCELLED', 'Pedido foi cancelado')
