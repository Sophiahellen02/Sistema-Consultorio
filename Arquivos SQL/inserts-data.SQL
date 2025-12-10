---------------------------------------------------------
-- Inserts
---------------------------------------------------------

-- INSERIR PACIENTES
INSERT INTO pacientes (nome, cpf, data_nascimento, telefone, endereco, email)
VALUES 
('Maria Fernandes', '12345678901', '1988-03-10', '84988880001', 'Rua A, 100 - Centro', 'maria@gmail.com'),
('João Ribeiro', '23456789012', '1990-06-21', '84988880002', 'Rua B, 200 - Centro', 'joao@gmail.com'),
('Ana Paula Souza', '34567890123', '1985-12-05', '84988880003', 'Rua C, 300 - Centro', 'ana@gmail.com');

-- INSERIR MÉDICOS
INSERT INTO medicos (nome, crm, especialidade, telefone, email)
VALUES
('Dr. Carlos Almeida', 'CRM1010', 'Cardiologia', '84999990001', 'carlos@clinica.com'),
('Dra. Helena Castro', 'CRM2020', 'Pediatria', '84999990002', 'helena@clinica.com'),
('Dr. Marcos Nogueira', 'CRM3030', 'Dermatologia', '84999990003', 'marcos@clinica.com');

-- INSERIR CONSULTAS
INSERT INTO consultas (paciente_id, medico_id, data_consulta, horario, status, observacoes)
VALUES
(1, 1, '2025-02-10', '09:00', 'realizada', 'Consulta de rotina.'),
(2, 2, '2025-02-10', '10:00', 'realizada', 'Consulta pediátrica.'),
(3, 3, '2025-02-11', '14:00', 'agendada', NULL),
(1, 3, '2025-02-12', '15:30', 'confirmada', 'Queixa dermatológica.');

-- INSERIR PRONTUÁRIOS
INSERT INTO prontuarios (consulta_id, descricao)
VALUES
(1, 'Paciente com pressão arterial controlada. Histórico atualizado.'),
(2, 'Criança com sintomas gripais, sem complicações.');

-- INSERIR ATENDIMENTOS
INSERT INTO atendimentos (consulta_id, anotacoes, receita)
VALUES
(1, 'Exame físico normal. Pressão 12x8.', 'Losartana 50mg 1x ao dia.'),
(2, 'Criança com febre leve. Hidratação e repouso.', 'Dipirona 10 gotas a cada 6h.'),
(4, 'Lesão na pele com suspeita de dermatite.', 'Pomada antialérgica por 7 dias.');

-- INSERIR EXAMES SOLICITADOS
INSERT INTO exames_solicitados (atendimento_id, codigo_exame, descricao_exame)
VALUES
(1, 'ELETRO01', 'Eletrocardiograma'),
(1, 'SANGUE01', 'Hemograma completo'),
(2, 'COVID01', 'Teste rápido de COVID-19'),
(3, 'DERMA01', 'Raspagem de pele');

-- INSERIR PAGAMENTOS
INSERT INTO pagamentos (consulta_id, valor, forma_pagamento, status_pagamento)
VALUES
(1, 200.00, 'Cartão', 'Pago'),
(2, 150.00, 'PIX', 'Pago'),
(4, 180.00, 'Cartão', 'Pendente');

---------------------------------------------------------
-- UPDATES
---------------------------------------------------------

-- 1. Atualizar o status de uma consulta agendada
UPDATE consultas
SET status = 'confirmada'
WHERE consulta_id = 3;

-- 2. Corrigir o telefone de um paciente
UPDATE pacientes
SET telefone = '84999998888'
WHERE paciente_id = 2;

-- 3. Atualizar receita médica em um atendimento
UPDATE atendimentos
SET receita = 'Dipirona 15 gotas a cada 6h.'
WHERE atendimento_id = 2;

-- 4. Marcar pagamento como concluído
UPDATE pagamentos
SET status_pagamento = 'Pago', data_pagamento = CURRENT_DATE
WHERE pagamento_id = 3;

-- 5. Alterar o e-mail de um médico
UPDATE medicos
SET email = 'marcos.nogueira@clinica.com'
WHERE medico_id = 3;


---------------------------------------------------------
-- DELETES 
---------------------------------------------------------

-- 1. Remover um exame solicitado incorreto
DELETE FROM exames_solicitados
WHERE exame_id = 4;

-- 2. Remover um atendimento cancelado
DELETE FROM atendimentos
WHERE atendimento_id = 3;

-- 3. Limpar observações indevidas de uma consulta
UPDATE consultas
SET observacoes = NULL
WHERE consulta_id = 4;

-- 4. Remover um pagamento estornado
DELETE FROM pagamentos
WHERE pagamento_id = 2;

-- 5. Remover um prontuário incorreto
DELETE FROM prontuarios
WHERE prontuario_id = 2;


---------------------------------------------------------
-- SELECTS 
---------------------------------------------------------

-- 1. Listar todos os pacientes
SELECT * FROM pacientes;

-- 2. Listar médicos por especialidade
SELECT nome, especialidade
FROM medicos
ORDER BY especialidade;

-- 3. Consultas marcadas para um médico específico
SELECT 
    c.consulta_id,
    p.nome AS paciente,
    c.data_consulta,
    c.horario,
    c.status
FROM consultas c
JOIN pacientes p ON c.paciente_id = p.paciente_id
WHERE c.medico_id = 1
ORDER BY c.data_consulta, c.horario;

-- 4. Histórico de atendimentos de um paciente
SELECT 
    p.nome AS paciente,
    a.atendimento_id,
    a.anotacoes,
    a.receita,
    a.data_registro
FROM atendimentos a
JOIN consultas c ON c.consulta_id = a.consulta_id
JOIN pacientes p ON p.paciente_id = c.paciente_id
WHERE p.paciente_id = 1;

-- 5. Pagamentos concluídos
SELECT 
    pagamento_id,
    consulta_id,
    valor,
    forma_pagamento,
    data_pagamento
FROM pagamentos
WHERE status_pagamento = 'Pago';

-- 6. Exames solicitados em um atendimento
SELECT 
    es.exame_id,
    es.codigo_exame,
    es.descricao_exame,
    es.data_registro
FROM exames_solicitados es
WHERE es.atendimento_id = 1;

-- 7. Visualizar agenda completa dos médicos com seus pacientes
SELECT 
    m.nome AS medico,
    c.data_consulta,
    c.horario,
    p.nome AS paciente,
    c.status
FROM consultas c
JOIN medicos m ON m.medico_id = c.medico_id
JOIN pacientes p ON p.paciente_id = c.paciente_id
ORDER BY m.nome, c.data_consulta;

-- 8. Consultas realizadas em um período
SELECT 
    consulta_id,
    data_consulta,
    horario,
    status
FROM consultas
WHERE data_consulta BETWEEN '2025-02-01' AND '2025-02-28'
  AND status = 'realizada';

-- 9. Exames solicitados por paciente
SELECT
    p.nome AS paciente,
    es.codigo_exame,
    es.descricao_exame,
    es.data_registro
FROM exames_solicitados es
JOIN atendimentos a ON a.atendimento_id = es.atendimento_id
JOIN consultas c ON c.consulta_id = a.consulta_id
JOIN pacientes p ON p.paciente_id = c.paciente_id
ORDER BY p.nome, es.data_registro;

-- 10. Listar todas as consultas com médico, paciente e status
SELECT
    c.consulta_id,
    p.nome AS paciente,
    m.nome AS medico,
    c.data_consulta,
    c.horario,
    c.status
FROM consultas c
JOIN pacientes p ON p.paciente_id = c.paciente_id
JOIN medicos m ON m.medico_id = c.medico_id;