/*
Objetivo: Demonstrar a manipulação e consulta de dados no modelo
Objeto-Relacional criado para o projeto da Alfa Construções.
*/

-- Habilita a exibição de saídas do PL/SQL
SET SERVEROUTPUT ON;

-- ====================================================================================================
-- SEÇÃO 1: CONSULTAS AO CHECKLIST OBRIGATÓRIO
-- ====================================================================================================

-- 1.1. Consulta com SELECT REF
-- Objetivo: Obter a referência (ponteiro) do engenheiro supervisor.
SELECT REF(e) AS ref_supervisor
FROM TB_ENGENHEIROS e WHERE e.cpf = '88888888888';

-- 1.2. Consulta com SELECT DEREF
-- Objetivo: Obter o nome do supervisor a partir da referência no engenheiro supervisionado.
SELECT e.nome AS engenheiro, DEREF(e.ref_supervisor).nome AS supervisor
FROM TB_ENGENHEIROS e WHERE e.ref_supervisor IS NOT NULL;

-- 1.3. Consulta a VARRAY (TP_TELEFONES_ARRAY)
-- Objetivo: Listar todos os telefones de um fornecedor específico.
SELECT p.nome AS proprietario, t.numero AS telefone
FROM TB_FORNECEDORES p, TABLE(p.telefones) t;

-- 1.4. Consulta a NESTED TABLE (TP_ETAPA_LIST)
-- Objetivo: Encontrar projetos que tenham uma etapa 'Em execução'.
SELECT p.id_projeto, e.status_atual, e.data_conclusao_prevista
FROM TB_PROJETOS p, TABLE(p.etapas) e
WHERE e.status_atual = 'Em execução';


-- ====================================================================================================
-- SEÇÃO 2: DEMONSTRAÇÃO DE TODOS OS MÉTODOS DOS TIPOS
-- ====================================================================================================

-- 2.1. Demonstração de Polimorfismo (get_identificacao)
-- Objetivo: Chamar o mesmo método em diferentes subtipos de TP_PESSOA.
SELECT p.get_identificacao() AS identificacao FROM TB_CLIENTES p
UNION ALL
SELECT a.get_identificacao() FROM TB_ARQUITETOS a
UNION ALL
SELECT e.get_identificacao() FROM TB_ENGENHEIROS e
UNION ALL
SELECT o.get_identificacao() FROM TB_OPERARIOS o;

-- 2.2. Demonstração de Funções de Salário (salario_anual)
-- Objetivo: Calcular o salário anual de todos os funcionários.
SELECT f.nome, f.salario_anual() AS salario_total_ano
FROM TB_ARQUITETOS f
UNION ALL
SELECT f.nome, f.salario_anual() FROM TB_ENGENHEIROS f
UNION ALL
SELECT f.nome, f.salario_anual() FROM TB_OPERARIOS f;

-- 2.3. Teste da ORDER MEMBER FUNCTION (compara_salario)
-- Objetivo: Comparar dois funcionários e ver quem ganha mais.
DECLARE
  v_engenheiro TB_ENGENHEIROS%ROWTYPE;
  v_operario   TB_OPERARIOS%ROWTYPE;
BEGIN
  SELECT VALUE(e) INTO v_engenheiro FROM TB_ENGENHEIROS e WHERE e.cpf = '99999999999'; -- Roberto Lima, 10500.00
  SELECT VALUE(o) INTO v_operario FROM TB_OPERARIOS o WHERE o.cpf = '33333333333'; -- Carlos Souza, 2500.00

  IF v_engenheiro > v_operario THEN
    DBMS_OUTPUT.PUT_LINE(v_engenheiro.nome || ' (R$' || v_engenheiro.salario || ') ganha mais que ' || v_operario.nome || ' (R$' || v_operario.salario || ').');
  END IF;
END;
/

-- 2.4. Teste do MEMBER PROCEDURE (exibir_detalhes)
-- Objetivo: Executar o procedimento que mostra os detalhes de um engenheiro.
DECLARE
  v_engenheiro_obj TP_ENGENHEIRO;
BEGIN
  SELECT VALUE(e) INTO v_engenheiro_obj FROM TB_ENGENHEIROS e WHERE e.cpf = '99999999999';
  v_engenheiro_obj.exibir_detalhes();
END;
/

-- 2.5. Teste da MAP MEMBER FUNCTION (get_orcamento)
-- Objetivo: Obter o orçamento de um projeto específico.
SELECT p.id_projeto, p.get_orcamento() AS orcamento
FROM TB_PROJETOS p
ORDER BY p.get_orcamento() DESC;

-- ====================================================================================================
-- SEÇÃO 3: CONSULTAS COMPLEXAS E RELATÓRIOS DE NEGÓCIO
-- ====================================================================================================

-- 3.1. Relatório Detalhado de Projeto
-- Objetivo: Mostrar um resumo completo do 'PROJ001', incluindo cliente, arquiteto e endereço.
SELECT
    p.id_projeto,
    p.orcamento,
    DEREF(p.ref_endereco).rua || ', ' || DEREF(p.ref_endereco).numero AS endereco_projeto,
    (SELECT DEREF(c.ref_cliente).nome FROM TB_CONTRATAS c WHERE c.ref_projeto = REF(p)) AS nome_cliente,
    (SELECT DEREF(pr.ref_arquiteto).nome FROM TB_PROJETA pr WHERE pr.ref_projeto = REF(p)) AS nome_arquiteto
FROM
    TB_PROJETOS p
WHERE
    p.id_projeto = 'PROJ001';

-- 3.2. Análise de Fornecedores por Localização
-- Objetivo: Listar fornecedores e materiais de projetos na cidade de 'Recife'.
SELECT DISTINCT
    DEREF(a.ref_fornecedor).nome AS fornecedor,
    DEREF(a.ref_material).nome AS material
FROM
    TB_ALOCA_PARA a
WHERE
    DEREF(DEREF(a.ref_projeto).ref_endereco).cidade = 'Recife';

-- 3.3. Funcionários com Salário Acima da Média Geral
-- Objetivo: Identificar engenheiros que ganham mais que a média de todos os funcionários (arq, eng, op).
SELECT e.nome, e.cargo, e.salario
FROM TB_ENGENHEIROS e
WHERE e.salario > (
    SELECT AVG(salario) FROM (
        SELECT salario FROM TB_ENGENHEIROS
        UNION ALL
        SELECT salario FROM TB_ARQUITETOS
        UNION ALL
        SELECT salario FROM TB_OPERARIOS
    )
);