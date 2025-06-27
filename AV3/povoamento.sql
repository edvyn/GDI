/* inserção de dados nas tabelas */
-- 1. Tabela PESSOA --ok
INSERT INTO pessoa (cpf, nome) VALUES ('12345678901', 'João Silva');
INSERT INTO pessoa (cpf, nome) VALUES ('23456789012', 'Maria Oliveira');
INSERT INTO pessoa (cpf, nome) VALUES ('34567890123', 'Pedro Souza');
INSERT INTO pessoa (cpf, nome) VALUES ('45678901234', 'Ana Costa');
INSERT INTO pessoa (cpf, nome) VALUES ('56789012345', 'Carlos Pereira');
INSERT INTO pessoa (cpf, nome) VALUES ('67890123456', 'Beatriz Almeida');
INSERT INTO pessoa (cpf, nome) VALUES ('78901234567', 'Fernando Santos');
INSERT INTO pessoa (cpf, nome) VALUES ('89012345678', 'Mariana Gomes');
INSERT INTO pessoa (cpf, nome) VALUES ('90123456789', 'Roberto Lima');
INSERT INTO pessoa (cpf, nome) VALUES ('01234567890', 'Isabel Fernandes');
INSERT INTO pessoa (cpf, nome) VALUES ('11223344556', 'Lucas Martins');
INSERT INTO pessoa (cpf, nome) VALUES ('22334455667', 'Gabriela Rocha');
INSERT INTO pessoa (cpf, nome) VALUES ('33445566778', 'Daniel Alves');
INSERT INTO pessoa (cpf, nome) VALUES ('44556677889', 'Paula Ribeiro');

-- 2. Tabela ENDERECO --ok
INSERT INTO endereco (cep, numero, complemento, rua, bairro, cidade, estado) VALUES ('50000000', '100', 'Ap. 101', 'Rua Boa Vista', 'Centro', 'Recife', 'PE');
INSERT INTO endereco (cep, numero, complemento, rua, bairro, cidade, estado) VALUES ('50000000', '200', 'Casa', 'Rua Boa Vista', 'Centro', 'Recife', 'PE');
INSERT INTO endereco (cep, numero, complemento, rua, bairro, cidade, estado) VALUES ('01000000', '50', 'Sala 5', 'Av. Paulista', 'Bela Vista', 'São Paulo', 'SP');
INSERT INTO endereco (cep, numero, complemento, rua, bairro, cidade, estado) VALUES ('20000000', '10', 'Bloco A', 'Rua Sete de Setembro', 'Centro', 'Rio de Janeiro', 'RJ');
INSERT INTO endereco (cep, numero, complemento, rua, bairro, cidade, estado) VALUES ('30000000', '150', 'Loja 1', 'Av. Afonso Pena', 'Centro', 'Belo Horizonte', 'MG');
INSERT INTO endereco (cep, numero, complemento, rua, bairro, cidade, estado) VALUES ('90000000', '300', 'Fundos', 'Rua da Praia', 'Centro Histórico', 'Porto Alegre', 'RS');
INSERT INTO endereco (cep, numero, complemento, rua, bairro, cidade, estado) VALUES ('60000000', '80', 'Andar 2', 'Av. Beira Mar', 'Meireles', 'Fortaleza', 'CE');
INSERT INTO endereco (cep, numero, complemento, rua, bairro, cidade, estado) VALUES ('70000000', '123', 'Lote 5', 'Rua das Palmeiras', 'Asa Sul', 'Brasília', 'DF');

-- 3. Tabela TELEFONE_PESSOA --ok
INSERT INTO telefone_pessoa (cpf, numero_fone) VALUES ('12345678901', '81999991111');
INSERT INTO telefone_pessoa (cpf, numero_fone) VALUES ('12345678901', '8133331111');
INSERT INTO telefone_pessoa (cpf, numero_fone) VALUES ('23456789012', '11988882222');
INSERT INTO telefone_pessoa (cpf, numero_fone) VALUES ('34567890123', '21977773333');
INSERT INTO telefone_pessoa (cpf, numero_fone) VALUES ('45678901234', '31966664444');
INSERT INTO telefone_pessoa (cpf, numero_fone) VALUES ('11223344556', '85987654321');
INSERT INTO telefone_pessoa (cpf, numero_fone) VALUES ('22334455667', '61998765432');

-- 4. Tabela CLIENTE    --ok
INSERT INTO cliente (cpf, email) VALUES ('12345678901', 'joao.silva@example.com');
INSERT INTO cliente (cpf, email) VALUES ('23456789012', 'maria.oliveira@example.com');
INSERT INTO cliente (cpf, email) VALUES ('11223344556', 'lucas.martins@email.com');

-- 5. Tabela FORNECEDOR  ok
INSERT INTO fornecedor (cnpj, nome) VALUES ('00000000000001', 'Materiais de Construção LTDA');
INSERT INTO fornecedor (cnpj, nome) VALUES ('00000000000002', 'Ferramentas Essenciais S.A.');
INSERT INTO fornecedor (cnpj, nome) VALUES ('00000000000003', 'Cimento Forte Comércio');
INSERT INTO fornecedor (cnpj, nome) VALUES ('00000000000004', 'Tintas e Revestimentos EIRELI');

-- 6. Tabela TELEFONE_FORNECEDOR -ok
INSERT INTO telefone_fornecedor (cnpj, numero_fone_empresa) VALUES ('00000000000001', '8130305050');
INSERT INTO telefone_fornecedor (cnpj, numero_fone_empresa) VALUES ('00000000000001', '81991234567');
INSERT INTO telefone_fornecedor (cnpj, numero_fone_empresa) VALUES ('00000000000002', '1140406060');
INSERT INTO telefone_fornecedor (cnpj, numero_fone_empresa) VALUES ('00000000000004', '2132327070');

-- 7. Tabela OPERARIO --ok
INSERT INTO operario (cpf, cargo, salario) VALUES ('34567890123', 'Pedreiro', 2500.00);
INSERT INTO operario (cpf, cargo, salario) VALUES ('45678901234', 'Eletricista', 2800.00);
INSERT INTO operario (cpf, cargo, salario) VALUES ('56789012345', 'Encanador', 2600.00);
INSERT INTO operario (cpf, cargo, salario) VALUES ('33445566778', 'Carpinteiro', 2700.00);

-- 8. Tabela ARQUITETO  --ok
INSERT INTO arquiteto (cau, cpf, salario) VALUES ('CAU-BR123456', '67890123456', 7500.00);
INSERT INTO arquiteto (cau, cpf, salario) VALUES ('CAU-BR654321', '78901234567', 8000.00);
INSERT INTO arquiteto (cau, cpf, salario) VALUES ('CAU-MG789012', '44556677889', 7800.00);

-- 9. Tabela ENGENHEIRO ok
INSERT INTO engenheiro (crea, cpf, cargo, crea_supervisor, salario) VALUES ('CREA-PE10000', '89012345678', 'Engenheiro Civil', NULL, 9000.00);
INSERT INTO engenheiro (crea, cpf, cargo, crea_supervisor, salario) VALUES ('CREA-PE10001', '90123456789', 'Engenheiro Mestre', 'CREA-PE10000', 10500.00);
INSERT INTO engenheiro (crea, cpf, cargo, crea_supervisor, salario) VALUES ('CREA-SP20000', '01234567890', 'Engenheiro Ambiental', NULL, 8500.00);
INSERT INTO engenheiro (crea, cpf, cargo, crea_supervisor, salario) VALUES ('CREA-CE30000', '22334455667', 'Engenheiro Eletricista', 'CREA-PE10000', 9500.00);

-- 10. Tabela PROJETO
-- Usando a sequência para id_projeto  ok
INSERT INTO projeto (id_projeto, cep, numero, complemento, orcamento) VALUES ('PROJ' || LPAD(seq_projeto_id.NEXTVAL, 6, '0'), '50000000', '100', 'Ap. 101', 500000.00);
INSERT INTO projeto (id_projeto, cep, numero, complemento, orcamento) VALUES ('PROJ' || LPAD(seq_projeto_id.NEXTVAL, 6, '0'), '01000000', '50', 'Sala 5', 1200000.00);
INSERT INTO projeto (id_projeto, cep, numero, complemento, orcamento) VALUES ('PROJ' || LPAD(seq_projeto_id.NEXTVAL, 6, '0'), '20000000', '10', 'Bloco A', 800000.00);
INSERT INTO projeto (id_projeto, cep, numero, complemento, orcamento) VALUES ('PROJ' || LPAD(seq_projeto_id.NEXTVAL, 6, '0'), '60000000', '80', 'Andar 2', 750000.00);
INSERT INTO projeto (id_projeto, cep, numero, complemento, orcamento) VALUES ('PROJ' || LPAD(seq_projeto_id.NEXTVAL, 6, '0'), '70000000', '123', 'Lote 5', 900000.00);


-- 11. Tabela ENDERECO_CLIENTE ok
INSERT INTO endereco_cliente (cpf_cliente, cep, numero, complemento) VALUES ('12345678901', '50000000', '100', 'Ap. 101');
INSERT INTO endereco_cliente (cpf_cliente, cep, numero, complemento) VALUES ('23456789012', '50000000', '200', 'Casa');
INSERT INTO endereco_cliente (cpf_cliente, cep, numero, complemento) VALUES ('11223344556', '60000000', '80', 'Andar 2');

-- 12. Tabela ENDERECO_FORNECEDOR -ok
INSERT INTO endereco_fornecedor (cnpj_fornecedor, cep, numero, complemento) VALUES ('00000000000001', '30000000', '150', 'Loja 1');
INSERT INTO endereco_fornecedor (cnpj_fornecedor, cep, numero, complemento) VALUES ('00000000000002', '90000000', '300', 'Fundos');
INSERT INTO endereco_fornecedor (cnpj_fornecedor, cep, numero, complemento) VALUES ('00000000000004', '70000000', '123', 'Lote 5');

-- 13. Tabela MATERIAL --ok
INSERT INTO material (codigo, nome, quantidade, custo_unitario) VALUES ('CIM-001', 'Cimento CPII-32', 1000, 25.50);
INSERT INTO material (codigo, nome, quantidade, custo_unitario) VALUES ('AÇO-002', 'Vergalhão 3/8"', 500, 15.00);
INSERT INTO material (codigo, nome, quantidade, custo_unitario) VALUES ('TEL-003', 'Telha Cerâmica', 2000, 2.80);
INSERT INTO material (codigo, nome, quantidade, custo_unitario) VALUES ('HID-004', 'Tubos PVC 100mm', 100, 35.00);
INSERT INTO material (codigo, nome, quantidade, custo_unitario) VALUES ('TINTA-005', 'Tinta Acrílica Branca', 50, 80.00);
INSERT INTO material (codigo, nome, quantidade, custo_unitario) VALUES ('PISO-006', 'Piso Porcelanato 60x60', 300, 45.00);

-- 14. Tabela ETAPA --ok
INSERT INTO etapa (id_projeto, status_atual, data_inicio, data_conclusao_prevista) VALUES ('PROJ000001', 'Planejada', TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-07-30', 'YYYY-MM-DD'));
INSERT INTO etapa (id_projeto, status_atual, data_inicio, data_conclusao_prevista) VALUES ('PROJ000001', 'Em execução', TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));
INSERT INTO etapa (id_projeto, status_atual, data_inicio, data_conclusao_prevista) VALUES ('PROJ000002', 'Planejada', TO_DATE('2024-07-15', 'YYYY-MM-DD'), TO_DATE('2024-09-15', 'YYYY-MM-DD'));
INSERT INTO etapa (id_projeto, status_atual, data_inicio, data_conclusao_prevista) VALUES ('PROJ000003', 'Em execução', TO_DATE('2024-06-20', 'YYYY-MM-DD'), TO_DATE('2024-11-20', 'YYYY-MM-DD'));
INSERT INTO etapa (id_projeto, status_atual, data_inicio, data_conclusao_prevista) VALUES ('PROJ000004', 'Planejada', TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-09-30', 'YYYY-MM-DD'));

-- 15. Tabela CONTRATA -ok
INSERT INTO contrata (cpf_cliente, id_projeto, data_assinatura, valor_total, condicoes_pagamento) VALUES ('12345678901', 'PROJ000001', TO_DATE('2024-05-20', 'YYYY-MM-DD'), 500000.00, 'Parcelado em 10x');
INSERT INTO contrata (cpf_cliente, id_projeto, data_assinatura, valor_total, condicoes_pagamento) VALUES ('23456789012', 'PROJ000002', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 1200000.00, 'Financiamento Bancário');
INSERT INTO contrata (cpf_cliente, id_projeto, data_assinatura, valor_total, condicoes_pagamento) VALUES ('11223344556', 'PROJ000004', TO_DATE('2024-07-25', 'YYYY-MM-DD'), 750000.00, 'À vista com 5% de desconto');

-- 16. Tabela TRABALHA_EM -ok
INSERT INTO trabalha_em (cpf_operario, id_projeto) VALUES ('34567890123', 'PROJ000001');
INSERT INTO trabalha_em (cpf_operario, id_projeto) VALUES ('45678901234', 'PROJ000001');
INSERT INTO trabalha_em (cpf_operario, id_projeto) VALUES ('34567890123', 'PROJ000002');
INSERT INTO trabalha_em (cpf_operario, id_projeto) VALUES ('56789012345', 'PROJ000003');
INSERT INTO trabalha_em (cpf_operario, id_projeto) VALUES ('33445566778', 'PROJ000004');


-- 17. Tabela PLANEJA  --ok
INSERT INTO planeja (crea_engenheiro, id_projeto, status_calculo_estrutural, status_fundacao) VALUES ('CREA-PE10000', 'PROJ000001', 'Concluído', 'Concluído');
INSERT INTO planeja (crea_engenheiro, id_projeto, status_calculo_estrutural, status_fundacao) VALUES ('CREA-PE10001', 'PROJ000001', 'Concluído', 'Concluído');
INSERT INTO planeja (crea_engenheiro, id_projeto, status_calculo_estrutural, status_fundacao) VALUES ('CREA-SP20000', 'PROJ000002', 'Em andamento', 'Pendente');
INSERT INTO planeja (crea_engenheiro, id_projeto, status_calculo_estrutural, status_fundacao) VALUES ('CREA-CE30000', 'PROJ000003', 'Pendente', 'Em andamento');

-- 18. Tabela PROJETA ok
INSERT INTO projeta (cau_arquiteto, id_projeto) VALUES ('CAU-BR123456', 'PROJ000001');
INSERT INTO projeta (cau_arquiteto, id_projeto) VALUES ('CAU-BR654321', 'PROJ000002');
INSERT INTO projeta (cau_arquiteto, id_projeto) VALUES ('CAU-MG789012', 'PROJ000004');

-- 19. Tabela ALOCA_PARA --ok
INSERT INTO aloca_para (cnpj_fornecedor, codigo_material, id_projeto, previsao_entrega) VALUES ('00000000000001', 'CIM-001', 'PROJ000001', TO_DATE('2024-07-10', 'YYYY-MM-DD'));
INSERT INTO aloca_para (cnpj_fornecedor, codigo_material, id_projeto, previsao_entrega) VALUES ('00000000000001', 'AÇO-002', 'PROJ000001', TO_DATE('2024-07-15', 'YYYY-MM-DD'));
INSERT INTO aloca_para (cnpj_fornecedor, codigo_material, id_projeto, previsao_entrega) VALUES ('00000000000002', 'TEL-003', 'PROJ000002', TO_DATE('2024-08-01', 'YYYY-MM-DD'));
INSERT INTO aloca_para (cnpj_fornecedor, codigo_material, id_projeto, previsao_entrega) VALUES ('00000000000004', 'TINTA-005', 'PROJ000004', TO_DATE('2024-08-10', 'YYYY-MM-DD'));
