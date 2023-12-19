--checklist da AV3

-- CREATE TABLE
-- cláusula CONSTRAINT em CREATE TABLE
-- cláusula CHECK em CREATE TABLE
-- INSERT INTO
-- CREATE SEQUENCE

-- criação de tabelas

-- endereco

CREATE TABLE endereco(
    cep VARCHAR2(8) NOT NULL,
    rua VARCHAR2(50) NOT NULL,
    numero NUMBER NOT NULL,
    bairro VARCHAR2(50) NOT NULL,
    cidade VARCHAR2(50) NOT NULL,

    CONSTRAINT endereco_pk PRIMARY KEY (cep)
);

-- pessoa

CREATE TABLE pessoa(
    cpf VARCHAR2(11) NOT NULL,
    nome VARCHAR2(50) NOT NULL,
    cep VARCHAR2(8) NOT NULL,
    data_nascimento DATE NOT NULL,
    -- idade: nao precisa estar no banco de dados

    CONSTRAINT pessoa_pk PRIMARY KEY (cpf),
    CONSTRAINT pessoa_fk FOREIGN KEY (cep) REFERENCES endereco (cep)
);

-- telefone

CREATE TABLE telefone(
    numero NUMBER,
    cpf_fk VARCHAR2(11),

    CONSTRAINT telefone_pk PRIMARY KEY (numero, cpf_fk),
    CONSTRAINT telefone_fk FOREIGN KEY (cpf_fk) REFERENCES pessoa(cpf)
);


--historico_medico

CREATE TABLE historico_medico (
    id_historico NUMBER PRIMARY KEY
);

-- cirurgias

CREATE TABLE cirurgias (
    id_historico_medico NUMBER NOT NULL,
    descricao VARCHAR2(255) NOT NULL,
    CONSTRAINT fk_historico0 FOREIGN KEY (id_historico_medico) REFERENCES historico_medico(id_historico),
    PRIMARY KEY (id_historico_medico, descricao)
);

-- alergias

CREATE TABLE alergias (
    id_historico_medico NUMBER NOT NULL,
    descricao VARCHAR2(255) NOT NULL,
    CONSTRAINT fk_historico1 FOREIGN KEY (id_historico_medico) REFERENCES historico_medico(id_historico),
    PRIMARY KEY (id_historico_medico, descricao)
);

-- doencas_cronicas

CREATE TABLE doencas_cronicas (
    id_historico_medico NUMBER NOT NULL,
    descricao VARCHAR2(255) NOT NULL,
    CONSTRAINT fk_historico2 FOREIGN KEY (id_historico_medico) REFERENCES historico_medico(id_historico),
    PRIMARY KEY (id_historico_medico, descricao)
);

-- paciente

CREATE TABLE paciente (
    cpf_paciente VARCHAR2(11) PRIMARY KEY,
    pressao_arterial VARCHAR2(20),
    peso NUMBER,
    altura NUMBER,
    tipo_sanguineo VARCHAR2(10),
    id_historico_medico NUMBER NOT NULL,

    CONSTRAINT fk_historico_medico FOREIGN KEY (id_historico_medico) REFERENCES historico_medico(id_historico)
);

-- funcionario

CREATE TABLE funcionario (
    cpf_funcionario VARCHAR2(11) PRIMARY KEY,
    salario NUMBER,
    num_clt VARCHAR2(20),
    data_admissao DATE,
    
    CONSTRAINT fk_pessoa_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES pessoa(cpf)
);


--acompanhante

CREATE TABLE acompanhante (
    cpf_acompanhante VARCHAR2(11) NOT NULL,
    nome VARCHAR2(50) NOT NULL,
    grau_de_parentesco NUMBER,
    cpf_paciente VARCHAR2(11),

    PRIMARY KEY (cpf_acompanhante, cpf_paciente),
    CONSTRAINT fk_pessoa_acompanhada FOREIGN KEY (cpf_paciente) REFERENCES paciente(cpf_paciente)
);
