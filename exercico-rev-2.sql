DROP DATABASE exercicioRev02

CREATE DATABASE exercicioRev02

USE exercicioRev02

/*
 * 1. Crie o modelo lógico
 * 
 * Musico(*codMusico, NomeMusico, nomeArtisticoMusico, dataNascimentoMusico)
 * Cancao(*codCancao, nomeCancao, letraCancao, dataComposicaoCancao)
 * Banda(*codBanda, nomeBanda, dataCriacaoBanda)
 * Show(*codShow, dataShow, lugarShow, valorShow, +codBAnda)
 *      codBanda referencia Banda
 * Disco(*codDisco, tituloDisco, produtorDisco, anoGravacaoDisco, estudioDisco, +codBanda)
 *       codBanda referencia Banda
 * CancaoDisco(+codCancao, +codDisco)
 *             codCancao referencia Cancao
 *             codDisco referencia Disco
 * CancaoMusico(+codCancao, +codMusico)
 *              codCancao referencia Cancao
 *              codMusico referencia Musico
 * MusicoBanda(+codMusico, +codBanda, PapelMusico)
 *             codMusico referencia Musico
 *             codBanda referencia Banda
 */

/*
 * 2. Usando as regras de transformação entre modelos, crie o modelo físico em SQL para este BD.
 */

CREATE TABLE Musico (
    CodMusico INT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(30),
    NomeArtistico VARCHAR(30),
    DataNascimento DATE
)

SELECT * FROM Musico

CREATE TABLE Cancao (
    CodCancao INT PRIMARY KEY IDENTITY(1,1),
    Cancao VARCHAR(30),
    Letra TEXT,
    DataComposicao DATE
)

SELECT * FROM Cancao

CREATE TABLE Banda (
    CodBanda INT PRIMARY KEY IDENTITY(1,1),
    Banda VARCHAR(30),
    DataCriacao DATE
)

SELECT * FROM Banda

CREATE TABLE Show (
    CodShow INT PRIMARY KEY IDENTITY(1,1),
    DataShow DATE,
    LocalShow VARCHAR(30),
    Valor MONEY,
    CodBanda INT NOT NULL FOREIGN KEY REFERENCES Banda(CodBanda)
)

SELECT * FROM Show

CREATE TABLE Disco (
    CodDisco INT PRIMARY KEY IDENTITY(1,1),
    Titulo VARCHAR(30),
    Produtor VARCHAR(30),
    AnoGravacao INT,
    Estudio VARCHAR(30),
    CodBanda INT NOT NULL FOREIGN KEY REFERENCES Banda(CodBanda)
)

SELECT * FROM Disco

CREATE TABLE CancaoDisco (
    CodCancao INT NOT NULL FOREIGN KEY REFERENCES Cancao(CodCancao),
    CodDisco INT NOT NULL FOREIGN KEY REFERENCES Disco(CodDisco),
    PRIMARY KEY (CodCancao, CodDisco)
)

SELECT * FROM CancaoDisco

CREATE TABLE CancaoMusico (
    CodCancao INT NOT NULL FOREIGN KEY REFERENCES Cancao(CodCancao),
    CodMusico INT NOT NULL FOREIGN kEY REFERENCES Musico(CodMusico),
    PRIMARY KEY (CodCancao, CodMusico)
)

SELECT * FROM CancaoMusico

CREATE TABLE MusicoBanda (
    CodMusico INT NOT NULL FOREIGN KEY REFERENCES Musico(CodMusico),
    CodBanda INT NOT NULL FOREIGN KEY REFERENCES Banda(CodBanda),
    Papel VARCHAR(30),
    PRIMARY KEY (CodMusico, CodBanda)
)

SELECT * FROM MusicoBanda

/*
 * 3. Cadastre 5 músicos e 3 bandas.
 */

SET DATEFORMAT dmy

INSERT INTO Musico (Nome, NomeArtistico, DataNascimento) VALUES
	('Steven Tyler', 'Steven Tyler', '12/04/1954'),
	('Durval', 'Leonardo', '20/05/1960'),
	('Whashington', 'Cumpade Whashington', '01/10/1970'),
	('Alexander', 'Axl Rose', '10/08/1956'),
	('Paul', 'Paul Macartney', '20/05/1945')

SELECT * FROM Musico

INSERT INTO Banda (Banda, DataCriacao) VALUES
	('Aerosmith', '10/01/1964'),
	('É o Tchan', '05/07/1994'),
	('Guns n Roses', '10/01/1980')

SELECT * FROM Banda

/*
 * 4. Cadastre 5 discos para diferentes bandas.
 */

INSERT INTO Disco (Titulo, Produtor, AnoGravacao, Estudio, CodBanda) VALUES
	('Just Push Play', 'Steven Tyler', 2001 , 'Columbia', 1),
    ('Tchan no Hawaii', 'Beto Jamaíca', 1998, 'Sony', 2),
    ('Appetite for Destruition', 'Axl Rose', 1992 , 'EMY', 3),
    ('Olha o Kibe, Habibis', 'Beto Jamaíca', 1998, 'Sony', 2),
    ('Chinese Deocracy', 'Axl Rose', 2003, 'Universal', 3)

SELECT * FROM Disco

-- 5. Cadastre 8 canções.

INSERT INTO Cancao (Cancao, Letra, DataComposicao) VALUES
	('I Don t wana to miss a thing', 'aaaaa', '01/06/1997'),
	('Segura o Tchan', 'Segura o Tchan', '02/06/1994'),
	('Sweet Child o mine', 'asdfadsfads', '02/09/1991'),
	('Welcome to the Jangle', 'dkaslfjldas', '01/04/1989'),
	('Paradaise City', 'ldksflads', '02/03/1988'),
	('Jaded', 'Hey J', '02/08/2000'),
	('Dream on', 'Every time when I look in the mirror...', '01/02/1972'),
	('Alibaba', 'Alibaba o kaliba tá de olho no ...', '01/08/1997')
        
SELECT * FROM Cancao

/*
 * 6. Vincule cada canção aos seus compositores (lembre-se que uma canção pode ser composta por mais de um músico).
 */

SELECT * FROM Cancao

SELECT * FROM Musico

INSERT INTO CancaoMusico (CodCancao, CodMusico) VALUES
	(1, 3),
	(1, 4),
	(2, 3),
	(3, 4),
	(3, 5),
	(4, 1),
	(5, 1),
	(6, 5),
	(7, 2),
	(8, 3)
        
SELECT * FROM CancaoMusico

/*
 * 7. Cadastre os papéis de cada músico nas bandas que eles participam.
 */

SELECT * FROM Musico

SELECT * FROM Banda

INSERT INTO MusicoBanda VALUES
	(1, 1, 'Vocalista'),
    (3, 2, 'Figurante'),
    (4, 3, 'Vocalista')

SELECT * FROM MusicoBanda

/*
 * 8. Cadastre as músicas que fazem parte de cada disco já cadastrado.
 */

SELECT * FROM Cancao

SELECT * FROM Disco

INSERT INTO CancaoDisco VALUES
	(1,1),
    (2,2),
    (3,3),
    (4,3),
    (5,3),
    (6,1),
    (7,1),
    (8,4)
        
SELECT * FROM CancaoDisco

/*
 * 9. Cadastre 6 shows.
 */

INSERT INTO Show (DataShow, LocalShow, Valor, CodBanda) VALUES
	('12/10/2017', 'Franca-SP', '50000', 2),
    ('15/09/2017', 'Rio de Janeiro-RJ', '500000', 3),
    ('13/10/2017', 'Rio de Janeiro', '1000000', 1),
    ('12/11/2017', 'Salvador-BA', '50000', 2),
    ('15/11/2017', 'Ribeirão Preto-SP', '50000', 2),
    ('08/09/2017', 'Seatle-WAS', '2000000', 1),
    ('14/09/2017', 'Campinas-SP', '50000', 2),
    ('20/11/2017', 'São Paulo-SP', '50000', 3)

SELECT * FROM Show

/*
 * 10. Liste o preço médio dos shows realizados no ano de 2017.
 */

SET DATEFORMAT dmy

SELECT AVG(Valor) AS PrecoMedio
FROM Show
WHERE DataShow > '31/12/2016' AND DataShow < '01/01/2018'

/*
 * 11. Quantas canções existem no disco de código 1?
 */

SELECT COUNT(*) QuantidadeCancoes
FROM CancaoDisco AS CD
INNER JOIN Disco AS D
	ON CD.CodDisco = D.CodDisco
WHERE D.CodDisco = 1

/*
 * 12. Qual o nome das bandas cujos discos foram produzidos pelo produtor 'Fulano'?
 */

SELECT * FROM Disco

SELECT DISTINCT B.Banda, D.Produtor
FROM Banda AS B
INNER JOIN Disco AS D
	ON B.CodBanda = D.CodBanda
WHERE D.Produtor = 'Axl Rose'


/*
 * 13. Liste os nomes artísticos de cada músico, juntamente com o nome das bandas que ele participa e os papéis que exerce em cada banda.
 */

SELECT * FROM MusicoBanda

SELECT M.NomeArtistico, B.Banda, MB.Papel
FROM MusicoBanda AS MB
INNER JOIN Musico AS M
	ON M.CodMusico = MB.CodMusico
INNER JOIN Banda AS B
	ON B.CodBanda = MB.CodBanda

/*
 * 14. Liste os títulos e os estúdios onde foram gravados os discos lançados após o ano 2000 e os nomes das canções que fazem parte de cada disco.
 */

SELECT * FROM CancaoDisco

UPDATE CancaoDisco SET CodDisco = 5 WHERE CodCancao = 4

SELECT D.Titulo AS Disco, D.AnoGravacao, D.Estudio, C.Cancao
FROM CancaoDisco AS CD
INNER JOIN Disco AS D
	ON D.CodDisco = CD.CodDisco
INNER JOIN Cancao AS C
	ON C.CodCancao = CD.CodCancao
WHERE D.AnoGravacao > 2000
ORDER BY D.Titulo

-- 15. Liste os nomes de todas as bandas e os títulos dos discos que já gravaram (bandas que não gravaram discos também precisam ser listadas).

SELECT B.Banda, D.Titulo AS Disco
FROM Banda AS B
INNER JOIN Disco AS D
	ON B.CodBanda = D.CodBanda
ORDER BY B.Banda

-- 16. Quantas músicas existem nos discos lançados em 2015?

SELECT * FROM Disco

UPDATE Disco SET AnoGravacao = 2015 WHERE CodDisco = 5

SELECT COUNT(*) AS QuantidadeMusicas2015
FROM CancaoDisco AS CD
INNER JOIN Disco AS D
	ON CD.CodDisco = D.CodDisco
WHERE D.AnoGravacao = 2015

-- 17. Liste os nomes dos músicos que compuseram a canção 'Encontrar alguém', juntamente com sua data de composição.

SELECT * FROM CancaoMusico

SELECT C.Cancao, M.Nome AS Musico, C.DataComposicao
FROM CancaoMusico AS CM
INNER JOIN Musico AS M
	ON M.CodMusico = CM.CodMusico
INNER JOIN Cancao AS C
	ON C.CodCancao = CM.CodCancao
WHERE C.Cancao = 'Sweet Child o mine'