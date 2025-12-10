-- tests.sql
USE clinica_db;

-- 1) Testes de inserção: inserir paciente inválido (cpf duplicado) -> deve falhar
-- Inserir válido:
INSERT INTO pacientes (nome, cpf, data_nascimento, telefone, endereco, email)
VALUES ('Test User', '11122233344', '2000-01-01', '8300000000', 'Teste 1', 'test1@example.com');

-- 2) Teste de constraint única: tentar inserir CPF duplicado (deverá gerar erro)
-- INSERT INTO pacientes (nome, cpf, data_nascimento, telefone, endereco, email)
-- VALUES ('Dup User', '11122233344', '1999-01-01', '8300000001', 'Teste 2', 'dup@example.com');

-- 3) Teste de remoção: remover pagamento existente
DELETE FROM pagamentos WHERE pagamento_id = 2;

-- 4) Teste de SELECT / JOIN
SELECT * FROM vw_consultas_detalhadas LIMIT 10;

-- 5) Teste de UPDATE: marcar pagamento como 'pago' e observar trigger que atualiza status da consulta
UPDATE pagamentos SET status_pagamento = 'pago' WHERE pagamento_id = 1;

-- 6) Teste de views: consultar vw_pagamentos_recebidos
SELECT * FROM vw_pagamentos_recebidos;

-- 7) Teste de gatilho de horário (deve falhar ao inserir duplicado)
-- Exemplo (comentado para evitar erro automático):
-- INSERT INTO consultas (paciente_id, medico_id, data_consulta, horario) VALUES (1,1,'2025-12-10','09:00:00');

-- 8) Teste de funções
SELECT fn_total_pago_paciente(1) AS total_pago_paciente_1;
SELECT fn_consultas_realizadas_medico(1) AS consultas_realizadas_medico_1;
