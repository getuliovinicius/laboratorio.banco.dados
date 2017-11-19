CREATE DATABASE aula4Exemplo1

USE aula4Exemplo1

CREATE TABLE Professores (
    codProf INT CONSTRAINT PK_Professores PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(80) NOT NULL,
    rg NUMERIC(12) UNIQUE,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
    idade INT CHECK (idade BETWEEN 21 AND 80),
    cidade VARCHAR(50) CONSTRAINT DF_Professores_Cidade DEFAULT ('FRANCA'),
    titulacao VARCHAR(15) CHECK(titulacao in ('GRADUAÇÃO', 'ESPECIALIZAÇÃO', 'MESTRE', 'DOUTOR')),
    categoria VARCHAR(15) CHECK(categoria in ('AUXILIAR', 'ASSISTENTE', 'ADJUNTO', 'TITULAR')),
    salario MONEY CHECK (salario >= 500)
)

SELECT * FROM Professores

INSERT INTO Professores(rg, sexo, idade, titulacao, categoria, salario, nome) VALUES
	(123456, 'X', 15, 'BACHAREL', 'TRAINEE', 415.99, 'MANUEL')