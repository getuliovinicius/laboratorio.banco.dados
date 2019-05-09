/**
 * 3. Considerando um banco de dados representado pelo esquema a seguir, crie as stored procedures:
 */

/**
 * Curso (CodCurso, Curso)
 * Disciplina (codDisciplina, Disciplina)
 * Aluno (CodAluno, Nome, CodCurso)
 * Nota (CodNota, CodAluno, CodDisciplina, Nota)
 */

CREATE DATABASE Aula14Exercicio3

USE Aula14Exercicio3

CREATE TABLE Curso (
	CodCurso INT CONSTRAINT PK_Curso PRIMARY KEY IDENTITY (1,1),
	Curso VARCHAR(30) NOT NULL UNIQUE
)

CREATE TABLE Disciplina (
	CodDisciplina INT CONSTRAINT PK_Disciplina PRIMARY KEY IDENTITY (1,1),
	Disciplina VARCHAR(30) NOT NULL UNIQUE
)

CREATE TABLE Aluno (
	CodAluno INT CONSTRAINT PK_Aluno PRIMARY KEY,
	Nome VARCHAR(50) NOT NULL,
	CodCurso INT NOT NULL CONSTRAINT FK_Aluno_Curso FOREIGN KEY REFERENCES Curso (CodCurso)
)

CREATE TABLE Nota (
	CodNota INT CONSTRAINT PK_Nota PRIMARY KEY IDENTITY (1,1),
	Nota DECIMAL (10,2) NOT NULL,
	CodDisciplina INT NOT NULL CONSTRAINT FK_Nota_Disciplina FOREIGN KEY REFERENCES Disciplina (CodDisciplina),
	CodAluno INT NOT NULL CONSTRAINT FK_Nota_Aluno FOREIGN KEY REFERENCES Aluno (CodAluno)
)

-- a) Considere que o campo código da tabela Alunos NÃO está definido como autonumeração,
-- crie uma stored procedure para inserir registros nesta tabela, sem que seja necessário informar o código do aluno como parâmetro.

CREATE PROCEDURE SP_InsereAlunoSemCodigo
@Nome VARCHAR(50),
@CodCurso INT
AS
BEGIN
	DECLARE @ProximoCodigo INT
	SELECT @ProximoCodigo = ISNULL(MAX(CodAluno), 0) + 1 FROM Aluno
	INSERT INTO Aluno (CodAluno, Nome, CodCurso) VALUES (@ProximoCodigo, @Nome, @CodCurso)
END 

-- b) Considere que os campos códigos das tabelas Notas, Curso e Disciplina estão definidos como autonumeração,
-- crie stored procedures para inserir registros em cada tabela (uma stored procedure de inserção para cada tabela).

CREATE PROCEDURE SP_InsereCurso
@Curso VARCHAR(30)
AS
BEGIN
	INSERT INTO Curso (Curso) VALUES (@Curso)	
END

--

CREATE PROCEDURE SP_InsereDisciplina
@Disciplina VARCHAR(30)
AS
BEGIN
	INSERT INTO Disciplina (Disciplina) VALUES (@Disciplina)
END

--

CREATE PROCEDURE SP_InsereNota
@Nota DECIMAL(10,2),
@CodDisciplina INT,
@CodAluno INT
AS
BEGIN
	INSERT INTO Nota (Nota, CodDisciplina, CodAluno) VALUES (@Nota, @CodDisciplina, @CodAluno)
END

-- c) Usando as stored procedures criadas, insira pelo menos 5 registros em cada tabela.

EXEC SP_InsereCurso 'Matemática'
EXEC SP_InsereCurso 'Letras'
EXEC SP_InsereCurso 'Física'
EXEC SP_InsereCurso 'História'
EXEC SP_InsereCurso 'Educação Física'

SELECT * FROM Curso

Exec SP_InsereDisciplina 'Literatura'
Exec SP_InsereDisciplina 'Cálculo 1'
Exec SP_InsereDisciplina 'Física 1'
Exec SP_InsereDisciplina 'História Medieval'
Exec SP_InsereDisciplina 'Ginástica 1'

SELECT * FROM Disciplina

EXEC SP_InsereAlunoSemCodigo 'Miranda Cosgrove', 4
EXEC SP_InsereAlunoSemCodigo 'Janeth McKurdy', 3
EXEC SP_InsereAlunoSemCodigo 'Carlo Vilagran', 2
EXEC SP_InsereAlunoSemCodigo 'Ramon Valdés', 5
EXEC SP_InsereAlunoSemCodigo 'Roberto Bolaños', 1
EXEC SP_InsereAlunoSemCodigo 'Maria Antonieta Dela Nieve', 2
EXEC SP_InsereAlunoSemCodigo 'Edgar Vivar', 4

SELECT * FROM Aluno

EXEC SP_InsereNota 9.3, 4, 1 
EXEC SP_InsereNota 9.1, 3, 2 
EXEC SP_InsereNota 6.4, 1, 3 
EXEC SP_InsereNota 2.4, 5, 4 
EXEC SP_InsereNota 10.0, 2, 5 
EXEC SP_InsereNota 6.0, 3, 5 
EXEC SP_InsereNota 10.0, 1, 6 
EXEC SP_InsereNota 6.0, 4, 7

SELECT * FROM Nota

-- d) Qual o nome de cada curso e a quantidade de alunos matriculados em cada curso?

CREATE PROCEDURE SP_AlunosPorCurso
AS
BEGIN
	SELECT C.Curso AS Curso, COUNT(A.CodAluno) AS QuantidadeDeAlunos
	FROM Curso AS C
		INNER JOIN Aluno AS A
		ON C.CodCurso = A.CodCurso
	GROUP BY C.Curso
END 

EXEC SP_AlunosPorCurso

-- e) Dado um código de aluno, retornar o nome do aluno e a média das disciplinas que este aluno está cursando.

CREATE PROCEDURE SP_MediaNotasPorAluno
@CodAluno INT
AS
BEGIN
	SELECT A.Nome, AVG(N.Nota) AS Media
	FROM Nota AS N
		INNER JOIN Aluno AS A
		ON N.CodAluno = A.CodAluno
	WHERE N.CodAluno = @CodAluno
	GROUP BY A.Nome	
END 

EXEC SP_MediaNotasPorAluno 9

-- f) Dado um código de curso,
-- retornar o nome do curso,
-- os nomes dos alunos matriculados neste curso (em ordem alfabética),
-- e o nome das disciplinas, seguido de suas notas.

CREATE PROCEDURE SP_NotasPorCursoAnalitico
@CodCurso INT
AS
BEGIN
	SELECT C.Curso AS Curso, A.Nome AS Aluno, D.Disciplina AS Disciplina, N.Nota AS Nota
	FROM Curso AS C
		INNER JOIN Aluno AS A
		ON C.CodCurso = A.CodCurso
		INNER JOIN Nota AS N
		ON A.CodAluno = N.CodAluno
		INNER JOIN Disciplina AS D
		ON N.CodDisciplina = D.CodDisciplina
	WHERE C.CodCurso = @CodCurso
	ORDER BY A.Nome
END 

EXEC SP_NotasPorCursoAnalitico 1