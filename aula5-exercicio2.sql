CREATE DATABASE aula5Exercicio2

USE aula5Exercicio2

/*--------------------------------------------------------------------
 * 1. Crie um novo BD e as seguintes tabelas, observando suas restrições de integridade:
 *--------------------------------------------------------------------
 *
 * Carro (**CodCarro**, Modelo, Placa, Cor, Ano)
 * 
 * Seguro (**CodSeguro**, NumeroApolice, DataValidade, +CodCarro+)
 *         CodCarro Referencia Carro
 * 
 * Roubo (**CodRoubo**, DataOcorrencia, Local, Cidade, +CodCarro+)
 *        CodCarro Referencia Carro
 * 
 * Recuperacao (**CodRecuperacao**, DataRecuperacao, Responsavel, Observacao, CodRoubo)
 *              CodRoubo Referencia Roubo
 * 
 */

CREATE TABLE Carro (
	CodCarro INT CONSTRAINT PK_Carro PRIMARY KEY IDENTITY(1,1),
	Modelo VARCHAR(25),
	Placa CHAR(7),
	Cor VARCHAR(25),
	Ano INT	
)

SELECT * FROM Carro

CREATE TABLE Seguro (
	CodSeguro INT CONSTRAINT PK_Seguro PRIMARY KEY IDENTITY(1,1),
	NumeroApolice VARCHAR(25),
	DataValidade DATE,
	CodCarro INT CONSTRAINT FK_Seguro_Carro FOREIGN KEY REFERENCES Carro(CodCarro)
)

SELECT * FROM Seguro

CREATE TABLE Roubo (
	CodRoubo INT CONSTRAINT PK_Roubo PRIMARY KEY IDENTITY(1,1),
	DataOcorrencia DATETIME,
	LocalRoubo VARCHAR(25),
	Cidade VARCHAR(25),
	CodCarro INT CONSTRAINT FK_Roubo_Carro FOREIGN KEY REFERENCES Carro(CodCarro)
)

SELECT * FROM Roubo

--a) Crie um nome para as constraints de todas as chaves primárias e chaves estrangeiras.

CREATE TABLE Recuperacao (
	CodRecuperacao INT CONSTRAINT PK_Recuperacao PRIMARY KEY IDENTITY(1,1),
	DataRecuperacao DATETIME,
	Responsavel VARCHAR(25),
	Observacao TEXT,
	CodRoubo INT CONSTRAINT FK_Recuperacao_Roubo FOREIGN KEY REFERENCES Roubo(CodRoubo)
)

ALTER TABLE Recuperacao
	ALTER COLUMN CodRoubo UNIQUE


SELECT * FROM Roubo

--b) Ano de fabricação do carro deverá ser maior que zero.

ALTER TABLE Carro
	ADD CONSTRAINT CK_Ano CHECK (ano > 0)

--c) Modelo do carro é de preenchimento obrigatório.

ALTER TABLE Carro
	ALTER COLUMN Modelo VARCHAR(25) NOT NULL

--d) Número da apólice é um inteiro maior que 1000 e não pode ser deixado em branco.

ALTER TABLE Seguro
	ALTER COLUMN NumeroApolice INT NOT NULL
	
ALTER TABLE Seguro
	ADD CONSTRAINT CK_NumeroApolice CHECK (NumeroApolice > 1000)

--e) Data do roubo tem valor padrão como sendo a data atual do servidor.

ALTER TABLE Roubo
	ADD CONSTRAINT DF_DataRoubo DEFAULT(getdate()) FOR DataOcorrencia

/*-----------------------------
 * 2. Faça cadastros de:
 *-----------------------------
 * 8 Carros
 * 4 Seguros
 * 5 Roubos
 * 3 Recuperações
 *-----------------------------
 */

INSERT INTO Carro (Modelo, Placa, Cor, Ano)
	VALUES
		('FIESTA', 'QWE8976', 'PRETO', 2011),
		('GOL', 'KJH2332', 'VERMELHO', 2013),
		('FOCUS', 'QDE8976', 'AZUL', 2008),
		('GOLF', 'KJ12332', 'PRATA', 2013),
		('CRUSE', 'QKE8976', 'AMARELO', 2014),
		('HB20', 'KJH1234', 'PRETO', 2015),
		('LAND ROVER', 'QWE3276', 'GRAFITE', 2010),
		('UNO', 'MUE2332', 'VERMELHO', 2013),
		('FIESTA', 'QWE8656', 'PRATA', 2010),
		('GOL', 'KJH2312', 'VERDE', 2018),
		('FOCUS', 'QDE8976', 'AZUL', 2016),
		('GOLF', 'KJ12542', 'PRETO', 2015),
		('CRUSE', 'QKE1276', 'PRETO', 2015)

SELECT * FROM Carro

set dateformat dmy

INSERT INTO Seguro (NumeroApolice, DataValidade, CodCarro)
	VALUES
		(1001, '25-10-2017', 16),
		(1002, '25-03-2017', 20),
		(1003, '25-05-2017', 17),
		(1004, '25-11-2017', 13)
		
SELECT * FROM Seguro

INSERT INTO Roubo (DataOcorrencia, LocalRoubo, Cidade, CodCarro)
	VALUES
		('12-04-2017', 'CASA DO DONO', 'FRANCA', 14),
		('12-04-2017', 'CHACARÁ', 'CRISTAIS PAULISTA', 17),
		('12-04-2017', 'CASA DO AMIGO', 'FRANCA', 20),
		('12-04-2017', 'CLUBE', 'FRANCA', 18),
		('12-04-2017', 'CASA DO AMIGO', 'FRANCA', 1002),
		('12-04-2017', 'CLUBE', 'FRANCA', 1003)

INSERT INTO Roubo (LocalRoubo, Cidade, CodCarro)
	VALUES
		('SERVIÇO DO DONO', 'RESTINGA', 13)

SELECT * FROM Roubo

INSERT INTO Recuperacao (DataRecuperacao, Responsavel, Observacao, CodRoubo)
	VALUES
		('13-06-2017', 'ATALIBA', 'JOGADO NO MATO', 4),
		('12-06-2017', 'BALTAZAR', 'PRISAO DOS LADRÕES', 1),
		('15-08-2017', 'ATALIBA', 'ESCONDERIJO', 4)

SELECT * FROM Recuperacao
	
/*-----------------------------------------------
 * 3. Crie uma view que liste os modelos dos carros que foram roubados e não tinham seguro. 
 *-----------------------------------------------
 */

CREATE VIEW vRoubadosSemSeguro AS 
	SELECT DISTINCT CA.Modelo AS Modelo -- Alterado depois para DISTINCT
	FROM Carro AS CA
	LEFT JOIN Seguro AS SE
	ON CA.CodCarro = SE.CodCarro
	INNER JOIN Roubo AS RO
	ON CA.CodCarro = RO.CodCarro
	WHERE SE.CodCarro IS NULL

SELECT * FROM vRoubadosSemSeguro

/*-------------------------------------------------------
 * 4. Crie uma view que liste os carros que foram roubados em Franca e foram recuperados. Liste também as observações da recuperação.
 *-------------------------------------------------------
 */

CREATE VIEW vRecupedosRoubadosFranca AS
	SELECT CA.CodCarro AS Codigo, CA.Modelo AS Modelo, RE.Observacao AS Observacao, RO.Cidade AS Cidade
	FROM Carro AS CA
	INNER JOIN Roubo AS RO
	ON CA.CodCarro = RO.CodCarro
	INNER JOIN Recuperacao AS RE
	ON RO.CodRoubo = RE.CodRoubo
	WHERE RO.Cidade = 'FRANCA'

SELECT * FROM vRecupedosRoubadosFranca

/*-------------------------------------------------------
 * 5. Crie uma view que liste os carros que nunca foram roubados com as informações de seguro para aqueles que tem seguro.
 *------------------------------------------------------- 
 */

CREATE VIEW vCarrosSegurosNaoRoubados AS
	SELECT CA.CodCarro AS Codigo, CA.Modelo AS Modelo, SE.CodSeguro AS Seguro, SE.NumeroApolice AS Apolice, SE.DataValidade AS Validade
	FROM Carro AS CA
	LEFT JOIN Roubo AS RO
	ON CA.CodCarro = RO.CodCarro
	Left JOIN Seguro AS SE
	ON CA.CodCarro = SE.CodCarro
	WHERE RO.CodCarro IS NULL

SELECT * FROM vCarrosSegurosNaoRoubados
ORDER BY Codigo

/*------------------------------------------------------------------------------------*/

SELECT * FROM sys.objects
WHERE type_desc LIKE '%CONSTRAINT' AND OBJECT_NAME (parent_object_id)='Categoria'
ORDER BY create_date DESC

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME='Carro'
