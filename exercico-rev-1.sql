CREATE DATABASE exercicioRev01

USE exercicioRev01

/*
 * 1. Crie um novo BD e as seguintes tabelas, observando as chaves primárias e chaves estrangeiras:
 */

CREATE TABLE Categoria (
	CodCategoria INT PRIMARY KEY IDENTITY(1,1),
	Descricao VARCHAR(25),
	Ativo CHAR(1)
)

SELECT * FROM Categoria

CREATE TABLE Artista (
	CodArtista INT PRIMARY KEY IDENTITY(1,1),
	Nome VARCHAR(25),
	NomeArtistico VARCHAR(25),
	DataNascimento DATETIME,
	Pais VARCHAR(25)
)

SELECT * FROM Artista

CREATE TABLE CD (
	CodCD INT PRIMARY KEY IDENTITY(1,1),
	Titulo VARCHAR(25),
	Ano INT,
	CodCategoria INT NOT NULL FOREIGN KEY REFERENCES Categoria(CodCategoria),
	CodArtista INT NOT NULL FOREIGN KEY REFERENCES Artista(codArtista)
)

SELECT * FROM CD

/*
 * 2. Inserir 4 categorias e 4 artistas.
 */

INSERT INTO Categoria (Descricao, Ativo) VALUES
	('ROCK','S'),
	('HEAVY METAL','S'),
	('POP','N'),
	('AXÉ','S')

SELECT * FROM Categoria

INSERT INTO Artista (Nome, NomeArtistico, DataNascimento, Pais) VALUES
	('JOSÉ DA SILVA', 'RAUL SEIXAS', '1950/01/15', 'BRASIL'),
	('JOSÉ DA OLIVEIRA', 'BELCHIOR', '1998/12/09', 'BRASIL'),
	('MICHAEL', 'MICHAEL JACKSON', '1970/02/10', 'EUA'),
	('JOÃO SOUZA', 'CUMPADI WHASHINGTON', '2003/10/23', 'BRASIL')

SELECT * FROM Artista

SET dateformat dmy

INSERT INTO Artista (Nome, NomeArtistico, DataNascimento, Pais) VALUES
	('ANA','CELINE DION', '20/10/1973', 'CANADA')

SELECT * FROM Artista

/*
 * 3. Cadastre 6 CDs ou mais.
 */

INSERT INTO CD (Titulo, Ano, CodCategoria, CodArtista) VALUES
	('CD 1', 1998, 1, 1),
	('CD 2', 1994, 1, 2),
	('CD 3', 1991, 1, 3),
	('CD 4', 1994, 1, 4),
	('CD 5', 1978, 1, 5),
	('CD 6', 1961, 1, 3),
	('CD 7', 2017, 1, 4)

SELECT * FROM CD

/*
 * 4. Crie um campo para guardar o preço dos CDs.
 */

ALTER TABLE CD
	ADD Preco MONEY

SELECT * FROM CD

/*
 * 5. Atualize os precos de cada CD.
 */

UPDATE CD SET Preco = 1.99 WHERE CodCD < 4

UPDATE CD SET Preco = 4.99 WHERE CodCD >= 4

SELECT * FROM CD

/*
 * 6. Cadastre um artista da Alemanha.
 */

INSERT INTO Artista (Nome, NomeArtistico, DataNascimento, Pais) VALUES
	('HANS', 'HAROLD', '20/10/1985', 'ALEMANHA')

SELECT * FROM Artista

/*
 * 7. Cadastre 3 CDs para este artista.
 */

INSERT INTO CD (Titulo, Ano, CodCategoria, CodArtista, Preco) VALUES
	('CD 7', 1987, 2, 6, 4.50),
	('CD 8', 2000, 4, 6, 8.50),
	('CD 9', 2015, 3, 6, 5.50)

SELECT * FROM CD 
WHERE codArtista IN (SELECT codArtista FROM Artista WHERE pais = 'BRASIL')

SELECT CD.CodCD AS CD, CD.Titulo AS Titulo, AR.NomeArtistico As Artista, AR.Pais AS Pais
FROM CD AS CD
INNER JOIN Artista AS AR
	ON CD.codArtista = AR.codArtista
WHERE Pais = 'BRASIL'

/*
 * 8. Liste os CDs das categorias ativas.
 */

SELECT CD.*
FROM CD AS CD
INNER JOIN Categoria AS CA
	ON CD.codCategoria = CA.codCategoria
WHERE CA.ativo = 'S'

/*
 * 9. Mude o preço dos CDs lançados de 1950 a 2002 para 10% a mais.
 */

SELECT * FROM CD

UPDATE CD SET Preco = (Preco * 1.1)
WHERE Ano between 1950 and 2002

SELECT * FROM CD

/*
 * 10. Liste os CDs com preço acima da média.
 */

SELECT AVG(preco) FROM CD

SELECT * FROM CD
WHERE preco >= (SELECT AVG(preco) FROM CD) 

/*
 * 11. Exclua os CDs dos artistas do Brasil que estão em categorias inativas.
 */

SELECT * FROM CD

SELECT CodArtista FROM Artista WHERE Pais = 'BRASIL'

SELECT CodCategoria FROM Categoria WHERE Ativo <> 'S'

DELETE CD
WHERE
	CodArtista IN (SELECT CodArtista FROM Artista WHERE Pais = 'BRASIL')
	AND
	CodCategoria IN (SELECT CodCategoria FROM Categoria WHERE Ativo <> 'S') -- "<>" diferente de S

/*
 * 12. Quantos CDs foram lançados em 2015 por artistas da Alemanha?
 */

SELECT COUNT(*) as Total
FROM CD AS CD
INNER JOIN Artista AS AR
	ON CD.CodArtista = AR.CodArtista
WHERE Pais = 'ALEMANHA' AND ano = 2015