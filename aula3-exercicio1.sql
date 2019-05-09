CREATE DATABASE aula3Exercicio1

USE aula3Exercicio1

/* ---------------------------------------------------------
 * Exercício 01:
 * ---------------------------------------------------------
 * 1. Criar uma tabela com o nome TB_CLIENTE. A tabela deverá conter a seguinte estrutura:
 * a. Um atributo código do tipo inteiro;
 * b. Um atributo nome do tipo cadeia de caracteres de tamanho 50;
 * c. Um atributo telefone do tipo cadeia de caracteres de tamanho 20;
 * d. Um atributo tipo_cliente do tipo cadeia de caracteres de tamanho 20;
 * e. Um atributo dt_cadastro do tipo data e hora;
 * f. Um atributo nr_dependentes do tipo inteiro.
 * g. Todos os atributos da tabela devem ser obrigatórios.
 * ---------------------------------------------------------
 */

CREATE TABLE TB_CLIENTE (
    Codigo INT IDENTITY(1,1) NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Telefone VARCHAR(20) NOT NULL,
    TipoCliente VARCHAR(20) NOT NULL,
    DataCadastro DATETIME NOT NULL,
    NumeroDependentes INT NOT NULL
)

SELECT * FROM TB_CLIENTE

/*--------------------------------------------------
 * 2. A tabela acima deve conter as seguintes restrições:
 *--------------------------------------------------
 */

-- a. O atributo código representa a chave primária da tabela;

ALTER TABLE TB_CLIENTE
    ADD CONSTRAINT PK_TB_CLIENTE PRIMARY KEY(codigo)

-- b. O atributo dt_cadastro (data do cadastro) deve ter como valor padrão (default) a data e hora atual do sistema;

ALTER TABLE TB_CLIENTE
    ADD CONSTRAINT DF_DataCadastro DEFAULT (GETDATE()) FOR DataCadastro

-- c. O atributo tipo_cliente deve ser 'Titular' ou 'Dependente';

ALTER TABLE TB_CLIENTE
    ADD CONSTRAINT CK_TipoCliente CHECK(TipoCliente IN ('TITULAR', 'DEPENDENTE'))

-- d. O atributo nr_dependentes deve ser um inteiro maior ou igual a 0 e menor ou igual a 3.

ALTER TABLE TB_CLIENTE
    ADD CONSTRAINT CK_NumeroDependentes CHECK(NumeroDependentes BETWEEN 0 AND 3)

-- 3. Utilizar comandos SQL de inserção e atualização que tentem verificar e violar as restrições acima.

INSERT INTO TB_CLIENTE (Nome, Telefone, TipoCliente, NumeroDependentes) VALUES
	('Getulio Vinicius', '16-98767-8765', 'TITULAR', 3)

SELECT * FROM TB_CLIENTE
