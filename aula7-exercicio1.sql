CREATE DATABASE aula7Exercicio1

USE aula7Exercicio1

/*------------------------------------------------
 * 1. Analise o modelo conceitual apresentado, se encontrar erros, corrija-os.
 *------------------------------------------------
 */


/*-------------------------------
 * 2. Complete com as cardinalidades de cada relacionamento
 *    (você vai precisar simular algumas regras de negócio, como por exemplo: 
 *     um cliente poderá ter somente um endereço ou terá mais de um endereço?).
 *-------------------------------
 */

-- Cliente (**CodCliente, Nome, Telefone, LimiteCredito)
--
-- Endereco (**CodEdereco, Rua, Numero, Bairro, Cep, Cidade, +CodCliente)
--           CodCliente Referencia Cliente
-- Vendedor (**CodVendedor, Nome, Telefone, Funcao)
-- 
-- Salario (**CodSalario, Data, ValorFixo, +CodVendedor)
--          CodVendedor Referencia Vendedor 
-- 
-- Venda (**CodVenda, Data, ValorFrete, +CodCliente, +CodVendedor)
--        CodCliente Referencia Cliente
--        CodVendedor Referencia Vendedor
-- 
-- Financeiro (CodFinanceiro, Valor, DataLancamento, DataVencimento, DataLiquidacao, +CodVenda)
--             CodVenda Referencia Venda 
-- 
-- Tributacao (**CodTributacao, PercentualICMS, PercentualIPI)
-- 
-- Grade (**CodGrade, Nome)
-- 
-- Produto (**CodProduto, Nome, Unidade, Estoque, +CodTributacao, +CodGrade)
--          CodTributacao Referencia Tributacao
--          CodGrade Referencia Grade
-- 
-- ItemVenda (**CodItemVenda, Quantidate, ValorUnitario, +CodProduto, +CodVenda)
--            CodProduto Referencia Produto
--            CodVenda Referencia Venda

/*-------------------------------------
 * 3. A partir do modelo conceitual, aplique as regras de transformações de modelos e crie as tabelas (modelo físico).
 *-------------------------------------
 */

CREATE TABLE Cliente (
	CodCliente INT CONSTRAINT PK_Cliente PRIMARY KEY IDENTITY(1,1),
	Nome VARCHAR(25),
	Telefone CHAR(15),
	LimiteCredito MONEY
)

INSERT INTO Cliente ()


CREATE TABLE Endereco (
	CodEdereco INT CONSTRAINT PK_Endereco PRIMARY KEY IDENTITY(1,1),
	Rua VARCHAR(25) NOT NULL,
	Numero INT,
	Bairro VARCHAR(25),
	Cep CHAR(10),
	Cidade VARCHAR(25) NOT NULL,
	CodCliente INT CONSTRAINT FK_Endereco_Cliente FOREIGN KEY REFERENCES Cliente(CodCliente) NOT NULL
)

CREATE TABLE Vendedor (
	CodVendedor INT CONSTRAINT PK_Vendedor PRIMARY KEY IDENTITY(1,1),
	Nome VARCHAR(25) NOT NULL,
	Telefone CHAR(15),
	Funcao VARCHAR(25)
)

CREATE TABLE Salario (
	CodSalario INT CONSTRAINT PK_Salario PRIMARY KEY IDENTITY(1,1),
	DataPagamento DATE NOT NULL,
	ValorFixo MONEY NOT NULL,
	CodVendedor INT CONSTRAINT FK_Salario_Vendedor FOREIGN KEY REFERENCES Vendedor(CodVendedor) NOT NULL
)

CREATE TABLE Venda (
	CodVenda INT CONSTRAINT PK_Venda PRIMARY KEY IDENTITY(1,1),
	DataVenda DATE NOT NULL,
	ValorFrete MONEY,
	CodCliente INT CONSTRAINT FK_Venda_Cliente FOREIGN KEY REFERENCES Cliente(CodCliente) NOT NULL,
	CodVendedor INT CONSTRAINT FK_Venda_Vendedor FOREIGN KEY REFERENCES Vendedor(CodVendedor) NOT NULL
)
	
CREATE TABLE Financeiro (
	CodFinanceiro INT CONSTRAINT PK_Financeiro PRIMARY KEY IDENTITY(1,1),
	Valor MONEY NOT NULL,
	DataLancamento DATE NOT NULL,
	DataVencimento DATE,
	DataLiquidacao DATE,
	CodVenda INT CONSTRAINT FK_Financeiro_Venda FOREIGN KEY REFERENCES Venda(CodVenda) NOT NULL
)

CREATE TABLE Tributacao (
	CodTributacao INT CONSTRAINT PK_Tributacao PRIMARY KEY IDENTITY(1,1),
	PercentualICMS FLOAT,
	PercentualIPI FLOAT
)

CREATE TABLE Grade (
	CodGrade INT CONSTRAINT PK_Grade PRIMARY KEY IDENTITY(1,1),
	Nome VARCHAR(25) NOT NULL
)

CREATE TABLE Produto (
	CodProduto INT CONSTRAINT PK_Produto PRIMARY KEY IDENTITY(1,1),
	Nome VARCHAR(25) NOT NULL,
	Unidade CHAR(2) NOT NULL,
	Estoque INT NOT NULL,
	CodTributacao INT CONSTRAINT FK_Produto_Tributacao FOREIGN KEY REFERENCES Tributacao(CodTributacao) NOT NULL,
	CodGrade INT CONSTRAINT FK_Produto_Grade FOREIGN KEY REFERENCES Grade(CodGrade) NOT NULL
)

CREATE TABLE ItemVenda (
	CodItemVenda INT CONSTRAINT PK_ItemVenda PRIMARY KEY IDENTITY(1,1),
	Quantidate INT,
	ValorUnitario MONEY,
	CodProduto INT CONSTRAINT FK_ItemVenda_Produto FOREIGN KEY REFERENCES Produto(CodProduto) NOT NULL,
	CodVenda INT CONSTRAINT FK_ItemVenda_Venda FOREIGN KEY REFERENCES Venda(CodVenda) NOT NULL
)

SELECT * FROM ItemVenda

/*------------------------------------
 * 4. Analise e crie corretamente as chaves primárias das tabelas.
 * ------------------------------------
 */

/*------------------------------------
 * 5. Crie as restrições de integridade:
 *------------------------------------
 */

--a. Nome do cliente é um campo obrigatório.

ALTER TABLE Cliente
	ALTER COLUMN Nome VARCHAR(25) NOT NULL

--b. Data da venda tem valor padrão como sendo a data atual do sistema.

ALTER TABLE Venda
	ADD CONSTRAINT DF_Data DEFAULT(getdate()) FOR DataVenda

--c. Valor da comissão deve ser sempre maior que zero.

ALTER TABLE Salario
	ADD Comissao MONEY CONSTRAINT CK_Comissao CHECK (Comissao > 0)

--d. Função do vendedor só pode ser ‘Balcão’, ‘Externo’, ‘Aprendiz’, ‘Supervisor’.

ALTER TABLE Vendedor
	ADD CONSTRAINT CK_Funcao CHECK (Funcao IN ('BALACAO', 'EXTERNO', 'APRENDIZ', 'SUPERVISOR'))

--e. Para os produtos vendidos com unidade ‘PÇ’ o estoque não poderá ser negativo.

ALTER TABLE Produto
	ADD CONSTRAINT CK_Peca_Estoque CHECK ((Unidade = 'PC' AND Estoque >= 0) OR (Estoque <> 'PC'))

--f. Quando o salário fixo for maior que R$ 2.000,00 a comissão não poderá ser maior que R$ 1.800,00.

ALTER TABLE Salario
	ADD CONSTRAINT CK_Salario CHECK ((ValorFixo > 2000 AND Comissao <= 1800) OR (ValorFixo <= 2000))

--g. A data de vencimento do financeiro não pode ser menor que a data de lançamento.



/* ------------------------------------
 * 6. Crie comandos para simular transações explícitas nas tabelas para os casos:
 * ------------------------------------
 */

--a. Os registros de financeiro só poderão ser inseridos no momento em que um registro de venda for atualizado para ‘REGISTRADO’ 
--   (um campo venda.situacao for atualizado para ‘REGISTRADO’, por exemplo).

ALTER TABLE Venda
	ADD Situacao VARCHAR(14) CONSTRAINT DF_Situacao DEFAULT('NÃO REGISTRADO')

SELECT * FROM Venda

SET dateformat dmy

BEGIN TRANSACTION RegistroFinanceiro
	BEGIN TRY
		UPDATE Venda SET Situacao = 'REGISTRADO' WHERE CodVenda = 1
		INSERT INTO Financeiro (Valor, DataLancamento, DataVencimento, DataLiquidacao, CodVenda) VALUES
			(10.00, '31/07/2017', '31/10/2017', '31/12/2017', 1)
		COMMIT TRANSACTION RegistroFinanceiro
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION RegistroFinanceiro
	END CATCH

		
SELECT * FROM Financeiro

--b. Após a inserção de cada item da venda, os estoques dos produtos deverão ser atualizados.


--c. Quando uma venda for inserida, sua comissão pode ser inserida.


