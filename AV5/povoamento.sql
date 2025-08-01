-- Inserindo Endereços
INSERT INTO TB_ENDERECOS VALUES ('50000000', '100', 'Ap. 101', 'Rua Boa Vista', 'Centro', 'Recife', 'PE');
INSERT INTO TB_ENDERECOS VALUES ('50000000', '200', 'Casa', 'Rua Boa Vista', 'Centro', 'Recife', 'PE');
INSERT INTO TB_ENDERECOS VALUES ('01000000', '50', 'Sala 5', 'Av. Paulista', 'Bela Vista', 'São Paulo', 'SP');
INSERT INTO TB_ENDERECOS VALUES ('20000000', '10', 'Bloco A', 'Rua Sete de Setembro', 'Centro', 'Rio de Janeiro', 'RJ');
INSERT INTO TB_ENDERECOS VALUES ('30000000', '150', 'Loja 1', 'Av. Afonso Pena', 'Centro', 'Belo Horizonte', 'MG');
INSERT INTO TB_ENDERECOS VALUES ('90000000', '300', 'Fundos', 'Rua da Praia', 'Centro Histórico', 'Porto Alegre', 'RS');
INSERT INTO TB_ENDERECOS VALUES ('60000000', '80', 'Andar 2', 'Av. Beira Mar', 'Meireles', 'Fortaleza', 'CE');
INSERT INTO TB_ENDERECOS VALUES ('70000000', '123', 'Lote 5', 'Rua das Palmeiras', 'Asa Sul', 'Brasília', 'DF');

-- Inserir Cliente
INSERT INTO TB_CLIENTES VALUES (
    TP_CLIENTE('12345678901', 'Ana Silva')
);
UPDATE TB_CLIENTES SET email = 'ana.silva@email.com', telefones = TP_TELEFONES_ARRAY(TP_FONE('81912345678')) WHERE cpf = '12345678901';

-- Inserir Engenheiro Supervisor
INSERT INTO TB_ENGENHEIROS VALUES (
    TP_ENGENHEIRO(
        '89012345678',
        'Mariana Gomes',
        TP_TELEFONES_ARRAY(TP_FONE('81999998888')),
        9000.00,
        'CREA-PE10000',
        'Engenheiro Civil',
        NULL
    )
);

-- Engenheiro supervisionado
INSERT INTO TB_ENGENHEIROS VALUES (
    TP_ENGENHEIRO(
        '90123456789',
        'Roberto Lima',
        TP_TELEFONES_ARRAY(TP_FONE('81988776655')),
        10500.00,
        'CREA-PE10001',
        'Engenheiro Mestre',
        (SELECT REF(e) FROM TB_ENGENHEIROS e WHERE e.cpf = '89012345678')
    )
);

-- Inserir Operário
INSERT INTO TB_OPERARIOS VALUES (
    TP_OPERARIO(
        '23456789012',
        'Carlos Souza',
        TP_TELEFONES_ARRAY(TP_FONE('81987654321')),
        2500.00,
        'Pedreiro'
    )
);

-- Inserir Arquiteto
INSERT INTO TB_ARQUITETOS VALUES (
    TP_ARQUITETO(
        '34567890123',
        'Fernanda Lima',
        TP_TELEFONES_ARRAY(TP_FONE('81911223344')),
        7500.00,
        'CAU-PE12345'
    )
);

-- Inserir Fornecedor
INSERT INTO TB_FORNECEDORES VALUES (
    TP_FORNECEDOR(
        '12345678000199',
        'Construtora XYZ',
        TP_TELEFONES_ARRAY(TP_FONE('8133334444'))
    )
);

-- Inserir Material
INSERT INTO TB_MATERIAIS VALUES (
    TP_MATERIAL(
        'CIM-001',
        'Cimento CPII-32',
        1000,
        25.50
    )
);

-- Inserir Projeto
INSERT INTO TB_PROJETOS VALUES (
    TP_PROJETO(
        'PROJ001',
        (SELECT REF(e) FROM TB_ENDERECOS e WHERE e.cep = '50000000' AND e.numero = '100' AND e.complemento = 'Ap. 101'),
        500000.00,
        TP_ETAPA_LIST(
            TP_ETAPA('planejada', DATE '2024-06-01', DATE '2024-07-30'),
            TP_ETAPA('em execução', DATE '2024-08-01', DATE '2024-12-31')
        )
    )
);

-- Inserir Contrata
INSERT INTO TB_CONTRATAS VALUES (
    TP_CONTRATA(
        (SELECT REF(c) FROM TB_CLIENTES c WHERE c.cpf = '12345678901'),
        (SELECT REF(p) FROM TB_PROJETOS p WHERE p.id_projeto = 'PROJ001'),
        DATE '2024-05-20',
        500000.00,
        'Parcelado em 10x'
    )
);

-- Inserir Trabalha_em
INSERT INTO TB_TRABALHA_EM VALUES (
    TP_TRABALHA_EM(
        (SELECT REF(o) FROM TB_OPERARIOS o WHERE o.cpf = '23456789012'),
        (SELECT REF(p) FROM TB_PROJETOS p WHERE p.id_projeto = 'PROJ001')
    )
);

-- Inserir Planeja
INSERT INTO TB_PLANEJA VALUES (
    TP_PLANEJA(
        (SELECT REF(e) FROM TB_ENGENHEIROS e WHERE e.cpf = '89012345678'),
        (SELECT REF(p) FROM TB_PROJETOS p WHERE p.id_projeto = 'PROJ001'),
        'Concluído',
        'Concluído'
    )
);

-- Inserir Projeta
INSERT INTO TB_PROJETA VALUES (
    TP_PROJETA(
        (SELECT REF(a) FROM TB_ARQUITETOS a WHERE a.cpf = '34567890123'),
        (SELECT REF(p) FROM TB_PROJETOS p WHERE p.id_projeto = 'PROJ001')
    )
);

-- Inserir Aloca_para
INSERT INTO TB_ALOCA_PARA VALUES (
    TP_ALOCA_PARA(
        (SELECT REF(f) FROM TB_FORNECEDORES f WHERE f.cnpj = '12345678000199'),
        (SELECT REF(m) FROM TB_MATERIAIS m WHERE m.codigo = 'CIM-001'),
        (SELECT REF(p) FROM TB_PROJETOS p WHERE p.id_projeto = 'PROJ001'),
        DATE '2024-07-10'
    )
);

-- Testando o MEMBER PROCEDURE
SET SERVEROUTPUT ON;
DECLARE
    v_engenheiro TP_ENGENHEIRO;
BEGIN
    SELECT VALUE(e) INTO v_engenheiro FROM TB_ENGENHEIROS e WHERE e.cpf = '90123456789';
    v_engenheiro.exibir_detalhes();
END;

-- Testando o operador VALUE
SELECT VALUE(p) FROM TB_PROJETOS p WHERE p.id_projeto = 'PROJ001';

-- Testando ALTER TYPE
ALTER TYPE TP_OPERARIO ADD ATTRIBUTE data_admissao DATE CASCADE;