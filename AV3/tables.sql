/* criação de tabelas */
-- Tabela PESSOA  --ok
CREATE TABLE pessoa (
    cpf VARCHAR2(11) PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    CONSTRAINT cpf_check CHECK (REGEXP_LIKE(cpf, '^[0-9]{11}$'))
);

-- Tabela TELEFONE_PESSOA -- ok
CREATE TABLE telefone_pessoa (
    cpf VARCHAR2(11) NOT NULL,
    numero_fone VARCHAR2(15) NOT NULL,
    PRIMARY KEY (cpf, numero_fone),
    CONSTRAINT fk_telefone_pessoa FOREIGN KEY (cpf) REFERENCES pessoa(cpf) ON DELETE CASCADE,
    CONSTRAINT telefone_check CHECK (REGEXP_LIKE(numero_fone, '^\+?[0-9\s-]+$'))
);

-- Tabela ENDERECO  --ok
CREATE TABLE endereco (
    cep VARCHAR2(8) NOT NULL,
    numero VARCHAR2(10) NOT NULL,
    complemento VARCHAR2(50) NOT NULL,
    rua VARCHAR2(100) NOT NULL,
    bairro VARCHAR2(50) NOT NULL,
    cidade VARCHAR2(50) NOT NULL,
    estado VARCHAR2(2) NOT NULL,
    PRIMARY KEY (cep, numero, complemento),
    CONSTRAINT cep_check CHECK (REGEXP_LIKE(cep, '^[0-9]{8}$')),
    CONSTRAINT estado_check CHECK (estado IN (
        'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA',
        'PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'))
);

-- Tabela CLIENTE --ok
CREATE TABLE cliente (
    cpf VARCHAR2(11) PRIMARY KEY,
    email VARCHAR2(100),
    CONSTRAINT fk_cliente_pessoa FOREIGN KEY (cpf) REFERENCES pessoa(cpf) ON DELETE CASCADE,
    CONSTRAINT email_check CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]+$'))
);

-- Tabela ENDERECO_CLIENTE --ok
CREATE TABLE endereco_cliente (
    cpf_cliente VARCHAR2(11) NOT NULL,
    cep VARCHAR2(8) NOT NULL,
    numero VARCHAR2(10) NOT NULL,
    complemento VARCHAR2(50) NOT NULL,
    PRIMARY KEY (cpf_cliente, cep, numero, complemento),
    CONSTRAINT fk_end_cliente FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf) ON DELETE CASCADE,
    CONSTRAINT fk_endereco_cli FOREIGN KEY (cep, numero, complemento) REFERENCES endereco(cep, numero, complemento)
);

-- Tabela FORNECEDOR -ok
CREATE TABLE fornecedor (
    cnpj VARCHAR2(14) PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    CONSTRAINT cnpj_check CHECK (REGEXP_LIKE(cnpj, '^[0-9]{14}$'))
);

-- Tabela ENDERECO_FORNECEDOR --ok
CREATE TABLE endereco_fornecedor (
    cnpj_fornecedor VARCHAR2(14) NOT NULL,
    cep VARCHAR2(8) NOT NULL,
    numero VARCHAR2(10) NOT NULL,
    complemento VARCHAR2(50),
    PRIMARY KEY (cnpj_fornecedor, cep, numero, complemento),
    CONSTRAINT fk_end_fornecedor FOREIGN KEY (cnpj_fornecedor) REFERENCES fornecedor(cnpj) ON DELETE CASCADE,
    CONSTRAINT fk_endereco_forn FOREIGN KEY (cep, numero, complemento) REFERENCES endereco(cep, numero, complemento)
);

-- Tabela TELEFONE_FORNECEDOR --ok
CREATE TABLE telefone_fornecedor (
    cnpj VARCHAR2(14) NOT NULL,
    numero_fone_empresa VARCHAR2(15) NOT NULL,
    PRIMARY KEY (cnpj, numero_fone_empresa),
    CONSTRAINT fk_telefone_fornecedor FOREIGN KEY (cnpj) REFERENCES fornecedor(cnpj) ON DELETE CASCADE,
    CONSTRAINT telefone_forn_check CHECK (REGEXP_LIKE(numero_fone_empresa, '^\+?[0-9\s-]+$'))
);

-- Tabela OPERARIO --ok
CREATE TABLE operario (
    cpf VARCHAR2(11) PRIMARY KEY,
    cargo VARCHAR2(50) NOT NULL,
    salario NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_operario_pessoa FOREIGN KEY (cpf) REFERENCES pessoa(cpf) ON DELETE CASCADE,
    CONSTRAINT salario_operario_check CHECK (salario >= 1212.00)
);

-- Tabela ARQUITETO --ok
CREATE TABLE arquiteto (
    cau VARCHAR2(20) PRIMARY KEY,
    cpf VARCHAR2(11) NOT NULL UNIQUE,
    salario NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_arquiteto_pessoa FOREIGN KEY (cpf) REFERENCES pessoa(cpf) ON DELETE CASCADE,
    CONSTRAINT salario_arquiteto_check CHECK (salario >= 3000.00)
);

-- Tabela ENGENHEIRO --ok
CREATE TABLE engenheiro (
    crea VARCHAR2(20) PRIMARY KEY,
    cpf VARCHAR2(11) NOT NULL UNIQUE,
    cargo VARCHAR2(50) NOT NULL,
    crea_supervisor VARCHAR2(20),
    salario NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_engenheiro_pessoa FOREIGN KEY (cpf) REFERENCES pessoa(cpf) ON DELETE CASCADE,
    CONSTRAINT fk_engenheiro_supervisor FOREIGN KEY (crea_supervisor) REFERENCES engenheiro(crea),
    CONSTRAINT salario_engenheiro_check CHECK (salario >= 5000.00)
);

-- Tabela PROJETO --ok
CREATE TABLE projeto (
    id_projeto VARCHAR2(10) PRIMARY KEY,
    cep VARCHAR2(8) NOT NULL,
    numero VARCHAR2(10) NOT NULL,
    complemento VARCHAR2(50),
    orcamento NUMBER(15,2) NOT NULL,
    CONSTRAINT fk_projeto_endereco FOREIGN KEY (cep, numero, complemento) REFERENCES endereco(cep, numero, complemento),
    CONSTRAINT orcamento_check CHECK (orcamento > 0)
);

-- Tabela ETAPA --ok
CREATE TABLE etapa (
    id_projeto VARCHAR2(10) NOT NULL,
    status_atual VARCHAR2(20) NOT NULL,
    data_inicio DATE NOT NULL,
    data_conclusao_prevista DATE NOT NULL,
    PRIMARY KEY (id_projeto, status_atual),
    CONSTRAINT fk_etapa_projeto FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto) ON DELETE CASCADE,
    CONSTRAINT status_check CHECK (status_atual IN ('Planejada', 'Em execução', 'Concluída', 'Cancelada')),
    CONSTRAINT datas_check CHECK (data_conclusao_prevista >= data_inicio)
);

-- Tabela MATERIAL --ok
CREATE TABLE material (
    codigo VARCHAR2(10) PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    quantidade INTEGER NOT NULL,
    custo_unitario NUMBER(10,2) NOT NULL,
    CONSTRAINT quantidade_check CHECK (quantidade >= 0),
    CONSTRAINT custo_check CHECK (custo_unitario > 0)
);

-- Tabela CONTRATA --ok
CREATE TABLE contrata (
    cpf_cliente VARCHAR2(11) NOT NULL,
    id_projeto VARCHAR2(10) NOT NULL,
    data_assinatura DATE NOT NULL,
    valor_total NUMBER(15,2) NOT NULL,
    condicoes_pagamento VARCHAR2(50) NOT NULL,
    PRIMARY KEY (cpf_cliente, id_projeto),
    CONSTRAINT fk_contrata_cliente FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf) ON DELETE CASCADE,
    CONSTRAINT fk_contrata_projeto FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto) ON DELETE CASCADE,
    CONSTRAINT valor_total_check CHECK (valor_total > 0)
);

-- Tabela TRABALHA_EM --ok
CREATE TABLE trabalha_em (
    cpf_operario VARCHAR2(11) NOT NULL,
    id_projeto VARCHAR2(10) NOT NULL,
    PRIMARY KEY (cpf_operario, id_projeto),
    CONSTRAINT fk_trabalha_operario FOREIGN KEY (cpf_operario) REFERENCES operario(cpf) ON DELETE CASCADE,
    CONSTRAINT fk_trabalha_projeto FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto) ON DELETE CASCADE
);

-- Tabela PLANEJA --ok
CREATE TABLE planeja (
    crea_engenheiro VARCHAR2(20) NOT NULL,
    id_projeto VARCHAR2(10) NOT NULL,
    status_calculo_estrutural VARCHAR2(20) NOT NULL,
    status_fundacao VARCHAR2(20) NOT NULL,
    PRIMARY KEY (crea_engenheiro, id_projeto),
    CONSTRAINT fk_planeja_engenheiro FOREIGN KEY (crea_engenheiro) REFERENCES engenheiro(crea) ON DELETE CASCADE,
    CONSTRAINT fk_planeja_projeto FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto) ON DELETE CASCADE,
    CONSTRAINT status_calc_check CHECK (status_calculo_estrutural IN ('Pendente', 'Em andamento', 'Concluído')),
    CONSTRAINT status_fund_check CHECK (status_fundacao IN ('Pendente', 'Em andamento', 'Concluído'))
);

-- Tabela PROJETA --ok
CREATE TABLE projeta (
    cau_arquiteto VARCHAR2(20) NOT NULL,
    id_projeto VARCHAR2(10) NOT NULL,
    PRIMARY KEY (cau_arquiteto, id_projeto),
    CONSTRAINT fk_projeta_arquiteto FOREIGN KEY (cau_arquiteto) REFERENCES arquiteto(cau) ON DELETE CASCADE,
    CONSTRAINT fk_projeta_projeto FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto) ON DELETE CASCADE
);

-- Tabela ALOCA_PARA    --ok
CREATE TABLE aloca_para (
    cnpj_fornecedor VARCHAR2(14) NOT NULL,
    codigo_material VARCHAR2(10) NOT NULL,
    id_projeto VARCHAR2(10) NOT NULL,
    previsao_entrega DATE NOT NULL,
    PRIMARY KEY (cnpj_fornecedor, codigo_material, id_projeto),
    CONSTRAINT fk_aloca_fornecedor FOREIGN KEY (cnpj_fornecedor) REFERENCES fornecedor(cnpj) ON DELETE CASCADE,
    CONSTRAINT fk_aloca_material FOREIGN KEY (codigo_material) REFERENCES material(codigo) ON DELETE CASCADE,
    CONSTRAINT fk_aloca_projeto FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto) ON DELETE CASCADE
);

-- Sequência para ID do projeto
CREATE SEQUENCE seq_projeto_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
