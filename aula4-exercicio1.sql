CREATE DATABASE aula4Exercicio1

USE aula4Exercicio1

/* -----------------------------------------------------------------------------------
 * 1. Crie uma tabela para cadastro de Funcionários, obedecendo as seguintes regras:
 * 
 * -----------------------------------------------------------------------------------
 * 
 * - Um campo para código deverá ser chave primária com numeração automática,
 * - Defina as chaves de todas as demais tabelas desta forma.
 * - Nome é um atributo obrigatório;
 * - CPF e RG é um atributo que tem valor único para cada funcionário;
 * - Sexo poderá ser: 'M' ou 'F';
 * - Categoria deverá ser um dos seguintes valores: Auxiliar, Supervisor, Terceirizado, Contratado, Coordenador.
 * - Idade deve estar entre 16 e 65 anos;
 * - Código de departamento que este funcionário trabalha. 
 * -----------------------------------------------------------------------------------
 */

CREATE TABLE Funcionarios (
	CodFuncionario INT CONSTRAINT PK_Funcionarios PRIMARY KEY IDENTITY(1,1),
	Nome VARCHAR(50) NOT NULL,
	Cpf CHAR(14) UNIQUE,
	Rg CHAR(12) UNIQUE,
	Sexo CHAR(1) CONSTRAINT CK_Sexo CHECK(Sexo IN ('F','M')),
	Categoria CHAR(20) CONSTRAINT CK_Categoria CHECK(Categoria IN ('AUXILIAR', 'SUPERVISOR', 'TERCEIRIZADO', 'CONTRATADO', 'CORDENADOR')),
	Idade INT CONSTRAINT CK_Idade CHECK(Idade BETWEEN 16 AND 65)
)

SELECT * FROM Funcionarios

/* -----------------------------------------------------------------------------------
 * 2. Crie uma tabela para cadastro de Departamentos, com as seguintes restrições:
 *
 * -----------------------------------------------------------------------------------
 *
 * - Um campo para código do departamento também com numeração automática
 * - Nome do departamento é atributo obrigatório
 * - Descrição do departamento
 * - Código do funcionário gerente do departamento. 
 * -----------------------------------------------------------------------------------
 */

CREATE TABLE Departamentos (
	CodDepartamento INT CONSTRAINT PK_Departamentos PRIMARY KEY IDENTITY(1,1),
	Departamento VARCHAR(25) NOT NULL,
	Descricao TEXT,
	CodFuncionarioGerente INT CONSTRAINT FK_Departamentos_Funcionarios FOREIGN KEY REFERENCES Funcionarios(CodFuncionario)
)

SELECT * FROM Departamentos

/* -----------------------------------------------------------------------------------
 * 3. Crie uma tabela para cadastro de Projetos:
 * 
 * -----------------------------------------------------------------------------------
 * 
 * - Código do projeto é atributo obrigatório com numeração automática a partir de 100
 * - Nome é atributo obrigatório
 * - Descrição do projeto
 * -----------------------------------------------------------------------------------
 */

CREATE TABLE Projetos (
	CodProjeto INT CONSTRAINT PK_Projetos PRIMARY KEY IDENTITY(100,1),
	Projeto VARCHAR(50) NOT NULL,
	Descricao TEXT
)
	
SELECT * FROM Projetos

/* -----------------------------------------------------------------------------------
 * 4. Crie uma tabela para registrar a participação dos funcionários em projetos
 * 
 * -----------------------------------------------------------------------------------
 * 
 * - Código do funcionário deverá ser obrigatório
 * - Código do projeto deverá também ser obrigatório
 * - Data de início da participação no projeto
 * - Data de fim da participação do projeto
 * - A data de início deverá ser menor que a data de fim
 * -----------------------------------------------------------------------------------
 */

CREATE TABLE ParticipacaoProjetos (
	CodProjeto INT NOT NULL CONSTRAINT FK_Projetos FOREIGN KEY REFERENCES Projetos(codProjeto),
	CodFuncionario INT NOT NULL CONSTRAINT FK_Funcionarios FOREIGN KEY REFERENCES Funcionarios(CodFuncionario),
	DataInicioParticipacao DATE NOT NULL,
	DataFimParticipacao DATE,
	CONSTRAINT CK_DataFimParticipacao CHECK (DataFimParticipacao > DataInicioParticipacao)
)

SELECT * FROM ParticipacaoProjetos

/*
 * 5. Altere a tabela Funcionário criando uma ligação com a tabela de departamentos
 */

ALTER TABLE Funcionarios
	ADD CodDepartamento INT CONSTRAINT FK_Funcionarios_Departamentos FOREIGN KEY REFERENCES Departamentos(CodDepartamento)

SELECT * FROM Funcionarios

/*
 * 6. Crie uma restrição do tipo Chave Primária composta para a tabela Participação para os campos CodFun e CodProj
 */

ALTER TABLE ParticipacaoProjetos
	ADD CONSTRAINT PK_ParticipacaoProjetos PRIMARY KEY (CodProjeto, CodFuncionario) 

SELECT * FROM ParticipacaoProjetos

/* -----------------------------------------------------------------------------------
 * 7. Cadastre os seguintes departamentos
 * -----------------------------------------------------------------------------------
 * 
 * - CONTAS A PAGAR
 * - CONTAS A RECEBER
 * - FATURAMENTO
 * - VENDAS
 * - COMPRAS
 * ----------------------------------------------------------------------------------- 
 */

INSERT INTO Departamentos(Departamento, Descricao) VALUES
	('CONTAS A PAGAR', 'DEPARTAMENTO DE CONTAS A PAGAR'),
	('CONTAS A RECEBER', 'DEPARTAMENTO DE CONTAS A PAGAR'),
	('FATURAMENTO', 'DEPARTAMENTO DE FATURAMENTO'),
	('VENDAS', 'DEPARTAMENTO DE VENDAS'),
	('COMPRAS', 'DEPARTAMENTO DE COMPRAS')

SELECT * FROM Departamentos

/*
 * 8. Cadastre 5 projetos
 */

INSERT INTO Projetos (Projeto, Descricao) VALUES
	('Projeto Java', 'Projeto de sistema em Java'),
	('Projeto NodeJS', 'Projeto de sistema em NodeJS'),
	('Projeto Ruby', 'Projeto de sistema em Ruby'),
	('Projeto Python', 'Projeto de sistema em Python'),
	('Projeto Cobol', 'Projeto de sistema em Cobol')

SELECT * FROM Projetos

/*
 * 9. Cadastre 10 funcionários
 */

INSERT INTO Funcionarios (Nome, Cpf, Rg, Sexo, Idade, CodDepartamento) VALUES
	('Func1', '111.111.111-4', '44.444.444-4', 'M', 16, 2)
	
-- 'AUXILIAR', 'SUPERVISOR', 'TERCEIRIZADO', 'CONTRATADO', 'CORDENADOR'

INSERT INTO Funcionarios (Nome, Cpf, Rg, Sexo, Categoria, Idade, CodDepartamento) VALUES
	('Func2', '333.111.111-4', '44.744.444-4', 'M', 'CONTRATADO', 41, 2),
	('Func3', '444.111.111-4', '47.444.444-4', 'F', 'TERCEIRIZADO', 19, 2),
	('Func4', '555.111.111-4', '46.444.444-4', 'F', 'AUXILIAR', 17, 3),
	('Func5', '666.111.111-4', '45.444.444-4', 'F', 'CONTRATADO', 33, 3),
	('Func6', '777.111.111-4', '44.544.444-4', 'M', 'SUPERVISOR', 32, 4),
	('Func7', '777.771.111-4', '43.444.444-4', 'M', 'CORDENADOR', 21, 5),
	('Func8', '111.777.111-4', '43.244.444-4', 'F', 'AUXILIAR', 18, 1)

SELECT * FROM Funcionarios

/*
 * 10. Vincule 3 funcionários para cada um dos projetos cadastrados
 */

SET dateformat dmy 

SELECT * FROM Projetos

INSERT INTO ParticipacaoProjetos (CodProjeto, CodFuncionario, DataInicioParticipacao) VALUES
	(100, 1, '21-09-2016'),
	(100, 6, '21-09-2016'),
	(100, 5, '21-09-2016'),
	(101, 2, '21-09-2016'),
	(101, 3, '21-09-2016'),
	(101, 4, '21-09-2016'),
	(102, 2, '21-09-2016'),
	(102, 6, '21-09-2016'),
	(102, 1, '21-09-2016'),
	(103, 4, '21-09-2016'),
	(103, 5, '21-09-2016'),
	(103, 2, '21-09-2016'),
	(104, 4, '21-09-2016'),
	(104, 1, '21-09-2016'),
	(104, 6, '21-09-2016')

SELECT * FROM ParticipacaoProjetos

/*
 * 11. Cadastre os chefes dos departamentos
 */

UPDATE Departamentos SET codFuncionarioGerente=1 WHERE CodDepartamento=1 
UPDATE Departamentos SET codFuncionarioGerente=3 WHERE CodDepartamento=5 
UPDATE Departamentos SET codFuncionarioGerente=2 WHERE CodDepartamento=4 
UPDATE Departamentos SET codFuncionarioGerente=5 WHERE CodDepartamento=3 
UPDATE Departamentos SET codFuncionarioGerente=4 WHERE CodDepartamento=2 

SELECT * FROM Departamentos

/*
 * 12. Crie um campo para salário do funcioário com restrição de só aceitar valores maiores que 500.
 */

ALTER TABLE Funcionarios
	ADD Salario MONEY CONSTRAINT CK_Salario CHECK (Salario > 500)
	
SELECT * FROM Funcionarios
	
/*
 * 13. Insira um novo funcionário sem preencher o campo salario para testar sua constraint
 */

INSERT INTO Funcionarios (Nome, Cpf, Rg, Sexo, Categoria, Idade, CodDepartamento) VALUES
	('Func12', '233.111.111-4', '24.744.444-4', 'M', 'CONTRATADO', 41, 2)

/*
 * 14. Exclua o campo salario da tabela funcionário
 */

ALTER TABLE Funcionarios
	DROP CONSTRAINT CK_Salario

ALTER TABLE Funcionarios
	DROP COLUMN Salario
	
/*
 * 15. Crie um campo para cidade do funcionário com valor padrão sendo 'Franca'
 */

ALTER TABLE Funcionarios
	ADD Cidade VARCHAR(25) CONSTRAINT DF_Cidade DEFAULT('FRANCA')
	
/*
 * 16. Cadastre um novo funcionário sem preencher a cidade para testar sua constraint
 */

INSERT INTO Funcionarios (Nome, Cpf, Rg, Sexo, Categoria, Idade, CodDepartamento) VALUES
	('Func124', '167.321.487-4', '87.742.454-4', 'F', 'CONTRATADO', 41, 3)
	
SELECT * FROM Funcionarios
	
/*
 * 17. Crie novamente o campo para salario com suas restrições
 */

ALTER TABLE Funcionarios
	ADD Salario MONEY CONSTRAINT CK_Salario CHECK (Salario > 500)

SELECT * FROM Funcionarios

/*
 * 18. Crie um novo projeto e vincule 5 funcionários a este projeto
 */

INSERT INTO Projetos (Projeto, Descricao) VALUES
	('Projeto PHP', 'Projeto de sistema em PHP')
	
SELECT * FROM Projetos

INSERT INTO ParticipacaoProjetos (CodProjeto, CodFuncionario, DataInicioParticipacao) VALUES
	(105, 3, '21-10-2016'),
	(105, 6, '21-10-2016'),
	(105, 5, '21-10-2016'),
	(105, 2, '21-10-2016'),
	(105, 4, '21-10-2016')
	
SELECT * FROM ParticipacaoProjetos

/*
 * 19. Verifique se existe algum funcionário sem departamento, se houver, vincule os funcionários a algum departamento
 */

SELECT * FROM Funcionarios WHERE CodDepartamento IS NULL

UPDATE Funcionarios SET CodDepartamento=3 WHERE CodDepartamento IS NULL

/*
 * 20. Desative a Constraint que foi criada para o campo salário e insira um novo funcionário sem preencher o salario
 */

ALTER TABLE Funcionarios NOCHECK CONSTRAINT CK_Salario

INSERT INTO Funcionarios (Nome, Cpf, Rg, Sexo, Categoria, Idade, CodDepartamento) VALUES
	('Func129', '233.111.101-4', '24.744.434-4', 'M', 'CONTRATADO', 41, 2)

/*
 * 21. Ative novamente esta constraint do campo salario e faça o teste cadastrando um novo funcionário com salário = 0.
 */

ALTER TABLE Funcionarios CHECK CONSTRAINT CK_Salario

INSERT INTO Funcionarios (Nome, Cpf, Rg, Sexo, Categoria, Idade, CodDepartamento) VALUES
	('Func199', '203.111.101-4', '24.244.434-4', 'M', 'CONTRATADO', 41, 2)

/*
 * 22. Crie uma restrição para todos os campos Descrição de todas as tabelas que possuem um campo descrição.
 * Esta restrição deverá inserir um valor padrão para este campo.
 */

--ALTER TABLE Departamentos
--	DROP CONSTRAINT DF_DescricaoDpto

ALTER TABLE Departamentos
	ADD CONSTRAINT DF_Descricao DEFAULT('DEPARTAMENTO INTERNO DA EMPRESA') FOR Descricao
	
INSERT INTO Departamentos (Departamento, CodFuncionarioGerente)	VALUES
	('INFORMÁTICA', '4')

SELECT * FROM Departamentos

ALTER TABLE Projetos
	ADD CONSTRAINT DF_DescricaoProjeto DEFAULT('PROJETO INTERNO DA EMPRESA') FOR Descricao

INSERT INTO Projetos (Projeto) VALUES
	('Projeto C++')

SELECT * FROM Projetos

/*
 * 23. Exclua as tabelas que você criou.
 */

SELECT * FROM ParticipacaoProjetos

DROP TABLE ParticipacaoProjetos

SELECT * FROM Projetos

DROP TABLE Projetos

SELECT * FROM Departamentos

SELECT * FROM sys.objects
	WHERE type_desc LIKE '%CONSTRAINT' AND OBJECT_NAME(parent_object_id)='Departamentos'
	ORDER BY create_date DESC

ALTER TABLE Departamentos
	DROP CONSTRAINT FK_Departamentos_Funcionarios

ALTER TABLE Funcionarios
	DROP CONSTRAINT FK_Funcionarios_Departamentos

DROP TABLE Departamentos

SELECT * FROM Funcionarios

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
	WHERE TABLE_NAME='Funcionarios'

DROP TABLE Funcionarios
