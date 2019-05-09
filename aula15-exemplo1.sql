CREATE DATABASE Aula15Exemplo1

USE Aula15Exemplo1

CREATE TABLE aluno (
	CodAluno INT PRIMARY KEY IDENTITY (1,1),
	Nome VARCHAR(50),
	Cpf VARCHAR(14)
)

CREATE TRIGGER trgAlerta
	ON aluno
	FOR INSERT 
	AS
	PRINT 'Um aluno foi inserido'
	
-- COMANDOS QUE FARÃO A TRIGGER EXECUTAR

INSERT INTO aluno VALUES ('JOSE', '222.333.444-00')
INSERT INTO aluno VALUES ('JOAO', '555.666.777-11')
INSERT INTO aluno VALUES ('MARIA','777.888.999-22')

INSERT INTO aluno (nome, cpf) VALUES
	('Getulio', 98765434567)

-- COMANDOS QUE NÃO ACIONARÃO A TRIGGER

UPDATE aluno SET nome = 'JOSE DA SILVA' WHERE codAluno = 1
UPDATE aluno SET cpf = '000.111.222-55' WHERE codAluno = 3
DELETE aluno WHERE codAluno = 2

-- PARA ALTERAR A TRIGGER:

ALTER TRIGGER trgAlerta
	ON aluno
	FOR INSERT 
	AS
	PRINT 'Aluno inserido com sucesso!'

-- PARA REMOVER UMA TRIGGER DE UMA TABELA

DROP TRIGGER trgAlerta
	
--

CREATE TABLE cliente (
	CodCliente INT PRIMARY KEY IDENTITY (1,1), 
	Nome VARCHAR(50), 
	ValorAcumulado MONEY
)

CREATE TABLE Venda (
    CodVenda INT PRIMARY KEY IDENTITY (1,1),
    CodCliente INT FOREIGN KEY REFERENCES Cliente(CodCliente),
    DataVenda DATETIME,
    ValorTotal MONEY, 
    ValorImposto MONEY
)

INSERT INTO Cliente VALUES ('JOAO',0)
INSERT INTO Cliente VALUES ('JOSE',0)
INSERT INTO Cliente VALUES ('ANA',0)

CREATE TRIGGER trgIns
	ON Venda
	FOR INSERT
AS
	UPDATE Cliente
  	SET ValorAcumulado = ValorAcumulado + (SELECT ValorTotal - ValorImposto FROM inserted)
	WHERE CodCliente = (SELECT CodCliente FROM inserted)

INSERT INTO Venda VALUES (1, '2015/10/15', 100.00, 15.00)
SELECT * FROM Cliente

INSERT INTO Venda VALUES (2, '2015/02/07', 455.90, 23.49)
SELECT * FROM Cliente

INSERT INTO Venda VALUES (3, '2015/03/18', 118.00, 9.50)
SELECT * FROM Cliente

DROP TRIGGER trgIns

CREATE TRIGGER trgIns2
	ON Venda
	FOR INSERT
AS
	DECLARE @ClienteVenda INT, @TotalVenda MONEY
	SELECT @ClienteVenda = CodCliente, @TotalVenda = ValorTotal - ValorImposto
	FROM inserted
	UPDATE Cliente
	SET ValorAcumulado = ValorAcumulado + @TotalVenda
	WHERE CodCliente = @ClienteVenda
	
