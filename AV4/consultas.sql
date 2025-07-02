/* checklist SQL


 1. ALTER TABLE
2. CREATE INDEX
3. INSERT INTO
4. UPDATE
5. DELETE
6. SELECT-FROM-WHERE
7. BETWEEN
8. IN
9. LIKE
10. IS NULL ou IS NOT NULL
11. INNER JOIN
12. MAX
13. MIN
14. AVG
15. COUNT
16. LEFT ou RIGHT ou FULL OUTER JOIN
17. SUBCONSULTA COM OPERADOR RELACIONAL
18. SUBCONSULTA COM IN
19. SUBCONSULTA COM ANY
20. SUBCONSULTA COM ALL
21. ORDER BY
22. GROUP BY
23. HAVING
24. UNION ou INTERSECT ou MINUS
25. CREATE VIEW

*/

--1. ALTER TABLE : cria um novo campo na tabela pessoa
ALTER TABLE pessoa
ADD data_nascimento DATE;

--2. CREATE INDEX: cria um índice na tabela pessoa coluna nome
CREATE INDEX idx_pessoa_nome ON pessoa (nome);

--3 INSERT INTO : insere um novo registro na tabela pessoa e cliente

INSERT INTO pessoa (cpf, nome, data_nascimento) VALUES ('55443322110', 'Cristiano Ronaldo', TO_DATE('1988-03-10', 'YYYY-MM-DD'));
INSERT INTO cliente (cpf, email) VALUES ('55443322110', 'cris.ronaldo@email.com');

--4. UPDATE : atualiza o salário de um operário e a data de nascimento de uma pessoa

UPDATE operario
SET salario = 2850.00
WHERE cpf = '34567890123';

UPDATE pessoa
SET data_nascimento = TO_DATE('1990-01-15', 'YYYY-MM-DD')
WHERE cpf = '12345678901';

-- 5. DELETE: deleta um registro da tabela pessoa
DELETE FROM pessoa
WHERE cpf = '56789012345';

--6 e 7. SELECT-FROM-WHERE e BETWEEN: Seleciona os projetos entre 700k e uma milha.
SELECT id_projeto, orcamento, rua, bairro, cidade, estado
FROM projeto p
JOIN endereco e ON p.cep = e.cep AND p.numero = e.numero AND p.complemento = e.complemento
WHERE orcamento BETWEEN 700000.00 AND 1000000.00;

--8. IN: Seleciona pessoas que são clientes ou arquitetos, e kista cpf e nome.
SELECT p.cpf, p.nome
FROM pessoa p
WHERE p.cpf IN (SELECT c.cpf FROM cliente c)
   OR p.cpf IN (SELECT a.cpf FROM arquiteto a);

--9. LIKE: todos os clientes com email terminad em '@gmail.com'.

SELECT p.nome, c.email
FROM pessoa p
JOIN cliente c ON p.cpf = c.cpf
WHERE c.email LIKE '%@gmail.com';

--10. IS NULL ou IS NOT NULL: engenheiros q n tem supervisor.

SELECT p.nome AS nome_engenheiro, e.cargo
FROM pessoa p
JOIN engenheiro e ON p.cpf = e.cpf
WHERE e.crea_supervisor IS NULL;

--11.INNER JOIN: nome dos clientes e os projetos que eles contrataram

SELECT p.nome AS nome_cliente, pr.id_projeto, pr.orcamento
FROM pessoa p
INNER JOIN cliente c ON p.cpf = c.cpf
INNER JOIN contrata co ON c.cpf = co.cpf_cliente
INNER JOIN projeto pr ON co.id_projeto = pr.id_projeto;

--12MAX, 13. MIN, 14. AVG, 15. COUNT & 22. GROUP BY, 23. HAVING

-- Consulta p calcular o salário médio, máximo e mínimo dos operários, e também contar quantos existem por cargo,
-- mas só considerando os cargos com mais de um operário e com salário médio acima de 2600

SELECT cargo, COUNT(cpf) AS total_operarios,
       AVG(salario) AS salario_medio,
       MAX(salario) AS maior_salario,
       MIN(salario) AS menor_salario
FROM operario
GROUP BY cargo
HAVING AVG(salario) > 2600.00; 

-- 16.LEFT JOIN: Seleciona todos os projetos e os arquitetos associados, mesmo se não houver arquiteto.
SELECT pr.id_projeto, pr.orcamento, p.nome AS nome_arquiteto, ar.cau
FROM projeto pr
LEFT JOIN projeta pj ON pr.id_projeto = pj.id_projeto
LEFT JOIN arquiteto ar ON pj.cau_arquiteto = ar.cau
LEFT JOIN pessoa p ON ar.cpf = p.cpf;

-- 17. SUBCONSULTA COM OPERADOR RELACIONAL: Encontra o nome do engenheiro que tem o maior salário entre todos os engenheiros.

SELECT p.nome AS engenheiro_mais_bem_pago, e.salario
FROM pessoa p
JOIN engenheiro e ON p.cpf = e.cpf
WHERE e.salario = (SELECT MAX(salario) FROM engenheiro);


-- 18. SUBCONSULTA COM IN: Seleciona os nomes dos materiais alocados no projeto com id 'PROJ000001'.
SELECT nome
FROM material
WHERE codigo IN (SELECT codigo_material FROM aloca_para WHERE id_projeto = 'PROJ000001');

--19.SUBCONSULTA COM ANY: Seleciona os operários cujo salário é maior que qualquer engenheiro com cargo 'Engenheiro Ambiental'.
SELECT p.nome AS nome_operario, o.salario
FROM pessoa p
JOIN operario o ON p.cpf = o.cpf
WHERE o.salario > ANY (SELECT salario FROM engenheiro WHERE cargo = 'Engenheiro Ambiental');


-- 20. SUBCONSULTA COM ALL: Seleciona os operários cujo salário é menor que todos os engenheiros.
SELECT p.nome AS nome_operario, o.salario AS salario_operario
FROM pessoa p
JOIN operario o ON p.cpf = o.cpf
WHERE o.salario < ALL (
    SELECT e.salario
    FROM engenheiro e
);

-- 21. ORDER BY: Lista todos os projetos ordenados pelo orçamento em ordem decrescente
SELECT id_projeto, orcamento, cidade
FROM projeto pr
JOIN endereco e ON pr.cep = e.cep AND pr.numero = e.numero AND pr.complemento = e.complemento
ORDER BY orcamento DESC;



--24. UNION ou INTERSECT ou MINUS: 

--Mostra os CPFs de todas as pessoas que são ou clientes ou operários

SELECT cpf FROM cliente
UNION
SELECT cpf FROM operario;

--25. CREATE VIEW:

