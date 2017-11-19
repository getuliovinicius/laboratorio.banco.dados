/* DROP DATABASE Aula13Exercicio1 */

CREATE DATABASE Aula13Exercicio1

USE Aula13Exercicio1

/**
 * Criação das Tabelas
 */

CREATE TABLE Departamento (
	CodDepartamento INT CONSTRAINT PK_Departamento PRIMARY KEY IDENTITY (1,1),
	Departamento VARCHAR(40) NOT NULL
)

CREATE TABLE Funcionario (
	CodFuncionario INT CONSTRAINT PK_Funcionario PRIMARY KEY IDENTITY (1,1),
	Nome VARCHAR(60) NOT NULL,
	CodDepartamento INT CONSTRAINT FK_Funcionario_Departamento FOREIGN KEY REFERENCES Departamento(CodDepartamento)
)

CREATE TABLE Salario (
	CodSalario INT CONSTRAINT PK_Salario PRIMARY KEY IDENTITY (1,1),
	Valor MONEY CONSTRAINT CHK_Valor CHECK (Valor > 0),
	DataPagamento DATETIME,
	CodFuncionario INT CONSTRAINT FK_Salario_Funcionanrio FOREIGN KEY REFERENCES Funcionario(CodFuncionario)
)

INSERT INTO Departamento VALUES
	('LOGISTICA')

SELECT * FROM Departamento

INSERT INTO Funcionario VALUES
	('AUGUSTO', 1)

SELECT * FROM Funcionario

--altera o formato da data desta conexão!
SET dateformat dmy

INSERT INTO Salario(CodFuncionario, DataPagamento, Valor) VALUES 
	(1, '25/01/2014', 2050.49),
	(1, '15/02/2014', 2134.00),
	(1, '18/03/2014', 1998.40)
	
SELECT * FROM Salario 

/**
 * Exemplos de Storage Procedures
 */
	
CREATE PROCEDURE SP_SelecionaDepartamentos AS
BEGIN
	SELECT * FROM Departamento
END

EXEC SP_SelecionaDepartamentos

--

CREATE PROCEDURE SP_SelecionaDepartamentosParametros
@CodFuncionario INT
AS
BEGIN
	SELECT * FROM Funcionario WHERE CodFuncionario = @CodFuncionario
END

EXEC SP_SelecionaDepartamentosParametros 1

--

ALTER PROCEDURE SP_SelecionaDepartamentosParametros
@CodFuncionario INT
AS
BEGIN
	SELECT * FROM Funcionario WHERE CodFuncionario = @CodFuncionario
END

EXEC SP_SelecionaDepartamentosParametros 1

--

CREATE TABLE MediaSalarial (
	CodValorMedio INT CONSTRAINT PK_MediaSalarial PRIMARY KEY IDENTITY (1,1),
	CodFuncionario INT CONSTRAINT FK_MediaSalarial_Funcionario FOREIGN KEY REFERENCES Funcionario(CodFuncionario),
	ValorMedio MONEY
)

--

CREATE PROCEDURE SP_MediaSalarial
@CodFuncionario INT
AS
BEGIN
	INSERT INTO MediaSalarial(CodFuncionario, ValorMedio)
		SELECT CodFuncionario, ROUND(AVG(Valor),2)
		FROM Salario
		WHERE CodFuncionario = @CodFuncionario
		GROUP BY CodFuncionario
END

EXEC SP_MediaSalarial 4

SELECT * FROM MediaSalarial

--

CREATE PROCEDURE SP_InsereDepartamento
@Departamento VARCHAR(40)
AS
BEGIN
	INSERT INTO Departamento VALUES
		(@Departamento)
END

--

CREATE PROCEDURE SP_InsereFuncionario
@Nome VARCHAR(60),
@Departamento INT
AS
BEGIN
	INSERT INTO Funcionario VALUES
		(@Nome, @Departamento)
END

--

CREATE PROCEDURE SP_InsereSalario
@Valor MONEY,
@DataPagamento DATETIME,
@CodFuncionario INT
AS
BEGIN
	INSERT INTO Salario (Valor, DataPagamento, CodFuncionario) VALUES
		(@Valor, @DataPagamento, @CodFuncionario)
END

/**
 * EXERCÍCIOS
 */

-- 1. Insira 4 departamentos usando o procedimento que foi criado (verifique se foi cadastrado).

EXEC SP_InsereDepartamento 'EXPEDICAO'
EXEC SP_InsereDepartamento 'COMPRAS'
EXEC SP_InsereDepartamento 'FATURAMENTO'
EXEC SP_InsereDepartamento 'PESSOAL'

SELECT * FROM Departamento

-- 2. Cadastre 3 novos funcionários e registre o salário de 4 meses de cada um deles.

EXEC SP_InsereFuncionario 'GOMES',1
EXEC SP_InsereFuncionario 'SOUSA',2
EXEC SP_InsereFuncionario 'FAGUNDES',3
EXEC SP_InsereFuncionario 'CESAR',1

SELECT * FROM Funcionario

EXEC SP_InsereSalario '2000', '05/01/2017', 1
EXEC SP_InsereSalario '2000', '05/02/2017', 1
EXEC SP_InsereSalario '2000', '05/03/2017', 1
EXEC SP_InsereSalario '2000', '05/04/2017', 1
EXEC SP_InsereSalario '2000', '05/01/2017', 2
EXEC SP_InsereSalario '2000', '05/02/2017', 2
EXEC SP_InsereSalario '2000', '05/03/2017', 2
EXEC SP_InsereSalario '2000', '05/04/2017', 2
EXEC SP_InsereSalario '2000', '05/01/2017', 3
EXEC SP_InsereSalario '2000', '05/02/2017', 3
EXEC SP_InsereSalario '2000', '05/03/2017', 3
EXEC SP_InsereSalario '2000', '05/04/2017', 3
EXEC SP_InsereSalario '7000', '05/01/2017', 5
EXEC SP_InsereSalario '5000', '05/02/2017', 5
EXEC SP_InsereSalario '1000', '05/03/2017', 5
EXEC SP_InsereSalario '3000', '05/04/2017', 5

SELECT * FROM Salario

-- 3. Crie stored procedure para excluir registro de salário, recebendo como parâmetros o nome do funcionário e a data de pagamento.

CREATE PROCEDURE SP_ExclusaoSalario
@Nome VARCHAR(60),
@DataPagamento DATETIME
AS
BEGIN
	DELETE Salario
	WHERE DataPagamento = @DataPagamento
		AND CodFuncionario = (SELECT CodFuncionario FROM Funcionario WHERE Nome = @Nome)	
END

EXEC SP_ExclusaoSalario 'AUGUSTO', '05/03/2017'

CREATE PROCEDURE SP_ExclusaoSalarioVariavel
@Nome VARCHAR(60),
@DataPagamento DATETIME
AS
BEGIN
	DECLARE @CodFuncionario INT
	SELECT @CodFuncionario = CodFuncionario FROM Funcionario WHERE Nome = @Nome
	DELETE Salario WHERE DataPagamento = @DataPagamento AND CodFuncionario = @CodFuncionario	
END

EXEC SP_ExclusaoSalarioVariavel 'AUGUSTO', '05/01/2017'

SELECT * FROM Salario

-- 4. Crie stored procedure para alterar o cadastro de um funcionário (todos os campos do cadastro).

CREATE PROCEDURE SP_EditaFuncionario
@CodFuncionario INT,
@Nome VARCHAR(60),
@CodDepartamento INT
AS
BEGIN
	UPDATE Funcionario SET Nome = @Nome, CodDepartamento = @CodDepartamento WHERE CodFuncionario = @CodFuncionario
END

EXEC SP_EditaFuncionario 5, 'JOAO', '3'

SELECT * FROM Departamento

-- 5. Crie stored procedure para excluir registro de funcionários recebendo como parâmetro o nome do funcionário.

CREATE PROCEDURE SP_ExclusaoFuncionario
@Nome VARCHAR(60)
AS
BEGIN
	DECLARE @CodFuncionario INT
	SELECT @CodFuncionario = CodFuncionario FROM Funcionario WHERE nome = @Nome
	DELETE MediaSalarial WHERE CodFuncionario = @CodFuncionario
	DELETE Salario WHERE CodFuncionario = @CodFuncionario
	DELETE Funcionario WHERE CodFuncionario = @CodFuncionario
END

EXEC SP_ExclusaoFuncionario 'GOMES'

SELECT * FROM Funcionario

SELECT * FROM MediaSalarial

SELECT * FROM Salario

-- 6. Crie stored procedure que receba o nome do funcionário e retorne seu nome e sua média salarial.

CREATE PROCEDURE SP_MediaSalarialFuncionario
@Nome VARCHAR(60)
AS
BEGIN
	SELECT F.Nome, M.ValorMedio
	FROM Funcionario AS F
		INNER JOIN MediaSalarial AS M
		ON F.CodFuncionario = M.CodFuncionario
	WHERE F.Nome = @Nome	
END 

EXEC SP_MediaSalarialFuncionario 'FAGUNDES'

SELECT * FROM Salario

-- 7. Crie stored procedure que receba o nome do departamento e diga qual é a soma, mês a mês, dos salários dos funcionários deste departamento.

SELECT * FROM Salario

SELECT * FROM Funcionario

SELECT * FROM Departamento

CREATE PROCEDURE SP_SomaMesMesDepartamento
@Departamento VARCHAR(60)
AS
BEGIN
	SELECT YEAR(S.DataPagamento) AS Ano, MONTH(S.DataPagamento) AS Mes, SUM (S.Valor) AS SomaSalarios
	FROM Salario AS S
		INNER JOIN Funcionario AS F
		ON S.CodFuncionario = F.CodFuncionario
		INNER JOIN Departamento AS D 
		ON F.CodDepartamento = D.CodDepartamento
	WHERE D.Departamento = @Departamento
	GROUP BY YEAR(S.DataPagamento), MONTH(S.DataPagamento)
END

EXEC SP_SomaMesMesDepartamento 'COMPRAS'