-- consultas_av5.sql - versão funcional com dados AV5
SET SERVEROUTPUT ON;

-- 1. SELECT REF
SELECT REF(e) FROM TB_ENGENHEIROS e WHERE e.cpf = '89012345678';

-- 2. SELECT DEREF
SELECT e.nome, DEREF(e.ref_supervisor).nome FROM TB_ENGENHEIROS e WHERE e.ref_supervisor IS NOT NULL;

-- 3. VARRAY
SELECT p.nome, t.numero FROM TB_FORNECEDORES p, TABLE(p.telefones) t;

-- 4. NESTED TABLE
SELECT p.id_projeto, e.status_atual FROM TB_PROJETOS p, TABLE(p.etapas) e WHERE e.status_atual = 'em execução';

-- 5. Polimorfismo
SELECT p.get_identificacao() FROM TB_CLIENTES p
UNION ALL SELECT a.get_identificacao() FROM TB_ARQUITETOS a
UNION ALL SELECT e.get_identificacao() FROM TB_ENGENHEIROS e;

-- 6. Salário anual
SELECT nome, salario, salario_anual() FROM TB_ENGENHEIROS
UNION ALL SELECT nome, salario, salario_anual() FROM TB_ARQUITETOS;

-- 7. Comparar salários
DECLARE
  v_eng TB_ENGENHEIRO; v_op TB_OPERARIO;
BEGIN
  SELECT VALUE(e) INTO v_eng FROM TB_ENGENHEIROS e WHERE e.cpf='90123456789';
  SELECT VALUE(o) INTO v_op FROM TB_OPERARIOS o WHERE o.cpf='23456789012';
  IF v_eng > v_op THEN
    DBMS_OUTPUT.PUT_LINE(v_eng.nome || ' ganha mais');
  END IF;
END;
/

-- 8. Detalhes engenheiro
DECLARE
  v_eng TB_ENGENHEIRO;
BEGIN
  SELECT VALUE(e) INTO v_eng FROM TB_ENGENHEIROS e WHERE e.cpf='90123456789';
  v_eng.exibir_detalhes();
END;
/

-- 9. Relatório de projeto
SELECT p.id_projeto, p.orcamento, DEREF(p.ref_endereco).cidade AS cidade
FROM TB_PROJETOS p
ORDER BY p DESC;

-- 10. Fornecedores por cidade
SELECT DISTINCT DEREF(a.ref_fornecedor).nome, DEREF(a.ref_material).nome
FROM TB_ALOCA_PARA a
WHERE DEREF(DEREF(a.ref_projeto).ref_endereco).cidade = 'Recife';
