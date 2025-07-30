/* 
CREATE OR REPLACE TYPE -- ok
CREATE OR REPLACE TYPE BODY -- ok
MEMBER PROCEDURE
MEMBER FUNCTION
ORDER MEMBER FUNCTION
MAP MEMBER FUNCTION
CONSTRUCTOR FUNCTION  --ok
OVERRIDING MEMBER
FINAL MEMBER
NOT INSTANTIABLE TYPE/MEMBER
HERANÇA DE TIPOS (UNDER/NOT FINAL) --ok
ALTER TYPE
CREATE TABLE OF  --ok
WITH ROWID REFERENCES  --ok
REF  -- ok
SCOPE IS
INSERT INTO
VALUE
VARRAY  --ok
NESTED TABLE --ok
*/




--------------------TIPOS--------------------------


-- tipo pra número de telefone
CREATE TYPE TP_FONE AS OBJECT (
    numero VARCHAR2(15),
    CONSTRUCTOR FUNCTION TP_FONE(numero VARCHAR2) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_fone
CREATE OR REPLACE TYPE BODY TP_FONE AS
    CONSTRUCTOR FUNCTION TP_FONE(numero VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        SELF.numero := numero;
        RETURN;
    END;
END;
/

-- tipo varray pra telefones de pessoa
CREATE TYPE TP_TELEFONE_PESSOA_ARRAY AS VARRAY(10) OF TP_FONE;
/

-- tipo varray pra telefones de fornecedor
CREATE TYPE TP_TELEFONE_FORNECEDOR_ARRAY AS VARRAY(10) OF TP_FONE;
/

-- tipo pra endereço
CREATE TYPE TP_ENDERECO AS OBJECT (
    cep VARCHAR2(8),
    numero VARCHAR2(10),
    complemento VARCHAR2(50),
    rua VARCHAR2(100),
    bairro VARCHAR2(50),
    cidade VARCHAR2(50),
    estado VARCHAR2(2),
    CONSTRUCTOR FUNCTION TP_ENDERECO(
        cep VARCHAR2,
        numero VARCHAR2,
        complemento VARCHAR2,
        rua VARCHAR2,
        bairro VARCHAR2,
        cidade VARCHAR2,
        estado VARCHAR2
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_endereço
CREATE OR REPLACE TYPE BODY TP_ENDERECO AS
    CONSTRUCTOR FUNCTION TP_ENDERECO(
        cep VARCHAR2,
        numero VARCHAR2,
        complemento VARCHAR2,
        rua VARCHAR2,
        bairro VARCHAR2,
        cidade VARCHAR2,
        estado VARCHAR2
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.cep := cep;
        SELF.numero := numero;
        SELF.complemento := complemento;
        SELF.rua := rua;
        SELF.bairro := bairro;
        SELF.cidade := cidade;
        SELF.estado := estado;
        RETURN;
    END;
END;
/

-- supertipo pra pessoa
CREATE TYPE TP_PESSOA AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(100),
    telefones TP_TELEFONE_PESSOA_ARRAY,
    CONSTRUCTOR FUNCTION TP_PESSOA(
        cpf VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_PESSOA_ARRAY
    ) RETURN SELF AS RESULT
) NOT FINAL;
/

-- corpo do construtor pra tp_pessoa
CREATE OR REPLACE TYPE BODY TP_PESSOA AS
    CONSTRUCTOR FUNCTION TP_PESSOA(
        cpf VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_PESSOA_ARRAY
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.cpf := cpf;
        SELF.nome := nome;
        SELF.telefones := telefones;
        RETURN;
    END;
END;
/

-- subtipo pra cliente
CREATE TYPE TP_CLIENTE UNDER TP_PESSOA (
    email VARCHAR2(100),
    CONSTRUCTOR FUNCTION TP_CLIENTE(
        cpf VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_PESSOA_ARRAY,
        email VARCHAR2
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_cliente
CREATE OR REPLACE TYPE BODY TP_CLIENTE AS
    CONSTRUCTOR FUNCTION TP_CLIENTE(
        cpf VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_PESSOA_ARRAY,
        email VARCHAR2
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF := TP_PESSOA(cpf, nome, telefones);
        SELF.email := email;
        RETURN;
    END;
END;
/

-- tipo pra fornecedor
CREATE TYPE TP_FORNECEDOR AS OBJECT (
    cnpj VARCHAR2(14),
    nome VARCHAR2(100),
    telefones TP_TELEFONE_FORNECEDOR_ARRAY,
    CONSTRUCTOR FUNCTION TP_FORNECEDOR(
        cnpj VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_FORNECEDOR_ARRAY
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_fornecedor
CREATE OR REPLACE TYPE BODY TP_FORNECEDOR AS
    CONSTRUCTOR FUNCTION TP_FORNECEDOR(
        cnpj VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_FORNECEDOR_ARRAY
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.cnpj := cnpj;
        SELF.nome := nome;
        SELF.telefones := telefones;
        RETURN;
    END;
END;
/

-- subtipo pra operário
CREATE TYPE TP_OPERARIO UNDER TP_PESSOA (
    cargo VARCHAR2(50),
    salario NUMBER(10,2),
    CONSTRUCTOR FUNCTION TP_OPERARIO(
        cpf VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_PESSOA_ARRAY,
        cargo VARCHAR2,
        salario NUMBER
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_operário
CREATE OR REPLACE TYPE BODY TP_OPERARIO AS
    CONSTRUCTOR FUNCTION TP_OPERARIO(
        cpf VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_PESSOA_ARRAY,
        cargo VARCHAR2,
        salario NUMBER
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF := TP_PESSOA(cpf, nome, telefones);
        SELF.cargo := cargo;
        SELF.salario := salario;
        RETURN;
    END;
END;
/

-- subtipo pra arquiteto
CREATE TYPE TP_ARQUITETO UNDER TP_PESSOA (
    cau VARCHAR2(20),
    salario NUMBER(10,2),
    CONSTRUCTOR FUNCTION TP_ARQUITETO(
        cpf VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_PESSOA_ARRAY,
        cau VARCHAR2,
        salario NUMBER
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_arquiteto
CREATE OR REPLACE TYPE BODY TP_ARQUITETO AS
    CONSTRUCTOR FUNCTION TP_ARQUITETO(
        cpf VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_PESSOA_ARRAY,
        cau VARCHAR2,
        salario NUMBER
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF := TP_PESSOA(cpf, nome, telefones);
        SELF.cau := cau;
        SELF.salario := salario;
        RETURN;
    END;
END;
/

-- subtipo pra engenheiro
CREATE TYPE TP_ENGENHEIRO UNDER TP_PESSOA (
    crea VARCHAR2(20),
    cargo VARCHAR2(50),
    ref_supervisor REF TP_ENGENHEIRO,
    salario NUMBER(10,2),
    CONSTRUCTOR FUNCTION TP_ENGENHEIRO(
        cpf VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_PESSOA_ARRAY,
        crea VARCHAR2,
        cargo VARCHAR2,
        ref_supervisor REF TP_ENGENHEIRO,
        salario NUMBER
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_engenheiro
CREATE OR REPLACE TYPE BODY TP_ENGENHEIRO AS
    CONSTRUCTOR FUNCTION TP_ENGENHEIRO(
        cpf VARCHAR2,
        nome VARCHAR2,
        telefones TP_TELEFONE_PESSOA_ARRAY,
        crea VARCHAR2,
        cargo VARCHAR2,
        ref_supervisor REF TP_ENGENHEIRO,
        salario NUMBER
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF := TP_PESSOA(cpf, nome, telefones);
        SELF.crea := crea;
        SELF.cargo := cargo;
        SELF.ref_supervisor := ref_supervisor;
        SELF.salario := salario;
        RETURN;
    END;
END;
/

-- tipo pra material
CREATE TYPE TP_MATERIAL AS OBJECT (
    codigo VARCHAR2(10),
    nome VARCHAR2(100),
    quantidade INTEGER,
    custo_unitario NUMBER(10,2),
    CONSTRUCTOR FUNCTION TP_MATERIAL(
        codigo VARCHAR2,
        nome VARCHAR2,
        quantidade INTEGER,
        custo_unitario NUMBER
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_material
CREATE OR REPLACE TYPE BODY TP_MATERIAL AS
    CONSTRUCTOR FUNCTION TP_MATERIAL(
        codigo VARCHAR2,
        nome VARCHAR2,
        quantidade INTEGER,
        custo_unitario NUMBER
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.codigo := codigo;
        SELF.nome := nome;
        SELF.quantidade := quantidade;
        SELF.custo_unitario := custo_unitario;
        RETURN;
    END;
END;
/

-- tipo pra etapa de projeto
CREATE TYPE TP_ETAPA AS OBJECT (
    status_atual VARCHAR2(20),
    data_inicio DATE,
    data_conclusao_prevista DATE,
    CONSTRUCTOR FUNCTION TP_ETAPA(
        status_atual VARCHAR2,
        data_inicio DATE,
        data_conclusao_prevista DATE
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_etapa
CREATE OR REPLACE TYPE BODY TP_ETAPA AS
    CONSTRUCTOR FUNCTION TP_ETAPA(
        status_atual VARCHAR2,
        data_inicio DATE,
        data_conclusao_prevista DATE
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.status_atual := status_atual;
        SELF.data_inicio := data_inicio;
        SELF.data_conclusao_prevista := data_conclusao_prevista;
        RETURN;
    END;
END;
/

-- tipo de tabela aninhada pra etapas de projeto
CREATE TYPE TP_ETAPA_LIST AS TABLE OF TP_ETAPA;
/

-- tipo pra projeto
CREATE TYPE TP_PROJETO AS OBJECT (
    id_projeto VARCHAR2(10),
    ref_endereco REF TP_ENDERECO,
    orcamento NUMBER(15,2),
    etapas TP_ETAPA_LIST,
    CONSTRUCTOR FUNCTION TP_PROJETO(
        id_projeto VARCHAR2,
        ref_endereco REF TP_ENDERECO,
        orcamento NUMBER,
        etapas TP_ETAPA_LIST
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_projeto
CREATE OR REPLACE TYPE BODY TP_PROJETO AS
    CONSTRUCTOR FUNCTION TP_PROJETO(
        id_projeto VARCHAR2,
        ref_endereco REF TP_ENDERECO,
        orcamento NUMBER,
        etapas TP_ETAPA_LIST
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.id_projeto := id_projeto;
        SELF.ref_endereco := ref_endereco;
        SELF.orcamento := orcamento;
        SELF.etapas := etapas;
        RETURN;
    END;
END;
/

-- tipo pra o relacionamento contrata
CREATE TYPE TP_CONTRATA AS OBJECT (
    ref_cliente REF TP_CLIENTE,
    ref_projeto REF TP_PROJETO,
    data_assinatura DATE,
    valor_total NUMBER(15,2),
    condicoes_pagamento VARCHAR2(50),
    CONSTRUCTOR FUNCTION TP_CONTRATA(
        ref_cliente REF TP_CLIENTE,
        ref_projeto REF TP_PROJETO,
        data_assinatura DATE,
        valor_total NUMBER,
        condicoes_pagamento VARCHAR2
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_contrata
CREATE OR REPLACE TYPE BODY TP_CONTRATA AS
    CONSTRUCTOR FUNCTION TP_CONTRATA(
        ref_cliente REF TP_CLIENTE,
        ref_projeto REF TP_PROJETO,
        data_assinatura DATE,
        valor_total NUMBER,
        condicoes_pagamento VARCHAR2
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.ref_cliente := ref_cliente;
        SELF.ref_projeto := ref_projeto;
        SELF.data_assinatura := data_assinatura;
        SELF.valor_total := valor_total;
        SELF.condicoes_pagamento := condicoes_pagamento;
        RETURN;
    END;
END;
/

-- tipo pra o relacionamento trabalha_em
CREATE TYPE TP_TRABALHA_EM AS OBJECT (
    ref_operario REF TP_OPERARIO,
    ref_projeto REF TP_PROJETO,
    CONSTRUCTOR FUNCTION TP_TRABALHA_EM(
        ref_operario REF TP_OPERARIO,
        ref_projeto REF TP_PROJETO
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_trabalha_em
CREATE OR REPLACE TYPE BODY TP_TRABALHA_EM AS
    CONSTRUCTOR FUNCTION TP_TRABALHA_EM(
        ref_operario REF TP_OPERARIO,
        ref_projeto REF TP_PROJETO
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.ref_operario := ref_operario;
        SELF.ref_projeto := ref_projeto;
        RETURN;
    END;
END;
/

-- tipo pra o relacionamento planeja
CREATE TYPE TP_PLANEJA AS OBJECT (
    ref_engenheiro REF TP_ENGENHEIRO,
    ref_projeto REF TP_PROJETO,
    status_calculo_estrutural VARCHAR2(20),
    status_fundacao VARCHAR2(20),
    CONSTRUCTOR FUNCTION TP_PLANEJA(
        ref_engenheiro REF TP_ENGENHEIRO,
        ref_projeto REF TP_PROJETO,
        status_calculo_estrutural VARCHAR2,
        status_fundacao VARCHAR2
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_planeja
CREATE OR REPLACE TYPE BODY TP_PLANEJA AS
    CONSTRUCTOR FUNCTION TP_PLANEJA(
        ref_engenheiro REF TP_ENGENHEIRO,
        ref_projeto REF TP_PROJETO,
        status_calculo_estrutural VARCHAR2,
        status_fundacao VARCHAR2
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.ref_engenheiro := ref_engenheiro;
        SELF.ref_projeto := ref_projeto;
        SELF.status_calculo_estrutural := status_calculo_estrutural;
        SELF.status_fundacao := status_fundacao;
        RETURN;
    END;
END;
/

-- tipo pra o relacionamento projeta
CREATE TYPE TP_PROJETA AS OBJECT (
    ref_arquiteto REF TP_ARQUITETO,
    ref_projeto REF TP_PROJETO,
    CONSTRUCTOR FUNCTION TP_PROJETA(
        ref_arquiteto REF TP_ARQUITETO,
        ref_projeto REF TP_PROJETO
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_projeta
CREATE OR REPLACE TYPE BODY TP_PROJETA AS
    CONSTRUCTOR FUNCTION TP_PROJETA(
        ref_arquiteto REF TP_ARQUITETO,
        ref_projeto REF TP_PROJETO
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.ref_arquiteto := ref_arquiteto;
        SELF.ref_projeto := ref_projeto;
        RETURN;
    END;
END;
/

-- tipo pra o relacionamento aloca_para
CREATE TYPE TP_ALOCA_PARA AS OBJECT (
    ref_fornecedor REF TP_FORNECEDOR,
    ref_material REF TP_MATERIAL,
    ref_projeto REF TP_PROJETO,
    previsao_entrega DATE,
    CONSTRUCTOR FUNCTION TP_ALOCA_PARA(
        ref_fornecedor REF TP_FORNECEDOR,
        ref_material REF TP_MATERIAL,
        ref_projeto REF TP_PROJETO,
        previsao_entrega DATE
    ) RETURN SELF AS RESULT
);
/

-- corpo do construtor pra tp_aloca_para
CREATE OR REPLACE TYPE BODY TP_ALOCA_PARA AS
    CONSTRUCTOR FUNCTION TP_ALOCA_PARA(
        ref_fornecedor REF TP_FORNECEDOR,
        ref_material REF TP_MATERIAL,
        ref_projeto REF TP_PROJETO,
        previsao_entrega DATE
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.ref_fornecedor := ref_fornecedor;
        SELF.ref_material := ref_material;
        SELF.ref_projeto := ref_projeto;
        SELF.previsao_entrega := previsao_entrega;
        RETURN;
    END;
END;
/


---------- tabelas ---------------

-- tabela pra endereços
CREATE TABLE TB_ENDERECOS OF TP_ENDERECO (
    cep CONSTRAINT ENDERECO_CEP_NN NOT NULL,
    numero CONSTRAINT ENDERECO_NUMERO_NN NOT NULL,
    complemento CONSTRAINT ENDERECO_COMPLEMENTO_NN NOT NULL,
    rua CONSTRAINT ENDERECO_RUA_NN NOT NULL,
    bairro CONSTRAINT ENDERECO_BAIRRO_NN NOT NULL,
    cidade CONSTRAINT ENDERECO_CIDADE_NN NOT NULL,
    estado CONSTRAINT ENDERECO_ESTADO_NN NOT NULL,
    CONSTRAINT PK_ENDERECO PRIMARY KEY (cep, numero, complemento),
    CONSTRAINT CEP_CHECK CHECK (REGEXP_LIKE(cep, '^[0-9]{8}$')),
    CONSTRAINT ESTADO_CHECK CHECK (estado IN (
        'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA',
        'PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'))
);

-- tabela pra pessoas
CREATE TABLE TB_PESSOAS OF TP_PESSOA (
    cpf CONSTRAINT PESSOA_CPF_NN NOT NULL,
    nome CONSTRAINT PESSOA_NOME_NN NOT NULL,
    CONSTRAINT PK_PESSOA PRIMARY KEY (cpf),
    CONSTRAINT CPF_CHECK CHECK (REGEXP_LIKE(cpf, '^[0-9]{11}$'))
);

-- tabela pra clientes
CREATE TABLE TB_CLIENTES OF TP_CLIENTE (
    cpf CONSTRAINT CLIENTE_CPF_PK PRIMARY KEY,
    email CONSTRAINT CLIENTE_EMAIL_NN NOT NULL,
    CONSTRAINT EMAIL_CHECK CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
);

-- tabela pra fornecedores
CREATE TABLE TB_FORNECEDORES OF TP_FORNECEDOR (
    cnpj CONSTRAINT FORNECEDOR_CNPJ_NN NOT NULL,
    nome CONSTRAINT FORNECEDOR_NOME_NN NOT NULL,
    CONSTRAINT PK_FORNECEDOR PRIMARY KEY (cnpj),
    CONSTRAINT CNPJ_CHECK CHECK (REGEXP_LIKE(cnpj, '^[0-9]{14}$'))
);

-- tabela pra operários
CREATE TABLE TB_OPERARIOS OF TP_OPERARIO (
    cpf CONSTRAINT OPERARIO_CPF_PK PRIMARY KEY,
    cargo CONSTRAINT OPERARIO_CARGO_NN NOT NULL,
    salario CONSTRAINT OPERARIO_SALARIO_NN NOT NULL,
    CONSTRAINT SALARIO_OPERARIO_CHECK CHECK (salario >= 1212.00)
);

-- tabela pra arquitetos
CREATE TABLE TB_ARQUITETOS OF TP_ARQUITETO (
    cpf CONSTRAINT ARQUITETO_CPF_PK PRIMARY KEY,
    cau CONSTRAINT ARQUITETO_CAU_NN NOT NULL UNIQUE,
    salario CONSTRAINT ARQUITETO_SALARIO_NN NOT NULL,
    CONSTRAINT SALARIO_ARQUITETO_CHECK CHECK (salario >= 3000.00)
);

-- tabela pra engenheiros
CREATE TABLE TB_ENGENHEIROS OF TP_ENGENHEIRO (
    cpf CONSTRAINT ENGENHEIRO_CPF_PK PRIMARY KEY,
    crea CONSTRAINT ENGENHEIRO_CREA_NN NOT NULL UNIQUE,
    cargo CONSTRAINT ENGENHEIRO_CARGO_NN NOT NULL,
    salario CONSTRAINT ENGENHEIRO_SALARIO_NN NOT NULL,
    CONSTRAINT FK_ENGENHEIRO_SUPERVISOR FOREIGN KEY (ref_supervisor) REFERENCES TB_ENGENHEIROS,
    CONSTRAINT SALARIO_ENGENHEIRO_CHECK CHECK (salario >= 5000.00)
);

-- tabela pra materiais
CREATE TABLE TB_MATERIAIS OF TP_MATERIAL (
    codigo CONSTRAINT MATERIAL_CODIGO_NN NOT NULL,
    nome CONSTRAINT MATERIAL_NOME_NN NOT NULL,
    quantidade CONSTRAINT MATERIAL_QUANTIDADE_NN NOT NULL,
    custo_unitario CONSTRAINT MATERIAL_CUSTO_UNITARIO_NN NOT NULL,
    CONSTRAINT PK_MATERIAL PRIMARY KEY (codigo),
    CONSTRAINT QUANTIDADE_CHECK CHECK (quantidade >= 0),
    CONSTRAINT CUSTO_CHECK CHECK (custo_unitario > 0)
);

-- tabela pra projetos
CREATE TABLE TB_PROJETOS OF TP_PROJETO (
    id_projeto CONSTRAINT PROJETO_ID_NN NOT NULL,
    ref_endereco WITH ROWID REFERENCES TB_ENDERECOS,
    orcamento CONSTRAINT PROJETO_ORCAMENTO_NN NOT NULL,
    CONSTRAINT PK_PROJETO PRIMARY KEY (id_projeto),
    CONSTRAINT ORCAMENTO_CHECK CHECK (orcamento > 0)
) NESTED TABLE etapas STORE AS NT_TB_ETAPAS_PROJETO (
    CONSTRAINT STATUS_CHECK CHECK (status_atual IN ('planejada', 'em execução', 'concluída', 'cancelada')),
    CONSTRAINT DATAS_CHECK CHECK (data_conclusao_prevista >= data_inicio)
);

-- tabela pra contratos
CREATE TABLE TB_CONTRATAS OF TP_CONTRATA (
    ref_cliente WITH ROWID REFERENCES TB_CLIENTES,
    ref_projeto WITH ROWID REFERENCES TB_PROJETOS,
    data_assinatura CONSTRAINT CONTRATA_DATA_ASS_NN NOT NULL,
    valor_total CONSTRAINT CONTRATA_VALOR_TOTAL_NN NOT NULL,
    condicoes_pagamento CONSTRAINT CONTRATA_COND_PAG_NN NOT NULL,
    CONSTRAINT PK_CONTRATA PRIMARY KEY (ref_cliente, ref_projeto),
    CONSTRAINT VALOR_TOTAL_CHECK CHECK (valor_total > 0)
);

-- tabela pra trabalha_em
CREATE TABLE TB_TRABALHA_EM OF TP_TRABALHA_EM (
    ref_operario WITH ROWID REFERENCES TB_OPERARIOS,
    ref_projeto WITH ROWID REFERENCES TB_PROJETOS,
    CONSTRAINT PK_TRABALHA_EM PRIMARY KEY (ref_operario, ref_projeto)
);

-- tabela pra planeja
CREATE TABLE TB_PLANEJA OF TP_PLANEJA (
    ref_engenheiro WITH ROWID REFERENCES TB_ENGENHEIROS,
    ref_projeto WITH ROWID REFERENCES TB_PROJETOS,
    status_calculo_estrutural CONSTRAINT PLANEJA_STATUS_CALC_NN NOT NULL,
    status_fundacao CONSTRAINT PLANEJA_STATUS_FUND_NN NOT NULL,
    CONSTRAINT PK_PLANEJA PRIMARY KEY (ref_engenheiro, ref_projeto),
    CONSTRAINT STATUS_CALC_CHECK CHECK (status_calculo_estrutural IN ('pendente', 'em andamento', 'concluído')),
    CONSTRAINT STATUS_FUND_CHECK CHECK (status_fundacao IN ('pendente', 'em andamento', 'concluído'))
);

-- tabela pra projeta
CREATE TABLE TB_PROJETA OF TP_PROJETA (
    ref_arquiteto WITH ROWID REFERENCES TB_ARQUITETOS,
    ref_projeto WITH ROWID REFERENCES TB_PROJETOS,
    CONSTRAINT PK_PROJETA PRIMARY KEY (ref_arquiteto, ref_projeto)
);

-- tabela pra aloca_para
CREATE TABLE TB_ALOCA_PARA OF TP_ALOCA_PARA (
    ref_fornecedor WITH ROWID REFERENCES TB_FORNECEDORES,
    ref_material WITH ROWID REFERENCES TB_MATERIAIS,
    ref_projeto WITH ROWID REFERENCES TB_PROJETOS,
    previsao_entrega CONSTRAINT ALOCA_PREVISAO_ENTREGA_NN NOT NULL,
    CONSTRAINT PK_ALOCA_PARA PRIMARY KEY (ref_fornecedor, ref_material, ref_projeto)
);

-- sequência pra id do projeto
CREATE SEQUENCE SEQ_PROJETO_ID
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- trigger pra gerar automaticamente o id_projeto
CREATE OR REPLACE TRIGGER TRG_PROJETO_ID
BEFORE INSERT ON TB_PROJETOS
FOR EACH ROW
BEGIN
    :NEW.id_projeto := 'PRJ' || SEQ_PROJETO_ID.NEXTVAL;
END;
/
