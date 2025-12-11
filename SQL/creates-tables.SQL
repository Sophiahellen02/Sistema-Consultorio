-- 1. Criação do Bando de Dados
CREATE DATABASE clinica_bd;

-- 2. Tabela Pacientes
CREATE TABLE pacientes (
    paciente_id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    data_criacao DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 3. Tabela Médico
CREATE TABLE medicos (
    medico_id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    crm VARCHAR(30) NOT NULL UNIQUE,
    especialidade VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    data_criacao DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 4. Tabela Consultas
CREATE TABLE consultas (
    consulta_id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL REFERENCES pacientes(paciente_id),
    medico_id INTEGER NOT NULL REFERENCES medicos(medico_id),
    data_consulta DATE NOT NULL,
    horario TIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'agendada',
    observacoes TEXT,
    data_agendamento DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 5. Tabela Prontuários
CREATE TABLE prontuarios (
    prontuario_id SERIAL PRIMARY KEY,
    consulta_id INTEGER NOT NULL REFERENCES consultas(consulta_id),
    descricao TEXT,
    data_registro DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 6. Tabela Atendimentos
CREATE TABLE atendimentos (
    atendimento_id SERIAL PRIMARY KEY,
    consulta_id INTEGER NOT NULL REFERENCES consultas(consulta_id),
    anotacoes TEXT,
    receita TEXT,
    exames_solicitados TEXT,
    data_registro DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 7. Tabela de Exames Solicitados
CREATE TABLE exames_solicitados (
    exame_id SERIAL PRIMARY KEY,
    atendimento_id INTEGER NOT NULL REFERENCES atendimentos(atendimento_id),
    codigo_exame VARCHAR(50) NOT NULL,
    descricao_exame VARCHAR(255) NOT NULL,
    data_registro DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 8. Tabela Pagamentos
CREATE TABLE pagamentos (
    pagamento_id SERIAL PRIMARY KEY,
    consulta_id INTEGER NOT NULL REFERENCES consultas(consulta_id),
    valor DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(50) NOT NULL,
    status_pagamento VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    data_pagamento DATE NOT NULL DEFAULT CURRENT_DATE
);

-- ALTER TABLE

-- Impede agendamento duplicado do mesmo médico no mesmo dia/horário
ALTER TABLE consultas
ADD CONSTRAINT unq_medico_horario UNIQUE (medico_id, data_consulta, horario);

-- Impede que uma consulta tenha mais de um pagamento
ALTER TABLE pagamentos
ADD CONSTRAINT unq_pagamento_consulta UNIQUE (consulta_id);

-- Impede que uma consulta tenha mais de um prontuário
ALTER TABLE prontuarios
ADD CONSTRAINT unq_prontuario_consulta UNIQUE (consulta_id);

-- Remove o atributo antigo que não deve mais existir
ALTER TABLE atendimentos
DROP COLUMN exames_solicitados;

-- VIEWS

-- Consultas detalhadas
CREATE VIEW vw_consultas_detalhadas AS
SELECT 
    c.consulta_id,
    p.nome AS paciente,
    m.nome AS medico,
    m.especialidade,
    c.data_consulta,
    c.horario,
    c.status
FROM consultas c
JOIN pacientes p ON p.paciente_id = c.paciente_id
JOIN medicos m ON m.medico_id = c.medico_id;

-- Histórico de atendimentos por paciente
CREATE VIEW vw_historico_atendimentos AS
SELECT 
    p.nome AS paciente,
    c.consulta_id,
    a.atendimento_id,
    a.anotacoes,
    a.receita,
    a.exames_solicitados,
    a.data_registro
FROM pacientes p
JOIN consultas c ON c.paciente_id = p.paciente_id
JOIN atendimentos a ON a.consulta_id = c.consulta_id;

-- Pagamentos recebidos
CREATE VIEW vw_pagamentos_recebidos AS
SELECT 
    pagamento_id,
    consulta_id,
    valor,
    forma_pagamento,
    data_pagamento
FROM pagamentos
WHERE status_pagamento = 'Pago';

-- Agenda do médico
CREATE VIEW vw_agenda_medico AS
SELECT 
    m.nome AS medico,
    c.data_consulta,
    c.horario,
    p.nome AS paciente,
    c.status
FROM consultas c
JOIN medicos m ON m.medico_id = c.medico_id
JOIN pacientes p ON p.paciente_id = c.paciente_id
ORDER BY m.nome, c.data_consulta, c.horario;

-- Exames por Paciente
CREATE VIEW vw_exames_por_paciente AS
SELECT
    p.nome AS paciente,
    es.exame_id,
    es.codigo_exame,
    es.descricao_exame,
    es.data_registro,
    a.atendimento_id,
    c.data_consulta
FROM exames_solicitados es
JOIN atendimentos a ON a.atendimento_id = es.atendimento_id
JOIN consultas c ON c.consulta_id = a.consulta_id
JOIN pacientes p ON p.paciente_id = c.paciente_id
ORDER BY p.nome, es.data_registro;