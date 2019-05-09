DROP DATABASE aula5Exercicio1

CREATE DATABASE aula5Exercicio1

USE aula5Exercicio1

/*--------------------------------------------------------------------
 * 1. Crie um novo BD e as seguintes tabelas,
 * observando suas restrições de integridade:
 *--------------------------------------------------------------------
 * 
 * Fabricante (**CodFabricante**, RazaoSocial, Cidade, Estado)
 * 
 * Categoria (**CodCategoria**, Descricao, Status)
 * 
 * Produto (**CodProduto**, Descricao, Preco, +CodFabricante+, +CodCategoria+)
 * 			CodFabricante referencia Fabricante
 * 			CodCategoria referencia Categoria
 *--------------------------------------------------------------------
 */

CREATE TABLE Fabricante (
	CodFabricante INT CONSTRAINT PK_Fabricante PRIMARY KEY IDENTITY (1,1),
	RazaoSocial VARCHAR(25),
	Cidade VARCHAR(25),
	Estado CHAR(2)
)

SELECT * FROM Fabricante

DROP TABLE Categoria

CREATE TABLE Categoria (
	CodCategoria INT CONSTRAINT PK_Categoria PRIMARY KEY IDENTITY (1,1),
	Descricao VARCHAR(25),
	Status CHAR(10)
)

SELECT * FROM Categoria

CREATE TABLE Produto (
	CodProduto INT CONSTRAINT PK_Produto PRIMARY KEY IDENTITY (1,1),
	Descricao VARCHAR(25),
	Preco MONEY,
	CodFabricante INT NOT NULL CONSTRAINT FK_Produto_Fabricante FOREIGN KEY REFERENCES Fabricante(CodFabricante),
	CodCategoria INT NOT NULL CONSTRAINT FK_Produto_Categoria FOREIGN KEY REFERENCES Categoria(CodCategoria)
)

SELECT * FROM Produto

-- a) Cidade do Fabricante tem valor padrão como sendo 'FRANCA'

ALTER TABLE Fabricante
	ADD CONSTRAINT DF_Cidade DEFAULT ('FRANCA') FOR Cidade

-- b) Campo Razão Social é um campo obrigatório.

ALTER TABLE Fabricante
	ALTER COLUMN RazaoSocial VARCHAR(25) NOT NULL

-- c) Só poderão ser cadastrados fabricantes de SP, MG ou RJ.

ALTER TABLE Fabricante
	ADD CONSTRAINT CK_Estado CHECK (Estado IN ('SP', 'MG', 'RJ'))

-- d) Descrição do produto é obrigatório.

ALTER TABLE Produto
	ALTER COLUMN Descricao VARCHAR(25) NOT NULL

-- e) Status da categoria poderá ser ATIVO ou INATIVO.

ALTER TABLE Categoria
	ADD CONSTRAINT CK_Status CHECK (Status IN ('ATIVO', 'INATIVO'))
	
-- f) Crie um campo para guardar o estoque dos produtos. Este campo deverá ser sempre um número positivo.

ALTER TABLE Produto
	ADD Estoque INT NOT NULL CONSTRAINT CK_Estoque CHECK (Estoque >= 0)
	
-- g) Preço do produto deverá ser sempre maior que 0 (zero).

ALTER TABLE Produto
	ADD CONSTRAINT CK_Preco CHECK (Preco > 0)

-- h) Observe as restrições impostas pelas cardinalidades.

-- i) Código da categoria deverá ser um número inteiro de 3 dígitos.

ALTER TABLE Produto
	DROP CONSTRAINT FK_Produto_Categoria
	
ALTER TABLE Categoria
	DROP CONSTRAINT PK_Categoria

ALTER TABLE Categoria
	DROP COLUMN CodCategoria
	
ALTER TABLE Categoria
	ADD CodCategoria INT CONSTRAINT PK_Categoria PRIMARY KEY IDENTITY (100,1)
	
ALTER TABLE Categoria
	ADD CONSTRAINT CK_CodCategoria CHECK (CodCategoria BETWEEN 100 AND 999)

ALTER TABLE Produto
	ADD CONSTRAINT FK_Produto_Categoria FOREIGN KEY (CodCategoria) REFERENCES Categoria(CodCategoria)

-- Poxa Cláudio que regra nada haver, TEM QUE SER INSERIDA NA CRIAÇÃO DA TABELA.

/*--------------------------------------
 * ISERIR DE DADOS PARA BRINCAR
 *--------------------------------------
 */	

INSERT INTO Fabricante (RazaoSocial, Cidade, Estado)
	VALUES
		('FORD', 'SÃO BERNARDO', 'SP'),
		('VOLKSWAGEN', 'SÃO BERNARDO', 'SP'),
		('PEGEOUT', 'NITERÓI', 'RJ'),
		('HYUNDAY', 'GOANIA', 'MG'),
		('CHEVROLET', 'ILHÉUS', 'RJ'),
		('RENAULT', 'SÃO JOSÉ DOS CAMPOS', 'SP'),
		('FIAT', 'RIBEIRÃO PRETO', 'SP')

INSERT INTO Fabricante (RazaoSocial, Estado)
	VALUES
		('MITSUBSHI', 'SP')

SELECT * FROM Fabricante

INSERT INTO Categoria (Descricao, Status)
	VALUES
		('ESPORTIVO', 'ATIVO'),
		('SEDAM', 'ATIVO'),
		('UTILITÁRIO', 'ATIVO'),
		('HATCH', 'ATIVO'),
		('COMPACTO', 'ATIVO'),
		('OFF-ROAD', 'ATIVO'),
		('DE BRINQUEDO', 'ATIVO'),
		('PICKUP', 'ATIVO'),
		('CAMINHONETE', 'ATIVO'),
		('DE CORRIDA', 'INATIVO'),
		('SUV', 'INATIVO')

SELECT * FROM Fabricante

INSERT INTO Produto (Descricao, Preco, CodFabricante, CodCategoria, Estoque)
	VALUES
		('FIESTA', 40000, 1, 103, 4),
		('ONIX', 45000, 5, 103, 2),
		('GOL', 35000, 2, 104, 10),
		('L200', 190000, 8, 108, 1),
		('UNO', 29000, 7, 106, 8),
		('FERRARI', 500000, 7, 100, 2),
		('PAJERO', 140000, 8, 110, 1)

SELECT * FROM Produto

/*--------------------------------------
 * 2. Crie as seguintes views para: 
 *--------------------------------------
 */

-- a) Listar o código do produto, sua descrição e preço, a categoria, o nome a cidade do fabricante.

CREATE VIEW vProduto AS
	SELECT P.CodProduto AS Codigo, P.Descricao AS Descricao, P.Preco AS Preco, C.Descricao AS Categoria, F.RazaoSocial AS Fabricante, F.Cidade AS Cidade
	FROM Produto AS P
	INNER JOIN Categoria AS C
	ON P.CodCategoria = C.CodCategoria
	INNER JOIN Fabricante AS F
	ON P.CodFabricante = F.CodFabricante

SELECT * FROM vProduto
	
-- b) Listar a quantidade de produtos que existem por categoria.

CREATE VIEW vCategoriaEstoque AS
	SELECT C.Descricao AS Descricao, SUM(P.Estoque) AS Quantidade
	FROM Categoria AS C
	INNER JOIN Produto AS P
	ON C.CodCategoria = P.CodCategoria 
	GROUP BY C.Descricao

SELECT * FROM vCategoriaEstoque

-- c) Selecionar de forma exclusiva as categorias que possuem produtos fornecidos (DEVE SER FABRICADO)
--    para no estado de SP e que estão em categorias inativas.

CREATE VIEW vCategoriaInativoSP AS
	SELECT DISTINCT C.Descricao AS Categoria, C.Status AS Status
	FROM Categoria AS C
	INNER JOIN Produto AS P
	ON C.CodCategoria = P.CodCategoria
	INNER JOIN Fabricante AS F
	ON P.CodFabricante = F.CodFabricante
	WHERE C.Status = 'INATIVO' AND F.Estado = 'SP'

SELECT * FROM vCategoriaInativoSP

-- d) Listar os nomes dos produtos, o preço total dos seus estoques (considerando o preço de venda) e o nome das categorias que eles pertencem.
-- Somente de produtos fabricados em SP.

CREATE VIEW vPrecoEstoqueSP AS
	SELECT P.Descricao AS Nome, (P.Preco * P.Estoque) AS PrecoTotalEstoque, C.Descricao AS Categoria, F.Estado AS Estado
	FROM Produto AS P
	INNER JOIN Categoria AS C
	ON P.CodCategoria = C.CodCategoria
	INNER JOIN Fabricante AS F
	ON P.CodFabricante = F.CodFabricante
	WHERE F.Estado = 'SP'

SELECT * FROM vPrecoEstoqueSP

/*--------------------------------------
 * 3. Crie uma nova tabela para cadastro de Marcas com os campos CodMarca e NomeMarca.
 * O código deverá ser chave primária com numeração automática a partir de 5000 e o Nome da marca precisará ser de preenchimento obrigatório.
 *--------------------------------------
 */

CREATE TABLE Marca (
	CodMarca INT CONSTRAINT PK_Marca PRIMARY KEY IDENTITY(5000,1),
	NomeMarca VARCHAR(25) NOT NULL
)

SELECT * FROM Marca

/*--------------------------------------
 * 4. Cada produto poderá ter apenas uma marca.
 *--------------------------------------
 */

ALTER TABLE Produto
	ADD CodMarca INT CONSTRAINT FK_Produto_Marca FOREIGN KEY REFERENCES Marca(CodMarca)

/*--------------------------------------
 * 5. Cadastre 5 marcas.
 *--------------------------------------
 */

INSERT INTO Marca (NomeMarca)
	VALUES
		('FORD'),
		('CHEVROLET'),
		('FERRARI'),
		('FIAT'),
		('VW'),
		('TOYOTA'),
		('PEGEOUT'),
		('RENAULT'),
		('HYUNDAY'),
		('MITSUBSHI'),
		('HONDA')
		
SELECT * FROM Marca

/*--------------------------------------
 * 6. Crie uma view que liste a quantidade de produtos que existe por marca.
 * Depois exiba o conteúdo desta view colocando no início da lista, a marca que tem mais produtos.
 *--------------------------------------
 */

UPDATE Produto SET CodMarca = 5000 WHERE CodProduto = 8
UPDATE Produto SET CodMarca = 5001 WHERE CodProduto = 9
UPDATE Produto SET CodMarca = 5004 WHERE CodProduto = 10
UPDATE Produto SET CodMarca = 5005 WHERE CodProduto = 11
UPDATE Produto SET CodMarca = 5003 WHERE CodProduto = 12
UPDATE Produto SET CodMarca = 5002 WHERE CodProduto = 13
UPDATE Produto SET CodMarca = 5009 WHERE CodProduto = 14

INSERT INTO Produto (Descricao, Preco, CodFabricante, CodCategoria, Estoque, CodMarca)
	VALUES
		('AWX', 80000, 12, 110, 3, 5009),		
		('FOCUS', 80000, 5, 101, 4, 5000),
		('CRUSE', 95000, 9, 101, 2, 5001),
		('JETTA', 35000, 6, 101, 3, 5004),
		('COROLA', 95000, 8, 101, 12, 5005),
		('LINEA', 29000, 11, 101, 7, 5003),
		('FERRARI ENZO', 543000, 11, 100, 4, 5002),
		('RANGER', 180000, 5, 108, 6, 5000)
		
SELECT * FROM Fabricante

CREATE VIEW vMarcaTotalProdutos AS
	SELECT M.NomeMarca AS Marca, COUNT(*) AS TotalProdutos
	FROM Marca AS M
	INNER JOIN Produto AS P
	ON M.CodMarca = P.CodMarca
	GROUP BY M.NomeMarca

SELECT * FROM vMarcaTotalProdutos
ORDER BY TotalProdutos DESC

/*--------------------------------------
 * 7. Crie uma view que informe quais são os fabricantes e as marcas dos produtos que estão nas categorias Inativas.
 *-------------------------------------- 
 */

CREATE VIEW vFabricanteMarcaCategoriaInativa AS
	SELECT F.RazaoSocial AS Fabricante, M.NomeMarca AS Marca, C.Status AS CategoriaStatus
	FROM Fabricante AS F
	INNER JOIN Produto AS P
	ON F.CodFabricante = P.CodFabricante
	INNER JOIN Marca AS M
	ON M.CodMarca = P.CodMarca
	INNER JOIN Categoria AS C
	ON C.CodCategoria = P.CodCategoria
	WHERE C.Status = 'INATIVO'

SELECT * FROM vFabricanteMarcaCategoriaInativa

/*--------------------------------------
 * 8. Crie uma nova view para mostrar a descrição e os preços dos produtos e suas respectivas marcas, ordenado por produto.
 *-------------------------------------- 
 */

CREATE VIEW vProdutoMarcaPreco AS
	SELECT P.Descricao AS Produto, M.NomeMarca AS Marca, P.Preco AS Preco
	FROM Produto AS P
	INNER JOIN Marca AS M
	ON P.CodMarca = M.CodMarca

SELECT * FROM vProdutoMarcaPreco
ORDER BY Produto

/*------------------------------------------------------------------------------------*/

SELECT * FROM sys.objects
WHERE type_desc LIKE '%CONSTRAINT' AND OBJECT_NAME (parent_object_id)='Categoria'
ORDER BY create_date DESC

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME='Produto'
