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
	('CANCELLED', 'Pedido foi cancelado');

INSERT INTO delivery_loja_status (
	code, descricao
)
VALUES
	('OPEN', 'Aberta para receber pedidos'),
	('CLOSED', 'Fora do horário de atendimento'),
	('PAUSED', 'Pausada por algum motivo');
