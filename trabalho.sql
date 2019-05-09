/**
 * Trabalho da Disciplina de Laboratório de Banco de Dados
 * Professor:
 * - Cláudio Paiva
 * Alunos:
 * - Andreia Caroline Silva Alves
 * - Getulio Vinicius Teixeira da Silva
 * - Michelle Geice Gonçalves Meletti
 * - Rafael Afonso da Silva Faria
 * - Socrates Eduardo Chieregato
 */

CREATE DATABASE TrabalhoBD

USE TrabalhoBD

/**
 * MODELO LÓGICO
 * 
 * Endereco (* CodEndereco, - Rua, - Numero, - Bairro, - etc)
 * 
 * TipoCliente (* CodTipo, + Tipo)
 * 
 * Cliente (* CodCliente, + CodTipoClinete, + CodEndereco, - DataCadastro)
 * CodTipoCliente referencia Cliente
 * CodEndereco referencia Endereco
 * 
 * PessoaFisica (* CodPessoaFisica, - Nome, - Sexo, - DataNascimento, - NumeroCNH, - DataPrimeiraCNH, - DataVencimentoCNH, - RG, - CPF, + CodCliente)
 * CodCliente referencia Cliente
 * 
 * PessoaJuridica (* CodPessoaJuridica, - CNPJ, - RazaoSocial, - InscricaoEstadual, + CodCliente)
 * CodCliente referencia Cliente
 * 
 * Funcionario (* CodFuncionario, + CodPessoaFisica, - DataAdmissao, - SalarioFixo)
 * CodPessoaFisica referencia PessoaFisica
 * 
 * SalarioMensal (* CodSalario, + CodFuncionario, - Comissão, - SalarioTotal, - DataSalario)
 * CodFuncionario referencia Funcionario
 * 
 * ComissaoLiquidado (* CodComissao, - ValorLocacao, - DataLancameto, - DataPagamento, + CodLocacao, + CodFuncionario)
 * CodFuncionario referencia Funcionario
 * CodLocacao referencia Locacao
 * 
 * Seguradora (* CodSeguradora, + CodPessoaJuridica)
 * CodPessoaJuridica referencia PessoaJuridica
 * 
 * TipoVeiculo (* CodTipoVeiculo, - Tipo, - Descricao, - Pontuacao)
 * 
 * Filial (* CodFilial, + CodEndereco)
 * CodEndereco referencia Endereco
 * 
 * Veiculo (* CodVeiculo, - DataCadastro, - Placa, - Chassi, - NumeroMotor, - Ano, - Modelo, - Cor, - Quilometragem, - ValorPeriodoRevisao, - ProximaRevisao, - Disponivel, + CodTipoVeiculo, + CodFilial)
 * CodTipoVeiculo referencia TipoVeiculo
 * CodFilial referencia Filial
 * 
 * Apolice (* CodApolice, + CodVeiculo, + CodSeguradora, - DataLancamento, - DataVencimento)
 * CodVeiculo referencia Veiculo
 * CodSeguradora referencia Seguradora
 * 
 * Revisao (* CodRevisao, + CodVeiculo, - DataProgramacao, - DataRevisao)
 * CodVeiculo referencia Veiculo
 * 
 * Reserva (* CodReserva, - DataRetirada, - DataDevolucao, - Status, + CodFilialRetirada, + CodFilialDevolucao, + CodVeiculo, + CodFuncionario)
 * CodFilialRetirada referencia Filial
 * CodFilialDevolucao referencia Filial
 * CodVeiculo referencia Veiculo
 * CodFuncionario referencia Funcionario
 * 
 * Locacao (* CodLocacao, + CodReserva, + PrincipalCondutor, - Status)
 * CodReserva referencia Reserva
 * PrincipalCondutor referencia PessoaFisica
 * 
 */

/*
 * CRIAÇÃO DAS TABELAS
 */

CREATE TABLE Endereco (
	CodEndereco INT CONSTRAINT PK_Endereco PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	Rua VARCHAR(50) NOT NULL,
	Numero CHAR(5),
	Complemento CHAR(10),
	CEP CHAR(10) NOT NULL,
	Bairro VARCHAR(50),
	Cidade VARCHAR(50) NOT NULL,
	Estado CHAR(2) NOT NULL
)

INSERT INTO Endereco (Rua, Numero, Complemento, CEP, Cidade, Estado) VALUES
	('Ruazinha', '987', 'Ap 3', '14.998-097', 'Franca', 'SP'),
	('Pedras', '3234', 'Casa', '14.383-777', 'Franca', 'SP'),
	('Comércio', '8765', 'Loja 1', '14.234-098', 'Franca', 'SP'),
	('Jardins', '8787', 'Loja 2', '14.333-123', 'Pedregulho', 'SP'),
	('Bancarios', '1999', 'Loja 3', '14.999-345', 'Belo Horizonte', 'MG'),
	('Comércio', '123', 'Casa', '14.234-098', 'Franca', 'SP'),
	('Justiça', '124', 'Ap 1', '14.234-123', 'Franca', 'SP'),
	('Bancarios', '143', 'AP 2', '14.234-345', 'Belo Horizonte', 'MG'),
	('Industria', '153', 'Casa', '14.234-456', 'Ribeirão Preto', 'SP'),
	('Churrasqueiros', '1439', 'Escr. 2', '23.234-385', 'Goiania', 'GO'),
	('Reformados', '1503', 'Escr. 3', '24.234-456', 'Rio de Janiero', 'RJ'),
	('Irraaaaaaaa', '443', 'Bloco 2', '98.234-385', 'Goiania', 'GO'),
	('Reformados', '1503', 'Escr. 3', '14.549-456', 'Franca', 'SP')
	
UPDATE Endereco SET Bairro = 'Parque Progresso' WHERE CodEndereco = 5
	
SELECT * FROM Endereco

CREATE TABLE TipoCliente (
	CodTipoCliente INT CONSTRAINT PK_TipoCliente PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	Tipo VARCHAR(30) NOT NULL
)

INSERT INTO TipoCliente (Tipo) VALUES
	('Ouro'),
	('Prata'),
	('Bronze'),
	('Platina')

SELECT * FROM TipoCliente

CREATE TABLE Cliente (
	CodCliente INT CONSTRAINT PK_Cliente PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	CodTipoCliente INT NOT NULL CONSTRAINT FK_Cliente_TipoCliente FOREIGN KEY REFERENCES TipoCliente (CodTipoCliente), -- ITEM a)
	DataCadastro DATETIME CONSTRAINT DF_DataCadastroCliente DEFAULT(GETDATE()), -- ITEM b)
	CodEndereco INT NOT NULL CONSTRAINT FK_Cliente_Endereco FOREIGN KEY REFERENCES Endereco(CodEndereco),
)

INSERT INTO Cliente (CodTipoCliente, CodEndereco) VALUES
	(1,1),
	(2,2),
	(3,3),
	(4,4),
	(1,5),
	(2,6),
	(3,7),
	(4,8),
	(1,9),
	(1,10),
	(1,11)
	
SELECT * FROM Cliente

CREATE TABLE PessoaFisica (
	CodPessoaFisica INT CONSTRAINT FK_PessoaFisica_Cliente FOREIGN KEY REFERENCES Cliente(CodCliente),
	Nome VARCHAR(50) NOT NULL,
	Sexo CHAR(1) NOT NULL CONSTRAINT CK_Sexo CHECK (Sexo IN ('F', 'M')), -- ITEM d)
	DataNascimento DATE NOT NULL,
	NumeroCNH CHAR(20) NOT NULL,
	DataPrimeiraCNH DATE NOT NULL,
	DataVencimentoCNH DATE NOT NULL,
	RG CHAR(12) NOT NULL,
	CPF CHAR(14) NOT NULL,
	CONSTRAINT PK_PessoaFisica PRIMARY KEY (CodPessoaFisica) -- ITEM c)
)

SET DATEFORMAT dmy

INSERT INTO PessoaFisica (CodPessoaFisica, Nome, Sexo, DataNascimento, NumeroCNH, DataPrimeiraCNH, DataVencimentoCNH, RG, CPF) VALUES
	(1, 'João', 'M', '19-04-1990', '1234567890', '14-09-2008', '20-08-2017', '12.234.098-4', '222.344.555-66'),
	(2, 'Maria', 'F', '19-08-1998', '1234567890', '14-09-2008', '20-12-2017', '12.666.098-8', '333.344.555-66'),
	(3, 'José', 'M', '19-05-1995', '1234567890', '14-09-2008', '20-08-2018', '12.555.098-3', '666.344.555-66'),
	(4, 'Cassandra', 'F', '19-03-1992', '1234567890', '14-09-2008', '25-09-2017', '15.444.098-6', '777.344.555-66'),
	(5, 'Washington', 'M', '20-04-1980', '1234567890', '14-09-2008', '26-12-2017', '13.222.098-7', '111.344.555-66'),
	(6, 'Marília', 'F', '30-06-1985', '1234567890', '14-09-2008', '24-01-2018', '21.999.098-5', '200.344.555-66')
	
SELECT * FROM PessoaFisica

CREATE TABLE PessoaJuridica (
	CodPessoaJuridica INT CONSTRAINT FK_PessoaJuridica_Cliente FOREIGN KEY REFERENCES Cliente(CodCliente),
	CNPJ CHAR(20) NOT NULL,
	RazaoSocial VARCHAR(50) NOT NULL,
	InscricaoEstadual CHAR(20) NOT NULL,
	CONSTRAINT PK_PessoaJuridica PRIMARY KEY (CodPessoaJuridica) -- ITEM c)
)

INSERT INTO PessoaJuridica (CodPessoaJuridica, CNPJ, RazaoSocial, InscricaoEstadual) VALUES
	(7, '87.291.578/0001-09', 'Armazens Gerais', '9080804032438'),
	(8, '88.291.444/0001-29', 'Agua da Fonte', '9080801543523'),
	(9, '66.555.578/0001-39', 'Cervejaria do Zé', '9080865463573'),
	(10, '88.933.665/0004-11', 'Seguradora Lider', '9080801543523'),
	(11, '77.555.333/0001-22', 'Seguradora Segura Peão', '9080865463573')

SELECT * FROM PessoaJuridica

CREATE TABLE Funcionario (
	CodFuncionario INT CONSTRAINT PK_Funcionario PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	CodPessoaFisica INT NOT NULL CONSTRAINT FK_Funcionario_PessoaFisica FOREIGN KEY REFERENCES PessoaFisica(CodPessoaFisica),
	DataAdmissao DATE NOT NULL,
	SalarioFixo MONEY NOT NULL
)

INSERT INTO Funcionario (CodPessoaFisica, DataAdmissao, SalarioFixo) VALUES
	(5, '10-08-2010', 2000),
	(6, '20-08-2010', 1800)
	
SELECT * FROM Funcionario

CREATE TABLE SalarioMensal (
	CodSalario INT CONSTRAINT PK_SalarioMensal PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	CodFuncionario INT NOT NULL CONSTRAINT FK_SalarioMensal_Funcionario FOREIGN KEY REFERENCES Funcionario(CodFuncionario),
	DataSalario DATE NOT NULL,
	Comissao MONEY CONSTRAINT DF_Comissao DEFAULT (0),
	SalarioTotal MONEY NOT NULL
)

INSERT INTO SalarioMensal (CodFuncionario, DataSalario, Comissao, SalarioTotal) VALUES
	(1, '05-09-2010', 200, 2200),
	(2, '05-09-2010', 200, 2000),
	(1, '05-10-2010', 100, 2100),
	(2, '05-10-2010', 200, 2000),
	(1, '05-11-2010', 150, 2150),
	(2, '05-11-2010', 50, 1850),
	(1, '05-12-2010', 300, 2300),
	(2, '05-12-2010', 500, 2300)

SELECT * FROM SalarioMensal

CREATE TABLE Seguradora (
	CodSeguradora INT CONSTRAINT PK_Seguradora PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	CodPessoaJuridica INT NOT NULL CONSTRAINT FK_Seguradora_PessoaJuridica FOREIGN KEY REFERENCES PessoaJuridica(CodPessoaJuridica)
)

INSERT INTO Seguradora (CodPessoaJuridica) VALUES
	(10),
	(11)
	
SELECT * FROM Seguradora

CREATE TABLE TipoVeiculo (
	CodTipoVeiculo INT CONSTRAINT PK_TipoVeiculo PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	Tipo CHAR(2) NOT NULL UNIQUE,
	Descricao TEXT NOT NULL,
	Pontuacao INT NOT NULL
)

INSERT INTO TipoVeiculo (Tipo, Descricao, Pontuacao) VALUES
	('A1', 'carros populares mais simples, com 2 portas, sem ar-condicionado, sem vidros elétricos e sem direção hidráulica', 2),
	('A5', 'carros tipo sedan, com ar-condicionado, som, air-bag e direção hidráulica', 4 ),
	('C1', 'modelos mais simples de passeio', 6),
	('C5', 'modelos completos de passeio', 7),
	('C8', 'modelos que somente são alugados para finalidade de transporte de cargas', 6)
	
SELECT * FROM TipoVeiculo

CREATE TABLE Filial (
	CodFilial INT CONSTRAINT PK_Filial PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	CodEndereco INT NOT NULL CONSTRAINT FK_Filial_Endereco FOREIGN KEY REFERENCES Endereco(CodEndereco)
)

INSERT INTO Filial (CodEndereco) VALUES
	(12),
	(13)

SELECT * FROM Filial

DROP TABLE Veiculo

CREATE TABLE Veiculo (
	CodVeiculo INT CONSTRAINT PK_Veiculo PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	DataCadastro DATETIME CONSTRAINT DF_DataCadastroVeiculo DEFAULT(GETDATE()), -- ITEM b) 
	Placa CHAR(8) NOT NULL UNIQUE,
	Chassi VARCHAR(30) NOT NULL UNIQUE,
	NumeroMotor VARCHAR(30) NOT NULL,
	Ano CHAR(4) NOT NULL,
	Modelo VARCHAR(30) NOT NULL,
	Cor CHAR(20) NOT NULL,
	Quilometragem INT NOT NULL,
	ValorPeriodoRevisao INT NOT NULL,
	ProximaRevisao INT,
	Disponivel CHAR(1) NOT NULL,
	CodTipoVeiculo INT NOT NULL CONSTRAINT FK_Veiculo_TipoVeiculo FOREIGN KEY REFERENCES TipoVeiculo(CodTipoVeiculo),
	CodFilial INT NOT NULL CONSTRAINT FK_Veiculo_Filial FOREIGN KEY REFERENCES Filial(CodFilial)
)

INSERT INTO Veiculo (Placa, Chassi, NumeroMotor, Ano, Modelo, Cor, Quilometragem, ValorPeriodoRevisao, ProximaRevisao, Disponivel, CodTipoVeiculo, CodFilial) VALUES
	('TED-1233', 'HW2938DKF9394KD', '8765434323', '2015', 'VW Gol', 'Prata', 0, 10000, NULL, 'S', 1, 1),
	('FTR-1212', 'HW293DER33394KD', '8465434399', '2017', 'Ford Focus', 'Prata', 0, 10000, NULL, 'S', 2, 1),
	('TED-1987', 'KF9394KDHW2938D', '8743235653', '2016', 'Hyundai HB-20', 'Prata', 0, 8000, NULL, 'S', 3, 1),
	('YYY-1563', 'HW293KD8DKF9394', '3432387654', '2014', 'Toyota Corola', 'Preto', 0, 8000, NULL, 'S', 4, 1),
	('YTY-1263', '9394HW293KD8DKF', '2387343654', '2017', 'Fiat Fiorino', 'Branco', 0, 15000, NULL, 'S', 5, 1)
	

SELECT * FROM Veiculo

CREATE TABLE Apolice (
	CodApolice INT CONSTRAINT PK_Apolice PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	CodVeiculo INT NOT NULL CONSTRAINT FK_Apolice_Veiculo FOREIGN KEY REFERENCES Veiculo(CodVeiculo),
	CodSeguradora INT NOT NULL CONSTRAINT FK_Apolice_Seguradora FOREIGN KEY REFERENCES Seguradora(CodSeguradora),
	DataLancamento DATE NOT NULL,
	DataVencimento DATE NOT NULL,
	CONSTRAINT CK_Data CHECK (DataLancamento < DataVencimento) --ITEM g)
)

INSERT INTO Apolice (CodVeiculo, CodSeguradora, DataLancamento, DataVencimento) VALUES
	('1', '2', '29-11-2017', '28-11-2018'),
	('2', '1', '29-11-2017', '06-12-2017'),
	('3', '2', '29-11-2017', '28-12-2017'),
	('4', '1', '29-11-2017', '28-11-2018'),
	('5', '2', '29-11-2017', '25-12-2017')

CREATE TABLE Revisao (
	CodRevisao INT CONSTRAINT PK_Revisao PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	CodVeiculo INT NOT NULL CONSTRAINT FK_Revisao_Veiculo FOREIGN KEY REFERENCES Veiculo(CodVeiculo),
	DataProgramacao DATETIME CONSTRAINT DF_DataProgramacao DEFAULT (GETDATE()), --Item f)
	DataRevisao DATE NOT NULL
	--Status CHAR(10) CONSTRAINT CK_Status CHECK (Status IN ('Agendada', 'Cancelada', 'Realizada'))
)

INSERT INTO Revisao (CodVeiculo, DataRevisao) VALUES
	(2, '13-01-2018'),
	(3, '13-02-2018'),
	(4, '13-03-2018'),
	(5, '13-04-2018')

SELECT * FROM Revisao

DROP TABLE Reserva

CREATE TABLE Reserva (
	CodReserva INT CONSTRAINT PK_Reserva PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	DataRetirada DATETIME NOT NULL,
	DataDevolucao DATETIME NOT NULL,
	Status CHAR(10) NOT NULL,
	CodFilialRetirada INT NOT NULL CONSTRAINT FK_Reserva_Filial_Retirada FOREIGN KEY REFERENCES Filial(CodFilial),
	CodFilialDevolucao INT NOT NULL CONSTRAINT FK_Reserva_Filial_Devolucao FOREIGN KEY REFERENCES Filial(CodFilial),
	CodVeiculo INT NOT NULL CONSTRAINT FK_Reserva_Veiculo FOREIGN KEY REFERENCES Veiculo(CodVeiculo),
	CodFuncionario INT NOT NULL CONSTRAINT FK_Reserva_Funcionario FOREIGN KEY REFERENCES Funcionario(CodFuncionario),
	CodCliente INT NOT NULL CONSTRAINT FK_Reserva_Cliente FOREIGN KEY REFERENCES Cliente (CodCliente)
)

SET dateformat dmy

INSERT INTO Reserva VALUES
	('14-12-2017', '15-12-2017', 'Agendada', 1, 2, 1, 1, 1),
	('15-12-2017', '21-12-2017', 'Cancelada', 1, 2, 2, 1, 3),
	('16-12-2017', '18-12-2017', 'Agendada', 2, 1, 1, 2, 5),
	('17-12-2017', '21-12-2017', 'Agendada', 1, 1, 3, 2, 7),
	('18-12-2017', '21-12-2017', 'Agendada', 1, 2, 4, 1, 9)
	
SELECT * FROM Reserva

CREATE TABLE Locacao (
	CodLocacao INT CONSTRAINT PK_Locacao PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	CodReserva INT NOT NULL CONSTRAINT FK_Locacao_Reserva FOREIGN KEY REFERENCES Reserva(CodReserva),
	PrincipalCondutor INT NOT NULL CONSTRAINT FK_Locacao_PessoaFisica FOREIGN KEY REFERENCES PessoaFisica(CodPessoaFisica), -- ITEM e)
	Status CHAR(10) NOT NULL
)

INSERT INTO Locacao VALUES
	(1, 1, 'Encerrada'),
	(2, 6, 'Aberta'),
	(3, 4, 'Aberta'),
	(4, 2, 'Aberta')

SELECT * FROM Locacao

CREATE TABLE ComissaoLiquidado (
	CodComissao INT CONSTRAINT PK_ComissaoLiquidado PRIMARY KEY IDENTITY (1,1), -- ITEM c)
	ValorLocacao MONEY,
	DataLancamento DATE CONSTRAINT DF_DataLancamento DEFAULT (GETDATE()),
	DataPagamento DATE,
	CodLocacao INT NOT NULL CONSTRAINT FK_ComissaoLiquidado_Locacao FOREIGN KEY REFERENCES Locacao(CodLocacao),
	CodFuncionario INT NOT NULL CONSTRAINT FK_ComissaoLiquidado_Funcionario FOREIGN KEY REFERENCES Funcionario(CodFuncionario)
)

INSERT INTO ComissaoLiquidado (ValorLocacao, CodLocacao, CodFuncionario) VALUES
	(200, 1, 1),
	(200, 2, 2),
	(200, 3, 1),
	(200, 4, 2)
	
SELECT * FROM ComissaoLiquidado

/**
 * a) Considerando todas as regras de negócio apresentadas,
 * crie uma view que mostre todos os veículos disponíveis para reserva de locação
 * (observe novamente as regras de quando um veículo pode ser reservado ou não).
 */

CREATE VIEW VeiculosDisponiveis AS
	SELECT V.CodVeiculo, V.Placa, V.Modelo
	FROM Veiculo AS V
	WHERE V.Disponivel = 'S'
	
SELECT * FROM VeiculosDisponiveis
			
/**
 * b) Crie uma view que mostre os principais dados dos veículos locados atualmente e os clientes que os locaram.
 */

CREATE VIEW VeiculosLocados AS
	SELECT L.CodLocacao, V.CodVeiculo, V.Modelo, R.CodCliente
	FROM Locacao AS L
		INNER JOIN Reserva AS R
		ON L.CodReserva = R.CodReserva
		INNER JOIN Veiculo AS V
		ON R.CodVeiculo = V.CodVeiculo

SELECT * FROM VeiculosLocados

/*
 * c) Crie uma view que mostre os veículos e os dados das suas apólices de seguro:
 * data de início do seguro, nome da seguradora, data de vencimento da apólice. 
 */

CREATE VIEW VeiculosApolices AS
	SELECT V.CodVeiculo, A.CodApolice, A.DataLancamento AS Inicio, A.DataVencimento AS Fim, PJ.RazaoSocial 
	FROM Veiculo AS V
		INNER JOIN Apolice AS A
		ON V.CodVeiculo = A.CodVeiculo
		INNER JOIN Seguradora AS S
		ON A.CodSeguradora = S.CodSeguradora
		INNER JOIN PessoaJuridica AS PJ
		ON S.CodPessoaJuridica = PJ.CodPessoaJuridica
	
SELECT * FROM VeiculosApolices

/*
 * d) Crie uma view que liste os nomes dos funcionários e suas pontuações dentro do mês atual,
 * mostrando o funcionário que mais pontuou no início da lista.
 */

CREATE VIEW PontuacaoFuncionario AS
	SELECT YEAR(R.DataRetirada) AS Ano, MONTH(R.DataRetirada) AS Mes, F.CodFuncionario, PF.Nome, SUM(TV.Pontuacao) AS Pontuacao
	FROM PessoaFisica AS PF
		INNER JOIN Funcionario AS F
		ON PF.CodPessoaFisica = F.CodPessoaFisica
		INNER JOIN Reserva AS R
		ON F.CodFuncionario = R.CodFuncionario
		INNER JOIN Veiculo AS V
		ON R.CodVeiculo = V.CodVeiculo
		INNER JOIN TipoVeiculo AS TV
		On V.CodTipoVeiculo = TV.CodTipoVeiculo
	WHERE MONTH(R.DataRetirada) = '12'
	GROUP BY YEAR(R.DataRetirada), MONTH(R.DataRetirada), F.CodFuncionario, PF.Nome

SELECT * FROM PontuacaoFuncionario
ORDER BY Pontuacao DESC

/*
 * a) Crie uma stored procedure que receba o código de um veículo e a data da revisão como parâmetro
 * e gere um registro com programação de revisão de veículo, considerando os dados que devem ser 
 * observados para que seja feita a revisão.
 */

CREATE PROCEDURE SP_InsereRevisao
@CodVeiculo INT,
@DataRevisao DATE
AS
BEGIN
	DECLARE @QuilometragemAtual INT, @ProximaRevisao INT
	SELECT @QuilometragemAtual = Quilometragem, @ProximaRevisao = ProximaRevisao
	FROM Veiculo WHERE CodVeiculo = @CodVeiculo
	IF @QuilometragemAtual >= @ProximaRevisao
		INSERT INTO Revisao (CodVeiculo, DataRevisao) VALUES (@CodVeiculo, @DataRevisao)
	ELSE
		PRINT 'Quilometragem Atual: ' + cast(@QuilometragemAtual AS CHAR(15)) +' Insuficiente para revisão.'
		 + CHAR(13) + CHAR(10) + 'A próxima revisão deve ocorrer com a quilometragem mínima de: ' + 
		cast(@ProximaRevisao AS CHAR(15))
END

UPDATE Veiculo SET ProximaRevisao = 10000 WHERE CodVeiculo = 1

EXEC SP_InsereRevisao 1, '12-01-2018'

SELECT * FROM Revisao

/*
 * b) Crie uma stored procedure que faça a alteração da pontuação de um determinado tipo de carros
 * (A1, A5, C1, etc). Ela deverá receber como parâmetros o nome do tipo e o novo valor da pontuação a ser gravado no BD.
 */

CREATE PROCEDURE SP_AlterarPontuacao
@Tipo CHAR(2),
@Pontuacao INT
AS
BEGIN
	IF @Tipo = (SELECT Tipo FROM TipoVeiculo WHERE Tipo = @Tipo)
		UPDATE TipoVeiculo SET Pontuacao = @Pontuacao WHERE Tipo = @Tipo
	ELSE
		PRINT 'Tipo de Veiculo "' + @Tipo + '" não cadastrado.'
END

EXEC SP_AlterarPontuacao 'A1', 7

SELECT * FROM TipoVeiculo

/**
 * c) Crie uma stored procedure que faça o cancelamento de uma reserva de locação,
 * recebendo como parâmetro o código da reserva.
 * Atenção: não eliminar a reserva do BD, apenas mudar o seu status para Cancelado.
 */

CREATE PROCEDURE SP_CancelaReserva
@CodReserva INT
AS
BEGIN
	IF @CodReserva = (SELECT CodReserva FROM Reserva WHERE (CodReserva = @CodReserva) AND (Status = 'Agendada'))
		UPDATE Reserva SET Status = 'Cancelada' WHERE CodReserva = @CodReserva
	ELSE
		PRINT 'Reserva "' + cast(@CodReserva AS VARCHAR(10)) + '" não pode ser cancelada.'	
END

EXEC SP_CancelaReserva 1

SELECT * FROM Reserva

/**
 * d) Crie uma stored procedure que recebe como parâmetro um valor percentual e recalcule
 * o salário fixo de todos os funcionários que tenham pontuação acima de 150 no mês atual,
 * dando um aumento de salário, cujo percentual de aumento também será recebido como parâmetro.
 */

CREATE PROCEDURE SP_AumentaSalario
@ValorPercentual DECIMAL(10,2)
AS
BEGIN
	UPDATE Funcionario SET SalarioFixo = (SalarioFixo + (SalarioFixo * (@ValorPercentual/100)))
	WHERE CodFuncionario IN (SELECT CodFuncionario FROM PontuacaoFuncionario WHERE Pontuacao >= 16) -- 16 pra testar
END

SELECT CodFuncionario FROM PontuacaoFuncionario WHERE Pontuacao >= 16

SELECT * FROM PontuacaoFuncionario
ORDER BY Pontuacao DESC

EXEC SP_AumentaSalario 10

SELECT * FROM Funcionario

/**
 * a) Quando for inserida uma reserva e a carteira de habilitação do condutor estiver vencida
 * ou com data de vencimento para os próximos 30 dias, não poderá ser feita a reserva.
 */

-- O condutor principal será conhecido no momento da Locacao, sendo assim optamos por verificar se a CNH
-- está ou não vencida pela tabela Locacao ao invés de verificar na tabela Reserva

CREATE TRIGGER CarteiraHabilitacao
ON Locacao
FOR INSERT
AS
	DECLARE @DataVencimentoCNH DATE, @CodLocacao INT
	SELECT @DataVencimentoCNH = PF.DataVencimentoCNH, @CodLocacao = L.CodLocacao
	FROM Locacao AS L
		INNER JOIN PessoaFisica AS PF
		ON L.PrincipalCondutor = PF.CodPessoaFisica
	WHERE PF.CodPessoaFisica = (SELECT PrincipalCondutor FROM inserted)
	IF @DataVencimentoCNH < (GETDATE() + 30)
		BEGIN
			PRINT 'A Carteira de Habilitação irá vencer em menos de 30 dias, portanto deverá ser renovada para que seja feita uma Locação.'
			DELETE Locacao WHERE CodLocacao = @CodLocacao			
		END 
		
UPDATE Reserva SET Status = 'Agendada' WHERE CodReserva = 10

INSERT INTO Locacao VALUES
	(1, 5, 'Aberta')
	
SELECT * FROM Locacao

SELECT * FROM PessoaFisica

SELECT * FROM Reserva

/**
 * b) Quando uma reserva se transformar em locação, o veículo desta reserva precisará ter o valor
 * do campo “disponível” alterado para “N”, impedindo que seja incluído novamente em outra locação. 
 */

CREATE TRIGGER VeiculoIndisponivel
ON Reserva
FOR UPDATE
AS
	IF (SELECT Status FROM inserted) = 'Confirmada'
		UPDATE Veiculo SET Disponivel = 'N'	WHERE CodVeiculo = (SELECT CodVeiculo FROM inserted)

SELECT * FROM Reserva

UPDATE Reserva SET Status = 'Confirmada' WHERE CodReserva = 1

SELECT CodVeiculo, Disponivel FROM Veiculo

/**
 * c) Uma locação que já esteja com status de “encerrada” não poderá ter seus dados alterados.
 */

-- E

/*
 * d) Quando uma locação for encerrada (o carro foi devolvido), caso esta locação já esteja paga
 * (valor financeiro liquidado) a tabela comissaoLiquidados será alimentada com as informações do
 * funcionário, valor da locação e data do seu pagamento. Para que seja possível calcular a comissão mensal,
 * este registro também deverá ter uma data de lançamento como sendo a data atual do sistema.
 */

CREATE TRIGGER LocacaoEncerrada
ON Locacao
FOR UPDATE
AS
	DECLARE @CodLocacao INT, @PrincipalCondutor INT, @Status CHAR(10)
	SELECT @CodLocacao = CodLocacao, @PrincipalCondutor = PrincipalCondutor, @Status = Status FROM deleted
	IF (SELECT Status FROM deleted) = 'Encerrada'
		BEGIN
			PRINT 'Esta locação não pode ser alterada pois seu status está como "Encerrada".'
			UPDATE Locacao SET PrincipalCondutor = @PrincipalCondutor, Status = @Status WHERE CodLocacao = @CodLocacao
		END
	ELSE
		BEGIN
			UPDATE ComissaoLiquidado SET DataPagamento = GETDATE() WHERE CodLocacao = @CodLocacao 
		END 

UPDATE Locacao SET PrincipalCondutor = 5 WHERE CodLocacao = 1

UPDATE Locacao SET Status = 'Encerrada' WHERE CodLocacao = 4

SELECT * FROM Locacao

SELECT * FROM ComissaoLiquidado