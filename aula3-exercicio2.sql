DROP DATABASE aula3Exercicio2

CREATE DATABASE aula3Exercicio2

USE aula3Exercicio2

/*-------------------------------------------------------
 * Exercício 02:
 *-------------------------------------------------------
 *
 * Dado o seguinte esquema relacional:
 * Marca (id_marca, nome)
 * Produto (id_pro, nome_produto, id_marca, estoque, preço)
 * Pedido(id_pedido, data, valor_desc, valor_total)
 * ItemPedido (id_pedido, id_pro, qtde, vl_unit)
 * 
 * em que:
 * 
 * id_marca – identificador único da marca
 * nome – nome completo da marca, também único
 * id_pro- inteiro identificador de produto
 * nome_produto – não necessariamente único, descreve o produto, p.ex. 'borracha'
 * estoque – inteiro que define a quantidade em estoque (sempre positivo)
 * preço – preço de venda do produto
 * id_pedido – inteiro identificador do pedido
 * data – data do pedido
 */

/*
 * ------------------------------------------------------------------------------
 * CRIAR AS TABELAS COM AS REGRAS DEFINIDAS NO ENUNCIADO PRINCIPAL DO EXERCICIO:
 * ------------------------------------------------------------------------------
 */

CREATE TABLE Marca (
	IdMarca INT CONSTRAINT PK_Marca PRIMARY KEY IDENTITY (1,1),
	Marca VARCHAR(30) CONSTRAINT UN_Marca UNIQUE
)

SELECT * FROM Marca

CREATE TABLE Produto (
	IdProduto INT CONSTRAINT PK_Produto PRIMARY KEY IDENTITY (1,1),
	Produto VARCHAR(25),
	IdMarca INT,
	Estoque INT CONSTRAINT CK_Estoque CHECK (Estoque >= 0),
	Preco MONEY
)

SELECT * FROM Produto

CREATE TABLE Pedido (
	IdPedido INT CONSTRAINT PK_Pedido PRIMARY KEY IDENTITY (1,1),
	DataPedido DATETIME,
	ValorDesconto MONEY,
	ValorTotal MONEY
)

SELECT * FROM Pedido

CREATE TABLE ItemPedido (
	IdPedido INT NOT NULL CONSTRAINT FK_Pedido FOREIGN KEY REFERENCES Pedido(IdPedido),
	IdProduto INT NOT NULL CONSTRAINT FK_Produto FOREIGN KEY REFERENCES Produto(IdProduto),
	Quantidade INT CONSTRAINT CK_Quantidade CHECK (Quantidade >= 0),
	ValorUnitario MONEY
)

SELECT * FROM ItemPedido

/*
 *----------------------------------
 * RESOLVER OS ITEMS DO EXERCÍCIO:
 *----------------------------------
 */

/*
 * 1. O nome_produto é de preenchimento obrigatório.
 */ 

ALTER TABLE Produto
	ALTER COLUMN Produto VARCHAR(25) NOT NULL

/*
 * 2. Todos os valores da marca na relação Produto existem na relação Marca em id_marca.
 */

ALTER TABLE Produto
	ALTER COLUMN IdMarca INT NOT NULL
	
ALTER TABLE Produto
	ADD CONSTRAINT FK_Marca FOREIGN KEY (IdMarca) REFERENCES marca(IdMarca)
	
/*
 * 3. O id_pro é um inteiro com 4 dígitos. 
 */

ALTER TABLE ItemPedido
	DROP CONSTRAINT FK_Produto
	
ALTER TABLE Produto
	DROP CONSTRAINT PK_Produto
	
ALTER TABLE Produto
	DROP COLUMN IdProduto

ALTER TABLE Produto
	ADD IdProduto INT CONSTRAINT PK_Produto PRIMARY KEY IDENTITY (1000,1)

ALTER TABLE Produto
	ADD CONSTRAINT CK_IdProduto CHECK(idProduto BETWEEN 1000 AND 9999)
	
ALTER TABLE ItemPedido
	ADD CONSTRAINT FK_ItemPedidoProduto FOREIGN KEY (IdProduto) REFERENCES Produto(IdProduto)
	
/*
 * 4. A data do pedido é por padrão a data atual.
 */ 

ALTER TABLE Pedido
	ADD CONSTRAINT DF_DatatPedido DEFAULT(GETDATE()) FOR DataPedido

/*
 * 5. No mesmo pedido, não pode haver mais de uma venda do mesmo produto.
 */

ALTER TABLE ItemPedido
	ADD CONSTRAINT PK_ItemPedido PRIMARY KEY (IdPedido, IdProduto)
	
/*
 * 6. Se o preço de um item vendido é superior a 1000 então a quantidade vendida tem de ser menor que 100.
 */ 

ALTER TABLE ItemPedido
	ADD CONSTRAINT CH_PrecoQuantidade CHECK((ValorUnitario > 1000 AND Quantidade < 100) OR (ValorUnitario <= 1000))
	
/*
 * 7. O valor total do Estoque de cada Produto não pode exceder os 250.000 (considerando o preço de venda).
 */

ALTER TABLE Produto
	ADD CONSTRAINT CH_Valor_Maximo CHECK((Estoque * Preco) < 250000)