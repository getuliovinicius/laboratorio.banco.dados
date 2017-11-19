/**
 * 2. Usando o banco de dados criado anteriormente (BD do Power Point), crie stored procedures para: 
 */

CREATE DATABASE Aula14Exercicio2

USE Aula14Exercicio2

-- CRIAÇÃO DAS TABELAS

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

CREATE TABLE MediaSalarial (
	CodValorMedio INT CONSTRAINT PK_MediaSalarial PRIMARY KEY IDENTITY (1,1),
	CodFuncionario INT CONSTRAINT FK_MediaSalarial_Funcionario FOREIGN KEY REFERENCES Funcionario(CodFuncionario),
	ValorMedio MONEY
)

-- 1ª INSERÇÃO DE DADOS

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

-- CRIAÇÃO DE STORAGE PROCEDURES DO EX. ANTERIOR

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

-- 2ª INSERÇÃO DE DADOS

EXEC SP_InsereDepartamento 'EXPEDICAO'
EXEC SP_InsereDepartamento 'COMPRAS'
EXEC SP_InsereDepartamento 'FATURAMENTO'
EXEC SP_InsereDepartamento 'PESSOAL'

SELECT * FROM Departamento

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

SELECT * FROM Salario ORDER BY CodFuncionario, DataPagamento

-- MAIS PROCEDURES

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

--

CREATE PROCEDURE SP_EditaFuncionario
@CodFuncionario INT,
@Nome VARCHAR(60),
@CodDepartamento INT
AS
BEGIN
	UPDATE Funcionario SET Nome = @Nome, CodDepartamento = @CodDepartamento WHERE CodFuncionario = @CodFuncionario
END

EXEC SP_EditaFuncionario 5, 'JOAO', '3'

--

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

--

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

--

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

/**
 * NOVOS EXERCÍCIOS
 */

-- a) Dado um código de departamento, retornar a quantidade de funcionários deste departamento.

CREATE PROCEDURE SP_FuncionariosPorDepartamento
@CodDepartamento INT
AS
BEGIN
	SELECT COUNT(CodFuncionario) AS TotalDeFuncionarios
	FROM Funcionario
	WHERE CodDepartamento = @CodDepartamento
END

EXEC SP_FuncionariosPorDepartamento 1

-- b) Inserir, alterar ou excluir um registro em uma tabela qualquer (usando uma única stored procedure).



-- c) Selecionar os departamentos cujo código seja igual a um parâmetro ou cujos nomes sejam PARECIDOS com um segundo parâmetro.

CREATE PROCEDURE SP_SelecionaDepartamento
@CodDepartamento INT,
@Departamento VARCHAR(40)
AS
BEGIN
	SELECT * FROM Departamento
	WHERE CodDepartamento = @CodDepartamento OR Departamento LIKE '%@Departamento%'
END

EXEC SP_SelecionaDepartamento 1, 'COMPRAS'

SELECT * FROM Departamento

-- d) Gravar um log (nova tabela para guardar o cod consultado e a data e hora da pesquisa)
-- toda vez que um departamento for consultado pelo código.

CREATE TABLE LogDepartamento (
	CodLog INT CONSTRAINT PK_LogDepartamento PRIMARY KEY IDENTITY (1,1),
	CodDepartamento INT NOT NULL CONSTRAINT FK_LogDepartamento_Departamento REFERENCES Departamento (CodDepartamento),
	DataLog DATETIME NOT NULL CONSTRAINT DF_DataLog DEFAULT (GETDATE())
)

CREATE PROCEDURE SP_ConsultaDepartamento
@CodDepartamento INT
AS
BEGIN
	BEGIN TRANSACTION ConsultaDepartamento
		BEGIN TRY
			INSERT INTO LogDepartamento (CodDepartamento) VALUES (@CodDepartamento)
			SELECT * FROM Departamento WHERE CodDepartamento = @CodDepartamento
			COMMIT TRANSACTION ConsultaDepartamento
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION ConsultaDepartamento
		END CATCH
END

EXEC SP_ConsultaDepartamento 2

SELECT * FROM LogDepartamento

SELECT * FROM Departamento
