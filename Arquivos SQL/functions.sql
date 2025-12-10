---------------------------------------------------------
-- FUNÇÃO 1: Calcular total pago por um paciente
-- Finalidade:
--    Retorna a soma de todos os pagamentos com status 'Pago'
--    realizados por um determinado paciente.
-- Como usar:
--    SELECT fn_total_pago_paciente(1);
---------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_total_pago_paciente(id_paciente INTEGER)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    total_pago DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(p.valor), 0)
    INTO total_pago
    FROM pagamentos p
    JOIN consultas c ON c.consulta_id = p.consulta_id
    WHERE c.paciente_id = id_paciente
      AND p.status_pagamento = 'Pago';

    RETURN total_pago;
END;
$$ LANGUAGE plpgsql;



---------------------------------------------------------
-- FUNÇÃO 2: Contar quantidade de consultas realizadas
-- Finalidade:
--    Informa quantas consultas um médico já finalizou
--    (ou seja, consultas com status 'realizada').
-- Como usar:
--    SELECT fn_consultas_realizadas_medico(2);
---------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_consultas_realizadas_medico(id_medico INTEGER)
RETURNS INTEGER AS $$
DECLARE
    qtd INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO qtd
    FROM consultas
    WHERE medico_id = id_medico
      AND status = 'realizada';

    RETURN qtd;
END;
$$ LANGUAGE plpgsql;
