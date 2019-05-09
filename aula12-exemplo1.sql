CREATE DATABASE Aula12Exemplo1

USE Aula12Exemplo1

CREATE PROCEDURE sp_sayHello
AS
BEGIN
	PRINT 'Hello World'
END

EXEC sp_sayHello

CREATE TABLE departamento (
	idDepartamento INT CONSTRAINT pk_departamento PRIMARY KEY IDENTITY (1,1),
	depto VARCHAR(40) NOT NULL
)

CREATE TABLE funcionario (
	idFuncionario INT CONSTRAINT pk_funcionario PRIMARY KEY IDENTITY (1,1),
	nome VARCHAR(60) NOT NULL,
	idDepartamento INT CONSTRAINT fk_funcionario_departamento FOREIGN KEY REFERENCES departamento(idDepartamento)
)

CREATE TABLE salario (
	idSalario INT CONSTRAINT pk_salario PRIMARY KEY IDENTITY (1,1),
	valor MONEY CONSTRAINT chk_Valor CHECK (valor > 0),
	dtPagamento DATETIME,
	idFuncionario INT CONSTRAINT fk_salario_funcionanrio FOREIGN KEY REFERENCES funcionario(idFuncionario)
)


INSERT INTO departamento VALUES
	('LOGISTICA')

INSERT INTO funcionario VALUES
	('AUGUSTO', 1)

--altera o formato da data desta conexão!
SET dateformat dmy

INSERT INTO salario(idFuncionario, dtPagamento, valor) VALUES 
	(1, '25/01/2014', 2050.49),
	(1, '15/02/2014', 2134.00),
	(1, '18/03/2014', 1998.40)
  
--
	
CREATE PROCEDURE sp_selecionaDepartamentos
AS
BEGIN
	SELECT * FROM departamento
END

EXEC sp_selecionaDepartamentos

--

CREATE PROCEDURE sp_selecionaParametros
@id INT
AS
BEGIN
	SELECT * FROM funcionario
	WHERE idFuncionario = @id
END

EXEC sp_selecionaParametros 1

--

ALTER PROCEDURE sp_selecionaParametros
@id INT
AS
BEGIN
	SELECT * FROM funcionario
	WHERE idFuncionario = @id
END

EXEC sp_selecionaParametros 1

--

CREATE PROCEDURE sp_sayHelloNome
@nome VARCHAR(50),
@sexo VARCHAR(1)
AS
BEGIN
	IF @sexo = 'F'
		print 'Olá ' + @nome + '. Seja bem vinda!'
	ELSE
		print 'Olá ' + @nome + '. Seja bem vindo!'
END

EXEC sp_sayHelloNome 'Fulano', 'F'

--

CREATE TABLE MediaSalarial (
	idValorMedio INT CONSTRAINT pk_mediaSalarial PRIMARY KEY IDENTITY (1,1),
	idFuncionario INT CONSTRAINT fk_mediaSalarial_funcionario FOREIGN KEY REFERENCES funcionario(idFuncionario),
	valorMedio MONEY
)

--

ALTER PROCEDURE sp_MediaSalarial
@idFuncionario INT
AS
BEGIN
	INSERT INTO MediaSalarial(idFuncionario, valorMedio)
		SELECT idFuncionario, ROUND(AVG(valor),2)
		FROM salario
		WHERE idFuncionario = @idFuncionario
		GROUP BY idFuncionario
END

EXEC sp_MediaSalarial 1

SELECT * FROM MediaSalarial

--

-- Calcular o quadrado de um numero que será passado como parâmetro

CREATE PROCEDURE sp_Quadrado
@n1 INT
AS
BEGIN
	PRINT 'O quadrado de ' +
		CAST(@n1 AS VARCHAR(10)) +
		' é: ' +
		CAST(@n1*@n1 AS VARCHAR(10))
END

EXEC sp_Quadrado 2

-- Dados 2 numeros, imprimi-los em ordem crescente

CREATE PROCEDURE sp_OrdemNumeros
@num1 INT,
@num2 INT
AS
BEGIN
	IF (@num1 < @num2)
		BEGIN
			PRINT @num1
			PRINT @num2
		END
	ELSE
		BEGIN
			PRINT @num2
			PRINT @num1
		END
END

EXEC sp_OrdemNumeros 8, 2

-- Exibir a hora do servidor

ALTER PROCEDURE sp_DataHora
AS
BEGIN
	PRINT 'A hora do servidor é:' + 
		CONVERT(VARCHAR(20), GETDATE(), 108)
END 

EXEC sp_DataHora

-- Inserção de dados via procedure

CREATE PROCEDURE sp_inseredepto
	@depto varchar(40) AS
	BEGIN
		INSERT INTO departamento VALUES
			(@depto)
	END

EXEC sp_inseredepto 'EXPEDICAO'
EXEC sp_inseredepto 'COMPRAS'
EXEC sp_inseredepto 'FATURAMENTO'

SELECT * FROM departamento