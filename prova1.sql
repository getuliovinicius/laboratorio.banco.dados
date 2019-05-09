-- GETULIO VINICIUS TEIXEIRA DA SILVA

CREATE DATABASE Prova1

USE Prova1

-- 1

/**
 * Modelo Lógico baseado no Modelo Conceitual
 */

-- Empregado (*RegEmpregado, Endereco, NroSindicato, Telefone, Salario)

-- Controlador (*CodControlador, DataExame, RegEmpregado-)
--              RegEmpregado referencia Empregado 

-- Tecnico (*CodTecnico, RegEmpregado-)
--          RegEmpregado referencia Empregado

-- Modelo (*CodModelo, Peso, Capacidade)

-- Aviao (*RegAviao, CodModelo-)
--        CodModelo referencia Modelo

-- ModeloTecnico (*CodTecnico-, *CodModelo-)
--                CodTecnico referencia Tecnico
--                CodModelo referencia Modelo

-- Teste (*NroANA, Nome, PontuacaoMaxima)

-- AplicacaoTeste (*CodAplicacao, DataRealizacao, HorasGastas, PontuacaoObtida, CodTeste-, CodAviao-, CodTecnico-)
--        CodAviao referencia Aviao
--        CodTecnico referencia Tecnico
--        CodTeste referencia Teste

/**
 * Criacao das tabelas com base no modelo lógico
 */

CREATE TABLE Empregado (
	RegEmpregado INT CONSTRAINT PK_Empregado PRIMARY KEY IDENTITY (1,1),
	Endereco VARCHAR(25),
	NroSindicato INT,
	Telefone CHAR(15),
	Salario MONEY
)

CREATE TABLE Controlador (
	CodControlador INT CONSTRAINT PK_Controlador PRIMARY KEY IDENTITY (1,1),
	DataExame DATE,
	RegEmpregado INT NOT NULL CONSTRAINT FK_Controlador_Empregado FOREIGN KEY REFERENCES Empregado(RegEmpregado)
)

CREATE TABLE Tecnico (
	CodTecnico INT CONSTRAINT PK_Tecnico PRIMARY KEY IDENTITY (1,1),
	RegEmpregado INT NOT NULL CONSTRAINT FK_Tecnico_Empregado FOREIGN KEY REFERENCES Empregado(RegEmpregado)
)

CREATE TABLE Modelo (
	CodModelo INT CONSTRAINT PK_Modelo PRIMARY KEY IDENTITY (1,1),
	Peso INT,
	Capacidade INT
)

CREATE TABLE Aviao (
	RegAviao INT CONSTRAINT PK_Aviao PRIMARY KEY IDENTITY (1,1),
	CodModelo INT NOT NULL CONSTRAINT FK_Aviao_Modelo FOREIGN KEY REFERENCES Modelo(CodModelo)
)

CREATE TABLE ModeloTecnico (
	CodTecnico INT NOT NULL CONSTRAINT FK_ModeloTecnico_Tecnico FOREIGN KEY REFERENCES Tecnico(CodTecnico),
	CodModelo INT NOT NULL CONSTRAINT FK_ModeloTecnico_Modelo FOREIGN KEY REFERENCES Modelo(CodModelo),
	PRIMARY KEY (CodTecnico, CodModelo) 
)

CREATE TABLE Teste (
	NroANA INT CONSTRAINT PK_Teste PRIMARY KEY,
	Nome VARCHAR(25),
	PontuacaoMaxima INT
)

CREATE TABLE AplicacaoTeste (
	CodAplicacaoTeste INT CONSTRAINT PK_AplicacaoTeste PRIMARY KEY IDENTITY (1,1),
	DataRealizacao DATE,
	HorasGastas INT,
	PontuacaoObtida INT,
	CodTeste INT NOT NULL CONSTRAINT FK_AplicacaoTeste_Teste FOREIGN KEY REFERENCES Teste(NroANA),
	RegAviao INT NOT NULL CONSTRAINT FK_AplicacaoTeste_Aviao FOREIGN KEY REFERENCES Aviao(RegAviao),
	CodTecnico INT NOT NULL CONSTRAINT FK_AplicacaoTeste_Tecnico FOREIGN KEY REFERENCES Tecnico(CodTecnico)
)

-- 1. a)

ALTER TABLE Modelo
	ALTER COLUMN Peso INT NOT NULL
	
ALTER TABLE AplicacaoTeste
	ALTER COLUMN PontuacaoObtida INT NOT NULL

-- 1. b)

ALTER TABLE Modelo
	ADD CONSTRAINT CK_Capacidade CHECK (Capacidade IN (120, 132, 162, 275))
	
-- 1. c)

ALTER TABLE AplicacaoTeste
	DROP CONSTRAINT FK_AplicacaoTeste_Aviao
	
ALTER TABLE Aviao
	DROP CONSTRAINT PK_Aviao
	
ALTER TABLE Aviao
	DROP COLUMN RegAviao
	
ALTER TABLE Aviao
	ADD RegAviao INT CONSTRAINT PK_Aviao PRIMARY KEY IDENTITY (1, 1000)
	
ALTER TABLE Aviao
	ADD CONSTRAINT CK_RegAviao CHECK (RegAviao BETWEEN 1000 AND 9000)
	
ALTER TABLE AplicacaoTeste
	ADD CONSTRAINT FK_AplicacaoTeste_Aviao FOREIGN KEY (RegAviao) REFERENCES Aviao(RegAviao)

-- 1. d)

ALTER TABLE Empregado
	ADD TipoTecnico CHAR(1) CONSTRAINT CK_TipoTecnico CHECK (TipoTecnico IN ('S', 'N'))
	
ALTER TABLE Empregado
	ADD CONSTRAINT CK_Salario_TipoTecnico CHECK ((TipoTecnico = 'S' AND Salario >= 3000) OR (TipoTecnico = 'N'))
	
-- 1. e)

ALTER TABLE AplicacaoTeste
	ADD CONSTRAINT DF_DataRealizacao DEFAULT (GETDATE()) FOR DataRealizacao

-- 1. f)

ALTER TABLE Modelo
	ADD VelocidadeCruzeiro INT CONSTRAINT DF_VelocidadeCruzeiro DEFAULT (850)

ALTER TABLE Modelo
	ADD CONSTRAINT CK_Capacidade_VelocidadeCruzeiro CHECK ((Capacidade < 150 AND VelocidadeCruzeiro <= 850) OR (Capacidade >= 150))
	
-- 2

CREATE VIEW AvioesPontuacao AS
	SELECT A.RegAviao AS Registro, M.Capacidade AS Capacidade, AT.PontuacaoObtida AS Pontuacao
	FROM Aviao AS A
		INNER JOIN Modelo AS M
		ON A.CodModelo = M.CodModelo
		INNER JOIN AplicacaoTeste AS AT
		ON A.RegAviao = AT.RegAviao
		
-- 3

ALTER TABLE Empregado
	ADD Nome VARCHAR(25) NOT NULL

CREATE VIEW TecnicosTeste AS
	SELECT E.Nome AS Tecnico, COUNT(AT.CodAplicacaoTeste) AS QuantidateTestes
	FROM Empregado AS E
		INNER JOIN Tecnico AS Tec
		ON E.RegEmpregado = Tec.RegEmpregado
		INNER JOIN AplicacaoTeste AS AT
		ON Tec.CodTecnico = AT.CodTecnico
	GROUP BY E.Nome

-- 4

CREATE VIEW TestesAvioesPequenos AS
	SELECT T.Nome AS Teste
	FROM AplicacaoTeste AS AT
		INNER JOIN Teste AS T
		ON AT.CodTeste = T.NroANA
		INNER JOIN Aviao AS A
		ON AT.RegAviao = A.RegAviao 
		INNER JOIN Modelo AS M
		ON A.CodModelo = M.CodModelo
	WHERE M.Capacidade < 150
	
-- 5

-- 6

CREATE VIEW TestesPontuacaoAbaixoMedia AS
	SELECT T.Nome AS Teste
	From Teste AS T
		INNER JOIN AplicacaoTeste AS AT
		ON T.NroANA = AT.CodTeste
	WHERE AT.PontuacaoObtida < (SELECT AVG(PontuacaoObtida) FROM AplicacaoTeste)
	
-- 7

SELECT * FROM AplicacaoTeste

ALTER TABLE Tecnico
	ADD HorasExperiencia INT 

BEGIN TRANSACTION HORASEXPERIENCIA
	BEGIN TRY
		INSERT INTO AplicacaoTeste (DataRealizacao,HorasGastas,PontuacaoObtida,RegAviao,CodTecnico) VALUES
			('31/10/2017', 8, 100, 3200, 2)
		UPDATE Tecnico SET HorasExperiencia = HorasExperiencia + 8 WHERE CodTecnico = 2
		COMMIT TRANSACTION HORASEXPERIENCIA
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION HORASEXPERIENCIA
	END CATCH

SELECT * FROM AplicacaoTeste