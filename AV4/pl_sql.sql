-- Item 17: CREATE OR REPLACE PACKAGE (Especificação do Pacote)
-- Define a "cara" do nosso pacote, o que ele oferece para o mundo exterior.
CREATE OR REPLACE PACKAGE pkg_gerenciamento AS

    -- Item 4: CREATE PROCEDURE e Item 16: USO DE PARÂMETROS (IN)
    -- Procedimento para dar um aumento para um funcionário (operario ou engenheiro)
    PROCEDURE conceder_aumento (
        p_cpf       IN pessoa.cpf%TYPE, -- Item 6: %TYPE
        p_percentual_aumento IN NUMBER
    );

    -- Item 5: CREATE FUNCTION
    -- Função que retorna o número de projetos ativos de um determinado cliente.
    FUNCTION contar_projetos_cliente (
        p_cpf_cliente IN cliente.cpf%TYPE -- Item 6: %TYPE
    ) RETURN NUMBER;

END pkg_gerenciamento;
/

-- Item 18: CREATE OR REPLACE PACKAGE BODY (Corpo do Pacote)
-- Implementa a lógica que foi definida na especificação.
CREATE OR REPLACE PACKAGE BODY pkg_gerenciamento AS

    PROCEDURE conceder_aumento (
        p_cpf       IN pessoa.cpf%TYPE,
        p_percentual_aumento IN NUMBER
    ) AS
        v_salario_atual NUMBER;
        v_cargo         VARCHAR2(50);
    BEGIN
        -- Tenta encontrar o salário, primeiro em operario, depois em engenheiro
        BEGIN
            SELECT salario, cargo INTO v_salario_atual, v_cargo FROM operario WHERE cpf = p_cpf;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_salario_atual := NULL; -- Se não é operário, continua
        END;

        IF v_salario_atual IS NULL THEN
             BEGIN
                SELECT salario, cargo INTO v_salario_atual, v_cargo FROM engenheiro WHERE cpf = p_cpf;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Funcionário com CPF ' || p_cpf || ' não encontrado como operário ou engenheiro.');
                    RETURN; -- Sai do procedimento
            END;
        END IF;

        -- Item 8: IF ELSIF
        IF v_cargo = 'Pedreiro' OR v_cargo = 'Eletricista' OR v_cargo = 'Encanador' OR v_cargo = 'Carpinteiro' THEN
            UPDATE operario SET salario = salario * (1 + p_percentual_aumento / 100)
            WHERE cpf = p_cpf;
            DBMS_OUTPUT.PUT_LINE('Aumento concedido para o operário.');
        ELSIF v_cargo LIKE 'Engenheiro%' THEN
            UPDATE engenheiro SET salario = salario * (1 + p_percentual_aumento / 100)
            WHERE cpf = p_cpf;
            DBMS_OUTPUT.PUT_LINE('Aumento concedido para o engenheiro.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Cargo não elegível para aumento automático.');
        END IF;
        
        COMMIT;

    -- Item 15: EXCEPTION WHEN
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ocorreu um erro inesperado: ' || SQLERRM);
            ROLLBACK;
    END conceder_aumento;


    FUNCTION contar_projetos_cliente (
        p_cpf_cliente IN cliente.cpf%TYPE
    ) RETURN NUMBER AS
        v_total_projetos NUMBER;
    BEGIN
        -- Item 13: SELECT ... INTO
        SELECT COUNT(id_projeto)
        INTO v_total_projetos
        FROM contrata
        WHERE cpf_cliente = p_cpf_cliente;

        RETURN v_total_projetos;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RETURN -1; -- Indica um erro
    END contar_projetos_cliente;

END pkg_gerenciamento;
/

-- Item 20: CREATE OR REPLACE TRIGGER (LINHA)
-- Trigger que impede que o orçamento de um projeto seja reduzido.
CREATE OR REPLACE TRIGGER trg_valida_orcamento_projeto
BEFORE UPDATE OF orcamento ON projeto
FOR EACH ROW -- Isso o torna um trigger de LINHA
BEGIN
    IF :NEW.orcamento < :OLD.orcamento THEN
        RAISE_APPLICATION_ERROR(-20001, 'O orçamento de um projeto não pode ser reduzido. Valor antigo: ' || :OLD.orcamento);
    END IF;
END;
/

-- Item 19: CREATE OR REPLACE TRIGGER (COMANDO)
-- Trigger que audita (mostra uma mensagem) sempre que a tabela de fornecedores é alterada.
CREATE OR REPLACE TRIGGER trg_audita_fornecedores
AFTER INSERT OR UPDATE OR DELETE ON fornecedor
-- A ausência de "FOR EACH ROW" o torna um trigger de COMANDO
DECLARE
    v_operacao VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_operacao := 'inserção';
    ELSIF UPDATING THEN
        v_operacao := 'atualização';
    ELSIF DELETING THEN
        v_operacao := 'deleção';
    END IF;
    DBMS_OUTPUT.PUT_LINE('Aviso: Ocorreu uma operação de ' || v_operacao || ' na tabela FORNECEDOR.');
END;
/


-- Item 3: BLOCO ANÔNIMO para demonstrar os itens restantes
-- Este bloco testa as procedures, functions e demonstra os outros conceitos.
DECLARE
    -- Item 7: %ROWTYPE
    v_arquiteto_info arquiteto%ROWTYPE;

    -- Item 1: USO DE RECORD (tipo customizado)
    TYPE rec_resumo_material IS RECORD (
        nome          material.nome%TYPE,
        custo_unitario material.custo_unitario%TYPE
    );
    v_material rec_resumo_material;
    
    -- Item 2: USO DE ESTRUTURA DE DADOS DO TIPO TABLE
    TYPE tab_materiais IS TABLE OF rec_resumo_material;
    v_lista_materiais tab_materiais;

    -- Item 14: CURSOR (OPEN, FETCH e CLOSE)
    CURSOR c_projetos_caros IS
        SELECT id_projeto, orcamento FROM projeto WHERE orcamento > 800000;
    
    v_id_projeto projeto.id_projeto%TYPE;
    v_orcamento projeto.orcamento%TYPE;
    v_contador NUMBER := 1;

BEGIN
    -- Habilitar a saída para ver as mensagens
    DBMS_OUTPUT.PUT_LINE('--- INÍCIO DO TESTE PL/SQL ---');

    -- Testando o PACOTE
    DBMS_OUTPUT.PUT_LINE('Testando a procedure de aumento...');
    pkg_gerenciamento.conceder_aumento('34567890123', 10); -- Aumenta o salário do pedreiro em 10%
    
    DBMS_OUTPUT.PUT_LINE('Total de projetos do cliente 12345678901: ' || pkg_gerenciamento.contar_projetos_cliente('12345678901'));

    -- Usando o CURSOR explícito com LOOP EXIT WHEN
    -- Item 10: LOOP EXIT WHEN
    DBMS_OUTPUT.PUT_LINE(chr(10) || '--- Testando LOOP EXIT WHEN com Cursor ---');
    OPEN c_projetos_caros;
    LOOP
        FETCH c_projetos_caros INTO v_id_projeto, v_orcamento;
        EXIT WHEN c_projetos_caros%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Projeto caro encontrado: ' || v_id_projeto || ' - Orçamento: ' || v_orcamento);
    END LOOP;
    CLOSE c_projetos_caros;

    -- Usando BULK COLLECT com a estrutura de DADOS TIPO TABLE
    SELECT nome, custo_unitario BULK COLLECT INTO v_lista_materiais FROM material WHERE custo_unitario > 30;

    -- Item 11: WHILE LOOP para percorrer a coleção
    DBMS_OUTPUT.PUT_LINE(chr(10) || '--- Testando WHILE LOOP com Coleção de Materiais ---');
    v_contador := v_lista_materiais.FIRST;
    WHILE v_contador IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('Material: ' || v_lista_materiais(v_contador).nome);
        v_contador := v_lista_materiais.NEXT(v_contador);
    END LOOP;

    -- Item 12: FOR IN LOOP para percorrer os arquitetos
    DBMS_OUTPUT.PUT_LINE(chr(10) || '--- Testando FOR IN LOOP e CASE WHEN com Arquitetos ---');
    -- Item 9: CASE WHEN
    FOR arq IN (SELECT p.nome, a.salario FROM arquiteto a JOIN pessoa p ON a.cpf = p.cpf) LOOP
        CASE
            WHEN arq.salario > 7800 THEN
                DBMS_OUTPUT.PUT_LINE('Arquiteto Sênior: ' || arq.nome || ' - Salário: ' || arq.salario);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Arquiteto Pleno/Júnior: ' || arq.nome || ' - Salário: ' || arq.salario);
        END CASE;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- FIM DO TESTE PL/SQL ---');
END;