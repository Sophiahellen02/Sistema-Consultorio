---------------------------------------------------------
-- TRIGGER 1: Impedir consultas em horário já ocupado
-- Finalidade: Garantir que um médico não possa receber
-- duas consultas no mesmo dia e horário (reforço da UNIQUE).
---------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_validar_horario_medico()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se já existe outra consulta no mesmo horário
    IF EXISTS (
        SELECT 1 FROM consultas
        WHERE medico_id = NEW.medico_id
          AND data_consulta = NEW.data_consulta
          AND horario = NEW.horario
          AND consulta_id <> NEW.consulta_id
    ) THEN
        RAISE EXCEPTION 
        'O médico já possui consulta marcada nesse dia e horário.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_horario_medico
BEFORE INSERT OR UPDATE ON consultas
FOR EACH ROW
EXECUTE FUNCTION fn_validar_horario_medico();


---------------------------------------------------------
-- Descrição:
-- Este gatilho é executado ANTES de inserir ou atualizar
-- uma consulta. Ele impede que um médico tenha duas consultas
-- no mesmo dia e horário, garantindo integridade lógica no sistema.
---------------------------------------------------------



---------------------------------------------------------
-- TRIGGER 2: Atualizar status da consulta quando pagamento é realizado
-- Finalidade: Quando o pagamento for marcado como "Pago",
-- a consulta automaticamente muda para "realizada".
---------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_atualizar_status_consulta()
RETURNS TRIGGER AS $$
BEGIN
    -- Se o pagamento for marcado como pago,
    -- atualiza o status da consulta relacionada
    IF NEW.status_pagamento = 'Pago' THEN
        UPDATE consultas
        SET status = 'realizada'
        WHERE consulta_id = NEW.consulta_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_status_consulta
AFTER UPDATE ON pagamentos
FOR EACH ROW
EXECUTE FUNCTION fn_atualizar_status_consulta();


---------------------------------------------------------
-- Descrição:
-- Este gatilho executa DEPOIS de atualizar um pagamento.
-- Quando o pagamento muda para "Pago", a consulta automaticamente
-- é marcada como "realizada". Isso evita inconsistências 
-- entre o status financeiro e o status clínico.
---------------------------------------------------------
