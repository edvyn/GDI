-- =====================================================================
-- SEÇÃO 1: TIPOS DE DADOS BÁSICOS E DE COLEÇÃO
-- =====================================================================

-- TIPO PARA TELEFONE
CREATE OR REPLACE TYPE TP_FONE AS OBJECT (
    numero VARCHAR2(15)
);
/
-- TESTE/CONFERÊNCIA: DESC TP_FONE;

-- TIPO PARA ENDERECO
CREATE OR REPLACE TYPE TP_ENDERECO AS OBJECT (
    cep VARCHAR2(8),
    rua VARCHAR2(100),
    numero VARCHAR2(10),
    bairro VARCHAR2(50),
    cidade VARCHAR2(50),
    estado VARCHAR2(2),
    complemento VARCHAR2(50)
);
/
-- TESTE/CONFERÊNCIA: DESC TP_ENDERECO;

-- TIPO PARA ETAPA DE PROJETO
CREATE OR REPLACE TYPE TP_ETAPA AS OBJECT (
    status_atual VARCHAR2(20),
    data_inicio DATE,
    data_conclusao_prevista DATE
);
/
-- TESTE/CONFERÊNCIA: DESC TP_ETAPA;

-- TIPO DE COLEÇÃO VARRAY PARA TELEFONES
CREATE OR REPLACE TYPE TP_TELEFONES_ARRAY AS VARRAY(5) OF TP_FONE;
/

-- TIPO DE COLEÇÃO NESTED TABLE PARA ETAPAS
CREATE OR REPLACE TYPE TP_ETAPA_LIST AS TABLE OF TP_ETAPA;
/


-- =====================================================================
-- SEÇÃO 2: HIERARQUIA DE TIPOS DE PESSOA E MÉTODOS 
-- =====================================================================

-- SUPER TIPO PESSOA
CREATE OR REPLACE TYPE TP_PESSOA AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(100),
    telefones TP_TELEFONES_ARRAY,
    
    -- Função para ser sobrescrita posteriormente
    MEMBER FUNCTION get_identificacao RETURN VARCHAR2,
    
    -- Método FINAL para demonstrar o conceito
    FINAL MEMBER FUNCTION get_cpf RETURN VARCHAR2
) NOT FINAL; -- NOT FINAL permite a herança
/

-- SUBTIPO FUNCIONARIO 
CREATE OR REPLACE TYPE TP_FUNCIONARIO UNDER TP_PESSOA (
    salario NUMBER(10,2),
    
    -- Função para calcular salário anual
    MEMBER FUNCTION salario_anual RETURN NUMBER,
    
    -- Função de comparação de salários
    ORDER MEMBER FUNCTION compara_salario(f TP_FUNCIONARIO) RETURN INTEGER
) NOT INSTANTIABLE;
/

-- SUBTIPO ENGENHEIRO
CREATE OR REPLACE TYPE TP_ENGENHEIRO UNDER TP_FUNCIONARIO (
    crea VARCHAR2(20),
    cargo VARCHAR2(50),
    ref_supervisor REF TP_ENGENHEIRO,
    
    -- Sobrescrevendo a função
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2,

    -- Procedimento para exibir detalhes
    MEMBER PROCEDURE exibir_detalhes
);
/

-- SUBTIPO CLIENTE
CREATE OR REPLACE TYPE TP_CLIENTE UNDER TP_PESSOA (
    email VARCHAR2(100),
    
    -- Construtor customizado
    CONSTRUCTOR FUNCTION TP_CLIENTE(p_cpf VARCHAR2, p_nome VARCHAR2) RETURN SELF AS RESULT,
    
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2
);
/

-- =====================================================================
-- SEÇÃO 3: IMPLEMENTAÇÃO DOS MÉTODOS 
-- =====================================================================

CREATE OR REPLACE TYPE BODY TP_PESSOA AS
    MEMBER FUNCTION get_identificacao RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Pessoa: ' || SELF.nome;
    END;

    FINAL MEMBER FUNCTION get_cpf RETURN VARCHAR2 IS
    BEGIN
        RETURN SELF.cpf;
    END;
END;
/

CREATE OR REPLACE TYPE BODY TP_FUNCIONARIO AS
    MEMBER FUNCTION salario_anual RETURN NUMBER IS
    BEGIN
        RETURN SELF.salario * 12;
    END;
    
    ORDER MEMBER FUNCTION compara_salario(f TP_FUNCIONARIO) RETURN INTEGER IS
    BEGIN
        IF SELF.salario > f.salario THEN RETURN 1;
        ELSIF SELF.salario < f.salario THEN RETURN -1;
        ELSE RETURN 0; END IF;
    END;
END;
/

CREATE OR REPLACE TYPE BODY TP_ENGENHEIRO AS
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Engenheiro(a): ' || SELF.nome || ' (CREA: ' || SELF.crea || ')';
    END;
    
    MEMBER PROCEDURE exibir_detalhes IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Detalhes do Engenheiro ---');
        DBMS_OUTPUT.PUT_LINE('Nome: ' || SELF.nome);
        DBMS_OUTPUT.PUT_LINE('Salário Anual: ' || SELF.salario_anual());
        IF self.ref_supervisor IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Supervisor: ' || self.ref_supervisor.nome);
        END IF;
    END;
END;
/

CREATE OR REPLACE TYPE BODY TP_CLIENTE AS
    CONSTRUCTOR FUNCTION TP_CLIENTE(p_cpf VARCHAR2, p_nome VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        SELF.cpf := p_cpf;
        SELF.nome := p_nome;
        SELF.telefones := TP_TELEFONES_ARRAY(); -- Inicializa a coleção vazia
        SELF.email := 'default@email.com'; -- Valor padrão
        RETURN;
    END;
    
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Cliente: ' || SELF.nome || ' (Email: ' || SELF.email || ')';
    END;
END;
/

-- =====================================================================
-- SEÇÃO 4: OUTROS TIPOS DE OBJETO
-- =====================================================================
CREATE OR REPLACE TYPE TP_PROJETO AS OBJECT (
    id_projeto VARCHAR2(10),
    ref_endereco REF TP_ENDERECO,
    orcamento NUMBER(15,2),
    etapas TP_ETAPA_LIST,

    -- Função de mapeamento para ordenação
    MAP MEMBER FUNCTION get_orcamento RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY TP_PROJETO AS
    MAP MEMBER FUNCTION get_orcamento RETURN NUMBER IS
    BEGIN
        RETURN SELF.orcamento;
    END;
END;
/

-- =====================================================================
-- SEÇÃO 5: CRIAÇÃO DAS TABELAS DE OBJETOS 
-- =====================================================================

CREATE TABLE TB_ENDERECOS OF TP_ENDERECO (
    PRIMARY KEY (cep, numero, complemento)
);
/

CREATE TABLE TB_ENGENHEIROS OF TP_ENGENHEIRO (
    cpf PRIMARY KEY,
    crea UNIQUE,
    -- SCOPE IS força a referência a vir apenas da própria tabela
    SCOPE FOR (ref_supervisor) IS TB_ENGENHEIROS
);
/

CREATE TABLE TB_CLIENTES OF TP_CLIENTE (
    cpf PRIMARY KEY
);
/

CREATE TABLE TB_PROJETOS OF TP_PROJETO (
    id_projeto PRIMARY KEY,
    -- Garante a integridade da referência
    ref_endereco WITH ROWID REFERENCES TB_ENDERECOS
) NESTED TABLE etapas STORE AS NT_ETAPAS_PROJETO;
/