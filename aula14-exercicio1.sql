/**
 * 1. Analise o modelo conceitual, crie o modelo físico correspondente (Banco de Dados) e resolva os itens:
 */

/**
 * Contribuintes (+CodContribuinte, Email, DtNascimento, Nome)
 * 
 * Tributos (+CodTributo, Descricao)
 * 
 * Pagamentos (+CodPagamento, DtPagamento, DtVencimento, Valor, Juros, Multa, -CodTributo, -CodContribuinte)
 *           CodTributo referencia Tributo
 *           CodContribuinte referencia Contribuinte
 */

CREATE DATABASE Aula14Exercicio1

USE Aula14Exercicio1

CREATE TABLE Contribuinte (
	CodContribuinte INT CONSTRAINT PK_Contribuinte PRIMARY KEY IDENTITY (1,1),
	Nome VARCHAR(30) NOT NULL,
	DtNascimento DATE NOT NULL,
	Email VARCHAR(30) NOT NULL
)

CREATE TABLE Tributo (
	CodTributo INT CONSTRAINT PK_Tributo PRIMARY KEY IDENTITY (1,1),
	Descricao CHAR(10)
)

CREATE TABLE Pagamento (
	CodPagamento INT CONSTRAINT PK_Pagamento PRIMARY KEY IDENTITY (1,1),
	DtPagamento DATE,
	DtVencimento DATE NOT NULL,
	Valor MONEY,
	Juros MONEY,
	Multa MONEY,
	CodContribuinte INT NOT NULL CONSTRAINT FK_Pagamento_Contribuinte FOREIGN KEY REFERENCES Contribuinte (CodContribuinte),
	CodTributo INT NOT NULL CONSTRAINT FK_Pagamento_Tributo FOREIGN KEY REFERENCES Tributo (CodTributo)
)

SET dateformat dmy

-- a) Crie storeds procedures para inserir dados nas tabelas criadas.

CREATE PROCEDURE SP_InsereContribuinte
@Nome VARCHAR(30),
@DtNascimento DATE,
@Email VARCHAR(30)
AS
BEGIN
	INSERT INTO Contribuinte (Nome, DtNascimento, Email) VALUES
		(@Nome, @DtNascimento, @Email)
END

EXEC SP_InsereContribuinte 'Joao', '10-01-1997', 'joao@email.com' 
EXEC SP_InsereContribuinte 'José', '10-02-1997', 'jose@email.com' 
EXEC SP_InsereContribuinte 'Maria', '13-01-1997', 'maria@email.com' 
EXEC SP_InsereContribuinte 'Maravilha', '10-01-1994', 'maravilha@email.com' 
EXEC SP_InsereContribuinte 'Rosa', '10-05-1997', 'rosa@email.com' 
EXEC SP_InsereContribuinte 'Adelaide', '16-01-1996', 'adelaide@email.com' 

SELECT * FROM Contribuinte

CREATE PROCEDURE SP_InsereTributo
@Descricao CHAR(10)
AS
BEGIN
	INSERT INTO Tributo (Descricao) VALUES
		(@Descricao)
END

EXEC SP_InsereTributo 'ICMS'
EXEC SP_InsereTributo 'ISS'

SELECT * FROM Tributo 

CREATE PROCEDURE SP_InserePagamento
@DtVencimento DATE,
@Valor MONEY,
@CodContribuinte INT,
@CodTributo INT
AS
BEGIN
	INSERT INTO Pagamento (DtVencimento, Valor, CodContribuinte, CodTributo) VALUES
		(@DtVencimento, @Valor, @CodContribuinte, @CodTributo)
END

EXEC SP_InserePagamento '12-10-2017', 156.87, 26, 3
EXEC SP_InserePagamento '13-10-2017', 158.83, 27, 3
EXEC SP_InserePagamento '14-10-2017', 134.64, 30, 3
EXEC SP_InserePagamento '15-10-2017', 231.37, 31, 3
EXEC SP_InserePagamento '16-10-2017', 312.86, 28, 3
EXEC SP_InserePagamento '17-10-2017', 123.54, 29, 3

SELECT * FROM Pagamento

-- b) Crie uma stored procedure para editar um determinado registro de pagamento (qualquer campo poderá ser editado).

CREATE PROCEDURE SP_EditaPagamento
@CodPagamento INT,
@DtPagamento DATE,
@DtVencimento DATE,
@Valor MONEY,
@Juros DECIMAL(10,2),
@Multa DECIMAL(10,2),
@CodContribuinte INT,
@CodTributo INT
AS
BEGIN
	UPDATE Pagamento
	SET DtPagamento = @DtPagamento, DtVencimento = @DtVencimento, Valor = @Valor,
		Juros = @Juros, Multa = @Multa, CodContribuinte = @CodContribuinte, CodTributo = @CodTributo
	WHERE CodPagamento = @CodPagamento
END

EXEC SP_EditaPagamento 37, NULL, '15-11-2017', 176.54, NULL, NULL, 28, 4

SELECT * FROM Pagamento

-- c) Crie uma stored procedure para efetuar a liquidação de um pagamento.
-- Ela deverá receber como parâmetros o Valor da Multa e dos Juros, além da data de pagamento.

CREATE PROCEDURE SP_LiquidaPagamento
@CodPagamento INT,
@DtPagamento DATE,
@Juros MONEY,
@Multa MONEY
AS
BEGIN
	UPDATE Pagamento
	SET DtPagamento = @DtPagamento, Juros = @Juros, Multa = @Multa
	WHERE CodPagamento = @CodPagamento
END

EXEC SP_LiquidaPagamento 38, '14-10-2017', 2, 3.5 
EXEC SP_LiquidaPagamento 42, '17-10-2017', 0, 0 

SELECT * FROM Pagamento

-- d) Dado um código de contribuinte, mostre o total dos pagamentos liquidados e o total dos pagamentos em aberto para ele.

CREATE PROCEDURE SP_PagamentosContribuinte
@CodContribuinte INT
AS
BEGIN
	DECLARE @TotalPagamento MONEY
	DECLARE @TotalPagamentoLiquidado MONEY
	DECLARE @TotalPagamentoAberto MONEY
	SELECT @TotalPagamento = SUM(Valor) FROM Pagamento Where CodContribuinte = @CodContribuinte
	SELECT @TotalPagamentoAberto = SUM(Valor) FROM Pagamento Where CodContribuinte = @CodContribuinte AND DtPagamento IS NULL	
	SELECT @TotalPagamentoLiquidado = SUM(Valor) FROM Pagamento Where CodContribuinte = @CodContribuinte AND DtPagamento IS NOT NULL
	PRINT 'Total de Pagamento: ' + cast(@TotalPagamento AS CHAR(15)) + CHAR(13) + CHAR(10) +
		'Total de Pagamentos Abertos: ' + cast(@TotalPagamentoAberto AS CHAR(15)) + CHAR(13) + CHAR(10) +
		'Total de Pagamentos Liquidados: ' + cast(@TotalPagamentoLiquidado AS CHAR(15))
END

EXEC SP_PagamentosContribuinte 27

-- e) Receba o código de um tributo e liste a média dos pagamentos liquidados deste tributo.

CREATE PROCEDURE SP_MediaPagamentoLiquidadoTributo
@CodTributo INT
AS
BEGIN
	SELECT AVG(Valor) AS MediaLiquidados
	FROM Pagamento
	WHERE CodTributo = @CodTributo AND DtPagamento IS NOT NULL 
END

EXEC SP_MediaPagamentoLiquidadoTributo 3

-- f) Liste a soma dos pagamentos em aberto por contribuinte.

CREATE PROCEDURE SP_SomaPagamentoAbertoContribuinte
@CodContribuinte INT
AS
BEGIN
	SELECT SUM(Valor) AS SomaAbertos
	FROM Pagamento
	WHERE CodContribuinte = @CodContribuinte AND DtPagamento IS NULL 
END

EXEC SP_SomaPagamentoAbertoContribuinte 27

-- g) Qual foi o contribuinte que mais pagou tributos com multa?

/**
 * PERGUNTAR PRO CLAUDIO POIS TA MUITO DIFICIL
 */

SELECT * FROM Pagamento

SELECT MAX(PagamentoMulta.TotalPagamentos) AS TotalPagamentosComMulta
FROM (
	SELECT CodContribuinte AS Codigo, COUNT(Multa) AS TotalPagamentos FROM Pagamento
	WHERE Multa IS NOT NULL AND Multa <> 0
	GROUP BY CodContribuinte
) AS PagamentoMulta

SELECT CodContribuinte AS Codigo, COUNT(Multa) AS TotalPagamentos FROM Pagamento
WHERE Multa IS NOT NULL AND Multa <> 0
GROUP BY CodContribuinte

HAVING MAX(TotalPagamentos)
