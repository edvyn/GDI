-- =====================================================================
-- SEÇÃO 1: TIPOS DE DADOS BÁSICOS E DE COLEÇÃO
-- =====================================================================
-- TIPO PARA TELEFONE
CREATE OR REPLACE TYPE TP_FONE AS OBJECT (
    numero VARCHAR2(15)
);


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


-- TIPO PARA ETAPA DE PROJETO
CREATE OR REPLACE TYPE TP_ETAPA AS OBJECT (
    status_atual VARCHAR2(20),
    data_inicio DATE,
    data_conclusao_prevista DATE
);


-- TIPO DE COLEÇÃO VARRAY PARA TELEFONES
CREATE OR REPLACE TYPE TP_TELEFONES_ARRAY AS VARRAY(5) OF TP_FONE;


-- TIPO DE COLEÇÃO NESTED TABLE PARA ETAPAS
CREATE OR REPLACE TYPE TP_ETAPA_LIST AS TABLE OF TP_ETAPA;



-- =====================================================================
-- SEÇÃO 2: HIERARQUIA DE TIPOS DE PESSOA E MÉTODOS 
-- =====================================================================
-- SUPER TIPO PESSOA
CREATE OR REPLACE TYPE TP_PESSOA AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(100),
    telefones TP_TELEFONES_ARRAY,
    -- Método abstrato (NOT INSTANTIABLE MEMBER) - NOVO!
    NOT INSTANTIABLE MEMBER FUNCTION calcular_salario RETURN NUMBER,
    -- Função para ser sobrescrita
    MEMBER FUNCTION get_identificacao RETURN VARCHAR2,
    -- Método FINAL
    FINAL MEMBER FUNCTION get_cpf RETURN VARCHAR2
) NOT FINAL NOT INSTANTIABLE; -- Agora TP_PESSOA também é abstrata

-- SUBTIPO FUNCIONARIO 
CREATE OR REPLACE TYPE TP_FUNCIONARIO UNDER TP_PESSOA (
    salario NUMBER(10,2),
    -- Implementa o método abstrato
    OVERRIDING MEMBER FUNCTION calcular_salario RETURN NUMBER,
    -- Função para calcular salário anual
    MEMBER FUNCTION salario_anual RETURN NUMBER,
    -- Função de comparação de salários
    ORDER MEMBER FUNCTION compara_salario(f TP_FUNCIONARIO) RETURN INTEGER
) NOT INSTANTIABLE;

-- SUBTIPO ENGENHEIRO
CREATE OR REPLACE TYPE TP_ENGENHEIRO UNDER TP_FUNCIONARIO (
    crea VARCHAR2(20),
    cargo VARCHAR2(50),
    ref_supervisor REF TP_ENGENHEIRO,
    -- Sobrescrevendo as funções
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2,
    OVERRIDING MEMBER FUNCTION calcular_salario RETURN NUMBER,
    -- Procedimento para exibir detalhes
    MEMBER PROCEDURE exibir_detalhes
);

-- SUBTIPO CLIENTE
CREATE OR REPLACE TYPE TP_CLIENTE UNDER TP_PESSOA (
    email VARCHAR2(100),
    -- Construtor customizado
    CONSTRUCTOR FUNCTION TP_CLIENTE(p_cpf VARCHAR2, p_nome VARCHAR2) RETURN SELF AS RESULT,
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2,
    OVERRIDING MEMBER FUNCTION calcular_salario RETURN NUMBER
);

-- SUBTIPO OPERARIO
CREATE OR REPLACE TYPE TP_OPERARIO UNDER TP_FUNCIONARIO (
    cargo VARCHAR2(50),
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2,
    OVERRIDING MEMBER FUNCTION calcular_salario RETURN NUMBER
);

-- SUBTIPO ARQUITETO
CREATE OR REPLACE TYPE TP_ARQUITETO UNDER TP_FUNCIONARIO (
    cau VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2,
    OVERRIDING MEMBER FUNCTION calcular_salario RETURN NUMBER
);



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

CREATE OR REPLACE TYPE BODY TP_ENGENHEIRO AS
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Engenheiro(a): ' || SELF.nome || ' (CREA: ' || SELF.crea || ')';
    END;
    OVERRIDING MEMBER FUNCTION calcular_salario RETURN NUMBER IS
    BEGIN
        RETURN SELF.salario;
    END;
    MEMBER PROCEDURE exibir_detalhes IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('--- Detalhes do Engenheiro ---');
        DBMS_OUTPUT.PUT_LINE('Nome: ' || SELF.nome);
        DBMS_OUTPUT.PUT_LINE('Salário Anual: ' || SELF.salario_anual());
        IF SELF.ref_supervisor IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Supervisor: ' || DEREF(SELF.ref_supervisor).nome);
        END IF;
    END;
END;

CREATE OR REPLACE TYPE BODY TP_CLIENTE AS
    CONSTRUCTOR FUNCTION TP_CLIENTE(p_cpf VARCHAR2, p_nome VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        SELF.cpf := p_cpf;
        SELF.nome := p_nome;
        SELF.telefones := TP_TELEFONES_ARRAY();
        SELF.email := 'default@email.com';
        RETURN;
    END;
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Cliente: ' || SELF.nome || ' (Email: ' || SELF.email || ')';
    END;
    OVERRIDING MEMBER FUNCTION calcular_salario RETURN NUMBER IS
    BEGIN
        RETURN 0; -- Cliente não tem salário
    END;
END;

CREATE OR REPLACE TYPE BODY TP_OPERARIO AS
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Operário: ' || SELF.nome || ' (' || SELF.cargo || ')';
    END;
    OVERRIDING MEMBER FUNCTION calcular_salario RETURN NUMBER IS
    BEGIN
        RETURN SELF.salario;
    END;
END;

CREATE OR REPLACE TYPE BODY TP_ARQUITETO AS
    OVERRIDING MEMBER FUNCTION get_identificacao RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Arquiteto: ' || SELF.nome || ' (CAU: ' || SELF.cau || ')';
    END;
    OVERRIDING MEMBER FUNCTION calcular_salario RETURN NUMBER IS
    BEGIN
        RETURN SELF.salario;
    END;
END;



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


CREATE OR REPLACE TYPE BODY TP_PROJETO AS
    MAP MEMBER FUNCTION get_orcamento RETURN NUMBER IS
    BEGIN
        RETURN SELF.orcamento;
    END;
END;


-- TIPO FORNECEDOR
CREATE OR REPLACE TYPE TP_FORNECEDOR AS OBJECT (
    cnpj VARCHAR2(14),
    nome VARCHAR2(100),
    telefones TP_TELEFONES_ARRAY
);


-- TIPO MATERIAL
CREATE OR REPLACE TYPE TP_MATERIAL AS OBJECT (
    codigo VARCHAR2(10),
    nome VARCHAR2(100),
    quantidade INTEGER,
    custo_unitario NUMBER(10,2)
);


-- TIPOS DE RELACIONAMENTO (ASSOCIAÇÃO)
CREATE OR REPLACE TYPE TP_CONTRATA AS OBJECT (
    ref_cliente REF TP_CLIENTE,
    ref_projeto REF TP_PROJETO,
    data_assinatura DATE,
    valor_total NUMBER(15,2),
    condicoes_pagamento VARCHAR2(50)
);


CREATE OR REPLACE TYPE TP_TRABALHA_EM AS OBJECT (
    ref_operario REF TP_OPERARIO,
    ref_projeto REF TP_PROJETO
);


CREATE OR REPLACE TYPE TP_PLANEJA AS OBJECT (
    ref_engenheiro REF TP_ENGENHEIRO,
    ref_projeto REF TP_PROJETO,
    status_calculo_estrutural VARCHAR2(20),
    status_fundacao VARCHAR2(20)
);


CREATE OR REPLACE TYPE TP_PROJETA AS OBJECT (
    ref_arquiteto REF TP_ARQUITETO,
    ref_projeto REF TP_PROJETO
);


CREATE OR REPLACE TYPE TP_ALOCA_PARA AS OBJECT (
    ref_fornecedor REF TP_FORNECEDOR,
    ref_material REF TP_MATERIAL,
    ref_projeto REF TP_PROJETO,
    previsao_entrega DATE
);



-- =====================================================================
-- SEÇÃO 5: CRIAÇÃO DAS TABELAS DE OBJETOS 
-- =====================================================================
CREATE TABLE TB_ENDERECOS OF TP_ENDERECO (
    PRIMARY KEY (cep, numero, complemento)
);

CREATE TABLE TB_ENGENHEIROS OF TP_ENGENHEIRO (
    cpf PRIMARY KEY,
    crea UNIQUE,
    SCOPE FOR (ref_supervisor) IS TB_ENGENHEIROS
);

CREATE TABLE TB_CLIENTES OF TP_CLIENTE (
    cpf PRIMARY KEY
);

CREATE TABLE TB_OPERARIOS OF TP_OPERARIO (
    cpf PRIMARY KEY
);

CREATE TABLE TB_ARQUITETOS OF TP_ARQUITETO (
    cau PRIMARY KEY
);

CREATE TABLE TB_FORNECEDORES OF TP_FORNECEDOR (
    cnpj PRIMARY KEY
);

CREATE TABLE TB_MATERIAIS OF TP_MATERIAL (
    codigo PRIMARY KEY
);

CREATE TABLE TB_PROJETOS OF TP_PROJETO (
    id_projeto PRIMARY KEY,
    ref_endereco WITH ROWID REFERENCES TB_ENDERECOS
) NESTED TABLE etapas STORE AS NT_ETAPAS_PROJETO;

CREATE TABLE TB_CONTRATAS OF TP_CONTRATA (
    PRIMARY KEY (ref_cliente, ref_projeto)
);

CREATE TABLE TB_TRABALHA_EM OF TP_TRABALHA_EM (
    PRIMARY KEY (ref_operario, ref_projeto)
);

CREATE TABLE TB_PLANEJA OF TP_PLANEJA (
    PRIMARY KEY (ref_engenheiro, ref_projeto)
);

CREATE TABLE TB_PROJETA OF TP_PROJETA (
    PRIMARY KEY (ref_arquiteto, ref_projeto)
);

CREATE TABLE TB_ALOCA_PARA OF TP_ALOCA_PARA (
    PRIMARY KEY (ref_fornecedor, ref_material, ref_projeto)
);